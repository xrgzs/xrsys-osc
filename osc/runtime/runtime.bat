chcp 936 > nul
REM ===========================================================
REM 文件说明: 运行库安装脚本
REM 作者: 狂犬主子
REM SPDX-License-Identifier: GPL-3.0-or-later
REM 版权所有 (C) 潇然工作室
REM 未经作者许可，不得删除或修改此文件中的版权和许可信息
REM ===========================================================

cd /d "%~dp0"
call "%~dp0..\..\common\env.bat" OSC
title [OSC]运行库智能安装器

REM ========== 初始化检查 ==========
if not defined XRSYS_OSC_WINDOWS_VERSION_LEVEL exit
echo [OSC]正在安装运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "%SystemDrive%\WINDOWS\Setup\xrsysnoruntime.txt" exit

REM ========== 网络检测 ==========
set isoffline=1
ping www.aliyun.com -4 -n 2 >nul
if %errorlevel% EQU 0 set isoffline=0

REM ========== DX9 运行库 ==========
set _missing=0
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_33.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_36.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_43.dll" set /A _missing+=1
if %_missing% GEQ 2 (
    echo [OSC]正在安装DX9运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    if exist DX9.exe start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 DX9.exe /S
    if exist DirectX_Redist_Repack_x86_x64_Final.exe start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 DirectX_Redist_Repack_x86_x64_Final.exe /ai /gm2
)

REM ========== VC 运行库 ==========
set _missing=0
if not exist "%SystemDrive%\Windows\System32\mfc100.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\mfc120.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\mfc140.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\msvcp100.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\msvcp120.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\msvcp140.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\msvcr100.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\msvcr120.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\vcamp120.dll" set /A _missing+=1
if %_missing% GEQ 2 (
    if exist MSVCRedist.AIO.exe (
        echo [OSC]正在应用微软常用运行库 by XRSYS...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 MSVCRedist.AIO.exe /S
        del /f /q MSVCRedist.AIO.exe
    ) else if exist MSVBCRT.AIO.exe (
        echo [OSC]正在应用VC运行库 by Dreamcast...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 MSVBCRT.AIO.exe /SP- /SILENT /SUPPRESSMSGBOXES /NORESTART /COMPONENTS="vbvc567,vc2005,vc2008,vc2010,vc2012,vc2013,vc2019,vc2022,uc10,vstor"
        del /f /q MSVBCRT.AIO.exe
    ) else if exist VC.exe (
        echo [OSC]正在安装VC运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 VC.exe /S
        del /f /q VC.exe
    ) else if not %XRSYS_OSC_WINDOWS_VERSION_LEVEL% equ 1 if exist VisualCppRedist_AIO.exe (
        echo [OSC]正在应用VC运行库 by abodi1406...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 VisualCppRedist_AIO.exe /ai /gm2
        del /f /q VisualCppRedist_AIO.exe
    ) else if "%isoffline%"=="0" (
        echo [OSC]正在下载微软常用运行库 by XRSYS...>"%systemdrive%\Windows\Setup\wallname.txt"
        %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o MSVCRedist.AIO.exe "https://url.xrgzs.top/vc"
        if exist MSVCRedist.AIO.exe (
            echo [OSC]正在应用微软常用运行库 by XRSYS...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 MSVCRedist.AIO.exe /S
            del /f /q MSVCRedist.AIO.exe
        )
    )
)

REM ========== Flash ==========
set _missing=0
if not exist "%SystemDrive%\Windows\System32\Macromed\Flash\NPSWF.dll" set /A _missing+=1
if not exist "%SystemDrive%\Windows\System32\Macromed\Flash\pepflashplayer.dll" set /A _missing+=1
if %_missing% GEQ 1 (
    echo [OSC]正在安装Flash运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    if exist flash.exe (
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 flash.exe
        del /f /q flash.exe
    )
)

REM ========== Edge WebView ==========
if exist "Edge\*.exe" (
    echo [OSC]正在安装Edge运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    for %%a in ("Edge\*.exe") do (
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 %%a --msedgewebview --verbose-logging --do-not-launch-msedge --system-level
        start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 %%a --msedge --verbose-logging --do-not-launch-msedge --system-level
    )
    taskkill /f /im msedge.exe
    taskkill /f /im msedgewebview2.exe
    taskkill /f /im MicrosoftEdgeUpdate.exe
)

REM ========== .NET Desktop Runtime ==========
if exist "DotNet\*.exe" (
    echo [OSC]正在安装.NET运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    for %%a in ("DotNet\*.exe") do start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 %%a /install /quiet /norestart
)

REM ========== PowerShell ==========
if exist "PWSH\*.msi" (
    echo [OSC]正在安装PWSH运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    for %%a in ("PWSH\*.msi") do start "" /wait "%XRSYS_OSC_PECMD_EXE%" EXEC -wait -timeout:300000 msiexec.exe /package "%%~fa" /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1
)

REM ========== 系统增强组件 ==========
set os_arch=%PROCESSOR_ARCHITECTURE%
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set os_arch=x64

if not exist "%SystemDrive%\Windows\Setup\xrsysnoruntime.txt" (
    if not exist "%SystemDrive%\Windows\Fonts\FZXBSK.ttf" (
        echo [OSCol]正在安装系统增强组件xrfonts...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist xrfonts.exe if "%isoffline%"=="0" %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o xrfonts.exe "%XRSYS_OSC_LINK_BASE_URL%/xrfonts"
        if exist xrfonts.exe start /wait xrfonts.exe && del /f /q xrfonts.exe
    )
    ver | find /i "10.0." >nul && (
        if not exist "%SystemDrive%\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\8.*" (
            echo [OSCol]正在安装系统增强组件.NET 8...>"%SystemDrive%\Windows\Setup\wallname.txt"
            if not exist "dotnet8-%os_arch%.exe" if "%isoffline%"=="0" %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o "dotnet8-%os_arch%.exe" "%XRSYS_OSC_LINK_BASE_URL%/dotnet8-%os_arch%"
            if exist "dotnet8-%os_arch%.exe" start "" /wait "dotnet8-%os_arch%.exe" /q /norestart && del /f /q "dotnet8-%os_arch%.exe"
        )
        if not exist "%SystemDrive%\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\10.*" (
            echo [OSCol]正在安装系统增强组件.NET 10...>"%SystemDrive%\Windows\Setup\wallname.txt"
            if not exist "dotnet10-%os_arch%.exe" if "%isoffline%"=="0" %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o "dotnet10-%os_arch%.exe" "%XRSYS_OSC_LINK_BASE_URL%/dotnet10-%os_arch%"
            if exist "dotnet10-%os_arch%.exe" start "" /wait "dotnet10-%os_arch%.exe" /q /norestart && del /f /q "dotnet10-%os_arch%.exe"
        )
    )
)

exit
