chcp 936 > nul
@echo off
REM ===========================================================
REM 文件说明: API 文件自清理脚本
REM 作者: 狂犬主子
REM SPDX-License-Identifier: GPL-3.0-or-later
REM 版权所有 (C) 潇然工作室
REM 未经作者许可，不得删除或修改此文件中的版权和许可信息
REM ===========================================================
echo 正在清理相关残留文件...
rem taskkill /f /im api.exe
@rem taskkill /f /im EsDeploy.exe
taskkill /f /im ScDeploy.exe
taskkill /f /im ScTasks.exe
rem delete system deploy or drivers temp
rd /s /q "%SystemDrive%\AMD"
rd /s /q "%SystemDrive%\NVIDIA"
rd /s /q "%SystemDrive%\Drivers"
rd /s /q "%SystemDrive%\DrvPath"
del /f /s /q "%SystemDrive%\sysprep\*"
rd /s /q "%SystemDrive%\sysprep"
del /f /s /q "%SystemDrive%\wandrv\*"
rd /s /q "%SystemDrive%\wandrv"
del /f /q "%SystemDrive%\Windows\CxSoftQii.ini"
del /f /q "%SystemDrive%\Windows\KillPE.dat"
del /f /q "%SystemDrive%\Windows\PETime.dat"
del /f /q "%SystemDrive%\Windows\NoRun.log"
del /f /q "%SystemDrive%\Windows\reg.ini"
del /f /q "%SystemDrive%\Windows\System32\deploy.exe"
@rem del /f /s /q "%SystemDrive%\Windows\Setup\Set\*"
@rem rd /s /q "%SystemDrive%\Windows\Setup\Set"
del /f /q "%SystemDrive%\Windows\Panther\unattend.xml"
del /f /q "%SystemDrive%\Windows\Panther\unattend1.xml"

start /min cmd /c del /f /q %0