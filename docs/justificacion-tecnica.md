# Justificación Técnica — Competencias ASIX

## Módulos ASIX cubiertos

| Módulo ASIX | Componente del Proyecto |
|---|---|
| **Sistemas Operativos en Red** | Instalación y hardening de Ubuntu Server 22.04 en todas las VMs, gestión de servicios con `systemd`, acceso remoto via SSH |
| **Planificación y Administración de Redes** | Diseño de topología en tres subredes segmentadas (`192.168.10.x`, `20.x`, `30.x`), subnetting, routing entre interfaces, NAT con `nftables` en Ubuntu Router |
| **Seguridad y Alta Disponibilidad** | Firewall perimetral con `nftables` (política deny-all), IDS/IPS Suricata en interfaz WAN, SOC con Wazuh SIEM/XDR, principio de mínimo privilegio |
| **Servicios en Red** | DHCP con `isc-dhcp-server` con reservas MAC por subred, DNS interno Technitium con zona local `jankesto.local` y forwarders a `8.8.8.8` / `1.1.1.1` |
| **Implantación de Aplicaciones Web** | Servidor web Nginx + PHP-FPM en DMZ, base de datos MariaDB aislada, acceso a servicios internos y gestión del SOC via dashboard Wazuh (`https://192.168.10.10`) |

---

## Competencias Transversales

- **Gestión de Incidentes**: detección, análisis y respuesta automatizada mediante Wazuh — mapeo de alertas a MITRE ATT&CK, Active Response con bloqueo automático de IPs via `nftables`
- **Automatización**: scripts de healthcheck, reporte de agentes y backup programados via `cron`; scripts de backup modular del router por componente
- **Documentación técnica**: repositorio GitHub con estructura organizada por carpetas (`configs/`, `docs/`, `scripts/`, `diagrams/`), documentación por VM y weekly logs por sprint
- **Autonomia y resolución de problemas**: diseño e implementación end-to-end sin infraestructura comercial, troubleshooting documentado de incidencias reales (compatibilidad Wazuh 4.11 vs 4.14, resolución DNS, reglas nftables)
- **Trabajo en equipo**: gestión de tareas en ProofHub con sprints, control de versiones colaborativo en GitHub
