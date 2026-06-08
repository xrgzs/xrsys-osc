#Requires -Version 7
$ErrorActionPreference = 'Stop'

# 切换到当前目录
Set-Location $PSScriptRoot

# 下载文件

function Test-Hashes {
    param (
        [hashtable]$Hashes,
        [string]$Algorithm
    )
    return $Hashes.GetEnumerator() | ForEach-Object {
        $file = $_.Key
        $expectedHash = $_.Value
        Write-Host -ForegroundColor Blue "Verifying $file $Algorithm hash ..."
        Write-Host -ForegroundColor Gray "Expected: $expectedHash"
        $actualHash = (Get-FileHash -Path $file -Algorithm $Algorithm).Hash
        Write-Host -ForegroundColor Gray "Actual  : $actualHash"
        if ($actualHash -ne $expectedHash) {
            # return $false
            Write-Error "$file hash not match."
        }
        else {
            Write-Host -ForegroundColor Green "$file hash match."
        }
    }
}
function Test-SHA256 ([hashtable]$Hashes) { return Test-Hashes -Hashes $Hashes -Algorithm "SHA256" }

function Invoke-RobustRequest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,
        [Parameter(Mandatory = $true)]
        [string]$OutFile
    )
    if ([string]::IsNullOrWhiteSpace($Uri)) {
        throw "URL cannot be null or empty! OutFile: $OutFile"
    }

    for ($retry = 1; $retry -le 3; $retry++) {
        try {
            Invoke-WebRequest -Uri $Uri -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
            return
        }
        catch {
            if ($retry -eq 3) {
                throw "Failed after 3 retries! URL: '$Uri', Error: $_"
            }
            Write-Host "Retry $retry failed for '$Uri', trying again ($retry / 3)... Error: $_"
            Start-Sleep -Seconds 2
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
        Invoke-RobustRequest -Uri "https://api.xrgzs.top/sdlp/lanzou/?type=down&url=$Uri" -OutFile $OutFile
    }
    catch {
        try {
            Write-Host "Using lz.qaiu.top to parse link..."
            Invoke-RobustRequest -Uri "https://lz.qaiu.top/parser?url=$Uri" -OutFile $OutFile
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
    # Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/iy02F3ppu8mj" -OutFile "osc\xrkms\KMS_VL_ALL_AIO.cmd"
    Invoke-RobustRequest -Uri "https://nos.netease.com/ysf/3380523d9ee1fbc12a84e5a5b7994890.cmd" -OutFile "osc\xrkms\KMS_VL_ALL_AIO.cmd"
    # Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/iDhqm3ppuagf" -OutFile "osc\xrkms\HEU.exe"
    Invoke-RobustRequest -Uri "https://nos.netease.com/ysf/11c1b3885cf104fa5bef53d571e5156d.exe" -OutFile "osc\xrkms\HEU.exe"
    # Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iqnTr2wxjufc" -OutFile "osc\xrsoft.exe"
    Invoke-RobustRequest -Uri "https://nos.netease.com/ysf/e68b8f58127b7680debf16b120cad91a.exe" -OutFile "osc\xrsoft.exe"
    Invoke-RobustRequest -Uri "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/TSforge_Activation.cmd" -OutFile "osc\xrkms\TSforge_Activation.cmd"

    # 下载其他文件
}

# 验证文件
Test-SHA256 -Hashes @{
    "osc\xrkms\KMS_VL_ALL_AIO.cmd" = "CEE80B2DE0CA33BE709C33E6725E81D28FC366565211B4E1D996951512AA0049"
    "osc\xrkms\HEU.exe"            = "DBE10240FC4841A60410DF3EE1704487F43A8E19158AEA99DDD8EA214BAB23B6"
    "osc\xrsoft.exe"               = "9C863AE73272D7470D0BC48CB1E70D5B3172FEDF532CB14ECE502718726A220E"
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
