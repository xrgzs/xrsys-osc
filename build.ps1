$ErrorActionPreference = 'Stop'

# 切换到当前目录
Set-Location $PSScriptRoot

# 下载文件
function Get-LanzouLink {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Uri
    )
    $sharekey = $Uri -split '/' | Select-Object -Last 1
    if ((Invoke-RestMethod -Uri "https://lanzoui.com/$sharekey") -match 'src="(\/fn\?.\w+)') {
        $fn = Invoke-RestMethod -Uri ('https://lanzoui.com/' + $Matches[1])
    }
    else {
        throw "Failed to get fn. Please check whether the URL is correct."
    }
    if ($fn -match '\/ajaxm\.php\?file=\d\d+') {
        $ajaxm = $Matches[0]
    }
    else {
        throw "Failed to get ajaxm.php."
    }
    if ($fn -match "wp_sign = '(.*?)';") {
        $sign = $Matches[1]
    }
    else {
        throw "Failed to get sign."
    }
    $ajax = Invoke-RestMethod -Uri ('https://lanzoui.com/' + $ajaxm) -Method Post `
        -Headers @{ referer = "https://lanzoui.com/" } `
        -Body @{ 'action' = 'downprocess'; 'signs' = '?ctdf'; 'sign' = $sign; 'kd' = '1' }
    $directlink = $ajax.dom + '/file/' + $ajax.url
    try {
        Invoke-WebRequest -Uri $directlink -Method Head -MaximumRedirection 0 -ErrorAction SilentlyContinue `
            -Headers @{ 
                'accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
                'accept-encoding' = 'gzip, deflate, br, zstd'
                'accept-language' = 'zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6'
                'priority' = 'u=0, i'
                'upgrade-insecure-requests' = '1'
             } 
    }
    catch {
        $directlink = $_.Exception.Response.Headers.Location.OriginalString
    }
    Write-Host -ForegroundColor Yellow "Direct Link of $sharekey is: $directlink"
    if ($directlink) {
        return $directlink
    }
    else {
        throw "Failed to get direct link."
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
        Write-Host "Using PowerShell Function to parse link..."
        $directlink = Get-LanzouLink -Uri $Uri
        Invoke-WebRequest -Uri $directlink -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
    }
    catch {
        Write-Warning "PowerShell Function faild: $_"
        try {
            Write-Host "Using api.xrgzs.top to parse link..."
            Invoke-WebRequest -Uri "https://api.xrgzs.top/lanzou/?type=down&url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
        }
        catch {
            try {
                Write-Host "Using api.hanximeng.com to parse link..."
                Invoke-WebRequest -Uri "https://api.hanximeng.com/lanzou/?type=down&url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
            }
            catch {
                try {
                    Write-Host "Using lz.qaiu.top to parse link..."
                    Invoke-WebRequest -Uri "https://lz.qaiu.top/parser?url=$Uri" -OutFile $OutFile -ConnectionTimeoutSeconds 5 -AllowInsecureRedirect
                }
                catch {
                    Write-Error "Failed to download $Uri. ($_)"
                }
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
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iImmW2qeilob" -OutFile "osc\runtime\flash.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/icssN2xj2wrg" -OutFile "osc\runtime\MSVCRedist.AIO.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/idHOf2bfs3te" -OutFile "osc\xrkms\KMS_VL_ALL_AIO.cmd"
    Get-LanzouFile -Uri "https://xrgzs.lanzoum.com/ip4hN2w3qrlc" -OutFile "osc\xrkms\kms.exe"
    Get-LanzouFile -Uri "https://xrgzs.lanzouv.com/iqnTr2wxjufc" -OutFile "osc\xrsoft.exe"

    # 下载其他文件
    Invoke-WebRequest -Uri "https://url.xrgzs.top/osconline" -OutFile "osc\oscoffline.bat" -ErrorAction Stop
    Invoke-WebRequest -Uri "https://url.xrgzs.top/oscsoft" -OutFile "osc\oscsoftof.txt" -ErrorAction Stop
}

# 构建
if (-not $env:GITHUB_WORKFLOW_VERSION) {
    $env:GITHUB_WORKFLOW_VERSION = "2.5.0.0"
}
Set-Content -Path "osc\apifiles\Version.txt" -Value $env:GITHUB_WORKFLOW_VERSION
& "C:\Program Files (x86)\NSIS\makensis.exe" /V4 /DCUSTOM_VERSION=$env:GITHUB_WORKFLOW_VERSION "osc.nsi" || exit 1

$env:GITHUB_WORKFLOW_VERSION | Out-File -FilePath "osc.exe.ver"
(Get-FileHash -Path "osc.exe" -Algorithm SHA256).Hash | Out-File -FilePath "osc.exe.sha256"
(Get-FileHash -Path "osc.exe" -Algorithm MD5).Hash | Out-File -FilePath "osc.exe.md5"
