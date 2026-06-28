# ===========================================================
# 文件说明: 项目构建脚本
# 作者: 狂犬主子
# SPDX-License-Identifier: GPL-3.0-or-later
# 版权所有 (C) 潇然工作室
# 未经作者许可，不得删除或修改此文件中的版权和许可信息
# ===========================================================
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
    # Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/iTFGY3sbsbif" -OutFile "osc\xrkms\HEU.exe"
    Invoke-RobustRequest -Uri "https://nos.netease.com/ysf/739c3b7bdf7c2c5693c855adcd22466f.exe" -OutFile "osc\xrkms\HEU.exe"
    # Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/ioetN3tdzwzi" -OutFile "osc\xrsoft.exe"
    Invoke-RobustRequest -Uri "https://nos.netease.com/ysf/5ffe081048ed4848c294f6a6f721ea26.exe" -OutFile "osc\xrsoft.exe"
    Invoke-RobustRequest -Uri "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/TSforge_Activation.cmd" -OutFile "osc\xrkms\TSforge_Activation.cmd"

    # 下载 ViVeTool
    $viveZip = "$env:TEMP\ViVeTool-v0.3.4-IntelAmd.zip"
    Invoke-RobustRequest -Uri "https://github.com/thebookisclosed/ViVe/releases/download/v0.3.4/ViVeTool-v0.3.4-IntelAmd.zip" -OutFile $viveZip
    Test-SHA256 -Hashes @{ $viveZip = "CC27F073F3FE5DD2C3D947FAF558FD4B2F8E34454F812689B0D65EE8A52E4147" }
    Expand-Archive -Path $viveZip -DestinationPath "osc\apifiles\vivetool" -Force
    Remove-Item $viveZip -Force
}

# 验证文件
Test-SHA256 -Hashes @{
    "osc\xrkms\KMS_VL_ALL_AIO.cmd"       = "CEE80B2DE0CA33BE709C33E6725E81D28FC366565211B4E1D996951512AA0049"
    "osc\xrkms\HEU.exe"                  = "663280ECAFEEC1E7EDE1B0B669FD9F640F3836F88620C8225EBD27B1FA16239D"
    "osc\xrsoft.exe"                     = "A96DAB666AD7C9606D478F0A06539D25AF1DA4084BA0A87586541601434988CB"
    "osc\apifiles\vivetool\ViVeTool.exe" = "D3B69C982622A26AD0B37C65B8F006B5139E50AEB45FDA68734A33CA28706DEA"
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
