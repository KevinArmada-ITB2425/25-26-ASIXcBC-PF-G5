# Plan de Proyecto

## Información General

| Campo | Detalle |
|---|---|
| **Proyecto** | Arquitectura de Red Corporativa Segura con SOC |
| **Módulo** | Proyecto Integrado — Grado Superior ASIX |
| **Curso** | 2025–2026 |
| **Grupo** | G5 |
| **Herramienta de tareas** | ProofHub |
| **Repositorio** | GitHub (`25-26-ASIXcBC-PF-G5`) |

---

## Hitos (Milestones)

| Hito | Sprint | Entregable |
|---|---|---|
| M1 — Infraestructura base operativa | 1 | VMs funcionando, Ubuntu Router accesible |
| M2 — Red segmentada y firewall activo | 2 | 3 subredes aisladas con nftables + Suricata + DHCP + DNS |
| M3 — SOC y VPN operativos | 2 | Wazuh con 5 agentes + Active Response |

---

## Sprint 1 — Diseño e Infraestructura Base
**Duración:** Semana 1–2 · **Objetivo:** Entorno virtualizado lanzado y documentado

| # | Tarea | Descripción | Rama Git |
|---|---|---|---|
| 1 | Definir plan de direccionamiento IP y tabla de VMs | Decidir subredes definitivas (10, 20, 30) y asignar IPs fijas a los servidores y documentarlo en `docs/diseno-red.md` | `docs/diseno-red` |
| 2 | Crear diagrama de topología en packet tracert | Dibujar la topología completa (Internet → Ubuntu Router → subredes → VMs → Wazuh), exportar en PNG y guardarlo en `diagrams/` | `docs/diseno-red` |
| 3 | Crear las redes internas por subred | Configurar adaptadores de red interna en el hipervisor (uno por subred: Gestión, Usuarios, DMZ) para aislar el tráfico entre redes desde el inicio |  |
| 4 | Crear y arrancar la VM `ubuntu-router` | Descargar ISO Ubuntu Server 22.04, crear VM con 2 vCPUs / 2 GB RAM, asignar 4 interfaces (WAN + 3 subredes internas), completar la instalación inicial |  |
| 5 | Crear y arrancar la VM `wazuh-server` | Descargar ISO Ubuntu 22.04 LTS, crear VM con **mínimo 4 GB RAM y 2 vCPUs** (requisito Wazuh), configurar IP por dhcp gracias al router `192.168.10.10` en subred Gestión |  |
| 6 | Crear las VMs `admin-server`, `client-user1`, `client-user2`, `dmz-host1` y `dmz-db-server` | Instalar Ubuntu 22.04 en las 5 VMs restantes, asignarlas a su subred correspondiente y verificar arranque correcto |  |
| 7 | Verificar conectividad básica entre VMs | Comprobar con `ping` que cada VM puede comunicarse con su gateway (`ubuntu-router`) y que el router recibe tráfico correctamente |  |
| 8 | Documentar el entorno en `docs/diseno-red.md` | Escribir la tabla de VMs definitiva (SO, subred, IP, RAM, rol), la topología y la matriz de comunicación entre subredes | `docs/diseno-red` |

---

## Sprint 2 — Router, Firewall y Servicios de Red
**Duración:** Semana 3–4 · **Objetivo:** Red segmentada, aislada y con servicios básicos activos

| # | Tarea | Descripción | Rama Git |
|---|---|---|---|
| 1 | Configurar interfaces de red con Netplan | Asignar IPs fijas a las 4 interfaces del `ubuntu-router` (`enp1s0` WAN, `enp2s0` Gestión, `enp3s0` Usuarios, `enp4s0` DMZ) en `/etc/netplan/` y aplicar con `netplan apply` |  |
| 2 | Activar IP forwarding y NAT | Habilitar `net.ipv4.ip_forward=1` en `/etc/sysctl.conf` y configurar la regla de masquerade en `nftables` para NAT hacia internet por la interfaz WAN |  |
| 3 | Configurar `isc-dhcp-server` por subred | Definir un pool de IPs independiente para cada subred en `/etc/dhcp/dhcpd.conf`, con reservas MAC para todos los servidores y gateway/DNS por subred |  |
| 4 | Instalar y configurar Technitium DNS | Instalar Technitium DNS Server, configurar forwarders (`8.8.8.8` / `1.1.1.1`), crear zona local `jankesto.local` con registros A para las VMs principales |  |
| 5 | Implementar política deny-all con nftables | Escribir `/etc/nftables.conf` con política `drop` por defecto en las cadenas `input` y `forward`; activar y persistir con `systemctl enable nftables` |  |
| 6 | Añadir reglas de excepción explícitas | Por encima del deny-all, añadir únicamente el tráfico necesario: Usuarios → DMZ (HTTP/HTTPS), subredes → Wazuh (puertos 1514/1515/55000), DNS para todas las subredes, acceso admin al router |  |
| 7 | Instalar Suricata y configurar HOME_NET | Instalar Suricata desde `ppa:oisf/suricata-stable`, definir `HOME_NET` con las 3 subredes y configurar monitorización sobre la interfaz WAN (`enp1s0`) |  |
| 8 | Activar reglas y suprimir falsos positivos | Actualizar el ruleset con `suricata-update`, suprimir alertas de ruido conocido en `threshold.config` y verificar detección con `nmap` desde Kali |  |
| 9 | Exportar y sanear configuraciones | Guardar los ficheros saneados de nftables, DHCP, Netplan y Suricata en `configs/ubuntu-router/`; eliminar cualquier credencial antes del commit |  |
| 10 | Instalar Wazuh all-in-one en `wazuh-server` | Ejecutar el script oficial de instalación de Wazuh en Ubuntu 22.04, desplegando Manager, Indexer (OpenSearch) y Dashboard en una sola VM |  |
| 11 | Instalar y registrar agentes en todas las VMs | Instalar `wazuh-agent` v4.11.2 en los 5 endpoints, configurar la IP del manager (`192.168.10.10`) y registrar cada agente desde el dashboard |  |
| 12 | Verificar conectividad agentes → manager | Comprobar que los agentes de las subredes Usuarios y DMZ alcanzan los puertos 1514/1515 del manager a través de las reglas nftables; corregir el bloqueo documentado en `client-user1` |  |
| 13 | Configurar Active Response con Suricata + nftables | Añadir en `ossec.conf` el comando `nftables-drop` y la regla de active-response para el agente `007` (`ubuntu-router`); desplegar `nftables-drop.sh` en `/var/ossec/active-response/bin/` |  |
| 14 | Implementar scripts de automatización | Crear y desplegar en `/usr/local/bin/`: `wazuh-healthcheck.sh` (cada 5 min), `wazuh-agents-report.sh` (diario 08:00) y `wazuh-backup.sh` (diario 03:00); programar via `/etc/crontab` |  |
| 15 | Implementar scripts de backup del router | Crear los scripts modulares `01-base.sh` a `05-suricata.sh` en `configs/ubuntu-router/backups-automatizacion/scripts/` para backup automático de cada componente del router |  |

---
