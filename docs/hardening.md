# Hardening — Checklists de Securització

## pfSense / OPNsense
- [ ] Canviar credencials per defecte
- [ ] Deshabilitar accés WebGUI des de WAN
- [ ] Forçar HTTPS a la WebGUI
- [ ] SSH només des de VLAN 10, amb clau pública
- [ ] Bloquejar tràfic bogon i RFC1918 a WAN
- [ ] Habilitar scrubbing de paquets
- [ ] Configurar NTP amb servidors fiables

## Suricata
- [ ] Activar regles ET Open (Emerging Threats)
- [ ] Habilitar mode IPS inline a interfície LAN
- [ ] Bloqueig automàtic après ≥5 alertes des de la mateixa IP
- [ ] Ajustar llindars per reduir falsos positius

## Wazuh
- [ ] Accés al dashboard només des de VLAN 10
- [ ] Canviar credencials admin del dashboard
- [ ] Habilitar HTTPS al dashboard
- [ ] FIM actiu en: `/etc/passwd`, `/etc/sudoers`, `/etc/ssh/sshd_config`, `/bin/`, `/usr/bin/`
- [ ] Regla d'alerta per modificació d'arxius crítics (nivell ≥ 7)
- [ ] Resposta activa per bloquejar IPs après brute-force

## WireGuard
- [ ] Claus generades amb `wg genkey` (Curve25519, 256-bit)
- [ ] `AllowedIPs` específics per peer
- [ ] Port WireGuard accessible només des de WAN
- [ ] Rotació de PreSharedKey (PSK) periòdica

## Servidors Linux (Debian/Ubuntu)
```bash
apt update && apt full-upgrade -y

# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
AllowUsers adminuser
Port 2222

# UFW
ufw default deny incoming
ufw allow from 192.168.10.0/24 to any port 2222
ufw enable

apt install fail2ban -y
```

## Unbound DNS
- [ ] Deshabilitar recursió des de subxarxes no autoritzades
- [ ] Activar DNSSEC
- [ ] Carregar llista de bloqueig (DNSBL)
- [ ] Habilitar query name minimisation
