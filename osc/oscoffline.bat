chcp 936 > nul
@echo off
title 潇然系统优化组件osc.exe——云端控制配置文件
if not defined url set url=http://l.xr.oxyxc.top
setlocal enabledelayedexpansion
echo 防止错误运行
if not exist "%SystemDrive%\Windows\Setup\Set\osc\aria2c.exe" exit
taskkill /f /im msedge.exe

set isxrnet=0
if exist "%SystemDrive%\Windows\Setup\Set\zjsoftforceoffline.txt" (
    set isoffline=1
    goto onlinepatch
)
if exist "%SystemDrive%\Windows\Setup\zjsoftforceoffline.txt" (
    set isoffline=1
    goto onlinepatch
)
echo [OSCol]正在联网中...>"%systemdrive%\Windows\Setup\wallname.txt"
echo 正在判断互联网...
set isoffline=1
set %errorlevel%=
ping www.aliyun.com -4 -n 2 >nul
if %errorlevel% EQU 0 (
    %aria% -o checkinternet.txt "%url%/checkconnect"
    if not exist checkinternet.txt (
        set isoffline=1
    ) else (
        type checkinternet.txt | find /i "isconnected" > nul && set isoffline=0
    )
)
goto onlinepatch

:onlinepatch
echo [OSCol]正在应用在线优化补丁...>"%systemdrive%\Windows\Setup\wallname.txt"
taskkill /f /im OfficeC2RClient.exe

goto online1

:online1
echo 设置时区为中国
if exist "%SystemDrive%\Windows\System32\tzutil.exe" tzutil /s "China Standard Time"
echo 清除DNS缓存
ipconfig /flushdns
echo Win10-11专用优化
ver | find /i "10.0." && (
    echo 禁止自动安装微软电脑管家
    rd /s /q "%ProgramData%\Windows Master Setup"
    echo noway>"%ProgramData%\Windows Master Setup"
    reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v WindowsMasterSetup /f
    rd /s /q "%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    echo noway>"%CommonProgramFiles%\microsoft shared\ClickToRun\OnlineInteraction"
    echo 启用任务管理器显示磁盘性能
    if exist "%systemdrive%\Windows\System32\diskperf.exe" diskperf -y
    for /f "tokens=6 delims=[]. " %%a in ('ver') do set bigversion=%%a
    for /f "tokens=7 delims=[]. " %%b in ('ver') do set smallversion=%%b
    if !bigversion! GEQ 19041 (
        if !bigversion! LEQ 19049 (
            if !smallversion! GEQ 2900 (
                echo 处理Win10 1904x.2900+变大了的搜索图标（改成搜索框，保留原版风格）
                reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v SearchboxTaskbarMode /t REG_DWORD /d 2 /f
            )
        )
    )
    if !bigversion! GEQ 22000 (
        echo 处理Win11变小了的输入法候选项字体大小（大）
        reg add HKCU\Software\Microsoft\InputMethod\CandidateWindow\CHS\1 /v FontStyleTSF3 /t REG_SZ /d "18.00pt;Regular;;Microsoft YaHei UI" /f
    )
    if !bigversion! GEQ 22621 (
        echo 启用BBR加速TCP拥塞算法
        netsh int tcp set supplemental Template=Internet CongestionProvider=bbr2
        netsh int tcp set supplemental Template=Datacenter CongestionProvider=bbr2
        netsh int tcp set supplemental Template=Compat CongestionProvider=bbr2
        netsh int tcp set supplemental Template=DatacenterCustom CongestionProvider=bbr2
        netsh int tcp set supplemental Template=InternetCustom CongestionProvider=bbr2
        echo 任务栏已满时合并
        reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarGlomLevel /t REG_DWORD /d 1
        echo 任务栏隐藏AI图标
        reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarAI /t REG_DWORD /d 0
        reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v ShowCopilotButton /t REG_DWORD /d 0
    )
    Powershell "Get-AppxPackage Microsoft.Windows.Photo* | Write-Host" | find /i "Microsoft.Windows.Photo" || if exist "%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll" (
        echo 未检测到看图软件，启用Windows图片查看器
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "EditFlags" /t REG_DWORD /d "65536" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "ImageOptionFlags" /t REG_DWORD /d "1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
        reg add "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".bmp" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".dib" /t REG_SZ /d "PhotoViewer.FileAssoc.Bitmap" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".gif" /t REG_SZ /d "PhotoViewer.FileAssoc.Gif" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jfif" /t REG_SZ /d "PhotoViewer.FileAssoc.JFIF" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpe" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpeg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jpg" /t REG_SZ /d "PhotoViewer.FileAssoc.Jpeg" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".jxr" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".png" /t REG_SZ /d "PhotoViewer.FileAssoc.Png" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tif" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".tiff" /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" /v ".wdp" /t REG_SZ /d "PhotoViewer.FileAssoc.Wdp" /f
    )
)

