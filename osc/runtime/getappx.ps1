function Download-Appx($Name) {
    $obj = Invoke-WebRequest -Uri "https://store.rg-adguard.net/api/GetFiles" `
    -Method "POST" `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
    type = 'PackageFamilyName'
    url = $Name + '_8wekyb3d8bbwe'
    ring = 'RP'
    lang = 'zh-CN'
    }

    foreach ($link in $obj.Links) {
        if ($link.outerHTML -match '(?<=<a\b[^>]*>).*?(?=</a>)') {
            $linkText = $Matches[0]
            if ($linkText -match '(x86|x64|neutral).*\.(appx|appxbundle|msixbundle)\b') {
                Write-Debug "$linkText : $($link.href)"
                if (Test-Path -Path $linkText) {
                    Write-Warning "Already exists, skiping $linkText"
                } else {
                    Invoke-WebRequest -Uri $link.href -OutFile "$PSScriptRoot\Extension\$linkText"
                }
            }
        }
    }
}
Remove-Item -Path "$PSScriptRoot\Extension" -Force
New-Item -ItemType Directory -Path "$PSScriptRoot\Extension"
Download-Appx 'Microsoft.VCLibs.140.00'
Download-Appx 'Microsoft.AV1VideoExtension'
Download-Appx 'Microsoft.HEIFImageExtension'
Download-Appx 'Microsoft.MPEG2VideoExtension'
Download-Appx 'Microsoft.RawImageExtension'
Download-Appx 'Microsoft.VP9VideoExtensions'
Download-Appx 'Microsoft.WebMediaExtensions'
Download-Appx 'Microsoft.WebpImageExtension'
Download-Appx 'Microsoft.HEVCVideoExtensions'
