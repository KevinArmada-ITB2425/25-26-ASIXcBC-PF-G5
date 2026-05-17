# Disseny de Xarxa

## Topologia

```
                    ┌─────────────────┐
                    │    INTERNET     │
                    └────────┬────────┘
                             │ WAN
                    ┌────────┴────────┐
                    │ pfSense /       │
                    │ + Suricata IDS  │
                    └────────┬────────┘
           ┌─────────────────┼─────────────────┐
           │                 │                 │
    ┌──────┴──────┐   ┌──────┴──────┐   ┌──────┴──────┐
    │   vlan10    │   │   vlan20    │   │   vlan30    │
    │   Gestió    │   │   Usuaris   │   │   DMZ/IoT   │
    │.10.0/24     │   │.20.0/24     │   │.30.0/24     │
    └──────┬──────┘   └──────┬──────┘   └──────┬──────┘
           │                 │                 │
    [wazuh-server]    [Wazuh Agent 1]    [Wazuh Agent 3]
    [admin-server]    [client-user1]     [dmz-host1]
                      [Wazuh Agent 2]    [Wazuh Agent 4]
                      [client-user2]     [dmz-host2]

```

## Pla d'Adreçament IP

| VLAN | ID | Xarxa | Gateway | Pool DHCP |
|---|---|---|---|---|
| Gestió | vlan10 | 192.168.10.0/24 | 192.168.10.1 | .10–.50 |
| Usuaris | vlan20 | 192.168.20.0/24 | 192.168.20.1 | .10–.100 |
| DMZ/IoT | vlan30 | 192.168.30.0/24 | 192.168.30.1 | .10–.50 |

**IPs fixes:**
- `192.168.10.1` → `ubuntu router` (gateway vlan10)
- `192.168.10.10` → `wazuh-server`
- `192.168.10.20` → `admin-server`
- `192.168.20.1` → `ubuntu router` (gateway vlan20)
- `192.168.30.1` → `ubuntu router` (gateway vlan30)
- `192.168.30.10` → `dmz-host1`
- `192.168.30.20` → `dmz-host2`

## Màquines Virtuals

| VM | SO | Xarxa interna | IP | RAM | Rol |
|---|---|---|---|---|---|
| `ubuntu router` | Ubuntu Server 22.04 LTS | Totes | 192.168.X.1 | 1 GB | Firewall + Suricata + nftables |
| `wazuh-server` | Ubuntu 22.04 LTS | vlan10 | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Ubuntu 22.04 LTS | vlan10 | 192.168.10.20 | 1 GB | Kea DHCP + Unbound DNS + Wazuh Agent |
| `client-user1` | Ubuntu 22.04 LTS | vlan20 | DHCP (~.10) | 1 GB | Endpoint usuari + Wazuh Agent 1 |
| `client-user2` | Ubuntu 22.04 LTS | vlan20 | DHCP (~.11) | 1 GB | Endpoint usuari + Wazuh Agent 2 |
| `dmz-host1` | Ubuntu Server 22.04 LTS | vlan30 | 192.168.30.10 | 1 GB | Servei exposat + Wazuh Agent 3 |
| `dmz-host2` | Ubuntu Server 22.04 LTS | vlan30 | 192.168.30.20 | 1 GB | Servei exposat + Wazuh Agent 4 |

> RAM total mínima del host: **12 GB**

## Matriu de Comunicació Inter-VLAN

| Origen \ Destí | VLAN10 Gestió | VLAN20 Usuaris | VLAN30 DMZ | Internet | VPN |
|---|---|---|---|---|---|
| **VLAN10 Gestió** | ✅ Lliure | ✅ Controlat | ✅ Controlat | ✅ Permès | ✅ Permès |
| **VLAN20 Usuaris** | ❌ DENY | ✅ Lliure | ❌ DENY | ✅ HTTP/HTTPS | ❌ DENY |
| **VLAN30 DMZ/IoT** | ❌ DENY | ❌ DENY | ✅ Lliure | ⚠️ Limitat | ❌ DENY |

