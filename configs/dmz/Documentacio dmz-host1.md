# **Manual de Administración: Servidor Web Seguro (DMZ-HOST1)**

**Proyecto:** Infraestructura de Red Segura Zero Trust / SOC

**Host:** dmz-host1

**IP:** 192.168.30.10

**Rol:** Servidor Web Corporativo monitorizado.

---

## **1\. Instalación y Configuración del Stack Web (LNMP)**

Para cumplir con la capa de segmentación DMZ, se instaló un entorno Nginx con procesamiento PHP.

### **Comandos de Instalación**

Bash

* sudo apt update  
  * sudo apt install nginx php-fpm php-mysql \-y  
    

    ### **Gestión del Servicio**

* **Verificar estado:** sudo systemctl status nginx  
* **Reiniciar tras cambios:** sudo systemctl restart nginx  
* **Validar sintaxis de configuración:** sudo nginx \-t

  ---

  ## **2\. Implementación del SOC (Wazuh Agent)**

Para la monitorización activa mediante el SOC, se despliega el agente de Wazuh.

### **Instalación de la versión compatible (4.11.2)**

Debido a la necesidad de mantener compatibilidad con la versión del Manager, se utiliza el paquete específico:

Bash

* \# Descarga de llave y repositorio  
  * curl \-s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg \--dearmor | sudo tee /usr/share/keyrings/wazuh.gpg \> /dev/null  
  * echo "deb \[signed-by=/usr/share/keyrings/wazuh.gpg\] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list  
  * sudo apt update  
  *   
  * \# Instalación manual por downgrade  
  * wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent\_4.11.2-1\_amd64.deb  
  * sudo WAZUH\_MANAGER='192.168.10.10' dpkg \-i ./wazuh-agent\_4.11.2-1\_amd64.deb  
      
    ---

    ## **3\. Resolución de Problemas (Troubleshooting)**

    ### **Escenario A: Error "502 Bad Gateway" en el navegador**

* **Síntoma:** Nginx no puede conectar con el backend de PHP.  
* **Causa común:** El socket de PHP-FPM en /etc/nginx/sites-available/default no coincide con la versión instalada.  
* **Solución:**  
  1. Identificar socket activo: ls /var/run/php/  
  2. Editar configuración: sudo nano /etc/nginx/sites-available/default  
  3. Asegurar que la línea fastcgi\_pass unix:/var/run/php/phpX.X-fpm.sock; es correcta.

     ### **Escenario B: El Agente Wazuh no arranca (Error 1202\)**

* **Síntoma:** Job for wazuh-agent.service failed. Logs indican No such tag 'users'.  
* **Causa:** El archivo de configuración contiene etiquetas de versiones superiores (4.14+).  
* **Solución:**  
  1. Editar: sudo nano /var/ossec/etc/ossec.conf  
  2. En la sección \<syscollector\>, eliminar las etiquetas: \<users\>, \<groups\>, \<services\>, \<browser\_extensions\>.  
  3. Reiniciar: sudo systemctl restart wazuh-agent

     ### **Escenario C: Pérdida de resolución de nombres (DNS)**

* **Síntoma:** No se pueden descargar paquetes o actualizaciones.  
* **Solución persistente:**  
  1. Editar cabecera: sudo nano /etc/resolvconf/resolv.conf.d/head  
  2. Añadir: nameserver 8.8.8.8  
  3. Aplicar: sudo resolvconf \-u  
     ---

     ## **4\. Monitorización Activa (Verificación del SOC)**

Para asegurar que el dmz-host1 está bajo vigilancia del SOC:

1. **Logs del Agente:** sudo tail \-f /var/ossec/logs/ossec.log  
   * Debe mostrar: Connected to the server.  
2. **Logs de Nginx:** Verificar que Wazuh lee los accesos en /var/log/nginx/access.log.

   

