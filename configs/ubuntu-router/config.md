# Configuració Ubuntu Router

## Informació General

| Camp | Detall |
|---|---|
| **VM** | `ubuntu-router` |
| **SO** | Ubuntu Server 22.04 LTS |
| **RAM** | 4 GB |
| **vCPUs** | 2 |
| **Rol** | Router + Firewall (nftables) + DHCP + DNS (Technitium) + Suricata |

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

## DHCP — isc-dhcp-server

### Instal·lació

```bash
sudo apt update
sudo apt install isc-dhcp-server -y
```

### Interfícies d'escolta — `/etc/default/isc-dhcp-server`

```bash
INTERFACESv4="enp2s0 enp3s0 enp4s0"
```

### Configuració — `/etc/dhcp/dhcpd.conf`

```bash
# Configuració global
authoritative;
default-lease-time 600;
max-lease-time 7200;

option domain-name "jankesto.local";
option domain-search "jankesto.local";

# Subxarxa Gestió
subnet 192.168.10.0 netmask 255.255.255.0 {
  option routers 192.168.10.1;
  option domain-name-servers 192.168.10.1;

  # Reserva wazuh-server
  host servidor_wazuh {
    hardware ethernet 52:54:00:01:56:1a;
    fixed-address 192.168.10.10;
  }
}

# Subxarxa Usuaris
subnet 192.168.20.0 netmask 255.255.255.0 {
  range 192.168.20.100 192.168.20.200;
  option routers 192.168.20.1;
  option domain-name-servers 192.168.20.1;
}

# Subxarxa DMZ
subnet 192.168.30.0 netmask 255.255.255.0 {
  option routers 192.168.30.1;
  option domain-name-servers 192.168.30.1;

  # Reserva dmz-host1
  host servidor-web-dmz1 {
    hardware ethernet 52:54:00:02:ee:b8;
    fixed-address 192.168.30.10;
  }

  # Reserva dmz-host2
  host servidor-web-dmz2 {
    hardware ethernet 52:54:00:02:33:9e;
    fixed-address 192.168.30.20;
  }
}
```

### Activar servei

```bash
sudo systemctl restart isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server
```

### Reserves MAC

| VM | MAC | IP reservada | Subxarxa |
|---|---|---|---|
| `wazuh-server` | `52:54:00:01:56:1a` | `192.168.10.10` | Gestió |
| `dmz-host1` | `52:54:00:02:ee:b8` | `192.168.30.10` | DMZ |
| `dmz-host2` | `52:54:00:02:33:9e` | `192.168.30.20` | DMZ |

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

## DNS — Technitium DNS Server

### Instal·lació

```bash
curl -sSL https://download.technitium.com/dns/install.sh | sudo bash
```

Accés al panell web: `http://192.168.10.1:5380`

### Configuració de Forwarders

| Forwarder | Descripció |
|---|---|
| `8.8.8.8` | Google DNS primari |
| `1.1.1.1` | Cloudflare DNS secundari |

### Zona local — `jankesto.local`

| Nom | Tipus | IP |
|---|---|---|
| `wazuh` | A | `192.168.10.10` |
| `DMZ` | A | `192.168.30.10` |

> Zona interna per resoldre noms de les VMs sense dependre de DNS extern.

### Verificació

```bash
ping wazuh.jankesto.local
ping DMZ.jankesto.local
```

**Evidència de verificació:**

![Verificació Technitium DNS] ???

---

## Verificació general

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