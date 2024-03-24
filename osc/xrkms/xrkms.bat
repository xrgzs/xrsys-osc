@echo off
chcp 936 > nul
cd /d "%~dp0"
setlocal enabledelayedexpansion
set ver=�������漤��� V3.24.1.11
title %ver%������رմ˴��ڣ�
if exist "%systemdrive%\Windows\Setup\xrsysnokms.txt" exit
if exist "%SystemDrive%\wandrv\wall.exe" exit
if exist wbox.exe set wbox="%~dp0wbox.exe"
@rem if not exist "%SystemDrive%\WINDOWS\Setup\Set\api.exe" (
@rem     if exist "%SystemDrive%\WINDOWS\OSConfig\osc.exe" (
@rem         if exist "%SystemDrive%\wandrv\wall.exe" exit
@rem     ) else (
@rem         echo ��⵽��δ����Ȼϵͳ������������У����򼴽��˳�������
@rem         timeout -t 5 2>nul || ping 127.0.0.1 -n 5 >nul
@rem         exit
@rem     )
@rem )

:ask
cls
title %ver% - �Թ���Ȩ����ѯ�ʣ�����رմ˴��ڣ�
if defined wbox (
    %wbox% "�Թ���Ȩ����ѯ��" "�������ܼ���ϵͳ��^�������Ҫʹ���Թ�����Ȩ��^����10s������ѡ��" "���ܼ��� -$- ;ȡ������" /TM=15 /FS=12
    echo !errorlevel!
    if "!errorlevel!"=="2" exit
) else (
    echo ��������ϵͳ���������Ҫʹ���Թ�����Ȩ������5s�ڹص��˴��ڣ�
    timeout -t 5 2>nul || ping 127.0.0.1 -n 5 >nul
)

:main
mode con: cols=70 lines=5
cls
title %ver% - ���ڶ�ȡ����������رմ˴��ڣ�
::ϵͳ�汾�ж�
set osver=0
::����һ�пɸ���ϵͳ����ֶ���дϵͳ�汾����������ȫ��ע�͵�
ver | find /i "5.1." > nul && set osver=1 && set osname=WindowsXP
ver | find /i "6.0." > nul && set osver=2 && set osname=WindowsVista
ver | find /i "6.1." > nul && set osver=2 && set osname=Windows7
ver | find /i "6.2." > nul && set osver=3 && set osname=Windows8
ver | find /i "6.3." > nul && set osver=3 && set osname=Windows8.1
ver | find /i "6.4." > nul && set osver=4 && set osname=Windows10
ver | find /i "10.0." > nul && set osver=4 && set osname=Windows10
ver | find /i "10.0.2" > nul && set osver=4 && set osname=Windows11

set server=kms.03k.org
set server1=kms.000606.xyz
set server2=kms.ghpym.com
set server3=kms.lotro.cc
set server4=kms.sixyin.com
set server5=kms.loli.best

:: Windows����
set iswindows=1
set iskms=1
set isoem=0
set isdigital=0
set iskms38=0
set isentg=0

:: Office����
set isoffice=0
set isnewoffice=0

if %osver% EQU 1 set iswindows=0

if %osver% EQU 2 set iskms=0
if %osver% EQU 2 set isoem=1
if %osver% EQU 2 (
    systeminfo>>osinfo.txt
    type osinfo.txt | find /i "Windows 7 ��ҵ��" && set iskms=1& set isoem=0
    type osinfo.txt | find /i "Windows 7 רҵ��" && set iskms=1& set isoem=0
    type osinfo.txt | find /i "Windows 7 Enterprise" && set iskms=1& set isoem=0
    type osinfo.txt | find /i "Windows 7 Professional" && set iskms=1& set isoem=0
    type osinfo.txt | find /i "Server" && set iskms=1& set isoem=0
    bcdedit /enum {current} | find /i "path" | find /i ".efi" && set isoem=0
)

