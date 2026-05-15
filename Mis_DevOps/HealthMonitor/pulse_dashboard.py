import tkinter as tk
from tkinter import ttk
import subprocess
import json
import re

def actualizar_datos():
    try:
        # Ejecutamos con Bypass
        cmd = ["powershell", "-ExecutionPolicy", "Bypass", "-File", "./Get-Stats-JSON.ps1"]
        resultado = subprocess.run(cmd, capture_output=True, text=True, encoding='latin-1') # latin-1 es más tolerante
        
        # Buscamos el JSON real ignorando basura
        match = re.search(r'(\{.*\})', resultado.stdout)
        
        if match:
            datos = json.loads(match.group(1))
            
            # Actualizar Barras
            lbl_cpu.config(text=f"CPU: {datos['cpu']}%")
            progress_cpu['value'] = datos['cpu']
            
            lbl_ram.config(text=f"RAM: {datos['ramUso']}GB / {datos['ramTotal']}GB")
            progress_ram['value'] = (datos['ramUso'] / datos['ramTotal']) * 100

            if datos['temp'] > 0:
                lbl_temp.config(text=f"🌡️ Temp: {datos['temp']}°C", fg="orange" if datos['temp'] > 70 else "black")
            else:
                lbl_temp.config(text="🌡️ Temp: Bloqueado/NA", fg="grey")
            
            # Actualizar el Top 3 de Procesos
            lista_procesos = datos['procesos']
            texto_top = "🚀 TOP 3 PROCESOS:\n" + "\n".join([f"{i+1}. {p.upper()}" for i, p in enumerate(lista_procesos)])

            # 2. Definir el color según la alerta
            color = "red" if datos['status_alerta'] else "blue"

            # 3. ACTUALIZAR LA ETIQUETA (Usa texto_top, no datos['procesos'])
            lbl_proc.config(text=texto_top, fg=color, justify="left")
            




        else:
            print("Esperando JSON...")

    except Exception as e:
        print(f"Error: {e}")
    
    root.after(2000, actualizar_datos)


root = tk.Tk()
root.title("System Pulse v1.0")
root.geometry("350x300")
root.attributes("-topmost", True)

tk.Label(root, text="Monitor de Recursos", font=("Arial", 12, "bold")).pack(pady=10)
lbl_cpu = tk.Label(root, text="CPU: 0%"); lbl_cpu.pack()
progress_cpu = ttk.Progressbar(root, length=200); progress_cpu.pack(pady=5)
lbl_ram = tk.Label(root, text="RAM: 0GB"); lbl_ram.pack()
progress_ram = ttk.Progressbar(root, length=200); progress_ram.pack(pady=5)
lbl_temp = tk.Label(root, text="🌡️ Temp: --°C", font=("Arial", 10))
lbl_temp.pack(pady=5)
lbl_proc = tk.Label(root, text="Iniciando...", fg="blue"); lbl_proc.pack(pady=20)

actualizar_datos()
root.mainloop()