# Pla de Projecte

## Informació General

| Camp | Detall |
|---|---|
| **Projecte** | Arquitectura de Xarxa Corporativa Segura amb SOC |
| **Mòdul** | Projecte Integrat — Grau Superior ASIX |
| **Curs** | 2025–2026 |
| **Grup** | G5 |
| **Eina de tasques** | ProofHub |
| **Repositori** | GitHub (`25-26-ASIXcBC-PF-G5`) |

---

## Fites (Milestones)

| Fita | Sprint | Entregable |
|---|---|---|
| M1 — Infraestructura base operativa | 1 | VMs funcionant, pfSense accessible |
| M2 — Xarxa segmentada i firewall actiu | 2 | 3 VLANs aïllades amb regles |
| M3 — SOC i VPN operatius | 3 | Wazuh amb agents + WireGuard actiu |

---

## Sprint 1 — Disseny i Infraestructura Base
**Durada:** Setmana 1–2 · **Objectiu:** Entorn virtualitzat llançat i documentat

| # | Tasca | Descripció | Branca Git |
|---|---|---|---|
| 1 | Definir pla d'adreçament IP i taula de VMs | Decidir subxarxes definitives per a cada VLAN (10, 20, 30) i WireGuard, assignar IPs fixes als servidors i documentar-ho a `docs/diseno-red.md` | `docs/diseno-red` |
| 2 | Crear diagrama de topologia a draw.io | Dibuixar la topologia completa (Internet → pfSense → VLANs → VMs → Wazuh → VPN), exportar en PNG i guardar-lo a `diagrams/` | `docs/diseno-red` |
| 3 | Instal·lar l'hipervisor al host | Instal·lar VirtualBox o IsardVDI a la màquina física i verificar que la virtualització hardware (VT-x/AMD-V) està habilitada a la BIOS | `feature/proxmox-setup` |
| 4 | Crear les xarxes internes per VLAN | Configurar adaptadors de xarxa interna al hipervisor (un per VLAN: `vlan10`, `vlan20`, `vlan30`) per aïllar el tràfic entre xarxes des de l'inici | `feature/proxmox-setup` |
| 5 | Crear i arrencar la VM `pfsense-fw` | Descarregar ISO de pfSense CE, crear VM amb 2 vCPUs / 1 GB RAM, assignar les interfícies WAN i LAN, completar l'assistent d'instal·lació inicial | `feature/proxmox-setup` |
| 6 | Crear i arrencar la VM `wazuh-server` | Descarregar ISO Ubuntu 22.04 LTS, crear VM amb **mínim 4 GB RAM i 2 vCPUs** (requisit Wazuh), configurar IP fixa 192.168.10.10 a VLAN Gestió | `feature/proxmox-setup` |
| 7 | Crear les VMs `admin-server`, `client-user` i `dmz-host` | Instal·lar Debian 12 a les 3 VMs restants, assignar-les a la seva VLAN corresponent i verificar arrencada correcta | `feature/proxmox-setup` |
| 8 | Fer snapshot inicial de totes les VMs | Abans de tocar cap configuració, crear un snapshot net a cada VM anomenat `"baseline-instalacio"` per poder revertir si alguna cosa surt malament | `feature/proxmox-setup` |
| 9 | Verificar connectivitat bàsica entre VMs | Comprovar amb `ping` que cada VM pot comunicar-se amb el seu gateway (pfSense) i que el firewall rep tràfic correctament | `feature/proxmox-setup` |
| 10 | Documentar l'entorn a `docs/diseno-red.md` | Escriure la taula de VMs definitiva (SO, VLAN, IP, RAM, rol), la topologia i la matriu de comunicació inter-VLAN | `docs/diseno-red` |

---

## Sprint 2 — Firewall, VLANs i Serveis de Xarxa
**Durada:** Setmana 3–4 · **Objectiu:** Xarxa segmentada, aïllada i amb serveis bàsics actius

