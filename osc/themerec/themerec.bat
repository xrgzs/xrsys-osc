@echo off
chcp 936 > nul
cd /d "%~dp0"
title Ö÷Ìâ»Ö¸´
if exist "%SystemDrive%\Windows\Setup\xrsysnotheme.txt" exit

set istouch=
set osver=0
ver | find /i "5.1." > nul && set osver=1
ver | find /i "6.0." > nul && set osver=2
ver | find /i "6.1." > nul && set osver=2
ver | find /i "6.2." > nul && set osver=3
ver | find /i "6.3." > nul && set osver=3
ver | find /i "6.4." > nul && set osver=4
ver | find /i "10.0." > nul && (
    set osver=4
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
)

if exist "%SystemDrive%\Windows\Setup\xrsyswall.jpg" (
    copy /y "%SystemDrive%\Windows\Setup\xrsyswall.jpg" wallpaper.jpg
)
if exist "%SystemDrive%\Windows\Setup\Set\wallpaper.jpg" (
    copy /y "%SystemDrive%\Windows\Setup\Set\wallpaper.jpg" wallpaper.jpg
)
if exist "%SystemDrive%\Windows\Setup\zjsoftseewo.txt" call :touch
if exist "%SystemDrive%\Windows\Setup\zjsofthite.txt" call :touch
if exist "%SystemDrive%\Windows\Setup\zjsoftwenxiang.txt" (
    regedit /s touchwx.reg
    call :touch
)

if %osver% GEQ 2 (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\Tablet PC" /v DeviceKind') do if /i not "%%a"=="0x0" call :touch
)

if %osver% GEQ 4 (
    if !bigversion! GEQ 22000 call :startmenu11
)

if %osver% GEQ 4 (
    if !bigversion! GEQ 26100 call :taskband11
)

:main
if exist "%SystemDrive%\Windows\Setup\xrsysdark.txt" (
    if exist "%SystemDrive%\Windows\Resources\Themes\dark.theme" (
        start "" "%SystemDrive%\Windows\Resources\Themes\dark.theme"
    )
) else (
    if exist "%SystemDrive%\Windows\Resources\Themes\Light.theme" (
        start "" "%SystemDrive%\Windows\Resources\Themes\Light.theme"
    ) else if exist "%SystemDrive%\Windows\Resources\Themes\aero.theme" (
        start "" "%SystemDrive%\Windows\Resources\Themes\aero.theme"
    )
)
timeout -t 3 2>nul || ping 127.0.0.1 -n 3 >nul
taskkill /F /IM SystemSettings.exe
if %osver% GEQ 2 %PECMD% TEAM FIND --class:CabinetWClass --wid* R^|KILL @@%%R%% 
del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Themes\Custom.theme"
goto setwall

:setwall
cd /d "%~dp0"
timeout /t 5
if exist "%SystemDrive%\Windows\Setup\xrsysnowall.txt" exit
if exist wallpaper.jpg (
    copy /y wallpaper.jpg "%SystemDrive%\Windows\Version.jpg"
    %PECMD% WALL "%SystemDrive%\Windows\Version.jpg"
    if %osver% GEQ 2 (
        reg add "HKCU\Control Panel\Desktop" /f /v "Wallpaper" /d "%SystemDrive%\Windows\Version.jpg"
        reg add "HKCU\Control Panel\Desktop" /f /v "WallpaperStyle" /d "10"
        RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
    )
)
reg delete "HKCU\Control Panel\Desktop" /f /v "Wallpaper.PECMD"
exit

:touch
if defined istouch goto :EOF
if exist "%ProgramW6432%" (
    PinToTaskbar.exe /pin "%SystemDrive%\Windows\System32\osk.exe"
) else (
    %PECMD% PINT "%SystemDrive%\Windows\System32\osk.exe",TaskBand
)
regedit /s touch.reg
set istouch=1
goto :EOF

:startmenu11
powershell -Command "Install-ProvisioningPackage -PackagePath .\startmenu11.ppkg -ForceInstall -QuietInstall"
powershell -Command "Uninstall-ProvisioningPackage -PackagePath .\startmenu11.ppkg"
goto :EOF

:taskband11
powershell -ExecutionPolicy bypass -File ".\removeOutlookNewTaskbar.ps1"
goto :EOF