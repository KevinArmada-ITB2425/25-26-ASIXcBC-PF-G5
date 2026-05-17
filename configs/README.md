# ⚙️ Configs

Archivos de configuración exportados y **saneados** (sin credenciales ni claves privadas)


---

## 📁 Estructura
```
configs/
├── wazuh/ # Wazuh Manager — ossec.conf, reglas personalizadas e imágenes
├── ubuntu-router/ # Router/Firewall Ubuntu — nftables, Suricata, DHCP, DNS
│ └── backups-automatizacion/ # Scripts y configs de backup automático del router
│ ├── configs/
│ └── scripts/
├── dmz/ # Documentación de los hosts en la DMZ
│ ├── Documentacio dmz-host1.md
│ ├── Documentacio dmz-host2.md
```

---

## 📂 Contenido por carpeta

### `wazuh/`

Configuración del Wazuh Manager all-in-one (`wazuh-server` · `192.168.10.10`). Documentación completa en [`config.md`](wazuh/config.md).

**Incluye:**
- Instalación y verificación de los 3 servicios (Manager + Indexer + Dashboard)
- 5 agentes registrados: `dmz-host1`, `dmz-db-server`, `client-user1`, `client-user2`, `admin-server`
- 3 scripts de automatización: healthcheck (cada 5 min), reporte diario de agentes y backup con retención de 7 días
- Active Response con Suricata: bloqueo automático de IPs atacantes en `nftables` durante 1 hora
- Capturas del dashboard como evidencia de funcionamiento

### `ubuntu-router/`

Router/Firewall Ubuntu Server (`192.168.X.1`) con 4 interfaces de red. Documentación completa en [`config.md`](ubuntu-router/config.md).

**Incluye:**
- Routing entre 3 subredes (Gestión `10.x`, Usuarios `20.x`, DMZ `30.x`) con NAT hacia internet via `nftables`
- Firewall con política deny-all por defecto y reglas de segmentación entre subredes
- DHCP (`isc-dhcp-server`) con reservas MAC para todos los servidores
- DNS interno Technitium con zona local `jankesto.local` y forwarders a `8.8.8.8` / `1.1.1.1`
- Suricata IDS monitorizando la interfaz WAN (`enp1s0`), logs en `eve.json` consumidos por Wazuh

**Subcarpeta `backups-automatizacion/`:** scripts de backup automático del router organizados por componente:

| Script | Componente |
|---|---|
| `01-base.sh` | Sistema base |
| `02-dhcp.sh` | Configuración DHCP |
| `03-dns.sh` | Configuración DNS |
| `04-nftables.sh` | Reglas de firewall |
| `05-suricata.sh` | Configuración Suricata |

### `dmz/`

Documentación de los dos hosts expuestos en la subred DMZ (`192.168.30.0/24`). Documentación detallada en [`Documentacio dmz-host1.md`](dmz/Documentacio%20dmz-host1.md) y [`Documentacio dmz-host2.md`](dmz/Documentacio%20dmz-host2.md).

| Host | IP | Rol | Agente Wazuh |
|---|---|---|---|
| `dmz-host1` | `192.168.30.10` | Servidor web (Nginx + PHP-FPM) | ✅ ID `002` |
| `dmz-host2` | `192.168.30.20` | Servidor de base de datos (MariaDB) | ✅ ID `003` |

**Incluye:**
- Instalación y configuración del stack web (Nginx + PHP-FPM) y base de datos (MariaDB)
- Despliegue del agente Wazuh v4.11.2 vinculado al Manager (`192.168.10.10`)
- Monitorización de logs de Nginx y MariaDB por el SOC
- Troubleshooting documentado: errores 502, compatibilidad Wazuh 4.11 vs 4.14, acceso remoto a MariaDB y resolución DNS


---

## 🔒 Reglas de seguridad antes de hacer commit

| Dato sensible | Acción |
|---|---|
| Contraseñas en texto plano | Eliminar o reemplazar por `<REDACTED>` |
| `PrivateKey` de WireGuard | Eliminar — nunca subir al repo |
| Certificados TLS / `.pem` | Excluidos vía `.gitignore` |
| Hashes bcrypt | Eliminar o reemplazar |
| Tokens de API (Wazuh, etc.) | Eliminar o reemplazar por `<TOKEN>` |
