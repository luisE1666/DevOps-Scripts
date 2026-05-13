# ============================================================
# 1. PRE-REQUISITO: Verificar e Instalar Git CLI
# ============================================================
$gitCheck = Get-Command git -ErrorAction SilentlyContinue
if (!$gitCheck) {
    Write-Host "!! Git CLI no detectado." -ForegroundColor Yellow
    $confirm = Read-Host "Deseas instalar Git via Winget? (s/n)"
    if ($confirm.ToLower() -eq 's') {
        winget install --id Git.Git -e --source winget
        Write-Host "OK. Instalado. REINICIA la terminal." -ForegroundColor Green
        return 
    }
}

# ============================================================
# 2. CONFIGURACION DE RUTA Y .GITIGNORE
# ============================================================
$rutaReal = (Get-Item .).FullName
Write-Host "Ruta fisica: $rutaReal" -ForegroundColor Gray

# Crear .gitignore si no existe (Seguridad Pro)
$gitignorePath = Join-Path $rutaReal ".gitignore"
if (!(Test-Path $gitignorePath)) {
    $contenidoDefault = @"
# Seguridad y Limpieza
.env
*.log
__pycache__/
.vscode/
*.tmp
"@
    $contenidoDefault | Out-File -FilePath $gitignorePath -Encoding utf8
    Write-Host "SEC: .gitignore de seguridad creado." -ForegroundColor Cyan
}

# ============================================================
# 3. INICIALIZACION Y LOGICA DE VERSION
# ============================================================
if (!(Test-Path -Path "$rutaReal\.git" -PathType Container)) {
    git -C "$rutaReal" init
    Start-Sleep -Seconds 1
}

$ultimoCommit = git -C "$rutaReal" log -1 --pretty=%B 2>$null
$nuevaVersion = 0

if ($ultimoCommit -and ($ultimoCommit -match "(?i)Version\s+(\d+)")) {
    if ($null -ne $matches) { $nuevaVersion = [int]$matches[1] + 1 }
}

if ($nuevaVersion -eq 0) {
    Write-Host "`n--- Configuracion de Nueva Secuencia ---" -ForegroundColor Cyan
    $entrada = Read-Host "Numero de inicio (ej: 1)"
    try { $nuevaVersion = [int]$entrada } catch { $nuevaVersion = 1 }
}

# ============================================================
# 4. EJECUCION DE GIT
# ============================================================
$comentario = Read-Host "Comentario para la Version ${nuevaVersion}"

Write-Host "Ejecutando Sincronizacion..." -ForegroundColor Yellow
git -C "$rutaReal" add --all
git -C "$rutaReal" commit -m "Version ${nuevaVersion}: $comentario"

# Intento de Push
if (git -C "$rutaReal" remote) {
    git -C "$rutaReal" push origin master
} else {
    Write-Host "AVISO: Commit local hecho. Falta configurar el remote origin." -ForegroundColor Yellow
}

Write-Host "PROCESO COMPLETADO para la Version ${nuevaVersion}!" -ForegroundColor Green