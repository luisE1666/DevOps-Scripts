import subprocess
import json
import tkinter as tk
from tkinter import messagebox
import re
import requests



TELEGRAM_TOKEN = "COLOQUE_AQUI_SU_TOKEN_DE_TELEGRAM"
TELEGRAM_CHAT_ID = "COLOQUE_AQUI_SU_CHAT_ID"

# CONFIGURACIÓN: Puertos que tú sabes que son normales en tu laptop (Ej: 135 para Windows, 443 para HTTPS)
PUERTOS_PERMITIDOS = [135, 445, 5357, 5040] 

def enviar_alerta_telegram(mensaje):
    """Envía un payload de texto directamente a tu chat de Telegram"""
    try:
        url = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/sendMessage"
        payload = {
            "chat_id": TELEGRAM_CHAT_ID,
            "text": mensaje,
            "parse_mode": "Markdown"  # Permite usar negritas y emojis
        }
        # Se envia la petición sin bloquear la GUI
        requests.post(url, json=payload, timeout=5)
    except Exception as e:
        print(f"No se pudo enviar la alerta a Telegram: {e}")

def auditar_puertos():
    try:
        cmd = ["powershell", "-ExecutionPolicy", "Bypass", "-File", "./Get-Ports-JSON.ps1"]
        resultado = subprocess.run(cmd, capture_output=True, text=True, encoding='latin-1')
        
        match = re.search(r'(\[.*\])', resultado.stdout)
        
        if match:
            conexiones = json.loads(match.group(1))
            sospechosos = []

            for c in conexiones:
                try:
                    p_actual = int(c['puerto'])
                except:
                    continue

                if "Listen" in c['estado']:
                    es_seguro = (
                        p_actual in PUERTOS_PERMITIDOS or 
                        p_actual > 49000 or 
                        c['proceso'].lower() in ['code', 'githubdesktop']
                    )

                    if not es_seguro:
                        sospechosos.append(f"• *Puerto:* {p_actual} | *Proceso:* {c['proceso']}")

            if sospechosos:
                # Quitamos duplicados para no saturar el mensaje
                sospechosos = list(set(sospechosos))
                cant_intrusos = len(sospechosos)
                
                # Actualizar Interfaz Local
                lbl_status.config(text="⚠️ INTRUSO DETECTADO", fg="red", font=("Arial", 12, "bold"))
                print(f"ALERTA CRÍTICA: Se detectaron {cant_intrusos} puertos no autorizados.")
                
                # --- NUEVO: DISPARAR ALERTA AL CELULAR ---
                cuerpo_mensaje = f"🚨 *¡ALERTA DE SEGURIDAD LOCAL!*\nSe detectaron {cant_intrusos} puertos no autorizados en escucha:\n\n" + "\n".join(sospechosos)
                
                enviar_alerta_telegram(cuerpo_mensaje)
                
            else:
                lbl_status.config(text="✅ Sistema Seguro", fg="green", font=("Arial", 10))

    except Exception as e:
        print(f"Error en auditoría: {e}")

    # Ejecutar cada 10 segundos
    root.after(10000, auditar_puertos)

# Mini ventana para que el script siga corriendo
root = tk.Tk()
root.title("Port Sentry v1.0")
root.geometry("250x120")
root.attributes("-topmost", True)

lbl_status = tk.Label(root, text="✅ Centinela Activo", fg="green", font=("Arial", 11, "bold"))
lbl_status.pack(pady=30)

auditar_puertos()
root.mainloop()