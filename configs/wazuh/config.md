# Configuración Wazuh Server

## Información General

| Campo | Detalle |
|---|---|
| **VM** | `wazuh-server` |
| **SO** | Ubuntu 22.04 LTS |
| **RAM** | 4 GB |
| **vCPUs** | 2 |
| **IP** | `192.168.10.10/24` |
| **Versión Wazuh** | 4.11 |
| **Rol** | SOC: Wazuh Manager + Indexer + Dashboard (all-in-one) |

---

## Prerequisitos

```bash
sudo apt update
sudo apt install curl apt-transport-https unzip wget -y
```

---

## Instalación

### 1. Descargar scripts oficiales

```bash
curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.11/config.yml
```

### 2. Configurar nodos — `config.yml`

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

> Todos los componentes (Indexer, Manager y Dashboard) se instalan en la misma VM (all-in-one).

### 3. Generar ficheros de configuración

```bash
sudo bash wazuh-install.sh --generate-config-files
```

### 4. Instalación all-in-one

```bash
sudo bash wazuh-install.sh -a
```

---

## Resultado de la instalación

INFO: --- Summary ---
INFO: You can access the web interface https://192.168.10.10
User: admin
Password: <REDACTED>
INFO: Installation finished.


> ⚠️ Las credenciales están guardadas de forma segura fuera del repositorio. Nunca subir contraseñas reales a GitHub.

---

## Verificación de servicios

```bash
# Comprobar que los 3 servicios están activos
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard

# Comprobar que el dashboard responde
curl -k https://192.168.10.10
```

**Evidencia de verificación:**

![Verificación Wazuh](verificacion_wazuh-dashboard.png)

### Acceso al Dashboard

| Campo | Valor |
|---|---|
| **URL** | `https://192.168.10.10` |
| **Usuario** | `admin` |
| **Contraseña** | Guardada en `wazuh-passwords.txt` (no en el repo) |

---

## Puertos utilizados

| Puerto | Protocolo | Servicio |
|---|---|---|
| `443` | HTTPS | Dashboard |
| `1514` | TCP/UDP | Comunicación agentes |
| `1515` | TCP | Registro de agentes |
| `9200` | HTTPS | Wazuh Indexer (OpenSearch) |
| `55000` | HTTPS | Wazuh API |

---

## Despliegue de Agentes

A continuación se detalla la configuración individual de cada agente registrado en el Wazuh Manager. El procedimiento de instalación es el mismo para todos; únicamente cambian el nombre, la IP y la red de cada VM.

### Agentes registrados

| ID | Nombre | IP | Red | SO | Versión | Estado |
|---|---|---|---|---|---|---|
| `002` | `dmz-host1` | `192.168.30.10` | DMZ | Ubuntu 22.04.5 LTS | v4.11.2 | ✅ activo |
| `003` | `dmz-db-server` | `192.168.30.20` | DMZ | Ubuntu 22.04.5 LTS | v4.11.2 | ✅ activo |
| `004` | `client-user2` | `192.168.20.100` | Usuarios | Ubuntu 22.04.4 LTS | v4.11.2 | ✅ activo |
| `005` | `client-user1` | `192.168.20.102` | Usuarios | Ubuntu 22.04.4 LTS | v4.11.2 | ✅ activo |
| `006` | `admin-server` | `192.168.10.20` | Gestión | Ubuntu 22.04.4 LTS | v4.11.2 | ✅ activo |

![Agentes registrados en el dashboard](wazuh-server_agentes-clientes.png)

---

## Agente 002 · `dmz-host1`

### Información

| Campo | Detalle |
|---|---|
| **VM** | `dmz-host1` |
| **SO** | Ubuntu Server 22.04.5 LTS |
| **IP** | `192.168.30.10` |
| **Nombre agente** | `dmz-host1` |
| **ID agente** | `002` |
| **Grupo** | `default` |
| **Versión** | Wazuh v4.11.2 |
| **Estado** | `active` |

### 1. Descargar e instalar el agente

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb \
  && sudo WAZUH_MANAGER='192.168.10.10' \
     WAZUH_AGENT_GROUP='default' \
     WAZUH_AGENT_NAME='dmz-host1' \
     dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb
```

### 2. Iniciar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 3. Verificar el estado

```bash
sudo systemctl status wazuh-agent
```

Resultado esperado: `Active: active (running)`

### Verificación en el Dashboard

- **Ruta:** `https://192.168.10.10` → Endpoints → Agents
- El agente aparece con estado **active** (verde) · Nodo del clúster: `node01`

![Dashboard dmz-host1](dashboard-dmz-host1.png)

---

## Agente 003 · `dmz-db-server`

### Información

| Campo | Detalle |
|---|---|
| **VM** | `dmz-db-server` |
| **SO** | Ubuntu Server 22.04.5 LTS |
| **IP** | `192.168.30.20` |
| **Nombre agente** | `dmz-db-server` |
| **ID agente** | `003` |
| **Grupo** | `default` |
| **Versión** | Wazuh v4.11.2 |
| **Estado** | `active` |