| # | Tasca | Descripció | Branca Git |
|---|---|---|---|
| 1 | Configuració inicial de pfSense | Canviar contrasenya admin, deshabilitar accés WebGUI des de WAN, forçar HTTPS, configurar interfícies WAN (DHCP del lab) i LAN | `feature/pfsense-vlans` |
| 2 | Crear les 3 interfícies de xarxa per VLAN | A pfSense assignar cada adaptador de xarxa interna com a interfície independent i configurar la IP gateway de cada VLAN (192.168.X.1) | `feature/pfsense-vlans` |
| 3 | Configurar Kea DHCP per VLAN | Definir un pool d'IPs independent per a cada VLAN des de `Services > DHCP Server`, evitant solapament entre rangs i reservant IPs fixes per a servidors | `feature/pfsense-vlans` |
| 4 | Configurar Unbound DNS amb filtratge | Activar Unbound a pfSense, habilitar DNSSEC, carregar una llista DNSBL (ej. Steven Black Hosts) per bloquejar dominis de malware i publicitat a nivell DNS | `feature/pfsense-vlans` |
| 5 | Implementar regla deny-all inter-VLAN | A les regles de firewall de cada VLAN, afegir una regla final `Block any → any` amb logging actiu; implementa la política de mínim privilegi | `feature/pfsense-vlans` |
| 6 | Afegir regles d'excepció explícites | Per sobre del deny-all, afegir únicament el tràfic necessari (VLAN20 permet HTTP/HTTPS cap a Internet, VLAN10 permet SSH cap a VLAN20); documentar cada regla amb justificació | `feature/pfsense-vlans` |
| 7 | Instal·lar Suricata a pfSense i activar ET Open | Des de `System > Package Manager`, instal·lar el paquet Suricata, activar-lo a la interfície LAN i descarregar el ruleset Emerging Threats Open | `feature/suricata-ids` |
| 8 | Configurar bloqueig automàtic a Suricata | Activar mode IPS inline i habilitar el bloqueig automàtic d'IPs que generin més de 5 alertes en menys de 60 segons | `feature/suricata-ids` |
| 9 | Exportar i sanejar configuració de pfSense | Des de `Diagnostics > Backup & Restore`, descarregar el `config.xml`, editar per reemplaçar tots els camps `<password>` per `REDACTED`, guardar a `configs/pfsense/` | `feature/pfsense-vlans` |
| 10 | Documentar regles i hardening a `docs/hardening.md` | Escriure la justificació de cada regla de firewall, els passos d'hardening aplicats i el checklist completat de Suricata | `docs/hardening` |

---

## Sprint 3 — SOC (Wazuh) i VPN (WireGuard)
**Durada:** Setmana 5–7 · **Objectiu:** Monitorització centralitzada activa i accés remot segur

| # | Tasca | Descripció | Branca Git |
|---|---|---|---|
| 1 | Instal·lar Wazuh all-in-one a `wazuh-server` | Executar l'script oficial d'instal·lació de Wazuh a Ubuntu 22.04, que desplega Manager, Indexer (OpenSearch) i Dashboard en una sola VM | `feature/wazuh-soc` |
| 2 | Instal·lar i registrar agent a `client-user` (VLAN 20) | Instal·lar el paquet `wazuh-agent`, configurar la IP del manager (192.168.10.10) a `/var/ossec/etc/ossec.conf` i registrar l'agent des del dashboard | `feature/wazuh-soc` |
| 3 | Instal·lar i registrar agent a `dmz-host` (VLAN 30) | Mateix procés que la tasca anterior però a la VM de la DMZ; verificar que l'agent pot arribar al manager a VLAN 10 a través de la regla de firewall corresponent | `feature/wazuh-soc` |
| 4 | Activar File Integrity Monitoring (FIM) | Afegir les rutes crítiques a monitoritzar: `/etc/passwd`, `/etc/sudoers`, `/etc/ssh/sshd_config`, `/bin/` i `/usr/bin/`; verificar alertes al dashboard | `feature/wazuh-soc` |
| 5 | Integrar pfSense → Wazuh via Syslog | A pfSense configurar reenviament de logs al servidor Wazuh (192.168.10.10, port UDP 514); afegir el decoder de pfSense perquè els events del firewall apareguin al dashboard | `feature/wazuh-soc` |
| 6 | Crear regles d'alerta personalitzades | Al fitxer `/var/ossec/etc/rules/local_rules.xml` afegir regles per: detecció de brute-force SSH (>4 fallades en 60s), ús de `sudo` i canvi de contrasenya d'usuari | `feature/wazuh-soc` |
| 7 | Instal·lar WireGuard a pfSense i generar claus | Des de `System > Package Manager` instal·lar WireGuard, generar el parell de claus del servidor amb `wg genkey`, configurar la interfície `wg0` amb la subxarxa `10.0.0.1/24` | `feature/wireguard-vpn` |
| 8 | Configurar i provar peer VPN des de Linux | Instal·lar `wireguard-tools`, crear `/etc/wireguard/wg0.conf` amb la clau pública del servidor, executar `wg-quick up wg0` i verificar amb `wg show` i `ping 10.0.0.1` | `feature/wireguard-vpn` |
| 9 | Configurar i provar peer VPN des de Windows | Descarregar l'app oficial de WireGuard per Windows, importar el fitxer `.conf` del peer generat a pfSense, activar el túnel i verificar connectivitat cap a la VLAN de Gestió | `feature/wireguard-vpn` |
| 10 | Exportar configs WireGuard i documentar | Guardar els fitxers `.conf` de cada peer a `configs/wireguard/` eliminant els camps `PrivateKey`; completar la secció WireGuard a `docs/hardening.md` amb la justificació criptogràfica | `feature/wireguard-vpn` |
