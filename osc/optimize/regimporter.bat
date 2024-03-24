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

:1st
cd /d "%~dp0\reg\all"
for %%a in (*.reg) do (
	reg import "%%a" >nul >nul
	regedit /s "%%a" >nul >nul
)
if %osver% LEQ 1 goto 2nd_nt5
if %osver% EQU 2 goto 2nd_nt6.1
if %osver% GEQ 3 goto 2nd_nt6.x

:2nd_nt5
cd /d "%~dp0\reg\nt5"
for %%a in (*.reg) do (
	reg import "%%a" >nul >nul
	regedit /s "%%a" >nul >nul
)
goto exit

:2nd_nt6.1
cd /d "%~dp0\reg\nt6.1"
for %%a in (*.reg) do (
	reg import "%%a" >nul >nul
	regedit /s "%%a" >nul >nul
)
goto 2nd_nt6

:2nd_nt6.x
cd /d "%~dp0\reg\nt6.x"
for %%a in (*.reg) do (
	reg import "%%a" >nul >nul
	regedit /s "%%a" >nul >nul
)
goto 2nd_nt6

:2nd_nt6
cd /d "%~dp0\reg\nt6"
for %%a in (*.reg) do (
	reg import "%%a" >nul >nul
	regedit /s "%%a" >nul >nul
)
goto exit


:exit
exit