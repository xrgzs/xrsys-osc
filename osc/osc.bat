chcp 936 > nul
setlocal EnableDelayedExpansion
@echo off
title 潇然系统优化组件 XRSYS-OSC
cd /d "%~dp0"
set aria="%~dp0aria2c.exe" --check-certificate=false --save-not-found=false --always-resume=false --auto-save-interval=10 --auto-file-renaming=false --allow-overwrite=true -c
set dmi="%~dp0apifiles\DMI.exe"
set netuser="%~dp0apifiles\NetUser.exe"
set nircmd="%~dp0apifiles\nircmd.exe"
set winput="%~dp0apifiles\winput.exe"
set wbox="%~dp0apifiles\wbox.exe"
set nsudo="%~dp0apifiles\NSudoLC.exe"
set pecmd="%~dp0apifiles\PECMD.EXE"
set srtool="%~dp0apifiles\srtool.exe"
set wlan="%~dp0apifiles\WLAN.exe"
set zip="%~dp0apifiles\7z.exe"
if exist "%systemdrive%\Windows\SysWOW64\wscript.exe" (
    set "PROCESSOR_ARCHITECTURE=AMD64"
)
rem 系统版本判断
set osver=0&& set osname=Win
ver | find /i "5.1." > nul && set osver=1&& set osname=WinXP
ver | find /i "6.0." > nul && set osver=2&& set osname=Vista
ver | find /i "6.1." > nul && set osver=2&& set osname=Win7
ver | find /i "6.2." > nul && set osver=3&& set osname=Win8
ver | find /i "6.3." > nul && set osver=3&& set osname=Win8.1
ver | find /i "6.4." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0.2" > nul && set osver=4&& set osname=Win11

rem 创建相关文件夹
mkdir "%SystemDrive%\Windows\Setup"
mkdir "%SystemDrive%\Windows\Setup\Run"
echo successful>"%SystemDrive%\Windows\Setup\oscrunstate.txt"

@rem :oscapifiles
@rem rem 为api提供文件
@rem if exist "%SystemDrive%\Windows\Setup\Set\needoscapifiles.txt" (
@rem     mkdir ..\apifiles
@rem     copy /y apifiles ..\apifiles
@rem     del /f /q "%SystemDrive%\Windows\Setup\Set\needoscapifiles.txt"
@rem     goto endoff
@rem )

:checkenv_generalize
rem 检测是否在部署阶段中运行
if exist "%SystemDrive%\Windows\Setup\State\State.ini" (
    find /i "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE" "%SystemDrive%\Windows\Setup\State\State.ini" && (
        echo 不支持在部署阶段中运行
        goto endoff
    )
)

:checkenv_winpe
rem 检测是否在PE系统中运行
if /i "%SystemDrive%"=="x:" if exist "X:\Windows\System32\PECMD.EXE" (
    echo 不支持在PE系统中运行
    goto endoff
)

:mainprogram
rem 潇然系统盗版提示
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /t REG_SZ /d "警告：您的系统可能没有部署完整（OSC）" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /t REG_SZ /d "这通常是网络连接不稳定或部署程序BUG导致的，请在点击【确定】登录账户后，访问http://url.xrgzs.top/osc下载、重新运行osc.exe尝试解决。此提示每次登录前都会强制弹出，如有特殊情况请联系QQ:2744460679解决。" /f

rem 创建runonce自删清理脚本...
if %osver% GEQ 2 (
	copy /y runonce.bat "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup\"
)
if not exist "%SystemDrive%\Windows\Setup\Set\xrsysstepapi5.flag" (
    start "" "%~dp0apifiles\PECMD.exe" LOAD "%~dp0apifiles\Wall.wcs"
)

:copytags
rem 拷贝相关TAG文件
mkdir "%SystemDrive%\Windows\Setup\"
for %%a in (C D E F G H) do (
    move /y "%%a:\zjsoft*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\xrok*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\xrsys*.txt" "%SystemDrive%\Windows\Setup"
)

