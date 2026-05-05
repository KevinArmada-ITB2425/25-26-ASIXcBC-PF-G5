# Configuració Ubuntu Router

## Informació General

| Camp | Detall |
|---|---|
| **VM** | `ubuntu-router` |
| **SO** | Ubuntu Server 22.04 LTS |
| **RAM** | 4 GB |
| **vCPUs** | 2 |
| **Rol** | Router + Firewall (nftables) + DHCP/DNS + Suricata |

---

## Interfícies de Xarxa

| Interfície | Xarxa IsardVDI | Subxarxa | IP | Rol |
|---|---|---|---|---|
| `enp1s0` | Default | WAN | DHCP (internet) | Sortida a internet |
| `enp2s0` | ASIXc2-ITB5a | Gestió | `192.168.10.1/24` | Gateway Gestió |
| `enp3s0` | ASIXc2-ITB6a | Usuaris | `192.168.20.1/24` | Gateway Usuaris |
| `enp4s0` | ASIXc2-ITB7a | DMZ/IoT | `192.168.30.1/24` | Gateway DMZ |

---

## Netplan — `/etc/netplan/00-installer-config.yaml`

```yaml
network:
  version: 2
  ethernets:

    # WAN — Default (internet)
    enp1s0:
      dhcp4: true

    # Gestió — ASIXc2-ITB5a
    enp2s0:
      addresses:
        - 192.168.10.1/24
      dhcp4: false

    # Usuaris — ASIXc2-ITB6a
    enp3s0:
      addresses:
        - 192.168.20.1/24
      dhcp4: false

    # DMZ/IoT — ASIXc2-ITB7a
    enp4s0:
      addresses:
        - 192.168.30.1/24
      dhcp4: false
```

---

## IP Forwarding — `/etc/sysctl.conf`

```bash
# Activar enrutament entre interfícies
net.ipv4.ip_forward=1
```

Aplicar:
```bash
sudo sysctl -p
```

---

## Firewall i NAT amb nftables — `/etc/nftables.conf`

```bash
#!/usr/sbin/nft -f

flush ruleset

# 1. NAT — dona internet a totes les subxarxes internes
table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        oifname "enp1s0" masquerade;
    }
}

# 2. Filter — restriccions entre subxarxes
table inet filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }
    chain forward {
        type filter hook forward priority 0; policy accept;

        # Permetre tràfic ja establert (sempre primer)
        ct state established,related accept;

        # Usuaris (enp3s0) → DMZ (enp4s0): només web
        iifname "enp3s0" oifname "enp4s0" tcp dport { 80, 443 } accept;

        # Bloquejar resta de tràfic Usuaris → DMZ
        iifname "enp3s0" oifname "enp4s0" drop;

        # Bloquejar accés Usuaris → Gestió
        iifname "enp3s0" oifname "enp2s0" drop;
    }
}
```

Activar i habilitar a l'arrencada:
```bash
sudo systemctl enable nftables
sudo systemctl start nftables
```

---

## Verificació

```bash
# Comprovar interfícies i IPs
ip addr show

# Comprovar que el routing està actiu
cat /proc/sys/net/ipv4/ip_forward  # ha de retornar 1

# Comprovar taula de rutes
ip route show

# Comprovar regles nftables actives
sudo nft list ruleset
```

**Evidència de verificació:**

![Verificació Ubuntu Router](verificacion_ubuntu-server.webp)