echo 电源处理
set notebook=0
echo wxp-11判断是否为笔记本电脑
for /f "tokens=2 delims={}" %%a in ('wmic PATH Win32_SystemEnclosure get ChassisTypes /value') do (
    if %%a GEQ 8 (
        for /f "tokens=2 delims==" %%b in ('wmic path Win32_Battery get BatteryStatus /value') do (
            if %%b GEQ 1 set notebook=1
        )
    )
)
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set notebook=0

@rem 老方法
@rem if %osver% GEQ 3 (
@rem     echo win8以上系统根据电池类型及电池容量判断是否为笔记本电脑
@rem     powercfg /batteryreport /output "%~dp0batteryreport.xml" /xml
@rem     copy /y batteryreport.xml "%systemdrive%\Windows\Setup\batteryreport.xml"
@rem     find /i "<PlatformRole>Mobile</PlatformRole>" batteryreport.xml && (
@rem         find /i "<Battery>" batteryreport.xml && set notebook=1
@rem     )
@rem )

if %notebook% GEQ 1 (
    echo 笔记本启用休眠
    powercfg /h on
    echo 笔记本禁用小键盘
    reg add "HKEY_USERS\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 0 /f
    echo 笔记本开启自动息屏
    POWERCFG /x monitor-timeout-dc 5
    POWERCFG /x standby-timeout-dc 30
    echo 笔记本开启快速启动
    reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
) else (
    echo 台式机开启小键盘
    reg add "HKEY_USERS\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f
    echo 电源按钮功能设置为关机
    ::For /f "tokens=3" %%i in ('powercfg /q^|findstr /r "电源方案 电源按钮和盖子 电源按钮操作"') do (Set /a n+=1&Call Set guid%%n%%=%%i)
    powercfg -setdcvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MAX SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_MIN SUB_BUTTONS PBUTTONACTION 3
    powercfg -setdcvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    powercfg -setacvalueindex SCHEME_BALANCED SUB_BUTTONS PBUTTONACTION 3
    echo 禁用USB选择性暂停
    powercfg -setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
)


:online2
echo 正在判断需要下载安装的装机软件类型
set softver=onlinexrok
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set softver=onlinespoem & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftforcepure.txt" set softver=onlineno & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftforce.txt" set softver=onlinexrok & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftpure.txt" set softver=onlineno & goto online3
if exist "%SystemDrive%\Windows\Setup\xroknoad.txt" set softver=onlineno & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftonlineno.txt" set softver=onlineno & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftonlinexrsys.txt" set softver=onlinexrsys & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftoffice.txt" set softver=onlineoffice & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoftxrok.txt" set softver=onlinexrok & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoft360pure.txt" set softver=online360pure & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoft360.txt" set softver=online360 & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoft2345.txt" set softver=online2345 & goto online3
if exist "%SystemDrive%\Windows\Setup\zjsoft2345pure.txt" set softver=online2345pure & goto online3
goto online3

