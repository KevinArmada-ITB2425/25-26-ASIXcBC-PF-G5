# 🔐 Arquitectura de Red Corporativa Segura amb SOC
> **Projecte Final — Grau Superior ASIX | Curs 25-26 | Grup 5**

[![Estat](https://img.shields.io/badge/Estat-En%20Desenvolupament-yellow)]()
[![pfSense](https://img.shields.io/badge/Firewall-pfSense%2FOPNsense-orange)]()
[![Wazuh](https://img.shields.io/badge/SOC-Wazuh%20SIEM%2FXDR-blue)]()
[![WireGuard](https://img.shields.io/badge/VPN-WireGuard-green)]()
[![Suricata](https://img.shields.io/badge/IDS%2FIPS-Suricata-red)]()

---

## 📌 ¿De qué trata este proyecto?

Este proyecto simula la infraestructura de red completa de una PYME real, diseñada desde cero con criterios de seguridad profesional. El objetivo es demostrar cómo una organización puede proteger sus activos digitales frente a amenazas externas e internas aplicando la **tríada CIA** (Confidencialidad, Integridad y Disponibilidad).

Todo el entorno se despliega en máquinas virtuales (VirtualBox / IsardVDI), reproduciendo fielmente un entorno corporativo real. Cada componente es **open source y estándar de la industria**.

---

## 🎯 ¿Qué problema resuelve?

Una PYME sin medidas de seguridad avanzadas es vulnerable a:

- **Movimiento lateral**: un atacante que compromete un equipo de usuario puede saltar a servidores críticos
- **Ataques perimetrales**: escaneos de puertos, fuerza bruta, exploits conocidos
- **Falta de visibilidad**: sin monitorización, los incidentes pasan desapercibidos durante días
- **Acceso remoto inseguro**: empleados que se conectan desde fuera sin cifrado exponen la red interna

Este proyecto ataca los cuatro problemas con una arquitectura de defensa en tres capas.

---

## 🏗️ Arquitectura — Tres Capas de Defensa

### Capa 1 — Perímetro
Firewall **pfSense/OPNsense** con **Suricata IDS/IPS** integrado. Filtra todo el tráfico de entrada/salida, aplica NAT y bloquea automáticamente IPs atacantes.

### Capa 2 — Segmentación Interna
Tres VLANs completamente aisladas con política **deny-all** por defecto:
- **VLAN 10 — Gestión** `192.168.10.0/24` — servidores críticos, solo accesible desde VPN
- **VLAN 20 — Usuarios** `192.168.20.0/24` — puestos de trabajo, sin acceso a Gestión
- **VLAN 30 — DMZ/IoT** `192.168.30.0/24` — servicios expuestos, aislada del resto

### Capa 3 — SOC (Security Operations Center)
Servidor **Wazuh** (SIEM + XDR) en VLAN Gestión. Agentes en todos los endpoints detectan en tiempo real: brute-force, modificaciones de archivos críticos (FIM), vulnerabilidades CVE y escaladas de privilegios. Eventos mapeados a **MITRE ATT&CK**.

### Acceso Remoto
**WireGuard VPN** con cifrado Curve25519 + ChaCha20-Poly1305. Clientes para Windows, Linux y Android. Todo el acceso auditado en el SOC.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Por qué esta elección |
|---|---|---|
| Hipervisor | VirtualBox / IsardVDI | Gratuito, entorno educativo |
| Firewall | pfSense / OPNsense | Estándar PYME, GUI completa |
| IDS/IPS | Suricata | Multihilo, integrado en pfSense |
| SOC (SIEM/XDR) | **Wazuh** | Open source, MITRE ATT&CK, sin límite de agentes |
| VPN | **WireGuard** | Más rápido que OpenVPN, criptografía moderna |
| DHCP | Kea DHCP | Control granular por subred |
| DNS | Unbound DNS | DNSSEC + filtrado de dominios maliciosos |

---

## 🖥️ Máquinas Virtuales

| VM | SO | Red | IP | RAM | Rol |
|---|---|---|---|---|---|
| `pfsense-fw` | FreeBSD (pfSense) | Todas | 192.168.X.1 | 1 GB | Firewall + Suricata + WireGuard |
| `wazuh-server` | Ubuntu 22.04 LTS | vlan10 | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Debian 12 | vlan10 | 192.168.10.20 | 1 GB | Kea DHCP + Unbound DNS |
| `client-user` | Debian 12 | vlan20 | DHCP | 1 GB | Endpoint usuario + Wazuh Agent |
| `dmz-host` | Debian 12 | vlan30 | 192.168.30.10 | 1 GB | Servicio expuesto + Wazuh Agent |

> ⚠️ RAM mínima del host: **10 GB**

---

## 📋 Sprints

| Sprint | Semanas | Objetivo |
|---|---|---|
| **Sprint 1** | 1–2 | Hipervisor, VMs, diseño de red y diagrama de topología |
| **Sprint 2** | 3–4 | Firewall, VLANs, DHCP, DNS, Suricata IDS/IPS |
| **Sprint 3** | 5–7 | SOC Wazuh (SIEM/XDR) + VPN WireGuard |

Gestión de tareas: **ProofHub** | Control de versiones: **este repositorio**

---

## 📁 Estructura del Repositorio

```
25-26-ASIXcBC-PF-G5/
├── docs/                    # Documentación técnica
├── configs/                 # Configuraciones exportadas (sanitizadas)
├── scripts/                 # Scripts de hardening y automatización
├── tests/evidencias/        # Capturas por prueba (T01/ ... T26/)
├── diagrams/                # Diagramas de topología (draw.io + PNG)
├── weekly-logs/             # Registro semanal de progreso
├── CONTRIBUTING.md          # Convención de commits y ramas
└── .gitignore               # Exclusiones de seguridad
```

---

## 🔒 Módulos ASIX cubiertos

- **Sistemas Operativos en Red** — Instalación y hardening Linux
- **Planificación y Administración de Redes** — VLANs, subneting, routing, NAT
- **Seguridad y Alta Disponibilidad** — Firewall, IDS/IPS, SOC, VPN, mínimo privilegio
- **Servicios en Red** — DHCP, DNS con DNSSEC y filtrado
- **Gestión de Incidentes** — Detección y respuesta con Wazuh + MITRE ATT&CK

---

## 👥 Autors — Grup 5

| Nom | GitHub |
|---|---|
| kevin [itb] armada carrillo | [@KevinArmada-ITB2425](https://github.com/KevinArmada-ITB2425) |
| jan [itb] martinez salas | [@JanMartinez-ITB2425](https://github.com/JanMartinez-ITB2425) |
| ernesto [itb] martinez argueta | [@ErnestoMartinez-ITB2425](https://github.com/ErnestoMartinez-ITB2425) |
