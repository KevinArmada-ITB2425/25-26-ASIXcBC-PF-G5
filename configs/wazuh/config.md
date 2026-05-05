# Configuració Wazuh Server

## Informació General

| Camp | Detall |
|---|---|
| **VM** | `wazuh-server` |
| **SO** | Ubuntu Server 22.04 LTS |
| **RAM** | 4 GB |
| **vCPUs** | 2 |
| **IP** | `192.168.10.10/24` |
| **Versió Wazuh** | 4.11 |
| **Rol** | SOC: Wazuh Manager + Indexer + Dashboard (all-in-one) |

---

## Prerequisits

```bash
sudo apt update
sudo apt install curl apt-transport-https unzip wget -y
```

---

## Instal·lació

### 1. Descarregar scripts oficials

```bash
curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.11/config.yml
```

### 2. Configurar nodes — `config.yml`

```yaml
nodes:
  indexer:
    - name: node-1
      ip: 192.168.10.10
  server:
    - name: wazuh-1
      ip: 192.168.10.10
  dashboard:
    - name: dashboard
      ip: 192.168.10.10
```

> Tots els components (Indexer, Manager i Dashboard) s'instal·len a la mateixa VM (all-in-one).

### 3. Generar fitxers de configuració

```bash
sudo bash wazuh-install.sh --generate-config-files
```

### 4. Instal·lació all-in-one

```bash
sudo bash wazuh-install.sh -a
```

---

## Resultat de la instal·lació
INFO: --- Summary ---
INFO: You can access the web interface https://192.168.10.10
User: admin
Password: <REDACTED>
INFO: Installation finished.


> ⚠️ Les credencials s'han guardat de forma segura fora del repositori. Mai pujar contrasenyes reals a GitHub.

---

## Verificació de serveis

```bash
# Comprovar que els 3 serveis estan actius
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard

# Comprovar que el dashboard respon
curl -k https://192.168.10.10
```

**Evidència de verificació:**

![Verificació Wazuh](verificacion_wazuh-dashboard.png)

### Accés al Dashboard

| Camp | Valor |
|---|---|
| **URL** | `https://192.168.10.10` |
| **Usuari** | `admin` |
| **Contrasenya** | Guardada a `wazuh-passwords.txt` (no al repo) |

---

## Ports utilitzats

| Port | Protocol | Servei |
|---|---|---|
| `443` | HTTPS | Dashboard |
| `1514` | TCP/UDP | Comunicació agents |
| `1515` | TCP | Registre d'agents |
| `9200` | HTTPS | Wazuh Indexer (OpenSearch) |
| `55000` | HTTPS | Wazuh API |