if exist "%systemdrive%\Windows\Setup\xrsysentg.txt" set isentg=1

if "%isentg%"=="1" call :windowsentg
call :checkmsostate

goto ping

:ping
if "%server%"=="" goto offline
if not exist vlmcs.exe goto offline
cls
title %ver% - ������ԣ�����رմ˴��ڣ�
echo ���ڲ������ĵ����Ƿ����뼤�������%server%����...
vlmcs.exe -l 1 %server% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server%���ӣ�����Ϊ�����߼���
    goto online
) || (
    echo ���ĵ��Բ����뼤�������%server%���ӣ�����Ϊ��������һ��������
    goto ping1
)

:ping1
cls
title %ver% - ������ԣ�����رմ˴��ڣ�
echo ���ڲ������ĵ����Ƿ��ܹ����ӵ�Internet...
ping www.baidu.com -n 1 >nul
if %errorlevel% EQU 0 (
    echo ���ĵ����ܹ����ӵ�Internet������Ϊ�����߼���
) else (
    echo ���ĵ��Բ��ܹ����ӵ�Internet������Ϊ�����ؼ���
    echo ���ĵ��Բ��ܹ����ӵ�Internet������Ϊ�����ؼ��� >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    goto offline
)
echo ���ڲ������ĵ����Ƿ����뼤�������%server1%����...
vlmcs.exe -l 1 %server1% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server1%���ӣ�����Ϊ�����߼���
    set server=%server1%
    goto online
)
echo ���ĵ��Բ����뼤�������%server1%���ӣ�����Ϊ��������һ��������
vlmcs.exe -l 1 %server2% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server2%���ӣ�����Ϊ�����߼���
    set server=%server2%
    goto online
)
echo ���ĵ��Բ����뼤�����%server2%�����ӣ�����Ϊ��������һ��������
vlmcs.exe -l 1 %server3% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server3%���ӣ�����Ϊ�����߼���
    set server=%server3%
    goto online
)
echo ���ĵ��Բ����뼤�����%server3%�����ӣ�����Ϊ��������һ��������
vlmcs.exe -l 1 %server4% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server4%���ӣ�����Ϊ�����߼���
    set server=%server4%
    goto online
)
echo ���ĵ��Բ����뼤�����%server5%�����ӣ�����Ϊ��������һ��������
vlmcs.exe -l 1 %server5% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo ���ĵ������뼤�������%server5%���ӣ�����Ϊ�����߼���
    set server=%server5%
    goto online
)
echo ���ĵ��Բ����뼤����������ӣ�����Ϊ�����ؼ���
echo ���ĵ��Բ����뼤����������ӣ�����Ϊ�����ؼ��� >>"%systemdrive%\Windows\Setup\xrkmsini.log"
goto offline

:offline
cls
title %ver% - ���߼������رմ˴��ڣ�
echo �������߼���ϵͳ�����Ժ�...
echo ����֧�֣�HEU KMS Activator by ֪�˶�֪��
@echo on
set heu=
if "%iswindows%"=="1" if "%iskms%"=="1" set heu=%heu% /kwi /ren
if "%iswindows%"=="1" if "%isoem%"=="1" set heu=%heu% /oem
if "%iswindows%"=="1" if "%isdigital%"=="1" set heu=%heu% /dig
if "%iswindows%"=="1" if "%iskms38%"=="1" set heu=%heu% /k38 /lok
if "%isoffice%"=="1" set heu=%heu% /kof /ren /r2v
if "%heu%"=="" goto exit
echo ִ�в�����%heu%
kms.exe %heu%
goto exit

:online
cls
title %ver% - ���߼������رմ˴��ڣ�
echo �������߼���ϵͳ�����Ժ�...
echo ����֧�֣�KMS_VL_ALL_AIO by abbodi1406
start /wait /min cmd /c KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
echo ���ڽ�һ������ϵͳ�����Ժ�...
if "%isoem%"=="1" call kms.exe /oem
if "%isdigital%"=="1" call kms.exe /dig
goto exit

