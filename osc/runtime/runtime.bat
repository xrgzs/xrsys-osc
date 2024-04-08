chcp 936 > nul
cd /d "%~dp0"
if not defined osver exit
echo [OSC]正在安装运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "%SystemDrive%\WINDOWS\Setup\xrsysnoruntime.txt" exit

:vc
set i=0
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_33.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_36.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\d3dcompiler_43.dll" ( set /A i=i+1 )
if %i% GEQ 2 (
	echo [OSC]正在安装DX9运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    if exist DX9.exe (
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 DX9.exe /S
    )
    if exist DirectX_Redist_Repack_x86_x64_Final.exe (
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 DirectX_Redist_Repack_x86_x64_Final.exe /ai /gm2
    )
)
set i=0
if not exist "%SystemDrive%\Windows\System32\mfc100.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\mfc120.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\mfc140.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\msvcp100.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\msvcp120.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\msvcp140.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\msvcr100.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\msvcr120.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\vcamp120.dll" ( set /A i=i+1 )
@rem if %osver% equ 1 ( set i=0 )
if %i% GEQ 2 (
    if exist MSVCRedist.AIO.exe (
        echo [OSC]正在应用VC运行库 by XRSYS...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 MSVCRedist.AIO.exe /S
        del /f /q MSVCRedist.AIO.exe
    ) else if exist MSVBCRT.AIO.exe (
        echo [OSC]正在应用VC运行库 by Dreamcast...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 MSVBCRT.AIO.exe /SP- /SILENT /SUPPRESSMSGBOXES /NORESTART /COMPONENTS="vbvc567,vc2005,vc2008,vc2010,vc2012,vc2013,vc2019,vc2022,uc10,vstor"
        del /f /q MSVBCRT.AIO.exe
    ) else if exist VC.exe (
        echo [OSC]正在安装VC运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 VC.exe /S
        del /f /q VC.exe
    ) else if not %osver% equ 1 if exist VisualCppRedist_AIO.exe (
            echo [OSC]正在应用VC运行库 by abodi1406...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%PECMD%" EXEC -wait -timeout:300000 VisualCppRedist_AIO.exe /ai /gm2
            del /f /q VisualCppRedist_AIO.exe
    )
)

:flash
set i=0
if not exist "%SystemDrive%\Windows\System32\Macromed\Flash\NPSWF.dll" ( set /A i=i+1 )
if not exist "%SystemDrive%\Windows\System32\Macromed\Flash\pepflashplayer.dll" ( set /A i=i+1 )
if %i% GEQ 1 (
	echo [OSC]正在安装Flash运行库...>"%systemdrive%\Windows\Setup\wallname.txt"
    if exist flash.exe (
        start "" /wait "%PECMD%" EXEC -wait -timeout:300000 flash.exe
        del /f /q flash.exe
    )
)

if not %osver% equ 4 exit

echo [OSC]正在安装UWP扩展解码插件...>"%systemdrive%\Windows\Setup\wallname.txt"
cd /d "%~dp0"
if exist "Extension\install.bat" call "Extension\install.bat"
exit