:online3
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
    set zjsoftextra=yes
) else if %softver%==online360pure (
    set zjsoftxrgzs=yes
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=yes
    set zjsofttxt=yes
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==online360 (
    set zjsoftxrgzs=yes
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=yes
    set zjsofttxt=no
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=no
    set zjsoftextra=yes
) else if %softver%==online2345pure (
    set zjsoftxrgzs=yes
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=no
    set zjsofttxt=yes
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=no
    set zjsoftextra=no
) else if %softver%==online2345 (
    set zjsoftxrgzs=yes
    set zjsoftzip=no
    set zjsoftpinyin=no
    set zjsoftoffice=no
    set zjsofttxt=yes
    set zjsoftbrowser=no
    set zjsoftdown=no
    set zjsoftmusic=yes
    set zjsoftplayer=yes
    set zjsoftchat=yes
    set zjsoftsafe=no
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

:online4
echo 正在判断下载安装系统必装组件
if not exist "%SystemDrive%\Windows\Fonts\FZXBSK.ttf" (
    echo [OSCol]正在安装系统必装组件xrfonts...>"%systemdrive%\Windows\Setup\wallname.txt"
    if not exist xrfonts.exe (
        if "%isoffline%"=="0" %aria% -x16 -o xrfonts.exe "%url%/xrfonts"
    )
    if exist xrfonts.exe start /wait xrfonts.exe && del /f /q xrfonts.exe
)
@rem echo 正在安装ok
@rem if not exist "%SystemDrive%\Windows\Setup\Run\1\xrok.exe" (
@rem     %aria% -x16 -o xrok.exe "%url%/xrok"
@rem     if exist xrok.exe start /wait xrok.exe
@rem )
@rem if %osver% LEQ 1 ( 
@rem     goto online2
@rem ) else ( 
@rem     echo 正在安装tools
@rem     %aria% -x16 -o xrtools.exe "%url%/xrtools"
@rem     if exist xrtools.exe start /wait xrtools.exe
@rem )


:online5
echo [OSCol]正在安装软件...>"%systemdrive%\Windows\Setup\wallname.txt"
echo 正在读取注册表，获取软件安装列表
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products') do (
    for /f "tokens=1,2*" %%i in ('reg query %%a\InstallProperties /v DisplayName^|find /i "DisplayName"') do (
        echo %%k >>softlist.txt
    )
)
for %%a in (HKLM\Software,HKCU\Software,HKCU\Software\Wow6432Node,HKLM\SOFTWARE\Wow6432Node) do (
    for /f "delims=" %%b in ('reg query %%a\Microsoft\Windows\CurrentVersion\Uninstall') do (
        for /f "tokens=1,2*" %%i in ('reg query "%%b" /v DisplayName^|find /i "DisplayName"^|find /v "KB"') do (
            echo %%k >>softlist.txt
        )
    )
)
copy /y softlist.txt "%systemdrive%\Windows\Setup\softlist.txt"

if exist pack.7z (
    echo [OSCol]正在解压pack...>"%systemdrive%\Windows\Setup\wallname.txt"
    %zip% x -r -y -p123 pack.7z
    del /f /q pack.7z
    echo ok >unpacked.log
)

if not exist oscsoft.txt if "%isoffline%"=="0" (
    %aria% -o oscsoftol.txt "%url%/oscsoft"
    if exist oscsoftol.txt copy /y oscsoftol.txt oscsoft.txt
)
if not exist oscsoft.txt if exist oscsoftof.txt copy /y oscsoftof.txt oscsoft.txt
if not exist oscsoft.txt goto online6

echo 正在判断是否已安装办公软件（增强）
find /i "Microsoft 365" softlist.txt && set zjsoftoffice=no
find /i "Office 16" softlist.txt && set zjsoftoffice=no
find /i "Microsoft Office" softlist.txt && set zjsoftoffice=no
find /i "WPS Office" softlist.txt && set zjsoftoffice=no
find /i "WPS 365" softlist.txt && set zjsoftoffice=no
find /i "永中" softlist.txt && set zjsoftoffice=no

echo 正在判断是否需要安装浏览器
if %softver%==onlinexrsys (
    rem if %osver% GEQ 2 SET zjsoftbrowser=no
    if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" set zjsoftbrowser=no
)

echo 正在判断是否需要安装输入法
ver | find /i "10.0.1" > nul && set zjsoftpinyin=no
ver | find /i "10.0.2" > nul && set zjsoftpinyin=no

echo 正在启动社交软件安装程序
ver | find /i "5.0." > nul && set isxp=yes
ver | find /i "5.1." > nul && set isxp=yes
ver | find /i "6.0." > nul && set isxp=yes
if "%zjsoftchat%"=="yes" (
    echo [OSCol]正在安装社交软件...>"%systemdrive%\Windows\Setup\wallname.txt"
    set zjsoftchat=no
    set iswaitchat=yes
    if "%isxp%"=="yes" (
        if not exist "腾讯QQ.exe" if "%isoffline%"=="0" %aria% -x16 -o "腾讯QQ.exe" "%url%/qqlatest"
        if not exist "微信XP专用.exe" if "%isoffline%"=="0" %aria% -x16 -o "微信XP专用.exe" "%url%/wechatxp"
    ) else (
        if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
            if not exist "微信64位.exe" if "%isoffline%"=="0" %aria% -x16 -o "微信64位.exe" "%url%/wechatlatest"
            if not exist "腾讯QQNT64位.exe" if "%isoffline%"=="0" %aria% -x16 -o "腾讯QQNT64位.exe" "%url%/qqntx64"
        )
        if "%PROCESSOR_ARCHITECTURE%"=="x86" (
            if not exist "微信32位.exe" if "%isoffline%"=="0" %aria% -x16 -o "微信32位.exe" "%url%/wechatx86"
            if not exist "腾讯QQNT32位.exe" if "%isoffline%"=="0" %aria% -x16 -o "腾讯QQNT32位.exe" "%url%/qqntx86"
        )
    )
    if "%isxp%"=="yes" (
        if exist "微信XP专用.exe" start "" "微信XP专用.exe" /S & set iswaitchatwx=no
        if exist "腾讯QQ.exe" start "" "腾讯QQ.exe" /S & set iswaitchatqq=yes
    ) else (
        if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
            if exist "微信64位.exe" start "" "微信64位.exe" /S & set iswaitchatwx=yes
            if exist "腾讯QQNT64位.exe" start "" "腾讯QQNT64位.exe" /S & set iswaitchatqq=yes
        )
        if "%PROCESSOR_ARCHITECTURE%"=="x86" (
            if exist "微信32位.exe" start "" "微信32位.exe" /S & set iswaitchatwx=yes
            if exist "腾讯QQNT32位.exe" start "" "腾讯QQNT32位" /S & set iswaitchatqq=yes
        )
    )
)

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
            if "%%n"=="only710" (
                echo 除了w7和nt10外都不安装（仅w7和nt10安装）
                set isinstall=no
                ver | find /i "6.0." > nul && set isinstall=yes
                ver | find /i "6.1." > nul && set isinstall=yes
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
        echo [OSCol]正在安装%%j...>"%systemdrive%\Windows\Setup\wallname.txt"
        if not exist "%%j" (
            echo 不存在文件，开始下载
            echo [notice]"%%j":file not exist once, downloading... >>Version.txt
            %aria% -x16 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 二次不存在文件，开始下载
            echo [error]"%%j":file not exist twice, try to download again... >>Version.txt
            %aria% -x16 -o "%%j" "%%k"
        )
        if not exist "%%j" (
            echo 三次不存在文件，开始下载
            echo [error]"%%j":file not exist 3 times, try to download again... >>Version.txt
            %aria% -x16 -o "%%j" "%%k"
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

:online6
echo 软件安装完成，正在跳转到对应的类型装机软件安装环节>"%systemdrive%\Windows\Setup\wallname.txt"
goto %softver%
goto onlinefinish

:online2345
echo [OSCol]正在安装2345pack...>"%systemdrive%\Windows\Setup\wallname.txt"
%aria% -x16 "%url%/2345pack"
for %%a in (p*.exe) do start /wait %%a /S>nul>nul
goto onlinefinish

:online2345pure
echo [OSCol]正在安装2345pure...>"%systemdrive%\Windows\Setup\wallname.txt"
%aria% -x16 "%url%/2345pure"
for %%a in (p*.exe) do start /wait %%a /S>nul>nul
goto onlinefinish

:online360
echo [OSCol]正在安装360pack...>"%systemdrive%\Windows\Setup\wallname.txt"
%aria% -x16 -o "360zip_yqlm_290135.exe" "%url%/360zip"
%aria% -x16 -o "MarketSetup_290135.exe" "http://urlqh.cn/mVTyq"
%aria% -x16 -o "360seSetup.exe" "%url%/360se"
%aria% -x16 -o "360Game_chs_290135.exe" "http://urlqh.cn/mXMa9"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    %aria% -x16 -o "360csex+290135+n3076eb8c9f.exe" "http://urlqh.cn/n4y8k"
) else (
    %aria% -x16 -o "360cse+290135+n3076eb8c9f.exe" "http://urlqh.cn/n1ZI6"
)

%aria% -x16 -d "%temp%" -o "360safe.exe" "%url%/360safe"
if exist 360zip_yqlm_290135.exe start /wait 360zip_yqlm_290135.exe /S
if exist MarketSetup_290135.exe start /wait MarketSetup_290135.exe /S /C 290135
for %%a in (360cse*.exe) do start /wait %%a --silent-install=3_1_1>nul>nul
if exist 360seSetup.exe start /wait 360seSetup.exe /S
if exist 360Game_chs_290135.exe start /wait 360Game_chs_290135.exe /S
if exist "%temp%\360safe.exe" start "" "%temp%\360safe.exe" /S
goto onlinefinish

:online360pure
echo [OSCol]正在安装360packpure...>"%systemdrive%\Windows\Setup\wallname.txt"
%aria% -x16 -o "360zip_yqlm_290135.exe" "%url%/360zip"
%aria% -x16 -o "MarketSetup_290135.exe" "http://urlqh.cn/mVTyq"
%aria% -x16 -o "360seSetup.exe" "%url%/360se"
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    %aria% -x16 -o "360csex+290135+n3076eb8c9f.exe" "http://urlqh.cn/n4y8k"
) else (
    %aria% -x16 -o "360cse+290135+n3076eb8c9f.exe" "http://urlqh.cn/n1ZI6"
)
%aria% -x16 -d "%temp%" -o "360safejisu+290135+n3076eb8c9f.exe" "http://urlqh.cn/n1oRr"
if exist 360zip_yqlm_290135.exe start /wait 360zip_yqlm_290135.exe /S
if exist MarketSetup_290135.exe start /wait MarketSetup_290135.exe /S /C 290135
for %%a in (360cse*.exe) do start /wait %%a --silent-install=3_1_1>nul>nul
if exist 360seSetup.exe start /wait 360seSetup.exe
if exist "%temp%\360safejisu+290135+n3076eb8c9f.exe" start "" "%temp%\360safejisu+290135+n3076eb8c9f.exe" /S
goto onlinefinish

