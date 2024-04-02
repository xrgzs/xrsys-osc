cd /d "%~dp0"
for %%a in (
Microsoft.VCLibs.140.00_14.0.33519.0_x64__8wekyb3d8bbwe.Appx
Microsoft.VCLibs.140.00_14.0.33519.0_x86__8wekyb3d8bbwe.Appx
Microsoft.AV1VideoExtension_1.2.661.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.HEIFImageExtension_1.1.861.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.MPEG2VideoExtension_1.0.61931.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.RawImageExtension_2.3.611.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.VP9VideoExtensions_1.1.451.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.WebMediaExtensions_1.1.663.0_neutral_~_8wekyb3d8bbwe.AppxBundle
Microsoft.WebpImageExtension_1.1.861.0_neutral_~_8wekyb3d8bbwe.AppxBundle
) do (
call Powershell -Command Add-AppxProvisionedPackage -SkipLicense -Online -PackagePath "%%~fa"
)

for %%a in (
Microsoft.HEVCVideoExtensions_2.1.45.0_neutral_~_8wekyb3d8bbwe.AppxBundle
) do (
call Powershell -Command Add-AppxProvisionedPackage -LicensePath "%~dp0Microsoft.HEVCVideoExtension.xml" -Online -PackagePath "%%~fa"
)

exit