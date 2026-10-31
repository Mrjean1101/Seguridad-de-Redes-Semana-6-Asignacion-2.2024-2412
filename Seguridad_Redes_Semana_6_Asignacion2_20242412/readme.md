# Implementación de AAA y RADIUS en Infraestructura Cisco con Windows Server 2025

## 📹 Video Demostrativo

**Enlace del video:** Video Demostrativo en YouTube: 


## 📐 Topología del Entorno

```text
+-------------------------------------------------------------+
|                     Windows Server 2025                     |
|            (Controlador de Dominio / AD DS / NPS)           |
|                     IP: 10.24.12.10/24                      |
+-------------------------------------------------------------+
                               |
                               | (Ethernet1 / VMnet2)
                               |
                               | (Gi0/0)
+-------------------------------------------------------------+
|                      Switch Cisco L2                        |
|                (Cliente RADIUS / SVI Vlan 1)                |
|                     IP: 10.24.12.3/24                       |
+-------------------------------------------------------------+
                               |
                               | (Gi0/1)
                               |
                               | (e2/0)
+-------------------------------------------------------------+
|                    Router Cisco (C7200)                     |
|                      (Cliente RADIUS)                       |
|                     IP: 10.24.12.2/24                       |
+-------------------------------------------------------------+




## 1.🎯 Propósito del Laboratorio

Diseñar, configurar y validar una infraestructura de autenticación, autorización y contabilización (AAA) centralizada sobre dispositivos de red Cisco (Router C7200 y Switch L2), integrando los servicios de Directorio Activo (AD DS) y Network Policy Server (NPS / RADIUS) sobre Windows Server 2025.

Se implementa una política estricta de control de acceso basada en roles (RBAC) mediante atributos propietarios del fabricante (`Cisco-AV-Pair`), asignando niveles de privilegio específicos (Nivel 0, Nivel 5 y Nivel 15) según la pertenencia a grupos de seguridad, forzando la autenticación centralizada en puertos de consola física/auxiliar, habilitando auditoría de comandos y sesiones mediante logs y desplegando acceso remoto cifrado seguro vía SSHv2 con cuentas de contingencia local.

### Tabla de Direccionamiento
| Dispositivo | Interfaz | Dirección IP | Máscara de Red | Función |
| :--- | :--- | :--- | :--- | :--- |
| **Windows Server 2025** | Ethernet1 | `10.24.12.10` | `255.255.255.0` | Servidor DC, AD DS y NPS (RADIUS) |
| **Router Cisco (C7200)** | Ethernet2/0 | `10.24.12.2` | `255.255.255.0` | Cliente RADIUS (Router) |
| **Switch Cisco** | Vlan 1 | `10.24.12.3` | `255.255.255.0` | Cliente RADIUS (Switch) |

---

## 2. Requisitos Implementados

### A. Directorio Activo y Servicio NPS
* **Estructura de Grupos y Cuentas:** Se crearon los grupos de seguridad `Grupo nivel 0`, `Grupo nivel 5` y `Grupo nivel 10`, vinculando sus respectivas cuentas de servicio (`user0`, `user5`, `user10`).
* **Directivas de Red (NPS):** Se definieron políticas de red asignando atributos específicos de fabricante mediante `Cisco-AV-Pair`:
  * `Grupo nivel 0` -> `shell:priv-lvl=0`
  * `Grupo nivel 5` -> `shell:priv-lvl=5`
  * `Grupo nivel 10` -> `shell:priv-lvl=15`

### B. Seguridad en Dispositivos Cisco (Router y Switch)
* **Modelo AAA y Cliente RADIUS:** Configuración de `aaa new-model` y vinculación hacia el servidor `10.24.12.10` con autenticación mediante clave secreta compartida.
* **Cuentas Locales de Respaldo:** Creación de usuario local con privilegio 15 para contingencias en caso de indisponibilidad del servidor RADIUS.
* **Restricción de Puertos:** Aplicación de autenticación y autorización RADIUS exclusiva para las líneas de consola física (`line con 0`) y auxiliar (`line aux 0`).
* **Servicio SSH Seguro:** Despliegue de SSHv2 con llaves RSA de 2048 bits para administración remota por líneas VTY mediante credenciales locales.
* **Auditoría y Logs:** Activación de contabilidad (`aaa accounting`) y almacenamiento en búfer de depuración (`logging buffered`) para trazabilidad de comandos y accesos.

---

## 3. Archivos y Recursos del Repositorio
* **Running-Configs:**
  * [Router C7200 Running Config](configs/Router_RunningConfig.txt)
  * [Switch Running Config](configs/Switch_RunningConfig.txt)
* **Scripts Utilizados:**
  * [Script de Despliegue PowerShell](scripts/WindowsServer_Config.ps1)
  * [Script CLI Cisco](scripts/Cisco_Router_Config.txt)