:oscdrivers
echo 电源选项设置
rem POWERCFG -HIBERNATE OFF
powercfg /h off
POWERCFG -CHANGE -monitor-timeout-ac 0
POWERCFG -CHANGE -monitor-timeout-dc 0
POWERCFG -CHANGE -standby-timeout-ac 0
POWERCFG -CHANGE -standby-timeout-dc 0
POWERCFG -CHANGE -hibernate-timeout-ac 0
POWERCFG -CHANGE -hibernate-timeout-dc 0
rem [监视器电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -monitor-timeout-ac 0
rem [磁盘电源不关闭]
powercfg setactive SCHEME_BALANCED && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -disk-timeout-ac 0
rem 安装驱动
if exist wandrv.iso (
    echo [OSC]正在应用万能驱动wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv
    move /y "%~dp0wandrv.iso" "%~dp0wandrv\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv\DriveCleaner.exe" /wandrv
    echo wandrv.iso>>"%systemdrive%\Windows\Setup\xrsysdriverdebug.log"
)
if exist wandrv2.iso (
    echo [OSC]正在应用万能驱动wandrv2.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv2
    move /y "%~dp0wandrv2.iso" "%~dp0wandrv2\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv2\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv2\DriveCleaner.exe" /wandrv
    echo wandrv2.iso>>"%systemdrive%\Windows\Setup\xrsysdriverdebug.log"
)


:optimize
if exist "optimize\start.bat" (
    echo [OSC]正在优化系统...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /wait /min "optimize\start.bat"
)

:themerec
echo [OSC]正在恢复系统主题...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "themerec\themerec.bat" echo y | start "" /wait /min "themerec\themerec.bat"
taskkill /f /im explorer.exe


:changepcname
echo 修改机器号
if exist "%SystemDrive%\Windows\Setup\xrsysnopcname.txt" goto changepasswd
if exist "%SystemDrive%\Windows\Setup\xrsyspcname.txt" (
    set /p pcname=<"%SystemDrive%\Windows\Setup\xrsyspcname.txt"
)
echo %computername% | find /i "-PC" && goto changepasswd
echo %computername% | find /i "PC-" && goto changepasswd
if defined pcname set "pcname=%pcname: =%"
if "!pcname!"=="%computername%" goto changepasswd

echo 生成四个随机字母
set str=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for /l %%a in (1 1 4) do (
    set /a n=!random!%%26
    call set random_letters=%%str:~!n!,1%%!random_letters!
)
if exist "%SystemDrive%\Windows\Setup\zjsoftseewo.txt" (
    set pcname=seewo-PC
) else if exist "%SystemDrive%\Windows\Setup\zjsofthite.txt" (
    set pcname=HiteVision-PC
) else if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" (
    set pcname=Admin-PC
) else (
    set pcname=PC-%date:~0,4%%date:~5,2%%date:~8,2%%random_letters%
)
wmic computersystem where "caption='%computername%'" call Rename name='%pcname%'
reg add "HKCU\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "NV Hostname" /t REG_SZ /d "%pcname%"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Hostname" /t REG_SZ /d "%pcname%"
reg add "HKU\.DEFAULT\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"

:changepasswd
setlocal enabledelayedexpansion
if exist "%systemdrive%\Windows\Setup\xrsyspasswd.txt" (
    set /p passwd=<"%SystemDrive%\Windows\Setup\xrsyspasswd.txt"
    del /f /q "%SystemDrive%\Windows\Setup\xrsyspasswd.txt"
    if not defined passwd set passwd=1
    if defined passwd set "passwd=!passwd: =!"
    if "!passwd!"=="1" set passwd=PassWd@123
    net user %USERNAME% !passwd!
)
endlocal

:restorewifi
rem 还原备份的WIFI密码
if %osver% GEQ 2 (
    for %%a in (C D E F G H) do (
        if exist "%%a:\Xiaoran\WLANPassword\*.xml" (
            FORFILES /P "%%a:\Xiaoran\WLANPassword" /M *.xml /C "cmd /c netsh wlan add profile filename=@path"
        )
        if exist "%%a:\WLANPassword\*.xml" (
            FORFILES /P "%%a:\WLANPassword" /M *.xml /C "cmd /c netsh wlan add profile filename=@path"
        )
    )
) else (
    for /f "tokens=1,2" %%i in ('%wlan% ei') DO (
        if "%%i"=="GUID:" (
            set GUID=%%j
            for %%a in (C D E F G H) do (
                for %%b in ("%%a:\Xiaoran\WLANPassword\*.xml") DO (
                    %wlan% sp !GUID! "%%b"
                )
            )
        )
    )
)


