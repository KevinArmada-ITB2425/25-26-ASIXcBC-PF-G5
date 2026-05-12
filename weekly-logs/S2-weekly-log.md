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
  - Activació de `ip_forward` al kernel de Linux i configuració de regles NAT (enmascarament) via `nftables`
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

### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `wazuh-server` sense DNS al fer `apt update` | `resolv.conf` apuntava a `127.0.0.53` (systemd-resolved sense gateway) | Substituït symlink per fitxer estàtic amb `8.8.8.8` i `1.1.1.1` |
| No es pot canviar password admin des de la GUI | L'usuari `admin` és reservat a OpenSearch/Wazuh Indexer | Canvi fet via `wazuh-passwords-tool.sh -u admin -p '...'` per CLI |
| `client-user1` desconnectat del Wazuh Manager | L'agent estava operatiu però després d'un reinici va deixar de connectar al port 1515 — bloqueig nftables entre VLANs | Resolt a la S4: regla explícita afegida a nftables per permetre ports `1514`, `1515`, `55000` des de Usuaris i DMZ cap a Wazuh |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dimarts 05/05 | 6h | Migració pfSense→Ubuntu, Netplan, Routing, NFTables, DHCP, DNS Technitium, canvi password Wazuh |
| Divendres 08/05 | 3h | Diagnosi blocant `client-user1` desconnectat de Wazuh, instal·lació agents DMZ |
| **Total S3** | **9h** | |

---

## Setmana 4 · 12/05 – 18/05

### ✅ Completat
- Crear les VMs `admin-server`, `client-user2` i `dmz-host` restants · *#sprint2*
  - Instal·lació de Debian 12 a les 3 VMs restants, assignació a la seva VLAN corresponent i verificació d'arrencada correcta
- Instal·lar agent a `client-user1` · *#sprint2*
  - Re-registre de `wazuh-agent` a `client-user1` (192.168.20.102) amb ID `005` després de resoldre el bloqueig nftables al port 1515
- Instal·lar agent a `client-user2` · *#sprint2*
  - Instal·lació de `wazuh-agent` a `client-user2` (192.168.20.100) i verificació de connectivitat al manager
- Instal·lar agent a `admin-server` · *#sprint2*
  - Instal·lació de `wazuh-agent` a `admin-server` (192.168.10.20) i registre al dashboard amb estat `active`
- Configurar Suricata IDS/IPS · *#sprint2*
  - Desplegament de Suricata com a sensor IDS/IPS en mode monitor sobre `ubuntu-router`, inspecció de tràfic (DPI) a la interfície WAN (`enp1s0`), regles de detecció d'escanejos de ports i patrons d'atacs a la DMZ

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dilluns 11/05 | 3h | Creació VMs restants, instal·lació agents `client-user2` i `admin-server` |
| Dimarts 12/05 | 6h | Resolució blocant `client-user1`, configuració Suricata, actualització nftables amb regles agents Wazuh |
| **Total S4** | **9h** | |

---

## 📊 Resum Sprint 2 (actualitzat 12/05)
| | Valor |
|---|---|
| Tasques completades | **13 / 13** |
| Hores totals | **18h** |
| Blocants resolts | 3 / 3 |