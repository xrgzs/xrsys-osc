@echo off
chcp 936 > nul
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