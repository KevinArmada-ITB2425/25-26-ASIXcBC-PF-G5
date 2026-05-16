# Sprint 1 — Weekly Log · 13/04/2026 – 04/05/2026
> **Objetivo:** Entorno virtualizado lanzado y documentado

---

## Semana 1 · 13/04 – 20/04

### ✅ Completado
- Creación de la estructura de carpetas y markdown en VSCode · *#43922*
  - Ramas `main` →  `README.md`
  - Carpetas: `docs/`, `configs/`, `diagrams/`, `scripts/`, `weekly-logs/`
- Definición del plan de direccionamiento IP y tabla de VMs en `docs/diseno-red.md` · *#43895*
  - Matriz de comunicación inter-subred con política deny-all incluida
- Crear diagrama de topología en Packet Tracer y exportado a `diagrams/` · *#43897*

### ❌ Bloqueantes
| Problema | Causa | Solución aplicada |
|---|---|---|
| `git push` rechazado con contraseña | GitHub no acepta passwords | Configurado Personal Access Token (PAT) |
| Conflicto de fusión en `README.md` | Historiales divergentes entre `main` local y remota | `git pull --allow-unrelated-histories --no-rebase` |

### ⏱️ Horas
| Día | Horas | Actividad |
|---|---|---|
| Lunes 13/04 | 3h | Configuración GitHub, estructura, CONTRIBUTING.md, resolución errores git |
| Martes 14/04 | 2h | README.md, diseno-red.md, diagrama Packet Tracer, push ramas |
| Lunes 20/04 | 3h | Modificaciones y resolución de problemas |
| **Total S1** | **8h** | |

---

## Semana 2 · 21/04 – 04/05

### ✅ Completado
- Instalación del hipervisor (IsardVDI) y verificación VT-x/AMD-V en la BIOS · *#43899*
- Creación y arranque de la VM `ubuntu-router` (2 vCPUs / 2 GB RAM, Ubuntu Server 22.04) · *#43904*
  - Configuración de 4 interfaces: WAN (Default), Gestión (ASIXc2-ITB5a), Usuarios (ASIXc2-ITB6a), DMZ (ASIXc2-ITB7a)
  - Activación de `ip_forward` y NAT con `iptables` para dar salida a internet a las subredes internas
- Creación y arranque de la VM `wazuh-server` (2 vCPUs / 4 GB RAM, Ubuntu 22.04 LTS) · *#43906*
  - Configuración IP fija `192.168.10.10/24` via netplan, gateway `192.168.10.1`
  - Instalación Wazuh 4.11.2 all-in-one (Manager + Indexer + Dashboard)
- Documentación del entorno definitivo en `docs/diseno-red.md` · *#43914*
- Crear las redes internas por subred en el hipervisor · *#43900*
  - Configurados adaptadores de red internos (uno por subred: gestión, usuarios, DMZ)
- Creación del script de backup automatizado para Wazuh · *scripts/wazuh-backup.sh*
  - Backup diario via cron (3:00 AM) de configuración, reglas, certificados y lista de agentes
  - Retención automática de 7 días en `/var/backups/wazuh/`

### ❌ Bloqueantes
| Problema | Causa | Solución aplicada |
|---|---|---|
| `wazuh-server` instalado con IP localhost | La IP estática no estaba configurada antes de la instalación | Pendiente: reinstalar Wazuh con la IP `192.168.10.10` ya activa |
| Subinterfaz `vlan10@enp0s3` innecesaria | En IsardVDI no hace falta tag 802.1Q con redes internas separadas | Resuelto: netplan con IP directa en cada interfaz física |

### ⏱️ Horas
| Día | Horas | Actividad |
|---|---|---|
| Martes 21/04 | 3h | Instalación IsardVDI, creación VM ubuntu-router, configuración interfaces y NAT |
| Lunes 27/04 | 2h | Creación VM wazuh-server, configuración netplan |
| Martes 28/04 | 3h | Configuración subnetting, instalación Wazuh, pruebas de conectividad |
| Lunes 04/05 | 3h | Resolución bloqueantes, reinstalación Wazuh con IP correcta |
| Martes 05/05 | 2h | Verificación servicios Wazuh, documentación final Sprint 1 |
| Sábado 16/05 | 1h | Script backup Wazuh + activación cron |
| **Total S2** | **14h** | |

---
## 📊 Resumen Sprint 1
| | Valor |
|---|---|
| Tareas completadas | **9 / 10** |
| Horas totales | **22h** |
| Bloqueantes resueltos | 3 / 4 |
