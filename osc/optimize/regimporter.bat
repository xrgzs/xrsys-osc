@echo off
chcp 936 > nul
set osver=0
cd /d "%~dp0"
ver | find /i "5.1." > nul && set osver=1
ver | find /i "6.0." > nul && set osver=1
ver | find /i "6.1." > nul && set osver=2
ver | find /i "6.2." > nul && set osver=3
ver | find /i "6.3." > nul && set osver=3
ver | find /i "6.4." > nul && set osver=4
ver | find /i "10.0." > nul && set osver=4

:: bypass UCPD
set random=
set reg_name=%random%
set regedit_name=%random%
copy /y "%SystemDrive%\Windows\System32\reg.exe" "%~dp0\%reg_name%.exe"
copy /y "%SystemDrive%\Windows\regedit.exe" "%~dp0\%regedit_name%.exe"

call :import_reg_folder all
if %osver% LEQ 1 (
    call :import_reg_folder nt5
    goto exit
)
call :import_reg_folder nt6
if %osver% EQU 2 (
    call :import_reg_folder nt6.1
    goto exit
)
if %osver% GEQ 3 (
    call :import_reg_folder nt6.x
)

:exit
del /f /q "%~dp0\reg%rand_name%.exe"
del /f /q "%~dp0\regedit%rand_name%.exe"
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
