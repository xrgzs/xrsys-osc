$ExtPath = Join-Path $PSScriptRoot ".." "osc" "runtime" "Extension"

Remove-Item -Path $ExtPath -Force -Recurse -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $ExtPath | Out-Null

Import-Module "$PSScriptRoot\MSStore.psm1"

function Get-Appx {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProductNumber,
        
        [Parameter(Mandatory = $false)]
        [string]$OutputPath = $ExtPath,
        
        [switch]$Latest
    )
    
    try {
        Write-Host "Getting download URLs for product: $ProductNumber" -ForegroundColor Cyan
        
        # Use the Get-StoreURLS function from the module
        $StoreData = Get-StoreURLS -ProductNumber $ProductNumber
        
        
        Write-Host ($StoreData | ConvertTo-Json -Depth 100)

        if ($Latest) {
            $StoreData = $StoreData | Sort-Object -Property ID -Descending | Select-Object -First 1
        }
        
        if ($null -eq $StoreData -or $StoreData.Count -eq 0) {
            Write-Error "No download URLs found for product: $ProductNumber"
            return
        }
        
        # Create output directory if it doesn't exist
        if (-not (Test-Path -Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }
        
        foreach ($item in $StoreData) {
            Write-Host "Processing: $($item.ID)" -ForegroundColor Yellow
            
            $url = $item.URLS[-1]
           
            # Extract filename from URL or use the ID
            $fileName = $item.FileName 

            if ($fileName -notmatch '(arm64|x64|x86|neutral).*\.(appx|appxbundle|msixbundle)\b') {
                Write-Host "Invalid filename: $fileName" -ForegroundColor Red
                continue
            }
                
            $filePath = Join-Path -Path $OutputPath -ChildPath $fileName
                
            if (Test-Path -Path $filePath) {
                Write-Warning "Already exists, skipping $fileName"
                continue
            }
                
            try {
                Write-Host "== Downloading $fileName" -ForegroundColor Green
                Write-Debug "URL: $url"
                    
                Invoke-WebRequest -Uri $url -OutFile $filePath -UseBasicParsing
                Write-Host "Downloaded: $fileName" -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to download $fileName`: $($_.Exception.Message)"
            }
        }
        
    }
    catch {
        Write-Error "Failed to get store URLs: $($_.Exception.Message)"
    }
}

# Download HEVC XML file
Invoke-WebRequest -Uri "https://alist.xrgzs.top/d/pxy/System/Windows/Win10/Res/Microsoft.HEVCVideoExtensions.xml" -OutFile "$ExtPath\Microsoft.HEVCVideoExtensions.xml"

# Use correct Microsoft Store product numbers
Get-Appx '9MVZQVXJBQ9V'  # AV1 Video Extension
Get-Appx '9PMMSR1CGPWG'  # HEIF Image Extension
Get-Appx '9N95Q1ZZPMH4'  # MPEG-2 Video Extension
Get-Appx '9NCTDW2W1BH8'  # Raw Image Extension
Get-Appx '9N4D0MSMP0PT'  # VP9 Video Extensions
Get-Appx '9N5TDP8VCMHS'  # Web Media Extensions
Get-Appx '9PG2DK419DRG'  # WebP Image Extension
Get-Appx '9NMZLZ57R3T7'  # HEVC Video Extensions
# Get-Appx '9WZDNCRFJ3Q2'  # Microsoft Visual C++ 2015-2019 Redistributable

Remove-Module MSStore