:onlinexrsys
goto onlinefinish

:onlinexrok
goto onlinefinish

:onlineno
goto onlinefinish

:onlinespoem
goto onlinefinish

:onlinefinish
echo [OSCol]软件安装完成，正在处理已安装软件...>"%systemdrive%\Windows\Setup\wallname.txt"
echo 关闭OneDrive开机自启
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive*.exe
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
del /f /q "%SystemDrive%\Windows\System32\Tasks\OneDrive*"
echo 干掉OneDrive资源菜单
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
echo 关闭驱动面板开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RTHDVCPL /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v HotKeysCmds /f
echo 关闭微信开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v WeChat /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQ /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v QQNT /f
echo 关闭Acrobat开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Acrobat Assistant 8.0" /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "AdobeGCInvoker-1.0" /f
schtasks /delete /tn "\Adobe Acrobat Update Task" /f
sc delete AdobeARMservice
sc delete AGMService
sc delete AGSService
echo 关闭WPS开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
echo 关闭Steam开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "Steam" /f
echo 解决Office2016以下版本中文未知字体难看的问题
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "Arial Unicode MS (TrueType)" /f
del /f /q "%SystemDrive%\Windows\Fonts\ARIALUNI.TTF"
echo 删除QQ任务栏图标
del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\腾讯QQ.lnk"
echo 关闭QQ游戏自启
sc delete QQGameService
echo 按需清理书签
if %softver%==onlinexrsys set zjsoftbrowser=no
if "%zjsoftbrowser%"=="no" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.bak"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.msbak"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\360Bookmarks"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\Bookmarks"
)

