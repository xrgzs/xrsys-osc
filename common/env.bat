@echo off
set "XRSYS_OSC_ENV_MODE=%~1"
if not defined XRSYS_OSC_ENV_MODE set "XRSYS_OSC_ENV_MODE=OSC"

set "XRSYS_OSC_COMMON_DIR=%~dp0"
for %%I in ("%XRSYS_OSC_COMMON_DIR%..") do set "XRSYS_OSC_INSTALL_ROOT=%%~fI"

if /i "%XRSYS_OSC_ENV_MODE%"=="API" (
    if exist "%XRSYS_OSC_INSTALL_ROOT%\apifiles\DriveCleaner.exe" (
        set "XRSYS_OSC_HOME=%XRSYS_OSC_INSTALL_ROOT%"
    ) else if exist "%XRSYS_OSC_INSTALL_ROOT%\api\api.bat" (
        set "XRSYS_OSC_HOME=%XRSYS_OSC_INSTALL_ROOT%\api"
    ) else (
        set "XRSYS_OSC_HOME=%XRSYS_OSC_INSTALL_ROOT%"
    )
) else (
    if exist "%XRSYS_OSC_INSTALL_ROOT%\osc\osc.bat" (
        set "XRSYS_OSC_HOME=%XRSYS_OSC_INSTALL_ROOT%\osc"
    ) else (
        set "XRSYS_OSC_HOME=%XRSYS_OSC_INSTALL_ROOT%"
    )
)

set "XRSYS_OSC_TOOLS_DIR=%XRSYS_OSC_HOME%\apifiles"
set "XRSYS_OSC_LINK_BASE_URL=https://url.xrgzs.top"

set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=0"
set "XRSYS_OSC_WINDOWS_NAME=Win"
set "XRSYS_OSC_WINDOWS_BUILD=0"
set "XRSYS_OSC_WINDOWS_REVISION=0"
ver | find /i "5.1." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=1"&& set "XRSYS_OSC_WINDOWS_NAME=WinXP"
ver | find /i "6.0." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=2"&& set "XRSYS_OSC_WINDOWS_NAME=Vista"
ver | find /i "6.1." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=2"&& set "XRSYS_OSC_WINDOWS_NAME=Win7"
ver | find /i "6.2." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=3"&& set "XRSYS_OSC_WINDOWS_NAME=Win8"
ver | find /i "6.3." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=3"&& set "XRSYS_OSC_WINDOWS_NAME=Win8.1"
ver | find /i "6.4." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=4"&& set "XRSYS_OSC_WINDOWS_NAME=Win10"
ver | find /i "10.0." > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=4"&& set "XRSYS_OSC_WINDOWS_NAME=Win10"
ver | find /i "10.0.2" > nul && set "XRSYS_OSC_WINDOWS_VERSION_LEVEL=4"&& set "XRSYS_OSC_WINDOWS_NAME=Win11"
if "%XRSYS_OSC_WINDOWS_VERSION_LEVEL%"=="4" (
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set "XRSYS_OSC_WINDOWS_BUILD=%%a"
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set "XRSYS_OSC_WINDOWS_REVISION=%%b"
)

set XRSYS_OSC_ARIA2_CMD="%XRSYS_OSC_HOME%\aria2c.exe" -c -R --retry-wait=5 --check-certificate=false --save-not-found=false --always-resume=false --auto-save-interval=10 --auto-file-renaming=false --allow-overwrite=true
set "XRSYS_OSC_DMI_EXE=%XRSYS_OSC_TOOLS_DIR%\DMI.exe"
set "XRSYS_OSC_NETUSER_EXE=%XRSYS_OSC_TOOLS_DIR%\NetUser.exe"
set "XRSYS_OSC_NIRCMD_EXE=%XRSYS_OSC_TOOLS_DIR%\nircmd.exe"
set "XRSYS_OSC_WINPUT_EXE=%XRSYS_OSC_TOOLS_DIR%\winput.exe"
set "XRSYS_OSC_WBOX_EXE=%XRSYS_OSC_TOOLS_DIR%\wbox.exe"
set "XRSYS_OSC_NSUDO_EXE=%XRSYS_OSC_TOOLS_DIR%\NSudoLC.exe"
set "XRSYS_OSC_PECMD_EXE=%XRSYS_OSC_TOOLS_DIR%\PECMD.exe"
set "XRSYS_OSC_DRVINDEX_EXE=%XRSYS_OSC_TOOLS_DIR%\DrvIndex.exe"
set "XRSYS_OSC_SRTOOL_EXE=%XRSYS_OSC_TOOLS_DIR%\srtool.exe"
set "XRSYS_OSC_WLAN_EXE=%XRSYS_OSC_TOOLS_DIR%\WLAN.exe"
set "XRSYS_OSC_7Z_EXE=%XRSYS_OSC_TOOLS_DIR%\7z.exe"
