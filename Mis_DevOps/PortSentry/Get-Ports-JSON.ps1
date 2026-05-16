$ErrorActionPreference = "SilentlyContinue"

$connections = Get-NetTCPConnection | Select-Object LocalPort, RemoteAddress, State, OwningProcess

$puertos = @()
foreach ($c in $connections) {
    try {
        $procName = (Get-Process -Id $c.OwningProcess -ErrorAction SilentlyContinue).Name
        if (-not $procName) { $procName = "Unknown" }
    } catch { $procName = "Access Denied" }
    
    $puertos += @{
        puerto = [int]$c.LocalPort
        remoto = [string]$c.RemoteAddress
        estado = [string]$c.State
        proceso = [string]$procName
    }
}

# Solo una salida, y que sea JSON comprimido
Write-Output ($puertos | ConvertTo-Json -Compress)