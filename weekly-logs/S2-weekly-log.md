# Sprint 2 — Weekly Log · 05/05/2026 – 19/05/2026
> **Objetivo:** Router Ubuntu, subnetting, DHCP, DNS, Suricata IDS/IPS

---

## Semana 3 · 05/05 – 11/05

### ✅ Completado
- Migración de pfSense a Ubuntu Server como router perimetral · *#sprint2*
  - Migración completa de la infraestructura de red perimetral desde pfSense hacia Ubuntu Server 22.04
- Configuración de las interfaces de red via Netplan · *#sprint2*
  - Configuración estática de las cuatro interfaces de red (WAN + Gestión + Usuarios + DMZ)
- Configuración de Routing (ip_forward + NAT) · *#sprint2*
  - Activación de `ip_forward` en el kernel de Linux y configuración de reglas NAT (enmascaramiento) via `nftables`
- Configuración de NFTables · *#sprint2*
  - Implementación de firewall perimetral con `nftables` para aislar redes, permitiendo tráfico web de Usuarios → DMZ
- Configuración DHCP · *#sprint2*
  - Instalación y puesta en marcha del servidor `isc-dhcp-server`, configuración de subredes y reservas MAC
- Configuración DNS · *#sprint2*
  - Instalación y configuración de Technitium DNS Server con interfaz web, implementación de zona local `jankesto.local`
- Cambio de contraseña admin de Wazuh · *#sprint2*
  - Contraseña por defecto sustituida mediante `wazuh-passwords-tool.sh` por línea de comandos (la GUI devuelve `FORBIDDEN` para el usuario `admin`)
- Instalar agente en `dmz-host1` · *#sprint2*
  - Instalación de `wazuh-agent` en `dmz-host1` (192.168.30.10) y registro correcto en el dashboard con estado `active`
- Instalar agente en `dmz-db-server` · *#sprint2*
  - Instalación de `wazuh-agent` en `dmz-db-server` (192.168.30.20) y verificación de conectividad con el manager

### ❌ Bloqueantes
| Problema | Causa | Solución aplicada |
|---|---|---|
| `wazuh-server` sin DNS al hacer `apt update` | `resolv.conf` apuntaba a `127.0.0.53` (systemd-resolved sin gateway) | Sustituido symlink por fichero estático con `8.8.8.8` y `1.1.1.1` |
| No se puede cambiar password admin desde la GUI | El usuario `admin` está reservado en OpenSearch/Wazuh Indexer | Cambio hecho via `wazuh-passwords-tool.sh -u admin -p '...'` por CLI |
| `client-user1` desconectado del Wazuh Manager | El agente estaba operativo pero tras un reinicio dejó de conectar al puerto 1515 — bloqueo nftables entre VLANs | Resuelto en S4: regla explícita añadida a nftables para permitir puertos `1514`, `1515`, `55000` desde Usuarios y DMZ hacia Wazuh |

### ⏱️ Horas
| Día | Horas | Actividad |
|---|---|---|
| Martes 05/05 | 6h | Migración pfSense→Ubuntu, Netplan, Routing, NFTables, DHCP, DNS Technitium, cambio password Wazuh |
| Viernes 08/05 | 3h | Diagnóstico bloqueante `client-user1` desconectado de Wazuh, instalación agentes DMZ |
| **Total S3** | **9h** | |

---

## Semana 4 · 12/05 – 18/05

### ✅ Completado
- Crear las VMs `admin-server`, `client-user2` y `dmz-host` restantes · *#sprint2*
  - Instalación de Debian 12 en las 3 VMs restantes, asignación a su VLAN correspondiente y verificación de arranque correcto
- Instalar agente en `client-user1` · *#sprint2*
  - Re-registro de `wazuh-agent` en `client-user1` (192.168.20.102) con ID `005` tras resolver el bloqueo nftables en el puerto 1515
- Instalar agente en `client-user2` · *#sprint2*
  - Instalación de `wazuh-agent` en `client-user2` (192.168.20.100) y verificación de conectividad con el manager
- Instalar agente en `admin-server` · *#sprint2*
  - Instalación de `wazuh-agent` en `admin-server` (192.168.10.20) y registro en el dashboard con estado `active`
- Configurar Suricata IDS/IPS · *#sprint2*
  - Despliegue de Suricata como sensor IDS/IPS en modo monitor sobre `ubuntu-router`, inspección de tráfico (DPI) en la interfaz WAN (`enp1s0`), reglas de detección de escaneos de puertos y patrones de ataques en la DMZ

### ⏱️ Horas
| Día | Horas | Actividad |
|---|---|---|
| Lunes 11/05 | 3h | Creación VMs restantes, instalación agentes `client-user2` y `admin-server` |
| Martes 12/05 | 6h | Resolución bloqueante `client-user1`, configuración Suricata, actualización nftables con reglas agentes Wazuh |
| **Total S4** | **9h** | |

---

## 📊 Resumen Sprint 2 (actualizado 12/05)
| | Valor |
|---|---|
| Tareas completadas | **13 / 13** |
| Horas totales | **18h** |
| Bloqueantes resueltos | 3 / 3 |
