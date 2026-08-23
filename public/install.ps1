# 强制使用 UTF-8 编码，防止控制台中文乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==================== 1. 语言选择 ====================
Clear-Host
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host " Select Language / 请选择语言" -ForegroundColor Yellow
Write-Host " 1. 中文 (Chinese)"
Write-Host " 2. English"
Write-Host "=========================================" -ForegroundColor Cyan
$langChoice = Read-Host "Please input number (1-2) / 请输入数字 (默认 1)"
if (-not $langChoice) { $langChoice = "1" }

if ($langChoice -eq "2") {
    $txtTitle             = "=== Software Installation Hub ==="
    $txtSelectApp         = "Select the software you want to install:"
    $txtSelectMode        = "Select installation mode for"
    $txtModeManual        = "1. Manual Install (Launch installer GUI)"
    $txtModeSilent        = "2. Silent Install (Background auto-install)"
    $txtBack              = "0. Back / Exit"
    $txtDownloading       = "Downloading"
    $txtLaunching         = "Launching installer GUI..."
    $txtInstallingSilent  = "Executing silent installation..."
    $txtDone              = "Operation completed!"
    $txtInvalid           = "Invalid selection, try again."
} else {
    $txtTitle             = "=== 快捷软件下载安装工具 ==="
    $txtSelectApp         = "请选择你要下载安装的软件："
    $txtSelectMode        = "请选择安装模式 - "
    $txtModeManual        = "1. 普通安装 (打开安装包界面，手动选择)"
    $txtModeSilent        = "2. 静默安装 (后台自动静默安装)"
    $txtBack              = "0. 返回 / 退出"
    $txtDownloading       = "正在下载"
    $txtLaunching         = "正在打开安装程序..."
    $txtInstallingSilent  = "正在执行静默安装..."
    $txtDone              = "操作完成！"
    $txtInvalid           = "输入无效，请重新选择。"
}

# ==================== 2. 软件库清单配置 ====================
# 已将链接中的 ?sign=... 及 &token=... 参数全部移除
$softwareList = @(
    @{ 
        Id = "1"
        Name = "Roblox Player"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/RobloxPlayerInstaller.exe"
        FileName = "RobloxPlayerInstaller.exe"
        SilentArgs = "" 
    },
    @{ 
        Id = "2"
        Name = "Firefox 火狐浏览器 (在线安装包)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Installer.exe"
        FileName = "Firefox_Installer.exe"
        SilentArgs = "-ms"
    },
    @{ 
        Id = "3"
        Name = "Firefox 火狐浏览器 (154.0 离线安装包)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/Firefox%20Setup%20154.0.exe"
        FileName = "Firefox_Setup_154.0.exe"
        SilentArgs = "-ms"
    },
    @{ 
        Id = "4"
        Name = "ChatGPT"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/ChatGPT%20Installer.exe"
        FileName = "ChatGPT_Installer.exe"
        SilentArgs = "/S"
    },
    @{ 
        Id = "5"
        Name = "Google Chrome (在线安装包)"
        RawUrl = "https://alist.legspcpd.top/d/Github/ChromeSetup.exe"
        FileName = "ChromeSetup.exe"
        SilentArgs = "/silent /install"
    },
    @{ 
        Id = "6"
        Name = "Google Chrome (151.0 离线安装包)"
        RawUrl = "https://alist.legspcpd.top/d/Github/exe/151.0.7922.174_chrome_installer_uncompressed.exe"
        FileName = "chrome_installer_offline.exe"
        SilentArgs = "/silent /install"
    }
)

# 清理 URL 参数函数（确保去掉 ? 及后面的 sign 和 token）
function Get-CleanUrl ($url) {
    return ($url -split '\?')[0]
}

# ==================== 3. 主逻辑与界面循环 ====================
while ($true) {
    Clear-Host
    Write-Host $txtTitle -ForegroundColor Green
    Write-Host $txtSelectApp
    Write-Host "-----------------------------------------"
    
    foreach ($app in $softwareList) {
        Write-Host "$($app.Id). $($app.Name)"
    }
    Write-Host "0. Exit / 退出"
    Write-Host "-----------------------------------------"
    
    $selectedId = Read-Host "请输入编号 / Input ID"
    if ($selectedId -eq "0") { break }
    
    $targetApp = $softwareList | Where-Object { $_.Id -eq $selectedId }
    
    if ($null -ne $targetApp) {
        # 选择安装模式
        Clear-Host
        Write-Host "$txtSelectMode [$($targetApp.Name)]" -ForegroundColor Yellow
        Write-Host "-----------------------------------------"
        Write-Host $txtModeManual
        Write-Host $txtModeSilent
        Write-Host $txtBack
        Write-Host "-----------------------------------------"
        
        $modeChoice = Read-Host "请输入编号 / Input ID"
        if ($modeChoice -eq "0") { continue }
        
        # 取得不带参数的标准 URL
        $cleanUrl = Get-CleanUrl $targetApp.RawUrl
        $tempPath = Join-Path $env:TEMP $targetApp.FileName
        
        Write-Host "`n$txtDownloading: $cleanUrl ..." -ForegroundColor Cyan
        
        try {
            # 下载安装包到系统的 Temp 目录
            Invoke-WebRequest -Uri $cleanUrl -OutFile $tempPath -UseBasicParsing -ErrorAction Stop
            
            if ($modeChoice -eq "1") {
                # 普通安装：打开界面供用户手动安装
                Write-Host $txtLaunching -ForegroundColor Green
                Start-Process -FilePath $tempPath
            } 
            elseif ($modeChoice -eq "2") {
                # 静默安装：后台无人值守运行
                Write-Host $txtInstallingSilent -ForegroundColor Green
                if ($targetApp.SilentArgs) {
                    Start-Process -FilePath $tempPath -ArgumentList $targetApp.SilentArgs -Wait
                } else {
                    Start-Process -FilePath $tempPath -Wait
                }
                Write-Host $txtDone -ForegroundColor Green
                Start-Sleep -Seconds 2
            }
        } 
        catch {
            Write-Host "下载或安装过程出错: $_" -ForegroundColor Red
            Pause
        }
    } 
    else {
        Write-Host $txtInvalid -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}