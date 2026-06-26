$ErrorActionPreference = "Stop"
$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$FlutterDir = "$env:LOCALAPPDATA\flutter"
$FlutterBat = "$FlutterDir\bin\flutter.bat"

function Wait-ForFlutter {
    $deadline = (Get-Date).AddMinutes(45)
    while ((Get-Date) -lt $deadline) {
        if (Test-Path $FlutterBat) {
            return $true
        }
        Start-Sleep -Seconds 15
    }
    return $false
}

if (-not (Wait-ForFlutter)) {
    Write-Error "Flutter SDK not found at $FlutterDir. Install Flutter and re-run this script."
    exit 1
}

Set-Location $ProjectDir
Write-Host "Running flutter create to finalize platform scaffolding..."
& $FlutterBat create . --project-name nari_suraksha --org com.narisuraksha --platforms=android,ios,web,windows
Write-Host "Fetching dependencies..."
& $FlutterBat pub get
Write-Host "Project ready. Run: flutter run"
exit 0
