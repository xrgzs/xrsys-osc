$ExtPath = Join-Path $PSScriptRoot ".." "osc" "runtime" "Extension"

Remove-Item -Path $ExtPath -Force
New-Item -ItemType Directory -Path $ExtPath | Out-Null

function Get-Appx($Name) {
    $Body = @{
        type = 'PackageFamilyName'
        url  = $Name + '_8wekyb3d8bbwe'
        ring = 'RP'
        lang = 'zh-CN'
    }
    $msstoreApis = @(
        "https://api.xrgzs.top/msstore/GetFiles",
        "https://store.rg-adguard.net/api/GetFiles"
    )
    
    while ($true) {
        try {
            foreach ($url in $msstoreApis) {
                try {
                    $obj = Invoke-WebRequest -Uri $url `
                        -Method "POST" `
                        -ContentType "application/x-www-form-urlencoded" `
                        -Body $Body `
                        -ConnectionTimeoutSeconds 5 -OperationTimeoutSeconds 5
                    break
                }
                catch {
                    if ($url -eq $msstoreApis[-1]) {
                        throw "All requests failed. $_"
                    }
                    Write-Warning "Request failed with $url, trying next url... ($_)"
                    continue
                }
            }
            foreach ($link in $obj.Links) {
                if ($link.outerHTML -match '(?<=<a\b[^>]*>).*?(?=</a>)') {
                    $linkText = $Matches[0]
                    if ($linkText -match '(arm64|x64|x86|neutral).*\.(appx|appxbundle|msixbundle)\b') {
                        Write-Debug "$linkText : $($link.href)"
                        if (Test-Path -Path $linkText) {
                            Write-Warning "Already exists, skiping $linkText"
                        }
                        else {
                            Write-Host "== $linkText ($($link.href))"
                            Invoke-WebRequest -Uri $link.href -OutFile "$ExtPath\$linkText"
                        }
                    }
                }
            }
            break
        }
        catch {
            Write-Warning "Request failed, retrying in 3 seconds... ($_)"
            Start-Sleep -Seconds 3
        }
    }
}

Invoke-WebRequest -Uri "https://alist.xrgzs.top/d/pxy/System/Windows/Win10/Res/Microsoft.HEVCVideoExtensions.xml"  -OutFile "$ExtPath\Microsoft.HEVCVideoExtensions.xml"

Get-Appx 'Microsoft.AV1VideoExtension'
Get-Appx 'Microsoft.HEIFImageExtension'
Get-Appx 'Microsoft.MPEG2VideoExtension'
Get-Appx 'Microsoft.RawImageExtension'
Get-Appx 'Microsoft.VP9VideoExtensions'
Get-Appx 'Microsoft.WebMediaExtensions'
Get-Appx 'Microsoft.WebpImageExtension'
Get-Appx 'Microsoft.HEVCVideoExtensions'
Get-Appx 'Microsoft.VCLibs.140.00'