:restoreip
setlocal enabledelayedexpansion
if exist "%systemdrive%\Windows\Setup\xrsysnodhcp.txt" (
    for /f "tokens=3*" %%i in ('netsh interface show interface ^|findstr /I /R "本地.* 以太.* Local.* Ethernet" ^|findstr /I /R "已连接"') do (set EthName=%%j)
    for /f "tokens=1,2* delims==" %%i in (%systemdrive%\Windows\Setup\xrsysnodhcp.txt) do (set %%i=%%j)
    if defined EthName (
        if defined address if defined mask if defined gateway netsh -c interface ip set address name="!EthName!" source=static address=!address: =! mask=!mask: =! gateway=!gateway: =!
        if not defined dns1 set dns1=223.5.5.5& set dns2=119.29.29.29
        if defined dns set dns1=!dns!& set dns2=!dns!
        if defined dns1 netsh -c interface ip add dnsservers name="!EthName!" address=!dns1: =! index=1 validate=no
        if defined dns2 netsh -c interface ip add dnsservers name="!EthName!" address=!dns2: =! index=2 validate=no
    )
)
endlocal


:configurefirewall
if exist "%systemdrive%\Windows\Setup\xrsysfirewall.txt" (
    netsh advfirewall set currentprofile state on
    netsh firewall set opmode mode=enable
    netsh advfirewall set privateprofile state on
    netsh firewall set opmode mode=enable profile=ALL
    netsh advfirewall set allprofiles state on
    netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound
    netsh advfirewall set allprofiles settings inboundusernotification enable
    netsh advfirewall set allprofiles settings unicastresponsetomulticast enable
    @rem netsh advfirewall set allprofiles logging filename %SystemRoot%\System32\LogFiles\Firewall\pfirewall.log
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "DisableNotifications" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "DisableNotifications" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "EnableFirewall" /t reg_dword /d 1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "DisableNotifications" /t reg_dword /d 0
) else (
    netsh advfirewall set currentprofile state off
    netsh firewall set opmode mode=disable
    netsh advfirewall set privateprofile state off
    netsh firewall set opmode mode=disable profile=ALL
    netsh advfirewall set allprofiles state disable
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /f /v "EnableFirewall" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /f /v "EnableFirewall" /t reg_dword /d 0
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /f /v "EnableFirewall" /t reg_dword /d 0
)

:configurerdp
set rdpport=3389
if exist "%systemdrive%\Windows\Setup\xrsysrdp.txt" (
    set /p rdpportnew=<"%SystemDrive%\Windows\Setup\xrsysrdp.txt"
    if not "!rdpportnew: =!"=="" if !rdpportnew! GEQ 2 if !rdpportnew! LEQ 65535 set rdpport=!rdpportnew!
    netsh firewall set portopening protocol=ALL port=!rdpport: =! name=RDP mode=ENABLE scope=ALL profile=ALL
    netsh firewall set portopening protocol=ALL port=!rdpport: =! name=RDP mode=ENABLE scope=ALL profile=CURRENT
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v PortNumber /t reg_dword /d !rdpport: =! /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t reg_dword /d !rdpport: =! /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t reg_dword /d 0 /f
    FOR /F "tokens=2 delims=:" %%i in ('SC QUERYEX TermService ^|FINDSTR /I "PID"') do TASKKILL /F /PID %%i
    FOR /F "tokens=2 delims=:" %%i in ('SC QUERYEX UmRdpService ^|FINDSTR /I "PID"') do TASKKILL /F /PID %%i
    SC START TermService
)

:startwtdr
@rem echo [OSC]正在应用系统优化组件...>"%systemdrive%\Windows\Setup\wallname.txt"
@rem if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
@rem     start /wait WTDR.Pack64.exe /ApplyConfig /Desktop
@rem ) else (
@rem     start /wait WTDR.Pack32.exe /ApplyConfig /Desktop
@rem )

