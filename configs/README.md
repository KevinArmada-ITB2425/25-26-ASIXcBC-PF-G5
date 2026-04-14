# Configs

Arxius de configuració exportats i **sanitats** (sense credencials ni claus privades).

> ⚠️ Abans de fer commit, elimina o reemplaça: contrasenyes, hashes bcrypt, claus privades WireGuard i certificats TLS.

## Estructura

- `pfsense/` — config.xml sanititzat
- `wireguard/` — arxius .conf sense PrivateKey
- `vlans/` — configuració d'interfícies
- `wazuh/` — ossec.conf i regles personalitzades
