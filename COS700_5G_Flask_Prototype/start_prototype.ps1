param([switch]$NoBrowser)
# Locate the application and its local address.
$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
$prototypeUrl = 'http://127.0.0.1:5073'
Set-Location -LiteralPath $projectRoot

# Reuse only the explicitly versioned instance for this package.
# This build uses a dedicated port/version so an older prototype server cannot be mistaken for this build.
try {
    $health = Invoke-RestMethod -Uri "$prototypeUrl/api/health" -TimeoutSec 2
    if ($health.application -eq 'COS700_5G_Flask_Prototype' -and $health.version -eq 'cause-v6-both-cm-cards') {
        if (-not $NoBrowser) { Start-Process $prototypeUrl }
        Write-Host "Prototype is ready at $prototypeUrl"
        exit 0
    }
} catch { }

# IMPORTANT: keep the virtual environment in a short Windows path.
# PyTorch contains deeply nested license/vendor paths which can exceed the legacy
# Windows MAX_PATH limit when the venv lives inside this project folder.
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'COS700_5G_Prototype_Runtime_v6'
$runtimePython = Join-Path $runtimeRoot 'Scripts\python.exe'
$runtimeMarker = Join-Path $runtimeRoot '.dependencies-installed'

if (-not (Test-Path -LiteralPath $runtimePython)) {
    New-Item -ItemType Directory -Path $runtimeRoot -Force | Out-Null
    $pythonLauncher = Get-Command py -ErrorAction SilentlyContinue
    if ($pythonLauncher) {
        & $pythonLauncher.Source -3.12 -m venv $runtimeRoot
    } else {
        $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
        if (-not $pythonCommand) {
            throw 'Install Python 3.12, then open Start Prototype.cmd again.'
        }
        $pythonVersion = & $pythonCommand.Source -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
        if ($pythonVersion -ne '3.12') {
            throw 'Python 3.12 is required. Install it, then open Start Prototype.cmd again.'
        }
        & $pythonCommand.Source -m venv $runtimeRoot
    }
    if ($LASTEXITCODE -ne 0) { throw 'Could not create the Python 3.12 environment.' }
}
$pythonPath = $runtimePython

# Install the ordinary dependencies once into the short-path runtime.
if (-not (Test-Path -LiteralPath $runtimeMarker)) {
    & $pythonPath -m pip install -r (Join-Path $projectRoot 'requirements.txt')
    if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed. Check your internet connection.' }
    New-Item -ItemType File -Path $runtimeMarker -Force | Out-Null
}

# PyTorch is checked separately because a previous interrupted install may have
# left the runtime present but without a usable torch package.
$torchReady = $false
try {
    & $pythonPath -c "import torch; print(torch.__version__)" *> $null
    $torchReady = ($LASTEXITCODE -eq 0)
} catch { $torchReady = $false }
if (-not $torchReady) {
    & $pythonPath -m pip install --no-cache-dir 'torch==2.14.0' --index-url https://download.pytorch.org/whl/cpu
    if ($LASTEXITCODE -ne 0) { throw 'CPU PyTorch installation failed. If Windows still reports WinError 206, enable Windows long paths or move the runtime to a shorter path.' }
}

# Start the local server silently and keep readable logs.
$logFolder = Join-Path $projectRoot 'instance'
New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
$server = Start-Process -FilePath $pythonPath -ArgumentList @('"' + (Join-Path $projectRoot 'app.py') + '"') -WorkingDirectory $projectRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $logFolder 'server.log') -RedirectStandardError (Join-Path $logFolder 'server-errors.log')
$server.Id | Set-Content -LiteralPath (Join-Path $logFolder 'server.pid')

# Open the interface after the dataset has finished loading.
for ($attempt = 0; $attempt -lt 60; $attempt++) {
    Start-Sleep -Seconds 1
    try {
        $health = Invoke-RestMethod -Uri "$prototypeUrl/api/health" -TimeoutSec 2
        if ($health.application -eq 'COS700_5G_Flask_Prototype' -and $health.version -eq 'cause-v6-both-cm-cards') {
            if (-not $NoBrowser) { Start-Process $prototypeUrl }
            Write-Host "Prototype is ready at $prototypeUrl"
            exit 0
        }
    } catch { }
    if ($server.HasExited) { break }
}
throw 'The server did not start. See instance\server-errors.log for details.'