:oscapis
if exist "%SystemDrive%\Windows\Setup\zjsoftxrsoftno.txt" (
    del /f /q "%systemdrive%\Windows\Setup\Set\osc\xrsoft.exe"
)
if exist "%SystemDrive%\Windows\Setup\zjsoftforcepure.txt" (
    del /f /q "%systemdrive%\Windows\Setup\Set\osc\xrsoft.exe"
)
if exist "%systemdrive%\Windows\Setup\Set\osc\xrsoft.exe" (
    start "" "%systemdrive%\Windows\Setup\Set\osc\xrsoft.exe" /S
)
if exist "%SystemDrive%\Windows\Setup\Set\osc\Office\Office_*.iso" (
    echo [OSC]正在应用OfficeISO...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /min /wait cmd /c "%SystemDrive%\Windows\Setup\Set\osc\Office\MSOInst.bat"
)
if exist "%SystemDrive%\Windows\Setup\Run\1\api1.bat" (
    echo [OSC]正在应用DIY接口api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /max /wait "%SystemDrive%\Windows\Setup\Run\1\api1.bat"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.exe) do (
    echo [OSC]正在安装%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /S
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.msi) do (
    echo [OSC]正在安装%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /passive /qb-! /norestart
    del /f /q "%%b"
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.reg) do (
    echo [OSC]正在应用%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%b"
    del /f /q "%%b"
)
if exist "%SystemDrive%\Windows\Setup\xrsyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\Xiaoran\OSC\api1.bat" (
            echo [OSC]正在应用搜到的DIY接口%%a:\~\api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            echo y | start "" /max /wait "%%a:\Xiaoran\OSC\api1.bat"
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.exe) do (
            echo [OSC]正在运行搜到的%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.msi) do (
            echo [OSC]正在安装搜到的%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.reg) do (
            echo [OSC]正在应用搜到的%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)

:xrkms
if exist "xrkms\xrkms.bat" (
    echo [OSC]正在智能激活系统（可能需要3min）>"%systemdrive%\Windows\Setup\wallname.txt"
    timeout /t 3
    echo y | start "" /wait "xrkms\xrkms.bat"
)

:runtime
if exist "runtime\runtime.bat" echo y | start "" /wait /min "runtime\runtime.bat"


:osconline
echo [OSC]正在应用OSConline（可能需要15分钟, 请保持网络通畅）>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "online.bat" echo y | start "" /wait /min "online.bat"

:afterlife
echo [OSC]正在处理后续事项...>"%systemdrive%\Windows\Setup\wallname.txt"
if %osver% EQU 2 (
    echo win7系统WU服务处理
    echo yes>"%systemdrive%\Windows\Setup\xrsysnowu.txt"
)
if %osver% EQU 3 (
    echo Win8启用UAC
    echo yes>"%systemdrive%\Windows\Setup\xrsysuac.txt"
    echo win8系统WU服务处理
    echo yes>"%systemdrive%\Windows\Setup\xrsysnowu.txt"
)

if %osver% EQU 4 (
    echo win10+系统WU服务处理
    echo yes>"%systemdrive%\Windows\Setup\xrsyswu.txt"
)

:disablewu
if exist "%systemdrive%\Windows\Setup\xrsyswu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /E
) else if exist "%systemdrive%\Windows\Setup\xrsysfkwu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D /P
) else if exist "%systemdrive%\Windows\Setup\xrsysnowu.txt" (
    start "" /wait /min "%~dp0apifiles\Wub.exe" /D
)

:endosc
cd /d "%~dp0"
echo successful>"%SystemDrive%\Windows\Setup\oscstate.txt"
echo successfuldel>"%SystemDrive%\Windows\Setup\oscstate.txt"
if not exist "%SystemDrive%\Windows\Setup\Set\api.exe" (
    echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
    shutdown /r /t 5 /c "系统部署完成，重启后生效（OSC）"
)
if exist selfdel.bat start /wait /min selfdel.bat
:endoff
exit