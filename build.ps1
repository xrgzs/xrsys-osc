#Requires -Version 7
$ErrorActionPreference = 'Stop'

# 切换到当前目录
Set-Location $PSScriptRoot

# 下载文件
function Invoke-RobustRequest {
    param($Url, $OutFile)
    for ($retry = 1; $retry -le 3; $retry++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
            return
        }
        catch {
            if ($retry -eq 3) {
                throw
            }
            Write-Host "Retry $retry failed for $Url, trying again ($retry / 3)..."
        }
    }
}
    
function Get-LanzouFile {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Uri,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $OutFile
    )
    
    Write-Host "Downloading $Uri to $OutFile..."
    try {
        Write-Host "Using api.xrgzs.top to parse link..."
        Invoke-RobustRequest -Url "https://api.xrgzs.top/sdlp/lanzou/?type=down&url=$Uri" -OutFile $OutFile
    }
    catch {
        try {
            Write-Host "Using lz.qaiu.top to parse link..."
            Invoke-RobustRequest -Url "https://lz.qaiu.top/parser?url=$Uri" -OutFile $OutFile
        }
        catch {
            Write-Error "Failed to download $Uri. ($_)"
        }
    }
}

# 检查
if (Test-Path "$env:NSISDIR\makensis.exe") {
    $nsisDir = "$env:NSISDIR"
}
elseif (Test-Path "C:\Program Files (x86)\NSIS\makensis.exe") {
    $nsisDir = "C:\Program Files (x86)\NSIS"
}
else {
    Write-Host "Cannot find nsis!"
    exit 1
}
Write-Host "version: $env:GITHUB_WORKFLOW_VERSION"
Write-Host "nsisDir: $nsisDir"
if (Test-Path 'osc\xrsoft.exe') {
    Write-Host "xrsoft.exe already exists."
}
else {
    # 下载所需文件
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/idHOf2bfs3te" -OutFile "osc\xrkms\KMS_VL_ALL_AIO.cmd"
    Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/itYHu3avdgcb" -OutFile "osc\xrkms\kms.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iqnTr2wxjufc" -OutFile "osc\xrsoft.exe"
    Invoke-RobustRequest -Uri "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/TSforge_Activation.cmd" -OutFile "osc\xrkms\TSforge_Activation.cmd"

    # 下载其他文件
    Invoke-RobustRequest -Uri "https://url.xrgzs.top/osconline" -OutFile "osc\oscoffline.bat" -ErrorAction Stop
    Invoke-RobustRequest -Uri "https://url.xrgzs.top/oscsoft" -OutFile "osc\oscsoftof.txt" -ErrorAction Stop
}

# 构建
if (-not $env:GITHUB_WORKFLOW_VERSION) {
    $env:GITHUB_WORKFLOW_VERSION = "2.5.0.0"
}
Set-Content -Path "osc\apifiles\Version.txt" -Value $env:GITHUB_WORKFLOW_VERSION
& "$nsisDir\makensis.exe" /V4 /DCUSTOM_VERSION=$env:GITHUB_WORKFLOW_VERSION "osc.nsi" || exit 1

$env:GITHUB_WORKFLOW_VERSION | Out-File -FilePath "osc.exe.ver"
(Get-FileHash -Path "osc.exe" -Algorithm SHA256).Hash | Out-File -FilePath "osc.exe.sha256"
(Get-FileHash -Path "osc.exe" -Algorithm MD5).Hash | Out-File -FilePath "osc.exe.md5"