:exit
cd /d "%~dp0"
for %%a in (HEU*_Debug.txt) DO (
    type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
)
for %%a in (*_Silent.log) DO (
    type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
)
for %%a in (%TEMP%\HEU*_Debug.txt) DO (
    type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    del /f /q "%%a"
)
set >>"%systemdrive%\Windows\Setup\xrkmsini.log"
cls
echo ������ϣ������δ�����ʹ�����桰���ù��ߡ��ڵļ���߼��
timeout -t 5 >nul 2>nul || ping 127.0.0.1 -n 5 >nul
exit

:windowsentg
if %osver% LEQ 3 goto windowsact
echo ���ڻ�ȡ��ǰ��Windows SKU...
echo ���ڻ�ȡ��ǰ��Windows SKU... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
for /F "tokens=3* delims=: " %%A in ('dism /english /online /Get-CurrentEdition ^| find /i "Current Edition :"') do set "WIN_SKU=%%A"
echo ��ǰ��Windows SKUΪ��%WIN_SKU%
echo ��ǰ��Windows SKUΪ��%WIN_SKU% >>"%systemdrive%\Windows\Setup\xrkmsini.log"
echo ���ڼ���Ƿ���Ҫת��...
echo ���ڼ���Ƿ���Ҫת��... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
if "%WIN_SKU%"=="EnterpriseG" (
    echo ��ǰ��Windows�Ѿ���EnterpriseG SKU������ת����
    echo ��ǰ��Windows�Ѿ���EnterpriseG SKU������ת���� >>"%systemdrive%\Windows\Setup\xrkmsini.log"
) else (
    cd /d "%~dp0"
    echo ���ڽ���SKUת��...
    echo ���ڽ���SKUת��... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    if not exist "%windir%\System32\spp\tokens\skus\EnterpriseG-Volume-GVLK-1-ul-rtm.xrm-ms" expand -r -F:* EnterpriseG.cab "%windir%\System32\spp\tokens\skus\\" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    cscript.exe //B %windir%\System32\slmgr.vbs /rilc >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v NoGenTicket /t REG_DWORD /d 1 /f 1>nul 2>nul
    cscript.exe //B %windir%\System32\slmgr.vbs /act-type 0 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    cscript.exe //B %windir%\System32\slmgr.vbs /ckhc >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    cscript.exe //B %windir%\System32\slmgr.vbs /ipk YYVX9-NTFWV-6MDM3-9PT4T-4M68B >>"%systemdrive%\Windows\Setup\xrkmsini.log"
)
goto :eof

:checkmsostate
if exist "%SystemDrive%\Program Files\Microsoft Office\Office16\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files\Microsoft Office\Office16"
    set isoffice=1
    set isnewoffice=1
) else if exist "%SystemDrive%\Program Files\Microsoft Office\Office15\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files\Microsoft Office\Office15"
    set isoffice=1
    set isnewoffice=1
) else if exist "%SystemDrive%\Program Files\Microsoft Office\Office14\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files\Microsoft Office\Office14"
    set isoffice=1
) else if exist "%SystemDrive%\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files (x86)\Microsoft Office\Office16"
    set isoffice=1
    set isnewoffice=1
) else if exist "%SystemDrive%\Program Files (x86)\Microsoft Office\Office15\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files (x86)\Microsoft Office\Office15"
    set isoffice=1
    set isnewoffice=1
) else if exist "%SystemDrive%\Program Files (x86)\Microsoft Office\Office14\OSPP.VBS" (
    set "officepath=%SystemDrive%\Program Files (x86)\Microsoft Office\Office14"
    set isoffice=1
) else (
    set isoffice=0
    set isnewoffice=0
)
echo officepath:%officepath%>>"%systemdrive%\Windows\Setup\xrkmsini.log"
goto :eof