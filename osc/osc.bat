chcp 936 > nul
setlocal EnableDelayedExpansion
@echo off
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
rem ϵͳ�汾�ж�
set osver=0&& set osname=Win
ver | find /i "5.1." > nul && set osver=1&& set osname=WinXP
ver | find /i "6.0." > nul && set osver=2&& set osname=Vista
ver | find /i "6.1." > nul && set osver=2&& set osname=Win7
ver | find /i "6.2." > nul && set osver=3&& set osname=Win8
ver | find /i "6.3." > nul && set osver=3&& set osname=Win8.1
ver | find /i "6.4." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0." > nul && set osver=4&& set osname=Win10
ver | find /i "10.0.2" > nul && set osver=4&& set osname=Win11

rem ��������ļ���
mkdir "%SystemDrive%\Windows\Setup"
mkdir "%SystemDrive%\Windows\Setup\Run"
echo successful>"%SystemDrive%\Windows\Setup\oscrunstate.txt"

:oscapifiles
rem Ϊapi�ṩ�ļ�
if exist "%SystemDrive%\Windows\Setup\Set\needoscapifiles.txt" (
    mkdir ..\apifiles
    copy /y apifiles ..\apifiles
    del /f /q "%SystemDrive%\Windows\Setup\Set\needoscapifiles.txt"
    goto endoff
)

:checkenv_generalize
rem ����Ƿ��ڲ���׶�������
if exist "%SystemDrive%\Windows\Setup\State\State.ini" (
    find /i "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE" "%SystemDrive%\Windows\Setup\State\State.ini" && (
        echo ��֧���ڲ���׶�������
        goto endoff
    )
)

:checkenv_winpe
rem ����Ƿ���PEϵͳ������
if /i "%SystemDrive%"=="x:" if exist "X:\Windows\System32\PECMD.EXE" (
    echo ��֧����PEϵͳ������
    goto endoff
)

:mainprogram
rem ��Ȼϵͳ������ʾ
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /t REG_SZ /d "���棺����ϵͳ����û�в���������OSC��" /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /t REG_SZ /d "��ͨ�����������Ӳ��ȶ��������BUG���µģ����ڵ����ȷ������¼�˻��󣬷���http://url.xrgzs.top/osc���ء���������osc.exe���Խ��������ʾÿ�ε�¼ǰ����ǿ�Ƶ��������������������ϵQQ:2744460679�����" /f

rem �ӹ�winlogon
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v Shell /t REG_SZ /d "cmd.exe /c exit"
taskkill /f /im explorer.exe

rem ����runonce��ɾ�����ű�...
if %osver% GEQ 2 (
	copy /y runonce.bat "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup\"
)
if not exist "%SystemDrive%\Windows\Setup\Set\api.exe" (
    if exist apifiles\waller.exe (
        start "" "apifiles\waller.exe"
    )
)
taskkill /f /im explorer.exe

:copytags
rem �������TAG�ļ�
mkdir "%SystemDrive%\Windows\Setup\"
for %%a in (C D E F G H) do (
    move /y "%%a:\zjsoft*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\xrok*.txt" "%SystemDrive%\Windows\Setup"
    move /y "%%a:\xrsys*.txt" "%SystemDrive%\Windows\Setup"
)

:oscdrivers
echo ��Դѡ������
rem POWERCFG -HIBERNATE OFF
powercfg /h off
POWERCFG -CHANGE -monitor-timeout-ac 0
POWERCFG -CHANGE -monitor-timeout-dc 0
POWERCFG -CHANGE -standby-timeout-ac 0
POWERCFG -CHANGE -standby-timeout-dc 0
POWERCFG -CHANGE -hibernate-timeout-ac 0
POWERCFG -CHANGE -hibernate-timeout-dc 0
rem [��������Դ���ر�]
powercfg setactive SCHEME_BALANCED && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -monitor-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -monitor-timeout-ac 0
rem [���̵�Դ���ر�]
powercfg setactive SCHEME_BALANCED && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MAX && powercfg -x -disk-timeout-ac 0
powercfg setactive SCHEME_MIN && powercfg -x -disk-timeout-ac 0
rem ��װ����
if exist wandrv.iso (
    echo [OSC]����Ӧ����������wandrv.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv
    move /y "%~dp0wandrv.iso" "%~dp0wandrv\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv\DriveCleaner.exe" /wandrv
    echo wandrv.iso>>"%systemdrive%\Windows\Setup\xrsysdriverdebug.log"
)
if exist wandrv2.iso (
    echo [OSC]����Ӧ����������wandrv2.iso...>"%systemdrive%\Windows\Setup\wallname.txt"
    md wandrv2
    move /y "%~dp0wandrv2.iso" "%~dp0wandrv2\wandrv.iso"
    copy /y "%~dp0apifiles\DriveCleaner.exe" "%~dp0wandrv2\DriveCleaner.exe"
    start "" /wait "%~dp0wandrv2\DriveCleaner.exe" /wandrv
    echo wandrv2.iso>>"%systemdrive%\Windows\Setup\xrsysdriverdebug.log"
)


:optimize
if exist "optimize\start.bat" (
    echo [OSC]�����Ż�ϵͳ...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /wait /min "optimize\start.bat"
)
taskkill /f /im explorer.exe

