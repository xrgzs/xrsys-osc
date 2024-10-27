$ExtPath = Join-Path $PSScriptRoot ".." "osc" "runtime" "Extension"

Remove-Item -Path $ExtPath -Force
New-Item -ItemType Directory -Path $ExtPath | Out-Null

function Get-Appx([string]$Name) {
    Write-Host "Downloading $Name"
    $body = @{
        type = 'PackageFamilyName'
        url = $Name + '_8wekyb3d8bbwe'
        ring = 'RP'
        lang = 'zh-CN'
    }
    while ($true) {
        try {
            $obj = Invoke-WebRequest -Uri "https://api.xrgzs.top/msstore/GetFiles" `
            -Method "POST" `
            -ContentType "application/x-www-form-urlencoded" `
            -Body $body `
            -ConnectionTimeoutSeconds 5 -OperationTimeoutSeconds 5
            break
        }
        catch {
            Write-Host "请求失败，正在进行重试... $_"
            Start-Sleep -Seconds 3
        }
    }
    foreach ($link in $obj.Links) {
        if ($link.outerHTML -match '(?<=<a\b[^>]*>).*?(?=</a>)') {
            $linkText = $Matches[0]
            if ($linkText -match '(x86|x64|neutral).*\.(appx|appxbundle|msixbundle)\b') {
                Write-Debug "$linkText : $($link.href)"
                if (Test-Path -Path $linkText) {
                    Write-Warning "Already exists, skiping $linkText"
                } else {
                    Write-Host "== $linkText ($($link.href))"
                    Invoke-WebRequest -Uri $link.href -OutFile "$ExtPath\$linkText"
                }
            }
        }
    }
}

Invoke-WebRequest -Uri "https://alist.xrgzs.top/d/pxy/System/Windows/Win10/Res/Microsoft.HEVCVideoExtension.xml"  -OutFile "$ExtPath\Microsoft.HEVCVideoExtension.xml"

Get-Appx 'Microsoft.AV1VideoExtension'
Get-Appx 'Microsoft.HEIFImageExtension'
Get-Appx 'Microsoft.MPEG2VideoExtension'
Get-Appx 'Microsoft.RawImageExtension'
Get-Appx 'Microsoft.VP9VideoExtensions'
Get-Appx 'Microsoft.WebMediaExtensions'
Get-Appx 'Microsoft.WebpImageExtension'
Get-Appx 'Microsoft.HEVCVideoExtensions'
Get-Appx 'Microsoft.VCLibs.140.00'