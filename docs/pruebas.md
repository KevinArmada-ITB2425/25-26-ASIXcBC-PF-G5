# Pla de Proves — T01 a T26

## Aïllament i Connectivitat (Sprint 2)

| ID | Prova | Esperat | Eina | Estat |
|---|---|---|---|---|
| T01 | VLAN20 → Internet (HTTP/HTTPS) | ALLOW | curl | ⏳ |
| T02 | VLAN10 → Internet | ALLOW | ping | ⏳ |
| T03 | DHCP assigna IP correcta per VLAN | IP del pool correcte | ip a | ⏳ |
| T04 | DNS resol dominis legítims | Resolució correcta | nslookup | ⏳ |
| T05 | DNS bloqueja domini maliciós | NXDOMAIN | nslookup | ⏳ |
| T06 | VLAN20 → VLAN10 (ping) | **DENY** | ping | ⏳ |
| T07 | VLAN20 → VLAN10 (nmap) | **DENY / filtrat** | nmap | ⏳ |
| T08 | VLAN20 → VLAN30 (ping) | **DENY** | ping | ⏳ |
| T09 | VLAN30 → VLAN10 (ping) | **DENY** | ping | ⏳ |
| T10 | VLAN10 → VLAN20 (controlat) | ALLOW segons regles | ping | ⏳ |

## IDS/IPS Suricata (Sprint 2)

| ID | Prova | Esperat | Eina | Estat |
|---|---|---|---|---|
| T11 | Escaneig de ports agressiu | Alerta + bloqueig IP | nmap -A | ⏳ |
| T12 | Escaneig SYN stealth | Alerta generada | nmap -sS | ⏳ |
| T13 | Intent brute-force SSH | Alerta + bloqueig | hydra | ⏳ |
| T14 | Descàrrega EICAR (test malware) | Alerta generada | wget | ⏳ |
| T15 | Tràfic normal | Sense alertes (falsos positius) | navegació | ⏳ |

## SOC Wazuh (Sprint 3)

| ID | Prova | Esperat | Eina | Estat |
|---|---|---|---|---|
| T16 | Brute-force SSH des de VLAN 20 | Alerta nivell ≥ 10 a Wazuh | hydra | ⏳ |
| T17 | Modificació de /etc/passwd | Alerta FIM a Wazuh | echo manual | ⏳ |
| T18 | Modificació de /etc/sudoers | Alerta FIM a Wazuh | echo manual | ⏳ |
| T19 | Escalada de privilegis (sudo) | Alerta a Wazuh | sudo -l | ⏳ |
| T20 | Logs de pfSense visibles a Wazuh | Events firewall al dashboard | Dashboard | ⏳ |
| T21 | Vulnerabilitat CVE detectada | Apareix a Vulnerability tab | Wazuh scan | ⏳ |
| T22 | Resposta activa: bloqueig IP | IP bloquejada automàticament | Script Wazuh | ⏳ |

## VPN WireGuard (Sprint 3)

| ID | Prova | Esperat | Eina | Estat |
|---|---|---|---|---|
| T23 | Connexió VPN des de Linux | Túnel actiu | wg show | ⏳ |
| T24 | Connexió VPN des de Windows | Túnel actiu | WireGuard GUI | ⏳ |
| T25 | Accés a VLAN 10 per VPN | ALLOW (recursos interns) | ping / SSH | ⏳ |
| T26 | Tràfic VPN xifrat (Wireshark) | Il·legible en captura | Wireshark | ⏳ |

## Com registrar evidències

```bash
mkdir -p tests/evidencies/T16-brute-force-ssh/
hydra -l root -P /usr/share/wordlists/rockyou.txt ssh://192.168.20.x 2>&1 | tee tests/evidencies/T16-brute-force-ssh/output.txt
git add tests/evidencies/T16-brute-force-ssh/
git commit -m "test(wazuh): evidència detecció brute-force SSH T16"
```
