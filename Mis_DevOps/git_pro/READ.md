# 🚀 DevOps Script: Git Automation (git_pro.ps1)

Este proyecto contiene una herramienta de automatización desarrollada en **PowerShell** para agilizar el flujo de trabajo con Git. Está diseñada específicamente para entornos de desarrollo donde se requiere un control de versiones rápido, secuencial y seguro.

## 🛡️ Características (DevSecOps Focus)

- **Automatización de Commits:** Genera versiones secuenciales automáticamente (Version 1, Version 2, etc.).
- **Seguridad Pasiva:** Crea automáticamente un archivo `.gitignore` si no existe, protegiendo archivos sensibles (`.env`, `*.log`, `__pycache__`).
- **Validación de Entorno:** Verifica la instalación de Git CLI antes de ejecutar cualquier comando.
- **Manejo de Errores:** Incluye lógica para evitar errores de puntero nulo y fallos en repositorios no inicializados.

## 📋 Pre-requisitos

1. **PowerShell 5.1 o superior.**
2. **Git CLI** instalado.
3. **Política de ejecución:** Al ser un script de automatización, puede requerir permisos de ejecución en la sesión:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process