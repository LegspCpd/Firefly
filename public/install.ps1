[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

# 动态获取用户当前实际的 Downloads 路径（支持跨盘符与路径重定向）
function Get-DownloadsFolder {
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    $downloadsGuid = "{374DE290-123F-4565-9164-39C4925E467B}"
    
    $folder = (Get-ItemProperty -Path $regPath).$downloadsGuid
    if (-not $folder) {
        $folder = (Get-ItemProperty -Path $regPath)."{7D83EE9B-2244-4E70-B1A5-774182A0A931}"
    }
    
    if ($folder) {
        return [System.Environment]::ExpandEnvironmentVariables($folder)
    } else {
        return [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")
    }
}

$downloadDir = Get-DownloadsFolder

# 确保 Downloads 目录存在
if (-not (Test-Path $downloadDir)) {
    New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null
}

Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Select Language / 请选择语言" -ForegroundColor Yellow
Write-Host " 1. Chinese"
Write-Host " 2. English"
Write-Host "=========================================" -ForegroundColor Cyan
$langChoice = Read-Host "请输入数字 (1-2) [默认 1]"
if (-not $langChoice) { $langChoice = "1" }

if ($langChoice -eq "2") {
    $txtTitle             = "=== Software Installation Hub ==="
    $txtSelectApp         = "Select the software you want to install:"
    $txtSelectMode        = "Select installation mode for"
    $txtModeManual        = "1. Manual Install (Open setup UI)"
    $txtModeSilent        = "2. Silent Install (Background install)"
    $txtBack              = "0. Exit"
    $txtDownloading       = "Downloading"
    $txtLaunching         = "Launching installer..."
    $txtOpeningZip        = "Opening archive..."
    $txtInstallingSilent  = "Executing silent installation..."
    $txtDone              = "Operation completed!"
    $txtInvalid           = "Invalid selection."
} else {
    $txtTitle             = "=== 快捷软件下载安装工具 ==="
    $txtSelectApp         = "请选择你要下载安装的软件:"
    $txtSelectMode        = "请选择安装模式 -"
    $txtModeManual        = "1. 普通安装 (打开安装包,自行选择安装位置)"
    $txtModeSilent        = "2. 静默安装 (后台自动安装)"
    $txtBack              = "0. 退出 / Exit"
    $txtDownloading       = "正在下载"
    $txtLaunching         = "正在打开安装程序..."
    $txtOpeningZip        = "正在打开压缩包..."
    $txtInstallingSilent  = "正在静默安装..."
    $txtDone              = "操作完成!"
    $txtInvalid           = "输入无效."
}

$softwareList = @(
    @{ Id = "1"; Name = "Roblox Player"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/RobloxPlayerInstaller.exe"; FileName = "RobloxPlayerInstaller.exe"; SilentArgs = ""; IsZip = $false },
    @{ Id = "2"; Name = "Firefox Installer (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Installer.exe"; FileName = "Firefox_Installer.exe"; SilentArgs = "-ms"; IsZip = $false },
    @{ Id = "3"; Name = "Firefox Setup 154.0 (Offline)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Setup%20154.0.exe"; FileName = "Firefox_Setup_154.0.exe"; SilentArgs = "-ms"; IsZip = $false },
    @{ Id = "4"; Name = "ChatGPT Installer"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/ChatGPT%20Installer.exe"; FileName = "ChatGPT_Installer.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "5"; Name = "Google Chrome (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/ChromeSetup.exe"; FileName = "ChromeSetup.exe"; SilentArgs = "/silent /install"; IsZip = $false },
    @{ Id = "6"; Name = "Google Chrome (151.0 Offline)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/151.0.7922.174_chrome_installer_uncompressed.exe"; FileName = "chrome_installer_offline.exe"; SilentArgs = "/silent /install"; IsZip = $false },
    @{ Id = "7"; Name = "Old Outlook 2021 (Online)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Old%20Outlook%202021.exe"; FileName = "Old_Outlook_2021.exe"; SilentArgs = ""; IsZip = $false },
    @{ Id = "8"; Name = "PotPlayer 64bit"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/PotPlayerSetup64.exe"; FileName = "PotPlayerSetup64.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "9"; Name = "Bandizip Pro 8.00 Beta 10 x64 Repack"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"; FileName = "Bandizip-Pro-8.00-Beta-10-x64-Repack.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "10"; Name = "Bandizip Professional 7.46 x64 Repack"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/Bandizip-Professional-7.46-x64-Repack.exe"; FileName = "Bandizip-Professional-7.46-x64-Repack.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "11"; Name = "360 First Aid Kit (360急救箱)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360c0mpkill_5.1.64.1289-0701.zip"; FileName = "360c0mpkill.zip"; SilentArgs = ""; IsZip = $true },
    @{ Id = "12"; Name = "360 Secure Browser x32 (360极速浏览器)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360cse_23.0.1253.0.exe"; FileName = "360cse_x32.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "13"; Name = "360 Secure Browser x64 (360极速浏览器)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/360csex_23.1.1253.64.exe"; FileName = "360csex_x64.exe"; SilentArgs = "/S"; IsZip = $false },
    @{ Id = "14"; Name = "Huorong Security x64 (火绒安全)"; RawUrl = "https://alist.legspcpd.top/d/Github/exe/sysdiag-all-x64-6.0.11.2-2026.08.23.1.exe"; FileName = "Huorong_x64.exe"; SilentArgs = "/S"; IsZip = $false }
)

while ($true) {
    Clear-Host
    Write-Host $txtTitle -ForegroundColor Green
    Write-Host $txtSelectApp
    Write-Host "-----------------------------------------"
    
    foreach ($app in $softwareList) {
        Write-Host "$($app.Id). $($app.Name)"
    }
    Write-Host "0. Exit"
    Write-Host "-----------------------------------------"
    
    $selectedId = Read-Host "Input ID"
    if ($selectedId -eq "0") { break }
    
    $targetApp = $softwareList | Where-Object { $_.Id -eq $selectedId }
    
    if ($null -ne $targetApp) {
        Clear-Host
        Write-Host "$txtSelectMode [$($targetApp.Name)]" -ForegroundColor Yellow
        Write-Host "-----------------------------------------"
        Write-Host $txtModeManual
        Write-Host $txtModeSilent
        Write-Host $txtBack
        Write-Host "-----------------------------------------"
        
        $modeChoice = Read-Host "Input ID"
        if ($modeChoice -eq "0") { continue }
        
        $downloadUrl = $targetApp.RawUrl
        $targetPath = Join-Path $downloadDir $targetApp.FileName
        
        Write-Host "${txtDownloading}: $($targetApp.Name) ..." -ForegroundColor Cyan
        
        try {
            $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            Invoke-WebRequest -Uri $downloadUrl -OutFile $targetPath -UserAgent $userAgent -UseBasicParsing -ErrorAction Stop
            
            if ($targetApp.IsZip -or $targetApp.FileName -match '\.(zip|7z|rar|tar|gz)$') {
                Write-Host $txtOpeningZip -ForegroundColor Green
                Invoke-Item -Path $targetPath
            } else {
                if ($modeChoice -eq "1") {
                    Write-Host $txtLaunching -ForegroundColor Green
                    Start-Process -FilePath $targetPath
                } 
                elseif ($modeChoice -eq "2") {
                    Write-Host $txtInstallingSilent -ForegroundColor Green
                    if ($targetApp.SilentArgs) {
                        Start-Process -FilePath $targetPath -ArgumentList $targetApp.SilentArgs -Wait
                    } else {
                        Start-Process -FilePath $targetPath -Wait
                    }
                    Write-Host $txtDone -ForegroundColor Green
                    Start-Sleep -Seconds 2
                }
            }
        } 
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
            Pause
        }
    } 
    else {
        Write-Host $txtInvalid -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}