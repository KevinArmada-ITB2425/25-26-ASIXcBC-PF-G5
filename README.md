# 🔐 Arquitectura de Red Corporativa Segura amb SOC
> **Projecte Final — Grau Superior ASIX | Curs 25-26 | Grup 5**

[![Estat](https://img.shields.io/badge/Estat-En%20Desenvolupament-yellow)]()
[![Ubuntu](https://img.shields.io/badge/Router%2FFirewall-Ubuntu%20Server-orange)]()
[![Wazuh](https://img.shields.io/badge/SOC-Wazuh%20SIEM%2FXDR-blue)]()
[![WireGuard](https://img.shields.io/badge/VPN-WireGuard-green)]()
[![Suricata](https://img.shields.io/badge/IDS%2FIPS-Suricata-red)]()

---

## 📚 Índex

- [¿De qué trata?](#-de-qué-trata-este-proyecto)
- [¿Qué problema resuelve?](#-qué-problema-resuelve)
- [Arquitectura](#️-arquitectura--tres-capas-de-defensa)
- [Stack Tecnológico](#️-stack-tecnológico)
- [Máquinas Virtuales](#️-máquinas-virtuales)
- [Sprints y Weekly Logs](#-sprints--weekly-logs)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Módulos ASIX cubiertos](#-módulos-asix-cubiertos)
- [Autors](#-autors--grup-5)

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
Tres subredes completamente aisladas con política **deny-all** por defecto gestionada via `iptables`:
- **Subxarxa Gestió** `192.168.10.0/24` — servidors crítics, només accessible des de VPN
- **Subxarxa Usuaris** `192.168.20.0/24` — llocs de treball, sense accés a Gestió
- **Subxarxa DMZ/IoT** `192.168.30.0/24` — serveis exposats, aïllada de la resta

### Capa 3 — SOC (Security Operations Center)
Servidor **Wazuh** (SIEM + XDR) a la subxarxa Gestió. Agents en tots els endpoints detecten en temps real: brute-force, modificacions d'arxius crítics (FIM), vulnerabilitats CVE i escalades de privilegis. Esdeveniments mapejats a **MITRE ATT&CK**.

### Acceso Remoto
**WireGuard VPN** amb xifrat Curve25519 + ChaCha20-Poly1305 instal·lat a l'`admin-server`. Clients per a Windows, Linux i Android. Tot l'accés auditat al SOC.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Por qué esta elección |
|---|---|---|
| Hipervisor | IsardVDI | Disponible en el entorno educativo ITB |
| Router / Firewall | Ubuntu Server + nftables | Open source, configurable a mano, didáctico |
| IDS/IPS | Suricata | Multihilo, instalable en Ubuntu Server |
| SOC (SIEM/XDR) | **Wazuh** | Open source, MITRE ATT&CK, sin límite de agentes |
| VPN | **WireGuard** | Más rápido que OpenVPN, criptografía moderna |
| DHCP | isc-dhcp-server | Estándar, configuración por subred |
| DNS | Unbound | DNSSEC + filtrado de dominios maliciosos |

---

## 🖥️ Máquinas Virtuales

| VM | SO | Xarxa | IP | RAM | Rol |
|---|---|---|---|---|---|
| `ubuntu-router` | Ubuntu Server 22.04 | Totes | 192.168.X.1 | 2 GB | Router + Firewall (nftables) + Suricata + WireGuard |
| `wazuh-server` | Ubuntu 22.04 LTS | Gestió | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Debian 12 | Gestió | 192.168.10.20 | 1 GB | DHCP + DNS + WireGuard server |
| `client-user1` | Debian 12 | Usuaris | DHCP | 1 GB | Endpoint usuari + Wazuh Agent 1 |
| `client-user2` | Debian 12 | Usuaris | DHCP | 1 GB | Endpoint usuari + Wazuh Agent 2 |
| `dmz-host1` | Debian 12 | DMZ | 192.168.30.10 | 1 GB | Servei exposat + Wazuh Agent 3 |
| `dmz-host2` | Debian 12 | DMZ | 192.168.30.20 | 1 GB | Servei exposat + Wazuh Agent 4 |

> ⚠️ RAM mínima del host: **11 GB**

---

## 📋 Sprints & Weekly Logs

| Sprint | Semanas | Objetivo | Log |
|---|---|---|---|
| **Sprint 1** | S1–S2 | Hipervisor, VMs, disseny de xarxa i diagrama de topologia | [📄 Weekly Log S1](weekly-logs/S1-weekly-log.md) |
| **Sprint 2** | S3–S4 | Router Ubuntu, subnetting, DHCP, DNS, Suricata IDS/IPS | [📄 Weekly Log S2](weekly-logs/S2-weekly-log.md) |

Gestió de tasques: **ProofHub** | Control de versions: **aquest repositori**

---

## 📁 Estructura del Repositorio



```
25-26-ASIXcBC-PF-G5/
├── docs/ # Documentació tècnica
├── configs/ # Configuracions exportades (sanititzades)
├── scripts/ # Scripts de hardening i automatització
├── tests/evidencias/ # Captures per prova (T01/ ... T26/)
├── diagrams/ # Diagrames de topologia (draw.io + PNG)
├── weekly-logs/ # Registre setmanal de progrés
├── CONTRIBUTING.md # Convenció de commits i branques
└── .gitignore # Exclusions de seguretat
```


---

## 🔒 Módulos ASIX cubiertos

- **Sistemes Operatius en Xarxa** — Instal·lació i hardening Linux
- **Planificació i Administració de Xarxes** — Subnetting, routing, NAT, iptables
- **Seguretat i Alta Disponibilitat** — Firewall, IDS/IPS, SOC, VPN, mínim privilegi
- **Serveis en Xarxa** — DHCP, DNS amb DNSSEC i filtratge
- **Gestió d'Incidents** — Detecció i resposta amb Wazuh + MITRE ATT&CK

---

## 👥 Autors — Grup 5

| Nom | GitHub |
|---|---|
| kevin [itb] armada carrillo | [@KevinArmada-ITB2425](https://github.com/KevinArmada-ITB2425) |
| jan [itb] martinez salas | [@JanMartinez-ITB2425](https://github.com/JanMartinez-ITB2425) |
| ernesto [itb] martinez argueta | [@ErnestoMartinez-ITB2425](https://github.com/ErnestoMartinez-ITB2425) |