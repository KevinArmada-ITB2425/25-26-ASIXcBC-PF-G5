# 🔐 Arquitectura de Red Corporativa Segura con SOC
> Proyecto Integrado — Grado Superior ASIX

[![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-yellow)]()
[![pfSense](https://img.shields.io/badge/Firewall-pfSense%2FOPNsense-orange)]()
[![Wazuh](https://img.shields.io/badge/SOC-Wazuh%20SIEM%2FXDR-blue)]()
[![WireGuard](https://img.shields.io/badge/VPN-WireGuard-green)]()
[![Suricata](https://img.shields.io/badge/IDS%2FIPS-Suricata-red)]()

---

## 📌 ¿De qué trata este proyecto?

Este proyecto simula la infraestructura de red completa de una PYME real, diseñada desde cero con criterios de seguridad profesional. El objetivo es demostrar cómo una organización puede proteger sus activos digitales frente a amenazas externas e internas aplicando la **tríada CIA** (Confidencialidad, Integridad y Disponibilidad).

Todo el entorno se despliega en máquinas virtuales, lo que permite reproducir fielmente un entorno corporativo real sin necesidad de hardware dedicado. Cada componente está elegido por ser **estándar de la industria**, de código abierto y ampliamente utilizado en entornos empresariales reales.

---

## 🎯 ¿Qué problema resuelve?

Una PYME típica sin medidas de seguridad avanzadas es vulnerable a:

- **Movimiento lateral**: un atacante que compromete un equipo de usuario puede saltar a servidores críticos.
- **Ataques perimetrales**: escaneos de puertos, fuerza bruta, exploits conocidos.
- **Falta de visibilidad**: sin monitorización, los incidentes pasan desapercibidos durante días o semanas.
- **Acceso remoto inseguro**: empleados que se conectan desde fuera sin cifrado exponen la red interna.

Este proyecto ataca los cuatro problemas de forma simultánea con una arquitectura en capas.

---

## 🏗️ ¿Qué vamos a construir?

La infraestructura se organiza en **tres capas de defensa**:

### Capa 1 — Perímetro
Un firewall **pfSense/OPNsense** actúa como única puerta de entrada y salida de la red. Gestiona el enrutamiento, aplica NAT y filtra todo el tráfico con reglas explícitas. Integra **Suricata** como motor IDS/IPS que analiza cada paquete en busca de firmas de ataques conocidos y bloquea automáticamente las IPs que representen una amenaza.

### Capa 2 — Segmentación Interna (VLANs)
La red interna se divide en tres zonas lógicas completamente aisladas entre sí mediante etiquetado **802.1Q**:

- **VLAN 10 — Gestión** (`192.168.10.0/24`): para servidores críticos y administración. Solo accesible desde la VPN o la consola local.
- **VLAN 20 — Usuarios** (`192.168.20.0/24`): para los puestos de trabajo del personal. Sin acceso a la VLAN de Gestión.
- **VLAN 30 — DMZ/IoT** (`192.168.30.0/24`): para servicios expuestos o dispositivos menos seguros. Aislada del resto.

La política base es **deny-all**: ningún tráfico entre VLANs está permitido salvo que haya una regla explícita que lo justifique (principio de mínimo privilegio).

### Capa 3 — SOC (Security Operations Center)
Un servidor centralizado con **Wazuh** (SIEM + XDR open source) ubicado en la VLAN de Gestión recolecta y analiza logs de toda la infraestructura en tiempo real. Los agentes instalados en cada endpoint detectan:
- Intentos de acceso fallidos y ataques de fuerza bruta
- Modificaciones en archivos críticos del sistema (File Integrity Monitoring)
- Vulnerabilidades de software (cruce automático con bases de datos CVE)
- Escaladas de privilegios y comportamientos anómalos

Todos los eventos se mapean al framework **MITRE ATT&CK**, el estándar de la industria para clasificar tácticas y técnicas de ataque.

### Acceso Remoto Seguro
Un servidor **WireGuard VPN** permite que empleados externos accedan a recursos internos con cifrado de extremo a extremo (Curve25519 + ChaCha20-Poly1305), con clientes disponibles para Windows, Linux y Android. Todo el acceso queda auditado en el SOC.

---

## 🛠️ Stack Tecnológico

| Componente | Tecnología | Por qué esta elección |
|---|---|---|
| Hipervisor | VirtualBox / IsardVDI | Gratuito, multiplataforma, fácil de gestionar en entorno educativo |
| Firewall/Router | pfSense / OPNsense | Estándar de industria en PYMEs, FreeBSD, GUI completa, comunidad enorme |
| IDS/IPS | Suricata | Motor más rápido que Snort, multihilo, integrado nativamente en pfSense |
| SOC (SIEM/XDR) | **Wazuh** | Open source, unifica SIEM + XDR + EDR, integración MITRE ATT&CK, sin límite de agentes |
| VPN | **WireGuard** | Más rápido y moderno que OpenVPN, criptografía de última generación, código auditado |
| DHCP | Kea DHCP | Sucesor oficial de ISC DHCP, control granular por subred |
| DNS | Unbound DNS | Resolver recursivo con DNSSEC y filtrado de dominios maliciosos |

---

## 🖥️ Máquinas Virtuales del Entorno

| VM | Sistema Operativo | VLAN | IP | RAM | Rol |
|---|---|---|---|---|---|
| `pfsense-fw` | FreeBSD (pfSense CE) | Todas | 192.168.X.1 | 1 GB | Firewall + Suricata + WireGuard |
| `wazuh-server` | Ubuntu 22.04 LTS | VLAN 10 | 192.168.10.10 | **4 GB** | SOC: Wazuh Manager + Indexer + Dashboard |
| `admin-server` | Debian 12 | VLAN 10 | 192.168.10.20 | 1 GB | Kea DHCP + Unbound DNS |
| `client-user` | Debian 12 | VLAN 20 | DHCP | 1 GB | Endpoint usuario + Wazuh Agent |
| `dmz-host` | Debian 12 | VLAN 30 | 192.168.30.10 | 1 GB | Servicio expuesto + Wazuh Agent |

> ⚠️ **RAM mínima del host:** 10 GB (8 GB para VMs + 2 GB para el hipervisor)

---

## 📋 Plan de Trabajo

El proyecto se desarrolla en **3 sprints** de dos semanas cada uno, gestionados en ProofHub:

| Sprint | Semanas | Objetivo |
|---|---|---|
| **Sprint 1** | 1–2 | Infraestructura base: hipervisor, VMs y diseño de red |
| **Sprint 2** | 3–4 | Firewall, VLANs, Kea DHCP, Unbound DNS y Suricata |
| **Sprint 3** | 5–7 | SOC con Wazuh (SIEM/XDR) y VPN con WireGuard |

---

## 🔒 Competencias ASIX que cubre

Este proyecto integra conocimientos de múltiples módulos del grado:

- **Sistemas Operativos en Red** — Instalación, hardening y administración de Linux
- **Planificación y Administración de Redes** — VLANs 802.1Q, subneting, routing, NAT
- **Seguridad y Alta Disponibilidad** — Firewall perimetral, IDS/IPS, SOC, VPN, mínimo privilegio
- **Servicios en Red** — DHCP, DNS con DNSSEC y filtrado
- **Gestión de Incidentes** — Detección, análisis y respuesta mediante Wazuh + MITRE ATT&CK


---

## 👤 Autores

**kevin, ernesto y jan** — Grado Superior ASIX
