chcp 936 > nul
@echo off
REM ===========================================================
REM 文件说明: 软件安装脚本
REM 作者: 狂犬主子
REM SPDX-License-Identifier: GPL-3.0-or-later
REM 版权所有 (C) 潇然工作室
REM 未经作者许可，不得删除或修改此文件中的版权和许可信息
REM ===========================================================
title 潇然系统优化组件osc.exe——软件安装脚本

call "%~dp0..\common\env.bat" OSC
setlocal enabledelayedexpansion
taskkill /f /im msedge.exe

echo 检测系统是否为XP
set isxp=no
ver | find /i "5.0." > nul && set isxp=yes
ver | find /i "5.1." > nul && set isxp=yes
ver | find /i "6.0." > nul && set isxp=yes

if exist "%SystemDrive%\Windows\Setup\Set\zjsoftforceoffline.txt" (
    set isoffline=1
    goto software_prepare
)
if exist "%SystemDrive%\Windows\Setup\zjsoftforceoffline.txt" (
    set isoffline=1
    goto software_prepare
)
echo [OSCol]检测网络...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo 正在判断互联网...
set isoffline=1
ping www.aliyun.com -4 -n 2 >nul
if %errorlevel% EQU 0 set isoffline=0
goto software_prepare

:software_prepare
echo 设置时区为中国
if exist "%SystemDrive%\Windows\System32\tzutil.exe" tzutil /s "China Standard Time"
echo 校对时间
if "%isoffline%"=="0" "%XRSYS_OSC_PECMD_EXE%" NTPC ntp1.aliyun.com
echo 清除DNS缓存
ipconfig /flushdns

echo Win10/11 软件源优化
ver | find /i "10.0." && (
    if "%isoffline%"=="0" (
        if exist "%LocalAppData%\Microsoft\WindowsApps\winget.exe" (
            echo WinGet 换源
            winget source remove winget && winget source add winget https://mirrors.cernet.edu.cn/winget-source
        )
        @rem if exist "%SystemDrive%\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
        @rem     echo 安装 Scoop
        @rem     powershell -C "irm https://c.xrgzs.top/c/scoop|iex"
        @rem )
    )
)

echo [OSCol]正在检测组件...>"%SystemDrive%\Windows\Setup\wallname.txt"

echo [OSCol]正在应用在线优化补丁...>"%SystemDrive%\Windows\Setup\wallname.txt"
taskkill /f /im OfficeC2RClient.exe
:software_install
echo [OSCol]正在安装软件...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo 正在读取注册表，获取软件安装列表
for /f "tokens=1,2*" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products /s /v DisplayName^|find /i "DisplayName"') do (
    echo %%k >>softlist.txt
)
for %%a in (HKLM\Software,HKCU\Software,HKCU\Software\Wow6432Node,HKLM\SOFTWARE\Wow6432Node) do (
    for /f "tokens=1,2*" %%i in ('reg query "%%a\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName^|find /i "DisplayName"^|find /v "KB"') do (
        echo %%k >>softlist.txt
    )
)
copy /y softlist.txt "%SystemDrive%\Windows\Setup\softlist.txt"

if exist pack.7z (
    echo [OSCol]正在解压pack...>"%SystemDrive%\Windows\Setup\wallname.txt"
    "%XRSYS_OSC_7Z_EXE%" x -r -y -p123 pack.7z
    del /f /q pack.7z
    echo ok >unpacked.log
)

REM 优先加载外置TAG软件清单
set "softlistfile=xrsyssoft.txt"
if exist "%SystemDrive%\Windows\Setup\xrsyssoft.txt" set "softlistfile=%SystemDrive%\Windows\Setup\xrsyssoft.txt"
if not exist "!softlistfile!" goto softwarefinish

echo 正在遍历 !softlistfile! 安装软件
echo [软件清单] !softlistfile! >>Version.txt
echo [系统版本] %XRSYS_OSC_WINDOWS_VERSION_LEVEL% >>Version.txt
echo [处理器架构] %PROCESSOR_ARCHITECTURE% >>Version.txt
echo --- >>Version.txt

