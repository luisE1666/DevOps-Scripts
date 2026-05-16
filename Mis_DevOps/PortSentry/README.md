# 🛡️ Port Sentry v1.1 - Network IDS & Automated Alerting

Un Sistema de Detección de Intrusos (IDS) local y ligero diseñado para estaciones de trabajo Windows. El proyecto utiliza una arquitectura híbrida: **PowerShell** actúa como el sensor de red de bajo nivel y **Python** procesa los datos en tiempo real, aplicando una lógica de lista blanca (*whitelisting*) y disparando alertas instantáneas a un canal de **Telegram** cuando se detectan puertos no autorizados en modo escucha (*Listening*).

## 🛠️ Características Clave
* **Auditoría de Sockets Activos:** Monitoreo continuo de conexiones TCP utilizando comandos nativos de Windows (`Get-NetTCPConnection`).
* **Filtro Inteligente Anti-Falsos Positivos:** Ignora automáticamente puertos dinámicos efímeros de Windows (>49000) y herramientas de desarrollo comunes (como VS Code o GitHub Desktop).
* **Mecanismo Anti-Inundación (Anti-Flood):** Utiliza estructuras de datos de tipo *Set* en Python para recordar el estado anterior; el script solo enviará una notificación a Telegram si la superficie de ataque cambia (puertos nuevos o modificados).
* **Interfaz Gráfica de Alerta:** Ventana flotante construida en Tkinter con propiedad `always-on-top` para visualización crítica en el escritorio.

## 🏗️ Arquitectura del Sistema
1. **Sensor (`Get-Ports-JSON.ps1`):** Captura sockets TCP, resuelve los nombres de los procesos correspondientes (manejando excepciones de acceso denegado) y exporta un array JSON limpio a la salida estándar.
2. **Analizador (`port_sentry.py`):** Ejecuta el sensor mediante políticas de `Bypass`, parsea de forma segura el JSON aislando el búfer mediante expresiones regulares (`re`), evalúa el cumplimiento de la lista blanca y gestiona las conexiones HTTP hacia la API de Telegram.

---

## 🤖 Guía Paso a Paso: Creación del Bot de Telegram

Para recibir las alertas en tu teléfono móvil, necesitas configurar un bot propio siguiendo estos pasos:

### 1. Obtener el Token del Bot
1. Abre Telegram y busca al usuario oficial **`@BotFather`**.
2. Envía el comando `/newbot` para iniciar el proceso.
3. Elige un nombre visible para tu centinela (ej. `MiMonitorSeguridad`).
4. Elige un nombre de usuario único que termine obligatoriamente en `bot` (ej. `mi_port_sentry_intel_bot`).
5. **BotFather** te responderá con un mensaje de éxito que incluye el **API Token** (una cadena alfanumérica larga). *¡Mantén este token en secreto!*

### 2. Obtener tu Chat ID Personal
1. En el buscador de Telegram, localiza tu bot recién creado usando su nombre de usuario e inicia una conversación haciendo clic en el botón **Iniciar / Start**. *(Este paso es obligatorio para que el bot tenga permiso de escribirte)*.
2. Ahora, busca al bot asistente **`@userinfobot`** y dale a **Iniciar**.
3. El bot te responderá inmediatamente con tu **Id** (un número de 9 o 10 dígitos). Este es tu `TELEGRAM_CHAT_ID`.

---

## 🚀 Instalación y Despliegue

### Requisitos Previos
* Windows 10 o superior.
* Python 3.x instalado.
* Librería `requests` de Python (instalable vía `pip install requests`).

### Configuración del Código
Clona o descarga los archivos en un directorio local. Por motivos de seguridad (*Secret Management*), las credenciales reales de producción no deben ser subidas al repositorio. Antes de ejecutar, edita las variables en el script `port_sentry.py`:

```python
# --- CONFIGURACIÓN DE TELEGRAM ---
TELEGRAM_TOKEN = "COLOQUE_AQUI_SU_TOKEN_DE_BOT_FATHER"
TELEGRAM_CHAT_ID = "COLOQUE_AQUI_SU_CHAT_ID_PERSONAL"

# --- LISTA BLANCA DE CONFIANZA ---
PUERTOS_PERMITIDOS = [135, 445, 5040] # Modifique según sus necesidades corporativas/locales