### 1. Descargar e instalar el agente

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb \
  && sudo WAZUH_MANAGER='192.168.10.10' \
     WAZUH_AGENT_GROUP='default' \
     WAZUH_AGENT_NAME='dmz-db-server' \
     dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb
```

### 2. Iniciar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 3. Verificar el estado

```bash
sudo systemctl status wazuh-agent
```

Resultado esperado: `Active: active (running)`

### Verificación en el Dashboard

- **Ruta:** `https://192.168.10.10` → Endpoints → Agents
- El agente aparece con estado **active** (verde) · Nodo del clúster: `node01`

![Dashboard dmz-db-server](dashboard-dmz-db-server.png)

---

## Agente 004 · `client-user2`

### Información

| Campo | Detalle |
|---|---|
| **VM** | `client-user2` |
| **SO** | Ubuntu 22.04.4 LTS |
| **IP** | `192.168.20.100` |
| **Nombre agente** | `client-user2` |
| **ID agente** | `004` |
| **Grupo** | `default` |
| **Versión** | Wazuh v4.11.2 |
| **Estado** | `active` |

### 1. Descargar e instalar el agente

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb \
  && sudo WAZUH_MANAGER='192.168.10.10' \
     WAZUH_AGENT_GROUP='default' \
     WAZUH_AGENT_NAME='client-user2' \
     dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb
```

### 2. Iniciar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 3. Verificar el estado

```bash
sudo systemctl status wazuh-agent
```

Resultado esperado: `Active: active (running)`

### Verificación en el Dashboard

- **Ruta:** `https://192.168.10.10` → Endpoints → Agents
- El agente aparece con estado **active** (verde) · Nodo del clúster: `node01`

![Dashboard client-user2](dashboard-client-user2.png)

---

## Agente 005 · `client-user1`

### Información

| Campo | Detalle |
|---|---|
| **VM** | `client-user1` |
| **SO** | Ubuntu 22.04.4 LTS |
| **IP** | `192.168.20.102` |
| **Nombre agente** | `client-user1` |
| **ID agente** | `005` |
| **Grupo** | `default` |
| **Versión** | Wazuh v4.11.2 |
| **Estado** | `active` |

> ℹ️ El agente fue re-registrado con ID `005` tras resolver el bloqueo de conectividad en nftables que impedía la comunicación con el puerto 1515 del manager.

### 1. Descargar e instalar el agente

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb \
  && sudo WAZUH_MANAGER='192.168.10.10' \
     WAZUH_AGENT_GROUP='default' \
     WAZUH_AGENT_NAME='client-user1' \
     dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb
```

### 2. Iniciar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 3. Verificar el estado

```bash
sudo systemctl status wazuh-agent
```

Resultado esperado: `Active: active (running)`

### Verificación en el Dashboard

- **Ruta:** `https://192.168.10.10` → Endpoints → Agents
- El agente aparece con estado **active** (verde) · Nodo del clúster: `node01`

![Dashboard client-user1](dashboard-client-user1.png)

### Métricas iniciales recogidas

| Módulo | Estado |
|---|---|
| Threat Hunting | ✅ Activo — 33 eventos recogidos |
| MITRE ATT&CK | ✅ Tácticas detectadas (Defense Evasion, Privilege Escalation, Initial Access) |
| SCA (CIS Ubuntu 22.04 Benchmark v1.0.0) | ✅ Scan completado — 37 passed / 124 failed / Score 22% |
| Vulnerability Detection | ✅ Activo |

### Ejemplo de eventos generados

```bash
# Creación y eliminación de usuario (genera alertas de gestión de cuentas)
sudo useradd testuser && sudo userdel testuser
```

Resultado: el grupo de alertas `adduser` apareció en el dashboard y el contador de eventos subió de 193 a 202.

---

## Agente 006 · `admin-server`

### Información

| Campo | Detalle |
|---|---|
| **VM** | `admin-server` |
| **SO** | Ubuntu 22.04.4 LTS |
| **IP** | `192.168.10.20` |
| **Nombre agente** | `admin-server` |
| **ID agente** | `006` |
| **Grupo** | `default` |
| **Versión** | Wazuh v4.11.2 |
| **Estado** | `active` |

### 1. Descargar e instalar el agente

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.11.2-1_amd64.deb \
  && sudo WAZUH_MANAGER='192.168.10.10' \
     WAZUH_AGENT_GROUP='default' \
     WAZUH_AGENT_NAME='admin-server' \
     dpkg -i ./wazuh-agent_4.11.2-1_amd64.deb
```

### 2. Iniciar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 3. Verificar el estado

```bash
sudo systemctl status wazuh-agent
```

Resultado esperado: `Active: active (running)`

### Verificación en el Dashboard

- **Ruta:** `https://192.168.10.10` → Endpoints → Agents
- El agente aparece con estado **active** (verde) · Nodo del clúster: `node01`

![Dashboard admin-server](dashboard-admin-server.png)

![Creación agente — ejemplo 1](wazuh-agent_creacion-ejemplo1.png)

![Creación agente — ejemplo 2](wazuh-agent_creacion-ejemplo2.png)