FOR /F "eol=; tokens=1,2,3,4,5,6 delims=|" %%a in (!softlistfile!) do (
    echo 软件:%%a 下载:%%b 参数:%%c 检测:%%d 适用:%%e 架构:%%f
    set isinstall=yes
    set "softname=%%a"
    set "softurl=%%b"
    set "softargs=%%c"
    set "softdetect=%%d"
    set "softtarget=%%e"
    set "softarch=%%f"

    REM 检测已安装
    if not "!softdetect!"==" " (
        findstr /i "!softdetect!" softlist.txt && (
            echo [跳过] !softname! 已安装 >>Version.txt
            set isinstall=no
        )
    )

    REM 检测适用系统
    if not "!softtarget!"==" " (
        if "!softtarget!"=="xp" (
            echo [系统要求] 仅XP
            set isinstall=no
            ver | find /i "5.0." > nul && set isinstall=yes
            ver | find /i "5.1." > nul && set isinstall=yes
        )
        if "!softtarget!"=="win7" (
            echo [系统要求] Win7及以下
            set isinstall=no
            ver | find /i "5.0." > nul && set isinstall=yes
            ver | find /i "5.1." > nul && set isinstall=yes
            ver | find /i "6.0." > nul && set isinstall=yes
            ver | find /i "6.1." > nul && set isinstall=yes
        )
        if "!softtarget!"=="win10+" (
            echo [系统要求] Win10及以上
            set isinstall=no
            ver | find /i "10.0." > nul && set isinstall=yes
        )
        if "!softtarget!"=="win10" (
            echo [系统要求] 仅Win10
            set isinstall=no
            ver | find /i "10.0.1" > nul && set isinstall=yes
            ver | find /i "10.0.2" > nul && set isinstall=no
        )
        if "!softtarget!"=="win11" (
            echo [系统要求] 仅Win11
            set isinstall=no
            ver | find /i "10.0.2" > nul && set isinstall=yes
        )
        if "!softtarget!"=="win7-10" (
            echo [系统要求] Win7到Win10
            set isinstall=no
            ver | find /i "6.0." > nul && set isinstall=yes
            ver | find /i "6.1." > nul && set isinstall=yes
            ver | find /i "10.0." > nul && set isinstall=yes
        )
        if "!softtarget!"=="not-xp" (
            echo [系统要求] 除XP外
            ver | find /i "5.0." > nul && set isinstall=no
            ver | find /i "5.1." > nul && set isinstall=no
        )
        if "!softtarget!"=="not-win7" (
            echo [系统要求] 除Win7外
            ver | find /i "6.0." > nul && set isinstall=no
            ver | find /i "6.1." > nul && set isinstall=no
        )
        if "!softtarget!"=="not-win10" (
            echo [系统要求] 除Win10外
            ver | find /i "10.0." > nul && set isinstall=no
        )
        if "!softtarget!"=="not-win11" (
            echo [系统要求] 除Win11外
            ver | find /i "10.0.2" > nul && set isinstall=no
        )
    )

    REM 检测架构
    if not "!softarch!"==" " (
        if not "%PROCESSOR_ARCHITECTURE%"=="!softarch!" (
            echo [跳过] !softname! 架构不匹配 >>Version.txt
            set isinstall=no
        )
    )

    REM 未联网且文件不存在则跳过
    if not exist "!softname!" (
        if "%isoffline%"=="1" set isinstall=no
    )

    REM 开始安装
    if not "!isinstall!"=="no" (
        echo [安装] !softname! >>Version.txt
        echo [OSCol]正在安装!softname!...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist "!softname!" (
            echo   下载: !softurl! >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o "!softname!" "!softurl!"
        )
        if not exist "!softname!" (
            echo   重试下载... >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x8 -o "!softname!" "!softurl!"
        )
        if not exist "!softname!" (
            echo   最后尝试... >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x1 -o "!softname!" "!softurl!"
        )
        if exist "!softname!" (
            start "" /wait "!softname!" !softargs! >>Version.txt
            del /f /q "!softname!"
            echo   完成 >>Version.txt
        ) else (
            echo   失败: 文件不存在 >>Version.txt
        )
    ) else (
        echo [跳过] !softname! >>Version.txt
    )
)
goto softwarefinish

:softwarefinish
echo [OSC]正在运行软件安装后的清理操作...>"%SystemDrive%\Windows\Setup\wallname.txt"
if exist "optimize\postsoftware.bat" echo y | start "" /wait /min "optimize\postsoftware.bat"
cd /d "%~dp0"
echo successful>"%SystemDrive%\Windows\Setup\softwarestate.txt"
echo successful>"%SystemDrive%\Windows\Setup\oscolstate.txt"
exit
