$ErrorActionPreference = 'Stop'

# 切换到当前目录
Set-Location $PSScriptRoot

# 下载文件
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
        Write-Host "Using api.xrgzs.top..."
        Invoke-WebRequest -Uri "https://api.xrgzs.top/lanzou/?type=down&url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
       
    }
    catch {
        try {
            Write-Host "Using api.hanximeng.com..."
            Invoke-WebRequest -Uri "https://api.hanximeng.com/lanzou/?type=down&url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
        }
        catch {
            try {
                Write-Host "Using lz.qaiu.top..."
                Invoke-WebRequest -Uri "https://lz.qaiu.top/parser?url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
            }
            catch {
                Write-Error "Failed to download $Uri. ($_)"
            }
        }
    }
}

# 检查
Write-Host "version: $env:GITHUB_WORKFLOW_VERSION"
if (-not (Test-Path "C:\Program Files (x86)\NSIS\makensis.exe")) {
    Write-Host "Cannot find nsis!"
    exit 1
}
if (Test-Path 'osc\xrsoft.exe') {
    Write-Host "xrsoft.exe already exists."
}
else {
    # 下载所需文件
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/irdVI27gi2pg" -OutFile "osc\runtime\DirectX_Redist_Repack_x86_x64_Final.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/ihcxj29z4hbe" -OutFile "osc\runtime\flash.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iWN6I27gi6ch" -OutFile "osc\runtime\MSVCRedist.AIO.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iEOKz27gibqb" -OutFile "osc\xrkms\KMS_VL_ALL_AIO.cmd"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/i8NFT2a8fagh" -OutFile "osc\xrkms\kms.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/ixdbP27giisf" -OutFile "osc\xrsoft.exe"

    # 下载其他文件
    Invoke-WebRequest -Uri "http://url.xrgzs.top/osconline" -OutFile "osc\oscoffline.bat" -ErrorAction Stop
    Invoke-WebRequest -Uri "http://url.xrgzs.top/oscsoft" -OutFile "osc\oscsoftof.txt" -ErrorAction Stop
}

# 构建
if (-not $env:GITHUB_WORKFLOW_VERSION) {
    $env:GITHUB_WORKFLOW_VERSION = "2.5.0.0"
}
Set-Content -Path "osc\apifiles\Version.txt" -Value $env:GITHUB_WORKFLOW_VERSION
& "C:\Program Files (x86)\NSIS\makensis.exe" /V4 /DCUSTOM_VERSION=$env:GITHUB_WORKFLOW_VERSION "osc.nsi" || exit 1
