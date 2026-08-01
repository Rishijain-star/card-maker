#Requires -Version 5.1
<#
.SYNOPSIS
  ID-Shaydi — Laravel admin backend + Flutter app ek saath start karein.

.DESCRIPTION
  USB aur Wireless dono Android devices detect karta hai, verify karta hai,
  connected device auto-select karke app install/run karta hai.

.USAGE
  PowerShell (project folder se):
    .\run-dev.ps1

  Specific device force karne ke liye:
    .\run-dev.ps1 -DeviceId 9710c9d0
    .\run-dev.ps1 -DeviceId 192.168.1.50:5555

  Sirf backend:
    .\run-dev.ps1 -BackendOnly

  Sirf Flutter app:
    .\run-dev.ps1 -AppOnly

  Agar script run na ho (execution policy):
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#>

param(
    [string]$DeviceId = "",
    [int]$Port = 8000,
    [switch]$BackendOnly,
    [switch]$AppOnly
)

$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot
$AdminDir = Join-Path $ProjectRoot "admin"

function Test-CommandExists([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Get-ConnectionType([string]$Id) {
    if ($Id -match '^\d{1,3}(\.\d{1,3}){3}:\d+$') {
        return "Wireless"
    }
    return "USB"
}

function Get-LanIp {
    $ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object {
            $_.IPAddress -notlike "127.*" -and
            $_.IPAddress -notlike "169.254.*" -and
            $_.PrefixOrigin -ne "WellKnown"
        } |
        Sort-Object InterfaceMetric |
        Select-Object -First 1 -ExpandProperty IPAddress

    if (-not $ip) {
        $ip = "127.0.0.1"
    }
    return $ip
}

function Get-AdbAndroidDevices {
    if (-not (Test-CommandExists "adb")) {
        Write-Host '(WARN) adb not found in PATH - wireless/USB verify limited.' -ForegroundColor Yellow
        return @()
    }

    $result = @()
    $raw = adb devices -l 2>&1 | Out-String
    $lines = $raw -split "`r?`n"

    foreach ($line in $lines) {
        if ($line -match '^\s*(\S+)\s+(device|offline|unauthorized)\s*(.*)$' -and
            $line -notmatch '^List of devices') {
            $id = $Matches[1]
            $state = $Matches[2]
            $extras = $Matches[3]

            if ($id -eq "emulator-5554" -and $extras -notmatch 'model:') {
                continue
            }

            $model = "Unknown"
            if ($extras -match 'model:(\S+)') {
                $model = ($Matches[1] -replace '_', ' ')
            }
            $product = ""
            if ($extras -match 'product:(\S+)') {
                $product = $Matches[1]
            }

            $result += [PSCustomObject]@{
                Id         = $id
                Name       = $model
                Connection = Get-ConnectionType $id
                State      = $state
                Model      = $model
                Product    = $product
                Sdk        = ""
                Platform   = "android"
                IsSupported = ($state -eq "device")
                InAdb      = $true
                InFlutter  = $false
            }
        }
    }

    return $result
}

function Get-FlutterAndroidDevices {
    if (-not (Test-CommandExists "flutter")) {
        return @()
    }

    Push-Location $ProjectRoot
    try {
        $jsonText = flutter devices --machine 2>&1 | Out-String
        $parsed = $jsonText | ConvertFrom-Json -ErrorAction Stop

        return @($parsed | Where-Object {
            $_.targetPlatform -like "android*" -and $_.emulator -eq $false
        } | ForEach-Object {
            [PSCustomObject]@{
                Id          = $_.id
                Name        = $_.name
                Connection  = Get-ConnectionType $_.id
                State       = "device"
                Model       = $_.name
                Product     = ""
                Sdk         = $_.sdk
                Platform    = $_.targetPlatform
                IsSupported = [bool]$_.isSupported
                InAdb       = $false
                InFlutter   = $true
            }
        })
    }
    catch {
        Write-Host "(WARN) flutter devices --machine parse failed: $_" -ForegroundColor Yellow
        return @()
    }
    finally {
        Pop-Location
    }
}

function Merge-AndroidDevices {
    param(
        [array]$AdbDevices,
        [array]$FlutterDevices
    )

    $map = @{}

    foreach ($d in $AdbDevices) {
        $map[$d.Id] = [PSCustomObject]@{
            Id          = $d.Id
            Name        = $d.Name
            Connection  = $d.Connection
            State       = $d.State
            Model       = $d.Model
            Product     = $d.Product
            Sdk         = $d.Sdk
            Platform    = $d.Platform
            IsSupported = $d.IsSupported
            InAdb       = $true
            InFlutter   = $false
            Verified    = $false
        }
    }

    foreach ($f in $FlutterDevices) {
        if ($map.ContainsKey($f.Id)) {
            $entry = $map[$f.Id]
            $entry.Name = if ($f.Name) { $f.Name } else { $entry.Name }
            $entry.Sdk = $f.Sdk
            $entry.Platform = $f.Platform
            $entry.IsSupported = $f.IsSupported -and $entry.IsSupported
            $entry.InFlutter = $true
            if ($entry.Model -eq "Unknown" -and $f.Name) {
                $entry.Model = $f.Name
            }
        }
        else {
            $map[$f.Id] = [PSCustomObject]@{
                Id          = $f.Id
                Name        = $f.Name
                Connection  = $f.Connection
                State       = $f.State
                Model       = $f.Model
                Product     = $f.Product
                Sdk         = $f.Sdk
                Platform    = $f.Platform
                IsSupported = $f.IsSupported
                InAdb       = $false
                InFlutter   = $true
                Verified    = $false
            }
        }
    }

    return @($map.Values | Where-Object { $_.State -eq "device" -or $_.InFlutter })
}

function Test-DeviceReady {
    param([Parameter(Mandatory)]$Device)

    $checks = @{
        AdbState    = $false
        FlutterOk   = $false
        ShellOk     = $false
    }

    if (Test-CommandExists "adb") {
        $adbState = (adb -s $Device.Id get-state 2>&1 | Out-String).Trim()
        $checks.AdbState = ($adbState -eq "device")

        if ($checks.AdbState) {
            $shell = (adb -s $Device.Id shell echo ok 2>&1 | Out-String).Trim()
            $checks.ShellOk = ($shell -match "ok")
        }
    }

    $checks.FlutterOk = $Device.InFlutter -and $Device.IsSupported

    $Device.Verified = ($checks.AdbState -and $checks.ShellOk) -or ($Device.InFlutter -and $Device.IsSupported)

    return [PSCustomObject]@{
        Device = $Device
        Checks = $checks
        Ready  = $Device.Verified
    }
}

function Write-DeviceTable {
    param([array]$Devices)

    Write-Host "  #  Connection  Device ID              Name                 Status" -ForegroundColor DarkGray
    Write-Host "  -- ----------  ---------------------  -------------------  ------" -ForegroundColor DarkGray
    $i = 1
    foreach ($d in $Devices) {
        $status = if ($d.Verified) { "OK" } elseif ($d.State -eq "unauthorized") { "UNAUTHORIZED" } else { "CHECK" }
        $line = ("  {0,-2} {1,-10}  {2,-21}  {3,-19}  {4}" -f $i, $d.Connection, $d.Id, $d.Name, $status)
        if ($d.Verified) {
            Write-Host $line -ForegroundColor Green
        }
        elseif ($d.State -eq "unauthorized") {
            Write-Host $line -ForegroundColor Red
        }
        else {
            Write-Host $line -ForegroundColor Yellow
        }
        $i++
    }
}

function Select-AndroidDevice {
    param(
        [array]$Devices,
        [string]$PreferredId
    )

    if ($PreferredId) {
        $match = $Devices | Where-Object { $_.Id -eq $PreferredId }
        if (-not $match) {
            throw "Device ID '$PreferredId' connected nahi hai. Neeche available list dekhein."
        }
        return $match
    }

    $ready = @($Devices | Where-Object { $_.Verified })
    if ($ready.Count -eq 0) {
        $ready = @($Devices | Where-Object { $_.State -eq "device" -and $_.IsSupported })
    }
    if ($ready.Count -eq 0) {
        return $null
    }

    # Ek se zyada ho to USB prefer, phir pehla wireless
    $usb = @($ready | Where-Object { $_.Connection -eq "USB" })
    if ($usb.Count -ge 1) {
        return $usb[0]
    }

    $wireless = @($ready | Where-Object { $_.Connection -eq "Wireless" })
    if ($wireless.Count -ge 1) {
        return $wireless[0]
    }

    return $ready[0]
}

function Find-AndVerifyAndroidDevice {
    Write-Host "Scanning devices (USB + Wireless)..." -ForegroundColor Cyan
    Write-Host ""

    $adbList = Get-AdbAndroidDevices
    $flutterList = Get-FlutterAndroidDevices
    $merged = Merge-AndroidDevices -AdbDevices $adbList -FlutterDevices $flutterList

    if ($merged.Count -eq 0) {
        Write-Host "Koi Android device nahi mila." -ForegroundColor Red
        Write-Host ""
        Write-Host "Checklist:" -ForegroundColor Yellow
        Write-Host "  USB       : Cable lagao + USB Debugging ON + 'Allow' popup accept karo"
        Write-Host "  Wireless  : Phone par Wireless debugging ON + adb pair/connect"
        Write-Host "              adb pair IP:PORT  then  adb connect IP:PORT"
        Write-Host "  Verify    : adb devices -l"
        Write-Host ""
        return $null
    }

    Write-Host "Detected Android devices:" -ForegroundColor Cyan
    foreach ($d in $merged) {
        $result = Test-DeviceReady -Device $d
        $d.Verified = $result.Ready
    }
    Write-Host ""
    Write-DeviceTable -Devices $merged
    Write-Host ""

    $unauthorized = @($merged | Where-Object { $_.State -eq "unauthorized" })
    if ($unauthorized.Count -gt 0) {
        Write-Host "Kuch devices unauthorized hain - phone par RSA allow dialog accept karo." -ForegroundColor Red
    }

    try {
        $selected = Select-AndroidDevice -Devices $merged -PreferredId $DeviceId
    }
    catch {
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""
        Write-Host 'Manual: .\run-dev.ps1 -DeviceId YOUR_DEVICE_ID' -ForegroundColor Yellow
        return $null
    }

    if (-not $selected) {
        Write-Host "Koi ready device select nahi ho saka." -ForegroundColor Red
        return $null
    }

    if ($merged.Count -gt 1 -and -not $DeviceId) {
        Write-Host "Auto-selected: $($selected.Name) ($($selected.Connection)) - $($selected.Id)" -ForegroundColor Green
        Write-Host "(Multiple devices: USB ko priority di gayi)" -ForegroundColor DarkGray
    }
    else {
        Write-Host "Selected device: $($selected.Name) ($($selected.Connection)) - $($selected.Id)" -ForegroundColor Green
    }

    if ($selected.Sdk) {
        Write-Host "Android   : $($selected.Sdk)" -ForegroundColor DarkGray
    }
    if ($selected.Platform) {
        Write-Host "Platform  : $($selected.Platform)" -ForegroundColor DarkGray
    }
    Write-Host "ADB       : $(if ($selected.InAdb) { 'Yes' } else { 'No' })" -ForegroundColor DarkGray
    Write-Host "Flutter   : $(if ($selected.InFlutter) { 'Yes' } else { 'No' })" -ForegroundColor DarkGray
    Write-Host ""

    return $selected
}

# ===================== MAIN =====================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ID-Shaydi Dev Launcher" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $AdminDir)) {
    Write-Host "Admin folder not found: $AdminDir" -ForegroundColor Red
    exit 1
}

$LanIp = Get-LanIp
$ApiUrl = "http://${LanIp}:${Port}/api/v1"

Write-Host "Project : $ProjectRoot"
Write-Host "LAN IP  : $LanIp"
Write-Host "API URL : $ApiUrl"
Write-Host ""

# ---------- Backend ----------
if (-not $AppOnly) {
    if (-not (Test-CommandExists "php")) {
        Write-Host "PHP not found. Install PHP and add it to PATH." -ForegroundColor Red
        exit 1
    }

    if (-not (Test-Path (Join-Path $AdminDir "artisan"))) {
        Write-Host "Laravel artisan not found in admin folder." -ForegroundColor Red
        exit 1
    }

    $adminDirEscaped = $AdminDir -replace "'", "''"
    $backendCmd = "Set-Location -LiteralPath '$adminDirEscaped'; Write-Host 'Laravel Admin Backend' -ForegroundColor Green; Write-Host 'Admin: http://127.0.0.1:$Port/admin/login' -ForegroundColor Yellow; Write-Host 'API: http://${LanIp}:$Port/api/v1/products' -ForegroundColor Yellow; php artisan serve --host=0.0.0.0 --port=$Port"

    Start-Process -FilePath powershell.exe -ArgumentList '-NoExit', '-Command', $backendCmd
    Write-Host "(OK) Backend window opened (port $Port)" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# ---------- Flutter app ----------
$selectedDevice = $null

if (-not $BackendOnly) {
    if (-not (Test-CommandExists "flutter")) {
        Write-Host "Flutter not found. Install Flutter SDK and add to PATH." -ForegroundColor Red
        exit 1
    }

    $selectedDevice = Find-AndVerifyAndroidDevice
    if (-not $selectedDevice) {
        exit 1
    }

    $deviceId = $selectedDevice.Id
    $deviceName = $selectedDevice.Name
    $deviceConn = $selectedDevice.Connection

    $projectRootEscaped = $ProjectRoot -replace "'", "''"
    $flutterCmd = "Set-Location -LiteralPath '$projectRootEscaped'; Write-Host 'Flutter App - ID-Shaydi' -ForegroundColor Green; Write-Host 'Device: $deviceName ($deviceConn)' -ForegroundColor Yellow; Write-Host 'ID: $deviceId' -ForegroundColor Yellow; flutter run -d $deviceId --dart-define=APP_API_BASE_URL=$ApiUrl"

    Start-Process -FilePath powershell.exe -ArgumentList '-NoExit', '-Command', $flutterCmd
    Write-Host "(OK) Flutter window opened - installing/running on $deviceName" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done. Alag windows khul chuki hain:" -ForegroundColor Cyan
if (-not $AppOnly) {
    Write-Host "  1) Admin backend  - http://127.0.0.1:$Port/admin/login"
}
if (-not $BackendOnly -and $selectedDevice) {
    Write-Host "  2) Flutter app      - $($selectedDevice.Name) ($($selectedDevice.Connection))"
}
Write-Host ""
Write-Host "Phone aur PC same Wi-Fi par rakhein (Products API + wireless debug ke liye)." -ForegroundColor DarkGray
Write-Host ""
