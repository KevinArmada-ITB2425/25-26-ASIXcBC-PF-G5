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
- Instal·lar agent a `dmz-host1` · *#sprint2*
  - Instal·lació de `wazuh-agent` a `dmz-host1` (192.168.30.10) i registre correcte al dashboard amb estat `active`
- Instal·lar agent a `dmz-db-server` · *#sprint2*
  - Instal·lació de `wazuh-agent` a `dmz-db-server` (192.168.30.20) i verificació de connectivitat amb el manager

### 🔄 En progrés
- Instal·lació i configuració de Suricata IDS/IPS sobre ubuntu-router
- Crear les VMs `admin-server`, `client-user` i `dmz-host` restants i instal·lar Debian 12, assignar-les a la seva VLAN corresponent i verificar arrencada correcta
- Instal·lar `wazuh-agent` a `client-user1` i registrar-lo al dashboard
- Configurar Suricata com a sensor IDS/IPS en mode monitor per a inspecció profunda de tràfic (DPI), amb regles per detectar escaneos de ports i patrons d'atacs coneguts a la DMZ

### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `wazuh-server` sense DNS al fer `apt update` | `resolv.conf` apuntava a `127.0.0.53` (systemd-resolved sense gateway) | Substituït symlink per fitxer estàtic amb `8.8.8.8` i `1.1.1.1` |
| No es pot canviar password admin des de la GUI | L'usuari `admin` és reservat a OpenSearch/Wazuh Indexer | Canvi fet via `wazuh-passwords-tool.sh -u admin -p '...'` per CLI |
| `client-user1` desconnectat del Wazuh Manager | L'agent `client-user1` estava operatiu i registrava logs correctament, però després d'un reinici ha deixat de connectar-se al port 1515 del manager. El `nc -zv 192.168.10.10 1515` falla des del client — possible bloqueig de routing/nftables entre VLANs | En investigació (08/05) |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dimarts 05/05 | 6h | Migració pfSense→Ubuntu, Netplan, Routing, NFTables, DHCP, DNS Technitium, canvi password Wazuh |
| Divendres 08/05 | 3h | Diagnosi blocant `client-user1` desconnectat de Wazuh, instal·lació agents DMZ |
| **Total S3** | **9h** | |

---

## 📊 Resum Sprint 2 (parcial)
| | Valor |
|---|---|
| Tasques completades | **9 / 13** |
| Hores totals | **9h** |
| Blocants resolts | 2 / 3 |