@echo off
chcp 936 > nul
cd /d "%~dp0"
setlocal enabledelayedexpansion
set ver=�������漤��� V3.25.5.23
title %ver%������رմ˴��ڣ�
if exist "%systemdrive%\Windows\Setup\xrsysnokms.txt" exit
if exist "%SystemDrive%\wandrv\wall.exe" exit
if exist wbox.exe set wbox="%~dp0wbox.exe"

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

:: KMS�����������Ի�����
set serverlist=kms.03k.org kms.000606.xyz kms.ghpym.com kms.lotro.cc kms.sixyin.com kms.loli.best

:: Windows����
set iswindows=1
set iswts=1
set iskms=1
set isoem=0
set isdigital=0
set iskms38=0
set isentg=0

:: Office����
set isoffice=0
set isnewoffice=0
set isots=1
set isohk=0
set officepath=

echo ���ڼ�Ⲣ���ü����...
echo ���ڼ�Ⲣ���ü����... >>"%systemdrive%\Windows\Setup\xrkmsini.log"

call :isWinActivated
if %errorlevel% EQU 0 set iswindows=0

if %osver% EQU 2 set iskms=0
if %osver% EQU 2 set isoem=1
rem Windows 7�ϰ�װ��Office��OSPP�ӹܣ������� TSForge
if %osver% EQU 2 set isots=0
if %osver% EQU 2 (
    systeminfo>>osinfo.txt
    type osinfo.txt | find /i "Windows 7 ��ҵ��" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 רҵ��" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Enterprise" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Professional" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Server 2008" && (set iskms=1& set isoem=0)
    bcdedit /enum {current} | find /i "path" | find /i ".efi" && set isoem=0
)

if exist "%systemdrive%\Windows\Setup\xrsysentg.txt" set isentg=1

if "%isentg%"=="1" call :convertWinEntG
call :checkMSOState

goto ping

:ping
set server=
if not exist vlmcs.exe goto offline
cls
title %ver% - ������ԣ�����رմ˴��ڣ�
echo ���ڲ������ĵ����Ƿ��ܹ����ӵ�Internet...
ping www.baidu.com -n 1 >nul
if %errorlevel% NEQ 0 (
    echo ���ĵ��Բ��ܹ����ӵ�Internet������Ϊ�����ؼ���
    echo ���ĵ��Բ��ܹ����ӵ�Internet������Ϊ�����ؼ��� >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    goto offline
)
echo ���ĵ����ܹ����ӵ�Internet������Ϊ�����߼���
for %%s in (%serverlist%) do (
    echo ���ڲ������ĵ����Ƿ����뼤�������%%s����...
    vlmcs.exe -l 1 %%s 2>nul | find /i "successful" 1>nul 2>nul && (
        echo ���ĵ������뼤�������%%s���ӣ�����Ϊ�����߼���
        set server=%%s
        goto online
    )
    echo ���ĵ��Բ����뼤�������%%s���ӣ�������һ��������...
)
echo ���ĵ��Բ����뼤����������ӣ�����Ϊ�����ؼ���
echo ���ĵ��Բ����뼤����������ӣ�����Ϊ�����ؼ��� >>"%systemdrive%\Windows\Setup\xrkmsini.log"
goto offline

:offline
cls
title %ver% - ���߼������رմ˴��ڣ�
echo �������߼���ϵͳ�����Ժ�...
>Set.ini echo [Smart]
>>Set.ini echo HWID=0
>>Set.ini echo OHook=0
call :runHEU /smart
goto exit

:online
cls
title %ver% - ���߼������رմ˴��ڣ�
echo �������߼���ϵͳ�����Ժ�...
call :runKVA
call :isWinActivated
if %errorlevel% EQU 0 goto exit
echo ���ڽ�һ������ϵͳ�����Ժ�...
>Set.ini echo [Smart]
>>Set.ini echo OHook=0
>>Set.ini echo OfficeTSForge=0
>>Set.ini echo OfficeKMS=0
call :runHEU /smart
goto exit

:exit
cd /d "%~dp0"
for %%a in (HEU*_Debug.txt) DO type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
for %%a in (*_Silent.log) DO type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
for %%a in (%TEMP%\HEU*_Debug.txt) DO (
    type "%%a" >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    del /f /q "%%a"
)
set >>"%systemdrive%\Windows\Setup\xrkmsini.log"
cls
echo ������ϣ������δ�����ʹ�����桰���ù��ߡ��ڵļ���߼��
timeout -t 5 >nul 2>nul || ping 127.0.0.1 -n 5 >nul
exit

:runKVA
echo ����֧�֣�KMS_VL_ALL_AIO by abbodi1406
echo ��������%server%
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -hide -wait -timeout:120000 KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
) else (
    start /wait /min cmd /c KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
)
goto :eof

:runHEU <*param>
echo ����֧�֣�HEU KMS Activator by ֪�˶�֪��
echo ִ�в�����%*
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -wait -timeout:120000 kms.exe %*
) else (
    start /wait kms.exe %*
)
goto :eof

:convertWinEntG
if %osver% LEQ 3 goto :eof
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
set iswindows=1
goto :eof

:isWinActivated -> errorlevel EQU 0 ? true : false
:: XP ������ Windows
if %osver% EQU 1 (
    set errorlevel=0
    goto :eof
)
echo ���ڼ��Windows����״̬...
cscript.exe //nologo "%SystemDrive%\Windows\System32\slmgr.vbs" /xpr | find "    Windows "
if %errorlevel% EQU 0 (
    echo Windowsδ����
    set errorlevel=1
) else (
    echo Windows�Ѽ���
    set errorlevel=0
)
goto :eof

:isMSOActivated -> errorlevel EQU 0 ? true : false
if not defined officepath (
    set errorlevel=0
    goto :eof
)
echo ���ڼ��Office����״̬...
cscript.exe //nologo "%officepath%\OSPP.VBS" /dstatus | find /i "LICENSE STATUS:  ---LICENSED---"
if %errorlevel% EQU 0 (
    echo Officeδ����
    set errorlevel=1
) else (
    echo Office�Ѽ���
    set errorlevel=0
)
goto :eof

:checkMSOState
echo ���ڻ�ȡ��ǰ��Office�汾...
echo ���ڻ�ȡ��ǰ��Office�汾... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
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
    rem Office 2010��OSPP�ӹܣ������� TSForge
    set isots=0
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
if defined officepath echo Office·����%officepath%>>"%systemdrive%\Windows\Setup\xrkmsini.log"
call :isMSOActivated
if %errorlevel% EQU 0 set isoffice=0
goto :eof
