# **Manual de Administración: Servidor de Base de Datos Seguro (DMZ-HOST2)**

**Proyecto:** Infraestructura de Red Segura Zero Trust / SOC

**Host:** `dmz-host2`

**IP:** `192.168.30.20`

**Rol:** Servidor de Base de Datos (MariaDB) monitorizado.

---

## **1\. Instalación y Configuración de la Base de Datos (MariaDB)**

Para el almacenamiento de datos de la web, se optó por MariaDB, configurándolo bajo el principio de aislamiento de red.

### **Comandos de Instalación**

Bash  
sudo apt update  
sudo apt install mariadb-server \-y

### **Configuración de Acceso Remoto**

Para permitir que el servidor web (`30.10`) conecte con la base de datos (`30.20`):

1. **Modificar Bind-Address:** `sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf`  
   * Cambiar `127.0.0.1` por `0.0.0.0` (o la IP `192.168.30.20`).  
2. **Reiniciar el servicio:** `sudo systemctl restart mariadb`

### **Creación del Esquema y Privilegios (Mínimo Privilegio)**

SQL  
\-- Ejecutar dentro de: sudo mysql  
CREATE DATABASE jankesto\_db;  
CREATE USER 'webuser'@'192.168.30.10' IDENTIFIED BY 'TuContraseñaSegura';  
GRANT ALL PRIVILEGES ON jankesto\_db.\* TO 'webuser'@'192.168.30.10';  
FLUSH PRIVILEGES;

---

## **2\. Implementación del SOC (Wazuh Agent)**

Se integra el nodo en el SOC central para monitorizar intentos de acceso a los datos.

### **Instalación de la versión compatible (4.11.2)**

Al igual que en el host1, se evitó la versión 4.14 para garantizar compatibilidad con el Manager:

Bash  
\# Descarga de llave y paquete específico  
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent\_4.11.2-1\_amd64.deb

\# Instalación vinculada al Manager de la VLAN de Gestión  
sudo WAZUH\_MANAGER='192.168.10.10' WAZUH\_AGENT\_NAME='dmz-db-server' dpkg \-i ./wazuh-agent\_4.11.2-1\_amd64.deb

---

## **3\. Resolución de Problemas (Troubleshooting)**

### **Escenario A: Error "Access denied for user 'webuser'@'192.168.30.10'"**

* **Síntoma:** El frontal web muestra error de conexión a pesar de tener el usuario creado.  
* **Causa:** El usuario en MariaDB se creó con el host `localhost` en lugar de la IP del servidor web.  
* **Solución:** Recrear el usuario especificando la IP exacta del `dmz-host1` (`192.168.30.10`).

### **Escenario B: Error de configuración en Wazuh (Etiquetas XML)**

* **Síntoma:** El agente no arranca y el log indica `No such tag 'users'` o `'groups'`.  
* **Causa:** Etiquetas remanentes de la versión 4.14 incompatibles con el binario 4.11.  
* **Solución:** 1\. Editar `sudo nano /var/ossec/etc/ossec.conf`. 2\. Eliminar del módulo `<syscollector>` las líneas: `<users>`, `<groups>`, `<services>`, `<browser_extensions>`. 3\. Reiniciar: `sudo systemctl restart wazuh-agent`.

### **Escenario C: Denegación de Base de Datos (Error 1044\)**

* **Síntoma:** El usuario conecta pero no puede acceder a las tablas.  
* **Causa:** El nombre de la base de datos en el PHP (`jankesto_db`) no coincidía con la creada en MariaDB.  
* **Solución:** Ejecutar `CREATE DATABASE jankesto_db;` y reasignar privilegios.

---

## **4\. Monitorización Activa y Seguridad Final**

### **Vinculación de Logs de Auditoría**

Para que el SOC detecte ataques de fuerza bruta en la base de datos, se añadió la monitorización del log de errores:

1. **Editar:** `sudo nano /var/ossec/etc/ossec.conf`  
2. **Añadir:**

XML  
\<localfile\>  
  \<log\_format\>syslog\</log\_format\>  
  \<location\>/var/log/mysql/error.log\</location\>  
\</localfile\>

3. **Reiniciar:** `sudo systemctl restart wazuh-agent`

### **Verificación de Conexión**

* **Comando:** `sudo tail -n 5 /var/ossec/logs/ossec.log`  
* **Resultado OK:** `Connected to the server ([192.168.10.10]:1514/tcp)`.

