# ============================================================
# Herramienta: Organizador de Descargas (Versión 1.0)
# ============================================================

$downloadsPath = "$env:USERPROFILE\Downloads"
$rutaReal = (Get-Item .).FullName

Write-Host "--- Iniciando Ordenamiento en: $downloadsPath ---" -ForegroundColor Cyan

# Definición de extensiones y sus carpetas destino
$categorias = @{
    "Documentos"    = @(".pdf", ".docx", ".xlsx", ".pptx", ".txt", ".csv", ".xlsm") # Añadimos Excel con Macros
    "Imagenes"      = @(".jpg", ".jpeg", ".png", ".gif", ".svg")
    "Instaladores"  = @(".exe", ".msi")
    "Comprimidos"   = @(".zip", ".rar", ".7z")
    "Scripts"       = @(".ps1", ".py", ".sh", ".sql")
    "Redes_y_Labs"  = @(".pkt", ".rdp") 
}

# Crear carpetas si no existen y mover archivos
foreach ($nombreCarpeta in $categorias.Keys) {
    $destino = Join-Path $downloadsPath $nombreCarpeta
    
    if (!(Test-Path $destino)) {
        New-Item -ItemType Directory -Path $destino | Out-Null
        Write-Host "Carpeta creada: $nombreCarpeta" -ForegroundColor Gray
    }

    $extensiones = $categorias[$nombreCarpeta]
    
    # Buscar archivos que coincidan con las extensiones
    Get-ChildItem -Path $downloadsPath -File | Where-Object { $extensiones -contains $_.Extension.ToLower() } | ForEach-Object {
        try {
            Move-Item -Path $_.FullName -Destination $destino -Force -ErrorAction Stop
            Write-Host "Movido: $($_.Name) -> $nombreCarpeta" -ForegroundColor Green
        } catch {
            Write-Host "Error al mover $($_.Name): Archivo en uso o bloqueado." -ForegroundColor Yellow
        }
    }
}

Write-Host "`nPROCESO COMPLETADO!" -ForegroundColor Green