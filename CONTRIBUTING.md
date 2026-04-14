# Guia de Contribució — Convenció de Commits i Branques

## 🌿 Estratègia de Branques

```
main          ← Versió estable entregable
  └── develop ← Integració contínua
        ├── feature/proxmox-setup
        ├── feature/pfsense-vlans
        ├── feature/suricata-ids
        ├── feature/wazuh-soc
        ├── feature/wireguard-vpn
        └── docs/memoria-final
```

**Flux:** crea branca des de `develop` → treballes → PR cap a `develop` → al final de sprint, `develop` → `main`

---

## ✅ Convenció de Commits

**Format:** `tipus(àmbit): descripció en imperatiu`

### Tipus

| Tipus | Ús |
|---|---|
| `feat` | Nova funcionalitat o component configurat |
| `fix` | Correcció d'error de configuració |
| `config` | Arxiu de configuració exportat/actualitzat |
| `docs` | Canvi només en documentació |
| `test` | Prova executada o evidència afegida |
| `chore` | Manteniment (.gitignore, estructura) |

### Àmbits
`proxmox` · `firewall` · `vlan` · `dhcp` · `dns` · `ids` · `wazuh` · `vpn` · `scripts` · `docs`

### Exemples

```bash
feat(firewall): implementar regles deny-all inter-VLAN
feat(wazuh): instal·lar i registrar agent a VLAN 20
config(vpn): exportar configuració WireGuard servidor
test(ids): evidència detecció escaneig nmap amb Suricata
docs(vlan): actualitzar matriu de comunicació inter-VLAN
fix(dhcp): corregir rang d'IPs a VLAN de Gestió
```

### Commit amb cos (canvis importants)

```bash
git commit -m "feat(wazuh): configurar FIM en rutes crítiques

- Monitorització de /etc/passwd, /etc/sudoers, /etc/ssh/
- Monitorització de /bin i /usr/bin
- Alerta nivell 7 davant qualsevol modificació no autoritzada

Completa tasca ProofHub: Sprint 3 > 'Activar FIM als endpoints'"
```

---

## 📌 Labels d'Issues a GitHub

| Label | Ús |
|---|---|
| `infrastructure` | VirtualBox, VMs, xarxa |
| `firewall` | pfSense, regles |
| `vlan` | Segmentació |
| `wazuh` | SOC, SIEM, agents |
| `vpn` | WireGuard |
| `ids-ips` | Suricata |
| `documentation` | Docs, diagrames |
| `bug` | Fallada detectada |
| `in-progress` | En desenvolupament |
| `done` | Completat |
