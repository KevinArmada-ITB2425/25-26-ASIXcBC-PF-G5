# Sprint 1 — Weekly Log · 13/04/2026 – 24/04/2026
> **Objectiu:** Entorn virtualitzat llançat i documentat

---

## Setmana 1 · 13/04 – 20/04

### ✅ Completat
- Creació de l'estructura de carpetes i markdown en VSCode · *#43922*
  - Branques `main` → `develop` → `feature/`, `CONTRIBUTING.md`, `README.md`
  - Carpetes: `docs/`, `configs/`, `diagrams/`, `scripts/`, `tests/`, `weekly-logs/`
- Definició del pla d'adreçament IP i taula de VMs a `docs/diseno-red.md` · 
  - Matriu de comunicació inter-VLAN amb política deny-all inclosa
- Crear diagrama de topologia a Packet Tracer i exportat a `diagrams/` · 

### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `git push` rebutjat amb contrasenya | GitHub no accepta passwords | Configurat Personal Access Token (PAT) |
| Conflicte de fusió en `README.md` | Historials divergents entre `main` local i remota | `git pull --allow-unrelated-histories --no-rebase` |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dilluns 13/04 | 3h | Configuració GitHub, estructura, CONTRIBUTING.md, resolució errors git |
| Dimarts 14/04 | 2h | README.md, diseno-red.md, diagrama Packet Tracer, push branques |
| **Total S1** | **5h** | |

---

## Setmana 2 · 21/04 – 28/04

### ✅ Completat
- Instal·lació del hipervisor (VirtualBox) i verificació VT-x/AMD-V a la BIOS · 
- Creació i arrencada de la VM `pfsense-fw` (2 vCPUs / 1 GB RAM, pfSense CE 2.8.1) · 
  - Assignació d'interfícies: WAN (`le0`), LAN (`le1.10`), OPT1 (`le1.20`), OPT2 (`le1.30`)
- Creació i arrencada de la VM `wazuh-server` (2 vCPUs / 4 GB RAM, Ubuntu 22.04 LTS) · 
  - Configuració IP fixa `192.168.10.10/24` via netplan
- Documentació de l'entorn definitiu a `docs/diseno-red.md` · 
- Crear els switches virtuals per VLAN al hipervisor · 
  - Configurats adaptadors de xarxa interns (un per VLAN: gestió, usuaris, DMZ)

### 🔄 En progrés
- Creació VMs `admin-server`, `client-user1`, `client-user2`, `dmz-host1`, `dmz-host2` (Debian 12)
- Crear switches virtuals per VLAN al hipervisor
- Verificació de connectivitat bàsica entre VMs amb ping al gateway pfSense

### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `wazuh-server` no arriba a `pfsense-fw` (192.168.10.1) | VMs en PCs físics diferents amb adaptador pont | Pendent: migrar a IsardVDI o concentrar VMs en un sol host |
| Subinterfície `vlan10@enp0s3` innecessària | En VirtualBox no cal tag 802.1Q amb xarxes internes | Pendent: simplificar netplan amb IP directa a `enp0s3` |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dilluns 20/04 | 3h | Instal·lació VirtualBox, creació VM pfSense, assignació interfícies |
| Dimarts 21/04 | 2h | Creació VM wazuh-server, configuració netplan, debug connectivitat |
| **Total S2** | **5h** | |

---

## 📊 Resum Sprint 1
| | Valor |
|---|---|
| Tasques completades | **7 / 11** |
| Hores totals | **10h** |
| Blocants resolts | 2 / 4 |