:changepcname
echo �޸Ļ�����
if exist "%SystemDrive%\Windows\Setup\xrsysnopcname.txt" goto changepasswd
if exist "%SystemDrive%\Windows\Setup\xrsyspcname.txt" (
    set /p pcname=<"%SystemDrive%\Windows\Setup\xrsyspcname.txt"
)
echo %computername% | find /i "-PC" && goto changepasswd
echo %computername% | find /i "PC-" && goto changepasswd
if defined pcname set "pcname=%pcname: =%"
if "!pcname!"=="%computername%" goto changepasswd

echo �����ĸ������ĸ
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
rem ��ԭ���ݵ�WIFI����
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
    for /f "tokens=3*" %%i in ('netsh interface show interface ^|findstr /I /R "����.* ��̫.* Local.* Ethernet" ^|findstr /I /R "������"') do (set EthName=%%j)
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
@rem echo [OSC]����Ӧ��ϵͳ�Ż����...>"%systemdrive%\Windows\Setup\wallname.txt"
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
    echo [OSC]����Ӧ��OfficeISO...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /min /wait cmd /c "%SystemDrive%\Windows\Setup\Set\osc\Office\MSOInst.bat"
)
if exist "%SystemDrive%\Windows\Setup\Run\1\api1.bat" (
    echo [OSC]����Ӧ��DIY�ӿ�api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
    echo y | start "" /max /wait "%SystemDrive%\Windows\Setup\Run\1\api1.bat"
)
taskkill /f /im explorer.exe
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.exe) do (
    echo [OSC]���ڰ�װ%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /S
    del /f /q "%%b"
    taskkill /f /im explorer.exe
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.msi) do (
    echo [OSC]���ڰ�װ%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    start "" /wait "%%b" /passive /qb-! /norestart
    del /f /q "%%b"
    taskkill /f /im explorer.exe
)
for %%b in (%SystemDrive%\Windows\Setup\Run\1\*.reg) do (
    echo [OSC]����Ӧ��%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
    regedit /s "%%b"
    del /f /q "%%b"
)
taskkill /f /im explorer.exe
if exist "%SystemDrive%\Windows\Setup\xrsyssearchapi.txt" (
    for %%a in (C D E F G H) do (
        if exist "%%a:\Xiaoran\OSC\api1.bat" (
            echo [OSC]����Ӧ���ѵ���DIY�ӿ�%%a:\~\api1.bat...>"%systemdrive%\Windows\Setup\wallname.txt"
            echo y | start "" /max /wait "%%a:\Xiaoran\OSC\api1.bat"
            taskkill /f /im explorer.exe
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.exe) do (
            echo [OSC]���������ѵ���%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /S
            del /f /q "%%b"
            taskkill /f /im explorer.exe
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.msi) do (
            echo [OSC]���ڰ�װ�ѵ���%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            start "" /wait "%%b" /passive /qb-! /norestart
            del /f /q "%%b"
            taskkill /f /im explorer.exe
        )
        for %%b in (%%a:\Xiaoran\OSC\1\*.reg) do (
            echo [OSC]����Ӧ���ѵ���%%b...>"%systemdrive%\Windows\Setup\wallname.txt"
            regedit /s "%%b"
            del /f /q "%%b"
        )
    )
)
taskkill /f /im explorer.exe

:xrkms
if exist "xrkms\xrkms.bat" (
    echo [OSC]�������ܼ���ϵͳ��������Ҫ3min��>"%systemdrive%\Windows\Setup\wallname.txt"
    timeout /t 3
    echo y | start "" /wait "xrkms\xrkms.bat"
)
taskkill /f /im explorer.exe

:runtime
if exist "runtime\runtime.bat" echo y | start "" /wait /min "runtime\runtime.bat"
taskkill /f /im explorer.exe

:themerec
echo [OSC]���ڻָ�ϵͳ����...>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "themerec\themerec.bat" echo y | start "" /wait /min "themerec\themerec.bat"
taskkill /f /im explorer.exe

:osconline
echo [OSC]����Ӧ��OSConline��������Ҫ15����, �뱣������ͨ����>"%systemdrive%\Windows\Setup\wallname.txt"
if exist "online.bat" echo y | start "" /wait /min "online.bat"
taskkill /f /im explorer.exe

:afterlife
echo [OSC]���ڴ�����������...>"%systemdrive%\Windows\Setup\wallname.txt"
if %osver% EQU 2 (
    echo win7ϵͳWU������
    echo yes>"%systemdrive%\Windows\Setup\xrsysnowu.txt"
)
if %osver% EQU 3 (
    echo Win8����UAC
    echo yes>"%systemdrive%\Windows\Setup\xrsysuac.txt"
    echo win8ϵͳWU������
    echo yes>"%systemdrive%\Windows\Setup\xrsysnowu.txt"
)

if %osver% EQU 4 (
    echo win10+ϵͳWU������
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
rem ȡ���ӹ�winlogon
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v Shell /t REG_SZ /d "explorer.exe"
rem start explorer.exe
taskkill /f /im explorer.exe
echo successfuldel>"%SystemDrive%\Windows\Setup\oscstate.txt"
if not exist "%SystemDrive%\Windows\Setup\Set\api.exe" (
    echo exit>"%systemdrive%\Windows\Setup\wallname.txt"
    taskkill /f /im waller.exe
    taskkill /f /im wall.exe
    shutdown /r /t 5 /c "ϵͳ������ɣ���������Ч��OSC��"
)
if exist selfdel.bat start /wait /min selfdel.bat
:endoff
exit