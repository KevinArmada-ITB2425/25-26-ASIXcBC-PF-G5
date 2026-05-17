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
└── Documentacio dmz-host2.md
```

---

## 📂 Contenido por carpeta

### `wazuh/`
Configuración del Wazuh Manager (all-in-one): `ossec.conf` con las reglas de Active Response, integración con Suricata y agentes registrados. Incluye capturas del dashboard como evidencia.

### `ubuntu-router/`
Configuración del router/firewall Ubuntu Server: reglas `nftables`, configuración de Suricata IDS/IPS, DHCP por subred y DNS Technitium. La subcarpeta `backups-automatizacion/` contiene los scripts de backup automático y sus configuraciones.

### `dmz/`
Documentación de los dos hosts de la DMZ (`dmz-host1` y `dmz-host2`): servicios expuestos, configuración de los agentes Wazuh y hardening aplicado.

### `wireguard/`
Archivos `.conf` de los peers WireGuard con la `PrivateKey` eliminada. Incluye la configuración del servidor (`admin-server`) y los clientes.

---

## 🔒 Reglas de seguridad antes de hacer commit

| Dato sensible | Acción |
|---|---|
| Contraseñas en texto plano | Eliminar o reemplazar por `<REDACTED>` |
| `PrivateKey` de WireGuard | Eliminar — nunca subir al repo |
| Certificados TLS / `.pem` | Excluidos vía `.gitignore` |
| Hashes bcrypt | Eliminar o reemplazar |
| Tokens de API (Wazuh, etc.) | Eliminar o reemplazar por `<TOKEN>` |
