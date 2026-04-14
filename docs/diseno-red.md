# Disseny de Xarxa

## Topologia

```
                    ┌─────────────────┐
                    │    INTERNET      │
                    └────────┬────────┘
                             │ WAN
                    ┌────────┴────────┐
                    │  pfSense /       │
                    │  OPNsense        │
                    │  + Suricata IDS  │
                    │  + WireGuard VPN │
                    └────────┬────────┘
           ┌─────────────────┼─────────────────┐
           │                 │                 │
    ┌──────┴──────┐   ┌──────┴──────┐   ┌──────┴──────┐
    │   vlan10    │   │   vlan20    │   │   vlan30    │
    │   Gestió    │   │   Usuaris   │   │   DMZ/IoT   │
    │.10.0/24     │   │.20.0/24     │   │.30.0/24     │
    └──────┬──────┘   └──────┬──────┘   └──────┬──────┘
           │                 │                 │
    [wazuh-server]    [Wazuh Agent]      [Wazuh Agent]
    [admin-server]    [client-user]      [dmz-host]
           ▲
    ┌──────┴──────┐
    │ WireGuard   │
    │ 10.0.0.0/24 │
    └─────────────┘
```

## Pla d'Adreçament IP

| VLAN | ID | Xarxa | Gateway | Pool DHCP |
|---|---|---|---|---|
| Gestió | vlan10 | 192.168.10.0/24 | 192.168.10.1 | .10–.50 |
| Usuaris | vlan20 | 192.168.20.0/24 | 192.168.20.1 | .10–.100 |
| DMZ/IoT | vlan30 | 192.168.30.0/24 | 192.168.30.1 | .10–.50 |
| WireGuard | — | 10.0.0.0/24 | 10.0.0.1 | Estàtic |

**IPs fixes:**
- `192.168.10.1` → `pfsense-fw` (gateway vlan10)
- `192.168.10.10` → `wazuh-server`
- `192.168.10.20` → `admin-server`
- `192.168.20.1` → `pfsense-fw` (gateway vlan20)
- `192.168.30.1` → `pfsense-fw` (gateway vlan30)
- `192.168.30.10` → `dmz-host`

## Màquines Virtuals

| VM | SO | Xarxa interna | IP | RAM | Rol |
|---|---|---|---|---|---|
| `pfsense-fw` | FreeBSD (pfSense) | Totes | 192.168.X.1 | 1 GB | Firewall + Suricata + WireGuard |
| `wazuh-server` | Ubuntu 22.04 LTS | vlan10 | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Debian 12 | vlan10 | 192.168.10.20 | 1 GB | Kea DHCP + Unbound DNS |
| `client-user` | Debian 12 | vlan20 | DHCP | 1 GB | Endpoint usuari + Wazuh Agent |
| `dmz-host` | Debian 12 | vlan30 | 192.168.30.10 | 1 GB | Servei exposat + Wazuh Agent |

> RAM total mínima del host: **10 GB**

## Matriu de Comunicació Inter-VLAN

| Origen \ Destí | VLAN10 Gestió | VLAN20 Usuaris | VLAN30 DMZ | Internet | VPN |
|---|---|---|---|---|---|
| **VLAN10 Gestió** | ✅ Lliure | ✅ Controlat | ✅ Controlat | ✅ Permès | ✅ Permès |
| **VLAN20 Usuaris** | ❌ DENY | ✅ Lliure | ❌ DENY | ✅ HTTP/HTTPS | ❌ DENY |
| **VLAN30 DMZ/IoT** | ❌ DENY | ❌ DENY | ✅ Lliure | ⚠️ Limitat | ❌ DENY |
| **VPN WireGuard** | ✅ Permès | ⚠️ Sota demanda | ❌ DENY | ✅ Split tunnel | — |

> Política base: **deny-all**. Només es permet tràfic amb regla explícita documentada.
