# 🚀 System Pulse Monitor v1.1

Monitor de recursos en tiempo real diseñado para entornos corporativos con restricciones de seguridad. Utiliza una arquitectura híbrida entre **PowerShell** (extracción de datos) y **Python/Tkinter** (interfaz gráfica).

## 🛠️ Características
* **Monitoreo de CPU & RAM:** Lectura de carga de procesador y uso de memoria física.
* **Top 3 Procesos:** Identificación dinámica de los procesos que más consumen memoria.
* **Manejo de Errores Silencioso:** Diseñado para ignorar bloqueos de sensores de hardware (WMI/Thermal) comunes en laptops empresariales.
* **Always-on-Top:** La ventana se mantiene visible sobre otras aplicaciones.

## 🏗️ Arquitectura
El proyecto utiliza un flujo de datos JSON para la comunicación inter-lenguaje:
1. **Back-end (PowerShell):** Ejecuta consultas CIM/WMI, limpia la salida y genera un objeto JSON.
2. **Front-end (Python):** Ejecuta el script de PS con política de `Bypass`, parsea el JSON y actualiza la GUI.

## 🚀 Instalación y Uso
1. Asegúrate de tener Python 3.x instalado.
2. Coloca `Get-Stats-JSON.ps1` y `gui_monitor.py` en la misma carpeta.
3. Ejecuta el monitor:
   ```bash
   python gui_monitor.py