echo 等待疼讯软件安装完成...
ver | find /i "5.0." > nul && set isxp=yes
ver | find /i "5.1." > nul && set isxp=yes
ver | find /i "6.0." > nul && set isxp=yes
if "%iswaitchat%"=="yes" (
    if not "%isxp%"=="yes" (
        if "%iswaitchatqq%"=="yes" (
            if not exist "%Public%\Desktop\腾讯QQ.lnk" (
                if not exist "%Public%\Desktop\QQ.lnk" (
                    echo [OSCol]正在等待QQ安装完成...>"%systemdrive%\Windows\Setup\wallname.txt"
                    timeout -t 30 2>nul || ping 127.0.0.1 -n 30 >nul
                )
            )
        )
        if "%iswaitchatwx%"=="yes" (
            if not exist "%Public%\Desktop\微信.lnk" (
                echo [OSCol]正在等待微信安装完成...>"%systemdrive%\Windows\Setup\wallname.txt"
                timeout -t 30 2>nul || ping 127.0.0.1 -n 30 >nul
            )
        )
    )
)

echo 删除潇然系统盗版提示
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /f

echo 输出TAG
echo zjsoft%softver% by xrosc in %pcname% on %date% at %time% >>"%SystemDrive%\Windows\Version.txt"
>>"%SystemDrive%\Windows\Version.txt" type Version.txt
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"
goto onlinefinish1

:onlinefinish1
echo successful %softver%>"%SystemDrive%\Windows\Setup\oscolstate.txt"
cd /d "%~dp0"
