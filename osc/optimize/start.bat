chcp 936 > nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

:regimport
taskkill /f /im explorer.exe
taskkill /f /im StartMenuExperienceHost.exe
echo [OSC]正在导入注册表...>"%systemdrive%\Windows\Setup\wallname.txt"
start "" /wait /min regimporter.bat
if %osver% GEQ 2 (
    %nsudo% -U:T -P:E -wait regimporter.bat
)

:misc
cd /d "%~dp0"
echo 电源选项设置
rem POWERCFG -HIBERNATE OFF
powercfg /h off
POWERCFG -CHANGE -monitor-timeout-ac 0
POWERCFG -CHANGE -monitor-timeout-dc 0
POWERCFG -CHANGE -standby-timeout-ac 0
POWERCFG -CHANGE -standby-timeout-dc 0
POWERCFG -CHANGE -hibernate-timeout-ac 0
POWERCFG -CHANGE -hibernate-timeout-dc 0
rem [监视器电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -monitor-timeout-ac 0
rem [磁盘电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -disk-timeout-ac 0

if %osver% GEQ 3 (
    echo win8以上系统禁用快速启动
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
)

echo 恢复环境配置
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /f
if exist "%SystemDrive%\windows\system32\srclient.dll" (
    start "" /min %srtool% /off
    start "" /min %srtool% /reset
)

if %osver% GEQ 4 (
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
    rem 关闭遥测服务计划任务
    sc config DiagTrack start= disabled
    sc config dmwappushservice start= demand
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
    schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Autochk\Proxy"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"

    rem 关闭遥测
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t "REG_DWORD" /d "0" /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t "REG_DWORD" /d "0" /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t "REG_DWORD" /d "0" /f
    rem 关闭应用程序遥测
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t "REG_DWORD" /d "0" /f
    rem 禁用清单收集器
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t "REG_DWORD" /d "1" /f
    rem 诊断和反馈
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f
    reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f
    rem 允许应用使用我的广告 ID 向我展示个性化广告 - 关
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
    rem 量身定制的体验
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f
    rem 墨迹书写和键入个性
    rem reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t "REG_DWORD" /d "1" /f
    rem reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /t "REG_DWORD" /d "0" /f

    rem 禁用计划任务 App列表备份
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\AppListBackup\Backup"

    rem 禁用计划任务 Windows Defender 定期维护任务。"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" 

    rem 禁用计划任务 Windows Defender 定期清理任务。"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" 

    rem 禁用计划任务 Windows Defender 定期扫描任务。"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" 

    rem 禁用计划任务 Windows Defender 定期验证任务。"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" 

    rem 禁用计划任务 WindowsUpdate 更新扫描
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScan_LicenseAccepted"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\Start Oobe Expedite Work"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScan_OobeAppReady"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\StartOobeAppsScanAfterUpdate"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\UUS Failover Task"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\Report policies"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
    SCHTASKS /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\SdbinstMergeDbTask" 

    rem 禁用计划任务 OneDrive 自动安装（28000+）
    SCHTASKS /Change /DISABLE /TN "\Microsoft\OneDrive\OneDrive Per-Machine First Setup Task"

    rem 在用户登录时不启动隐私设置体验
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /t REG_DWORD /d 1 /f

    rem 设备管理器显示已禁用的设备
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowHiddenDevices" /t REG_DWORD /d 1 /f

    rem 设备管理器显示已断开的设备
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Multimedia\Audio\DeviceCpl" /v "ShowDisconnectedDevices" /t REG_DWORD /d 1 /f

    rem 让 Windows 选择计算机的最佳外观
    @rem reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 1 /f

    rem 当Windows检测到通信活动时：不执行任何操作
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f

    rem 找回隐藏的处理器电源管理选项
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 45bcc044-d885-43e2-8605-ee0ec6e96b59 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 -ATTRIB_HIDE
    powercfg -attributes 2E601130-5351-4d9d-8E04-252966BAD054 d502f7ee-1dc7-4efd-a55d-f04b6f5c0545 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 4e4450b3-6179-4e91-b8f1-5bb9938f81a1 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 3b04d4fd-1cc7-4f23-ab1c-d1337819c4bb -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 -ATTRIB_HIDE
    powercfg -attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 d639518a-e56d-4345-8af2-b9f32fb26109 -ATTRIB_HIDE
    powercfg -attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 d3d55efd-c1ff-424e-9dc3-441be7833010 -ATTRIB_HIDE
    powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 -ATTRIB_HIDE
    powercfg -attributes 7516b95f-f776-4464-8c53-06167f40cc99 2a737441-1930-4402-8d77-b2bebba308a3 -ATTRIB_HIDE
    powercfg -attributes 4faab71a-92e5-4726-b531-224559672d19 4faab71a-92e5-4726-b531-224559672d19 -ATTRIB_HIDE
    powercfg -attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 0b2d69d7-a2a1-449c-9680-f91c70521c60 -ATTRIB_HIDE
    powercfg -attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 dab60367-53fe-4fbc-825e-521d069d2456 -ATTRIB_HIDE
    powercfg -attributes 48672F38-7A9A-4bb2-8BF8-3D85BE19DE4E 2bfc24f9-5ea2-4801-8213-3dbae01aa39d -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 5d76a2ca-e8c0-402f-a133-2158492d58ad -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 8baa4a8a-14c6-4451-8e8b-14bdbd197537 -ATTRIB_HIDE
    powercfg -attributes 5FB4938D-1EE8-4b0f-9A3C-5036B0AB995C dd848b2a-8a5d-4451-9ae2-39cd41658f6c -ATTRIB_HIDE
    powercfg -attributes DE830923-A562-41AF-A086-E3A2C6BAD2DA 5c5bb349-ad29-4ee2-9d0b-2b25270f7a81 -ATTRIB_HIDE
    powercfg -attributes 7516b95f-f776-4464-8c53-06167f40cc99 8ec4b3a5-6868-48c2-be75-4f3044be88a7 -ATTRIB_HIDE
    powercfg -attributes DE830923-A562-41AF-A086-E3A2C6BAD2DA 5C5BB349-AD29-4ee2-9D0B-2B25270F7A81 -ATTRIB_HIDE
    powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4 -ATTRIB_HIDE
    powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 10778347-1370-4ee0-8bbd-33bdacaade49 -ATTRIB_HIDE
    powercfg -attributes 8619B916-E004-4dd8-9B66-DAE86F806698 82011705-FB95-4D46-8D35-4042B1D20DEF -ATTRIB_HIDE
    powercfg -attributes 7516b95f-f776-4464-8c53-06167f40cc99 684C3E69-A4F7-4014-8754-D45179A56167 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 cfeda3d0-7697-4566-a922-a9086cd49dfa -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 be337238-0d82-4146-a960-4f3749d470c7 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 bae08b81-2d5e-4688-ad6a-13243356654b -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 984cf492-3bed-4488-a8f9-4286c97bf5aa -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 93b8b6dc-0698-4d1c-9ee4-0644e900c85d -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 4d2b0152-7d5c-498b-88e2-34345392a2c5 -ATTRIB_HIDE
    powercfg -attributes 54533251-82be-4824-96c1-47b60b740d00 465e1f50-b610-473a-ab58-00d1077dc418 -ATTRIB_HIDE
    powercfg -attributes 2E601130-5351-4d9d-8E04-252966BAD054 C42B79AA-AA3A-484b-A98F-2CF32AA90A28 -ATTRIB_HIDE
    powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 -ATTRIB_HIDE
    powercfg -attributes 0012ee47-9041-4b5d-9b77-535fba8b1442 51dea550-bb38-4bc4-991b-eacf37be5ec8 -ATTRIB_HIDE
    powercfg -attributes 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 25DFA149-5DD1-4736-B5AB-E8A37B5B8187 -ATTRIB_HIDE
    powercfg -attributes 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 94AC6D29-73CE-41A6-809F-6363BA21B47E -ATTRIB_HIDE
    powercfg -attributes 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 -ATTRIB_HIDE

    rem 电源模式添加 卓越模式
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

    Powershell -NoLogo -NoProfile "Get-AppxPackage Microsoft.Windows.Photo* | Write-Host" | find /i "Microsoft.Windows.Photo" || if exist "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll" (
        echo 未检测到看图软件，启用Windows图片查看器
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
    )

    echo 关闭显示最近添加的应用，关闭显示最常用的应用
    for /f "delims=*" %%a in ('reg.exe query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount ^| find /i "}$$windows.data.unifiedtile.startglobalproperties"') do (
        reg.exe add "%%a\Current" /v "Data" /t REG_BINARY /d "0200000061F31E4D36CBDB010000000043420100C21401CB320A0305CEABD3E90224DAF40344C38A016682E58BB1AEFDFDBB3C0005A08FFCC103248AD0034480990166B0B599DCCDB097DE4D00058691CC930524AAA30144C38401669FF79DB187CBD1ACD40100C23C01C55A0100" /f
    )

    echo 启用任务管理器显示磁盘性能
    if exist "%systemdrive%\Windows\System32\diskperf.exe" diskperf -y
    if exist "%LocalAppData%\Microsoft\WindowsApps\wt.exe" (
        echo 更换默认控制台为Windows Terminal
        Reg.exe add "HKCU\Console\%%%%Startup" /v "DelegationConsole" /t REG_SZ /d "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}" /f
        Reg.exe add "HKCU\Console\%%%%Startup" /v "DelegationTerminal" /t REG_SZ /d "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}" /f
    )
    echo 禁用Smart App Control，修复Windows Installer安装缓慢
    if exist "%systemdrive%\Windows\System32\CiTool.exe" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /f /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d 0
        echo | CiTool.exe -r
    )
    if !bigversion! GEQ 19041 (
        echo 启用硬件加速GPU调度
        reg add HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers /f /v HwSchMode /t REG_DWORD /d 2
    )
    if !bigversion! GEQ 19041 if !bigversion! LEQ 19045 (
        reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds /v IsFeedsAvailable | find /i "0x1" && (
            echo 强制使用组策略关闭feeds
            reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /f /d 0
        )
    )
    if !bigversion! GEQ 22000 (
        echo 处理Win11变小了的输入法候选项字体大小（大）
        reg add HKCU\Software\Microsoft\InputMethod\CandidateWindow\CHS\1 /v FontStyleTSF3 /t REG_SZ /d "18.00pt;Regular;;Microsoft YaHei UI" /f
        
        echo Win11桌面不显示控制面板
        reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d 1 /f

        if !bigversion! GEQ 22621 (
            echo 任务栏已满时合并
            reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarGlomLevel /t REG_DWORD /d 1
            echo 任务栏隐藏AI图标
            reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarAI /t REG_DWORD /d 0
            reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v ShowCopilotButton /t REG_DWORD /d 0
            echo 启用右键单击即可在任务栏中启用结束任务
            reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /v TaskbarEndTask /t REG_DWORD /d 1 /f
        )
        if !bigversion! LEQ 22635 (
            echo 恢复传统右键菜单
            reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
        )
        if !bigversion! GEQ 26100 (
            if exist "%SystemDrive%\Windows\System32\sudo.exe" (
                echo 启用 sudo
                sudo config --enable enable
            )
        )

        if exist "start2.bin" if exist "%LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin" (
            echo 替换开始菜单固定文件
            copy /y "start2.bin" "%LocalAppData%\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start2.bin"
        )
    )
) else if %osver% GEQ 2 (
    schtasks /change /tn "\Microsoft\Windows\SystemRestore\SR" /disable 
    schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable 
    schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable 
    schtasks /change /tn "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /disable 
    schtasks /change /tn "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable 
    rem schtasks /change /tn "\Microsoft\Windows\Defrag\ScheduledDefrag" /disable 
    schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable 
    schtasks /change /tn "\Microsoft\Windows\WindowsBackup\ConfigNotification" /disable 
    schtasks /change /tn "\Microsoft\Windows\Location\Notifications" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\ActivateWindowsSearch" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\ConfigureInternetTimeService" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\DispatchRecoveryTasks" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\ehDRMInit" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\InstallPlayReady" /disable 
    schtasks /change /tn "\Microsoft\Windows\Media Center\mcupdate" /disable 
)

echo [OSC]正在优化浏览器配置...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "FUCKBrowserConfig.bat" start "" /wait /min "FUCKBrowserConfig.bat" /s
if %osver% GEQ 2 (
    taskkill /f /im msedge.exe
    rd /s /q "%LocalAppData%\Microsoft\Edge\User Data"
    mkdir "%LocalAppData%\Microsoft\Edge\User Data"
    xcopy /E /C /I /H /R /Y "User Data" "%LocalAppData%\Microsoft\Edge\User Data"
)
start explorer.exe

if %osver% GEQ 4 (
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
    echo Win10+选择应用在锁屏上显示详细状态-无
    powershell -NoLogo -NoProfile -ExecutionPolicy bypass -File "LockScreenStatus.ps1"
    if !smallversion! GEQ 26100 (
        echo Win11移除固定的新版Outlook任务栏图标
        powershell -NoLogo -NoProfile -ExecutionPolicy bypass -File "removeOutlookNewTaskbar.ps1"
    )
)
exit