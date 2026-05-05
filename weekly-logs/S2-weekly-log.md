# Sprint 2 — Weekly Log · 05/05/2026 – 19/05/2026
> **Objectiu:** Router Ubuntu, subnetting, DHCP, DNS, Suricata IDS/IPS

---

## Setmana 3 · 05/05 – 11/05

### ✅ Completat
- Migració de pfSense a Ubuntu Server com a router perimetral · *#sprint2*
  - Migració completa de la infraestructura de xarxa perimetral des de pfSense cap a Ubuntu Server 22.04
- Configuració de les interfícies de xarxa via Netplan · *#sprint2*
  - Configuració estàtica de les quatre interfícies de xarxa (WAN + Gestió + Usuaris + DMZ)
- Configuració de Routing (ip_forward + NAT) · *#sprint2*
  - Activació de `ip_forward` al kernel de Linux i configuració de regles NAT amb `iptables` (enmascarament)
- Configuració de NFTables · *#sprint2*
  - Implementació de firewall perimetral amb `nftables` per aïllar xarxes, permetent tràfic web de Usuaris → DMZ
- Configuració DHCP · *#sprint2*
  - Instal·lació i posada en marxa del servidor `isc-dhcp-server`, configuració de subxarxes i reserves MAC
- Configuració DNS · *#sprint2*
  - Instal·lació i configuració de Technitium DNS Server amb interfaz web, implementació de zona local `jankesto.local`
- Canvi de contrasenya admin de Wazuh · *#sprint2*
  - Contrasenya per defecte substituïda mitjançant `wazuh-passwords-tool.sh` per línia de comandes (la GUI retorna `FORBIDDEN` per a l'usuari `admin`)

### 🔄 En progrés
- Instal·lació i configuració de Suricata IDS/IPS sobre ubuntu-router
- Creació VMs `client-user1`, `client-user2`, `dmz-host1`, `dmz-host2` (Debian 12)

### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `wazuh-server` sense DNS al fer `apt update` | `resolv.conf` apuntava a `127.0.0.53` (systemd-resolved sense gateway) | Substituït symlink per fitxer estàtic amb `8.8.8.8` i `1.1.1.1` |
| No es pot canviar password admin des de la GUI | L'usuari `admin` és reservat a OpenSearch/Wazuh Indexer | Canvi fet via `wazuh-passwords-tool.sh -u admin -p '...'` per CLI |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dimarts 05/05 | 6h | Migració pfSense→Ubuntu, Netplan, Routing, NFTables, DHCP, DNS Technitium, canvi password Wazuh |
| **Total S3** | **6h** | |

---

## 📊 Resum Sprint 2 (parcial)
| | Valor |
|---|---|
| Tasques completades | **7 / 10** |
| Hores totals | **6h** |
| Blocants resolts | 2 / 2 |