# Sprint 1 — Weekly Log · 13/04/2026 – 04/05/2026
> **Objectiu:** Entorn virtualitzat llançat i documentat

---

## Setmana 1 · 13/04 – 20/04

### ✅ Completat
- Creació de l'estructura de carpetes i markdown en VSCode · *#43922*
  - Branques `main` → `develop` → `feature/`, `CONTRIBUTING.md`, `README.md`
  - Carpetes: `docs/`, `configs/`, `diagrams/`, `scripts/`, `tests/`, `weekly-logs/`
- Definició del pla d'adreçament IP i taula de VMs a `docs/diseno-red.md` · *#43895*
  - Matriu de comunicació inter-subxarxa amb política deny-all inclosa
- Crear diagrama de topologia a Packet Tracer i exportat a `diagrams/` · *#43897*

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
| Dilluns 20/04 | 3h | Modificacions i resolucions de problemes |
| **Total S1** | **8h** | |

---

## Setmana 2 · 21/04 – 04/05

### ✅ Completat
- Instal·lació del hipervisor (IsardVDI) i verificació VT-x/AMD-V a la BIOS · *#43899*
- Creació i arrencada de la VM `ubuntu-router` (2 vCPUs / 2 GB RAM, Ubuntu Server 22.04) · *#43904*
  - Configuració de 4 interfícies: WAN (Default), Gestió (ASIXc2-ITB5a), Usuaris (ASIXc2-ITB6a), DMZ (ASIXc2-ITB7a)
  - Activació de `ip_forward` i NAT amb `iptables` per donar sortida a internet a les subxarxes internes
- Creació i arrencada de la VM `wazuh-server` (2 vCPUs / 4 GB RAM, Ubuntu 22.04 LTS) · *#43906*
  - Configuració IP fixa `192.168.10.10/24` via netplan, gateway `192.168.10.1`
  - Instal·lació Wazuh 4.11.2 all-in-one (Manager + Indexer + Dashboard)
- Documentació de l'entorn definitiu a `docs/diseno-red.md` · *#43914*
- Crear les xarxes internes per subxarxa al hipervisor · *#43900*
  - Configurats adaptadors de xarxa interns (un per subxarxa: gestió, usuaris, DMZ)


### ❌ Blocants
| Problema | Causa | Solució aplicada |
|---|---|---|
| `wazuh-server` instal·lat amb IP localhost | La IP estàtica no estava configurada abans de la instal·lació | Pendent: reinstal·lar Wazuh amb la IP `192.168.10.10` ja activa |
| Subinterfície `vlan10@enp0s3` innecessària | En IsardVDI no cal tag 802.1Q amb xarxes internes separades | Resolt: netplan amb IP directa a cada interfície física |

### ⏱️ Hores
| Dia | Hores | Activitat |
|---|---|---|
| Dimarts 21/04 | 3h | Instal·lació IsardVDI, creació VM ubuntu-router, configuració interfícies i NAT |
| Dilluns 27/04 | 2h | Creació VM wazuh-server, configuració netplan |
| Dimarts 28/04 | 3h | Configuració subnetting, instal·lació Wazuh, proves de connectivitat |
| Dilluns 04/05 | 3h | Resolució blocants, reinstal·lació Wazuh amb IP correcta |
| Dimarts 05/05 | 2h | Verificació serveis Wazuh, documentació final Sprint 1 |
| **Total S2** | **13h** | |

---

## 📊 Resum Sprint 1
| | Valor |
|---|---|
| Tasques completades | **8 / 10** |
| Hores totals | **21h** |
| Blocants resolts | 3 / 4 |