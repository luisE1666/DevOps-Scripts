# Get-Stats-JSON.ps1
$ErrorActionPreference = "SilentlyContinue"

# Datos base (CPU y RAM)
$cpu = (Get-WmiObject Win32_Processor).LoadPercentage
$mem = Get-WmiObject Win32_OperatingSystem
$ramTotal = [math]::round($mem.TotalVisibleMemorySize / 1MB, 2)
$ramUso = [math]::round(($ramTotal - ($mem.FreePhysicalMemory / 1MB)), 2)

# --- NUEVO: Capturar Top 3 Procesos ---
$top3 = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 3 | ForEach-Object {
    "$($_.Name) ($([math]::round($_.WorkingSet64 / 1GB, 2)) GB)"
}

# Objeto final
$objeto = @{
    cpu = [float]$cpu
    ramUso = [float]$ramUso
    ramTotal = [float]$ramTotal
    procesos = $top3  # Esto ahora es una lista/array
    temp = 0 # Mantenemos el 0 por el bloqueo que ya conocemos
    status_alerta = [bool]($ramUso -gt ($ramTotal * 0.85))
}

$json = $objeto | ConvertTo-Json -Compress
[Console]::Clear()
Write-Output $json