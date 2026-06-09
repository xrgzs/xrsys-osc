@echo off
chcp 936 > nul
REM ===========================================================
REM 文件说明: 注册表导入脚本
REM 作者: 狂犬主子
REM SPDX-License-Identifier: GPL-3.0-or-later
REM 版权所有 (C) 潇然工作室
REM 未经作者许可，不得删除或修改此文件中的版权和许可信息
REM ===========================================================
cd /d "%~dp0"
call "%~dp0..\..\common\env.bat" OSC

:: bypass UCPD
set random=
set reg_name=%random%
set regedit_name=%random%
copy /y "%SystemDrive%\Windows\System32\reg.exe" "%~dp0\%reg_name%.exe"
copy /y "%SystemDrive%\Windows\regedit.exe" "%~dp0\%regedit_name%.exe"
if exist "%SystemDrive%\Windows\System32\drivers\ucpd.sys" (
    echo 禁用 UCPD 驱动
    sc stop ucpd
    sc config ucpd start= disabled
    schtasks /delete /tn "\Microsoft\Windows\AppxDeploymentClient\UCPD velocity" /f
)

call :import_reg_folder all
if %XRSYS_OSC_WINDOWS_VERSION_LEVEL% LEQ 1 (
    call :import_reg_folder nt5
    goto exit
)
call :import_reg_folder nt6
if %XRSYS_OSC_WINDOWS_VERSION_LEVEL% EQU 2 (
    call :import_reg_folder nt6.1
    goto exit
)
if %XRSYS_OSC_WINDOWS_VERSION_LEVEL% GEQ 3 (
    call :import_reg_folder nt6.x
)

:exit
del /f /q "%~dp0\%reg_name%.exe"
del /f /q "%~dp0\%regedit_name%.exe"
exit

:import_reg_folder <path>
cd /d "%~dp0\reg\%1"
for %%a in (*.reg) do (
    reg.exe import "%%a" >nul
    "%~dp0\%reg_name%.exe" import "%%a" >nul
    regedit.exe /s "%%a" >nul
    "%~dp0\%regedit_name%.exe" /s "%%a" >nul
)
goto :eof
