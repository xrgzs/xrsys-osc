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
goto software_profile

:software_profile
echo 正在判断需要下载安装的装机软件类型
set softver=onlinexrsys
if exist "%SystemDrive%\Windows\Setup\zjsoftxrok.txt" set softver=onlinexrok
if exist "%SystemDrive%\Windows\Setup\zjsoftoffice.txt" set softver=onlineoffice
if exist "%SystemDrive%\Windows\Setup\zjsoftonlinexrsys.txt" set softver=onlinexrsys
if exist "%SystemDrive%\Windows\Setup\zjsoftonlineno.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\xroknoad.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftpure.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftforce.txt" set softver=onlinexrok
if exist "%SystemDrive%\Windows\Setup\zjsoftforcepure.txt" set softver=onlineno
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set softver=onlinespoem
goto software_select

:software_select
echo 正在根据装机软件类型判断需要安装的基础软件
if %softver%==onlineno (
    set zjsoftxrgzs=no
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=no
    set zjsofttxt=no
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlinexrsys (
    set zjsoftxrgzs=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=no
    set zjsofttxt=no
    set zjsoftbrowser=yes
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlineoffice (
    set zjsoftxrgzs=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=yes
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=no
    set zjsoftchat=no
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==onlinexrok (
    set zjsoftxrgzs=yes
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=yes
    set zjsoftbrowser=yes
    set zjsoftdown=yes
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=yes
    echo test startup >"%SystemDrive%\Windows\Setup\zjsoftHR.txt"
    set zjsoftextra=yes
) else if %softver%==onlinespoem (
    set zjsoftxrgzs=no
    set zjsoftzip=yes
    set zjsoftpinyin=yes
    set zjsoftoffice=yes
    set zjsofttxt=no
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=no
    set zjsoftplayer=yes
    set zjsoftchat=no
    set zjsoftsafe=yes
    set zjsoftextra=no
    echo oem special do not 360 >"%SystemDrive%\Windows\Setup\zjsoftHR.txt"
)

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

if exist oscsoftof.txt copy /y oscsoftof.txt oscsoft.txt
if not exist oscsoft.txt goto softwarefinish

echo 正在判断是否已安装办公软件（增强）
find /i "Microsoft 365" softlist.txt && set zjsoftoffice=no
find /i "Office 16" softlist.txt && set zjsoftoffice=no
find /i "Microsoft Office" softlist.txt && set zjsoftoffice=no
find /i "WPS Office" softlist.txt && set zjsoftoffice=no
find /i "WPS 365" softlist.txt && set zjsoftoffice=no
find /i "永中" softlist.txt && set zjsoftoffice=no

echo 正在判断是否需要安装浏览器
@rem if %softver%==onlinexrsys (
@rem     rem if %XRSYS_OSC_WINDOWS_VERSION_LEVEL% GEQ 2 SET zjsoftbrowser=no
@rem     if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" set zjsoftbrowser=no
@rem )
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" set zjsoftbrowser=no
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Firefox.lnk" set zjsoftbrowser=no
if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" set zjsoftbrowser=no

echo 正在判断是否需要安装输入法
ver | find /i "10.0.1" > nul && set zjsoftpinyin=no
ver | find /i "10.0.2" > nul && set zjsoftpinyin=no


echo 正在遍历oscsoft.txt安装软件
set | find /i "zjsoft" >>Version.txt
FOR /F "eol=; tokens=1,2,3,4,5,6,7,8 delims=|" %%i in (oscsoft.txt) do (
    echo 1.软件类型:%%i 2.安装程序:%%j 3.下载地址:%%k 4.运行参数:%%l 5.关键词:%%m 6.指定不安装版本:%%n 7.指定安装位数:%%o
    set isinstall=yes
    if not "!%%i!"=="no" (
        if not "%%n"==" " (
            if "%%n"=="xp" (
                echo wXP不安装
                ver | find /i "5.0." > nul && set isinstall=no
                ver | find /i "5.1." > nul && set isinstall=no
            )
            if "%%n"=="onlyxp" (
                echo 除了wXP外都不安装（仅wXP安装）
                set isinstall=no
                ver | find /i "5.0." > nul && set isinstall=yes
                ver | find /i "5.1." > nul && set isinstall=yes
            )
            if "%%n"=="11xp" (
                echo w11和wXP不安装
                ver | find /i "5.0." > nul && set isinstall=no
                ver | find /i "5.1." > nul && set isinstall=no
                ver | find /i "10.0.19" > nul && set isinstall=no
                ver | find /i "10.0.2" > nul && set isinstall=no
            )
            if "%%n"=="7" (
                echo w7不安装
                ver | find /i "6.0." > nul && set isinstall=no
                ver | find /i "6.1." > nul && set isinstall=no
            )
            if "%%n"=="only7" (
                echo 除了w7外都不安装（仅w7安装）
                set isinstall=no
                ver | find /i "6.0." > nul && set isinstall=yes
                ver | find /i "6.1." > nul && set isinstall=yes
            )
            if "%%n"=="only710" (
                echo 除了w7和nt10外都不安装（仅w7和nt10安装）
                set isinstall=no
                ver | find /i "6.0." > nul && set isinstall=yes
                ver | find /i "6.1." > nul && set isinstall=yes
                ver | find /i "10.0." > nul && set isinstall=yes
            )
            if "%%n"=="only10" (
                echo 除了nt10外都不安装（仅nt10安装）
                set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=yes
            )
            if "%%n"=="710" (
                echo w7和nt10不安装（WPS）
                ver | find /i "6.0." > nul && set isinstall=no
                ver | find /i "6.1." > nul && set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=no
            )
            if "%%n"=="10" (
                echo nt10不安装
                ver | find /i "6.4." > nul && set isinstall=no
                ver | find /i "10.0." > nul && set isinstall=no
            )
            if "%%n"=="11" (
                echo w11不安装
                ver | find /i "10.0.2" > nul && set isinstall=no
            )
        )
        echo 已存在关键词不安装
        findstr /i "%%m" softlist.txt && set isinstall=no
        if not "%%o"==" " (
            if not "%PROCESSOR_ARCHITECTURE%"=="%%o" set isinstall=no
        )
    ) else (
        set isinstall=no
    )
    if not exist "%%j" (
        echo 不存在文件且未联网不安装
        if "%isoffline%"=="1" set isinstall=no
    )
    if not "!isinstall!"=="no" (
        echo 需要安装
        echo [OSCol]正在安装%%~nj...>"%SystemDrive%\Windows\Setup\wallname.txt"
        if not exist "%%j" (
            echo 不存在文件，开始下载
            echo [notice]"%%j":file not exist once, downloading... >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x16 -j16 -s16 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 二次不存在文件，开始下载
            echo [error]"%%j":file not exist twice, try to download again... >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x8 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 三次不存在文件，开始下载
            echo [error]"%%j":file not exist 3 times, try to download again... >>Version.txt
            %XRSYS_OSC_ARIA2_CMD% -x1 -o "%%j" "%%k"
        )
        if exist "%%j" (
            echo 存在文件，运行并等待安装
            start "" /wait "%%j" %%l >>Version.txt
            del /f /q "%%j"
            echo "%%j":install successfully >>Version.txt
        ) else (
            echo 不存在文件
            echo [error]"%%j":final file not exist, can not inst >>Version.txt
        )
    ) else (
        echo 不需要安装
        echo [notice]"%%j":isinstall=no, do nothing with >>Version.txt
    )
)
goto softwarefinish
:softwarefinish
echo [OSC]正在运行软件安装后的清理操作...>"%SystemDrive%\Windows\Setup\wallname.txt"
if exist "optimize\postsoftware.bat" echo y | start "" /wait /min "optimize\postsoftware.bat"
cd /d "%~dp0"
echo successful %softver%>"%SystemDrive%\Windows\Setup\softwarestate.txt"
echo successful %softver%>"%SystemDrive%\Windows\Setup\oscolstate.txt"
exit
