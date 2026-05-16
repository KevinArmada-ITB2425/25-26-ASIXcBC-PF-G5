# 🔐 Arquitectura de Red Corporativa Segura con SOC
> **Proyecto Final — Grado Superior ASIX | Curso 25-26 | Grupo 5**

[![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)]()
[![Ubuntu](https://img.shields.io/badge/Router%2FFirewall-Ubuntu%20Server-orange)]()
[![Wazuh](https://img.shields.io/badge/SOC-Wazuh%20SIEM%2FXDR-blue)]()
[![WireGuard](https://img.shields.io/badge/VPN-WireGuard-green)]()
[![Suricata](https://img.shields.io/badge/IDS%2FIPS-Suricata-red)]()

---

## 📚 Índice

- [¿De qué trata?](#-de-qué-trata-este-proyecto)
- [¿Qué problema resuelve?](#-qué-problema-resuelve)
- [Arquitectura](#️-arquitectura--tres-capas-de-defensa)
- [Stack Tecnológico](#️-stack-tecnológico)
- [Máquinas Virtuales](#️-máquinas-virtuales)
- [Sprints y Weekly Logs](#-sprints--weekly-logs)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Módulos ASIX cubiertos](#-módulos-asix-cubiertos)
- [Autores](#-autores--grupo-5)

---

## 📌 ¿De qué trata este proyecto?

Este proyecto simula la infraestructura de red completa de una PYME real, diseñada desde cero con criterios de seguridad profesional. El objetivo es demostrar cómo una organización puede proteger sus activos digitales frente a amenazas externas e internas aplicando la **tríada CIA** (Confidencialidad, Integridad y Disponibilidad).

Todo el entorno se despliega en máquinas virtuales (IsardVDI), reproduciendo fielmente un entorno corporativo real. Cada componente es **open source y estándar de la industria**.

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
Router/Firewall **Ubuntu Server** con **Suricata IDS/IPS** y `nftables`. Gestiona el enrutamiento entre subredes, aplica NAT hacia internet y bloquea tráfico no autorizado entre segmentos.

### Capa 2 — Segmentación Interna
Tres subredes completamente aisladas con política **deny-all** por defecto gestionada via `nftables`:
- **Subred de Gestión** `192.168.10.0/24` — servidores críticos, solo accesible desde VPN
- **Subred de Usuarios** `192.168.20.0/24` — puestos de trabajo, sin acceso a Gestión
- **Subred DMZ/IoT** `192.168.30.0/24` — servicios expuestos, aislada del resto

### Capa 3 — SOC (Security Operations Center)
Servidor **Wazuh** (SIEM + XDR) en la subred de Gestión. Agentes en todos los endpoints detectan en tiempo real: fuerza bruta, modificaciones de archivos críticos (FIM), vulnerabilidades CVE y escaladas de privilegios. Eventos mapeados a **MITRE ATT&CK**.

### Acceso Remoto
**WireGuard VPN** con cifrado Curve25519 + ChaCha20-Poly1305 instalado en el `admin-server`. Clientes disponibles para Windows, Linux y Android. Todo el acceso auditado en el SOC.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Por qué esta elección |
|---|---|---|
| Hipervisor | IsardVDI | Disponible en el entorno educativo ITB |
| Router / Firewall | Ubuntu Server + nftables | Open source, configurable manualmente, didáctico |
| IDS/IPS | Suricata | Multihilo, instalable en Ubuntu Server |
| SOC (SIEM/XDR) | **Wazuh** | Open source, MITRE ATT&CK, sin límite de agentes |
| VPN | **WireGuard** | Más rápido que OpenVPN, criptografía moderna |
| DHCP | isc-dhcp-server | Estándar, configuración por subred |
| DNS | Technitium DNS | Interfaz web, zona local `jankesto.local` |

---

## 🖥️ Máquinas Virtuales

| VM | SO | Red | IP | RAM | Rol |
|---|---|---|---|---|---|
| `ubuntu-router` | Ubuntu Server 22.04 | Todas | 192.168.X.1 | 2 GB | Router + Firewall (nftables) + Suricata + WireGuard |
| `wazuh-server` | Ubuntu 22.04 LTS | Gestión | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Ubuntu 22.04 | Gestión | 192.168.10.20 | 1 GB | Administración + WireGuard server |
| `client-user1` | Ubuntu 22.04 | Usuarios | 192.168.20.101 | 1 GB | Endpoint usuario + Wazuh Agent |
| `client-user2` | Ubuntu 22.04 | Usuarios | 192.168.20.100 | 1 GB | Endpoint usuario + Wazuh Agent |
| `dmz-host1` | Ubuntu Server 22.04 | DMZ | 192.168.30.10 | 1 GB | Servicio expuesto + Wazuh Agent |
| `dmz-db-server` | Ubuntu Server 22.04 | DMZ | 192.168.30.20 | 1 GB | Servicio expuesto + Wazuh Agent |

> ⚠️ RAM mínima del host: **11 GB**

---

## 📋 Sprints & Weekly Logs

| Sprint | Semanas | Objetivo | Log |
|---|---|---|---|
| **Sprint 1** | S1–S2 | Hipervisor, VMs, diseño de red y diagrama de topología | [📄 Weekly Log S1](weekly-logs/S1-weekly-log.md) |
| **Sprint 2** | S3–S4 | Router Ubuntu, subnetting, DHCP, DNS, Suricata IDS/IPS | [📄 Weekly Log S2](weekly-logs/S2-weekly-log.md) |

Gestión de tareas: **ProofHub** | Control de versiones: **este repositorio**

---

## 📁 Estructura del Repositorio



```
25-26-ASIXcBC-PF-G5/
├── docs/ # Documentación técnica
├── configs/ # Configuraciones exportadas (saneadas)
├── scripts/ # Scripts de hardening y automatización
├── tests/evidencias/ # Capturas por prueba (T01/ ... T26/)
├── diagrams/ # Diagramas de topología (draw.io + PNG)
├── weekly-logs/ # Registro semanal de progreso
└── .gitignore # Exclusiones de seguridad
```


---

## 🔒 Módulos ASIX cubiertos

- **Sistemas Operativos en Red** — Instalación y hardening Linux
- **Planificación y Administración de Redes** — Subnetting, routing, NAT, nftables
- **Seguridad y Alta Disponibilidad** — Firewall, IDS/IPS, SOC, VPN, mínimo privilegio
- **Servicios en Red** — DHCP, DNS con zona local y filtrado
- **Gestión de Incidentes** — Detección y respuesta con Wazuh + MITRE ATT&CK

---

## 👥 Autores — Grupo 5

| Nombre | GitHub |
|---|---|
| Kevin Armada Carrillo | [@KevinArmada-ITB2425](https://github.com/KevinArmada-ITB2425) |
| Jan Martinez Salas | [@JanMartinez-ITB2425](https://github.com/JanMartinez-ITB2425) |
| Ernesto Martinez Argueta | [@ErnestoMartinez-ITB2425](https://github.com/ErnestoMartinez-ITB2425) |
