@echo off
chcp 936 > nul
cd /d "%~dp0"
setlocal enabledelayedexpansion
set ver=智能正版激活工具 V3.24.5.25
title %ver%（请勿关闭此窗口）
if exist "%systemdrive%\Windows\Setup\xrsysnokms.txt" exit
if exist "%SystemDrive%\wandrv\wall.exe" exit
if exist wbox.exe set wbox="%~dp0wbox.exe"
@rem if not exist "%SystemDrive%\WINDOWS\Setup\Set\api.exe" (
@rem     if exist "%SystemDrive%\WINDOWS\OSConfig\osc.exe" (
@rem         if exist "%SystemDrive%\wandrv\wall.exe" exit
@rem     ) else (
@rem         echo 检测到您未在潇然系统部署过程中运行，程序即将退出！！！
@rem         timeout -t 5 2>nul || ping 127.0.0.1 -n 5 >nul
@rem         exit
@rem     )
@rem )

:ask
cls
title %ver% - 自购授权需求询问（请勿关闭此窗口）
if defined wbox (
    %wbox% "自购授权需求询问" "即将智能激活系统，^如果您需要使用自购的授权，^请在10s内做出选择！" "智能激活 -$- ;取消激活" /TM=15 /FS=12
    echo !errorlevel!
    if "!errorlevel!"=="2" exit
) else (
    echo 即将激活系统，如果您需要使用自购的授权，请在5s内关掉此窗口！
    timeout -t 5 2>nul || ping 127.0.0.1 -n 5 >nul
)

:main
mode con: cols=70 lines=5
cls
title %ver% - 正在读取参数（请勿关闭此窗口）
::系统版本判断
set osver=0
::上面一行可根据系统情况手动填写系统版本，并将下面全部注释掉
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

:: Windows激活
set iswindows=1
set iskms=1
set isoem=0
set isdigital=0
set iskms38=0
set isentg=0

:: Office激活
set isoffice=0
set isnewoffice=0

if %osver% EQU 1 set iswindows=0

if %osver% EQU 2 set iskms=0
if %osver% EQU 2 set isoem=1
if %osver% EQU 2 (
    systeminfo>>osinfo.txt
    type osinfo.txt | find /i "Windows 7 企业版" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 专业版" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Enterprise" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Professional" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Server 2008" && (set iskms=1& set isoem=0)
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
title %ver% - 网络测试（请勿关闭此窗口）
echo 正在测试您的电脑是否能与激活服务器%server%连接...
vlmcs.exe -l 1 %server% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server%连接，即将为您在线激活
    goto online
) || (
    echo 您的电脑不能与激活服务器%server%连接，即将为您尝试另一个服务器
    goto ping1
)

:ping1
cls
title %ver% - 网络测试（请勿关闭此窗口）
echo 正在测试您的电脑是否能够连接到Internet...
ping www.baidu.com -n 1 >nul
if %errorlevel% EQU 0 (
    echo 您的电脑能够连接到Internet，即将为您在线激活
) else (
    echo 您的电脑不能够连接到Internet，即将为您本地激活
    echo 您的电脑不能够连接到Internet，即将为您本地激活 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    goto offline
)
echo 正在测试您的电脑是否能与激活服务器%server1%连接...
vlmcs.exe -l 1 %server1% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server1%连接，即将为您在线激活
    set server=%server1%
    goto online
)
echo 您的电脑不能与激活服务器%server1%连接，即将为您尝试另一个服务器
vlmcs.exe -l 1 %server2% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server2%连接，即将为您在线激活
    set server=%server2%
    goto online
)
echo 您的电脑不能与激活服务%server2%器连接，即将为您尝试另一个服务器
vlmcs.exe -l 1 %server3% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server3%连接，即将为您在线激活
    set server=%server3%
    goto online
)
echo 您的电脑不能与激活服务%server3%器连接，即将为您尝试另一个服务器
vlmcs.exe -l 1 %server4% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server4%连接，即将为您在线激活
    set server=%server4%
    goto online
)
echo 您的电脑不能与激活服务%server5%器连接，即将为您尝试另一个服务器
vlmcs.exe -l 1 %server5% 2>nul | find /i "successful" 1>nul 2>nul && (
    echo 您的电脑能与激活服务器%server5%连接，即将为您在线激活
    set server=%server5%
    goto online
)
echo 您的电脑不能与激活服务器连接，即将为您本地激活
echo 您的电脑不能与激活服务器连接，即将为您本地激活 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
goto offline

:offline
cls
title %ver% - 离线激活（请勿关闭此窗口）
echo 正在离线激活系统，请稍候...
echo 技术支持：HEU KMS Activator by 知彼而知己
set heu=
if "%iswindows%"=="1" if "%iskms%"=="1" set heu=%heu% /kwi /ren
if "%iswindows%"=="1" if "%isoem%"=="1" set heu=%heu% /oem
if "%iswindows%"=="1" if "%isdigital%"=="1" set heu=%heu% /dig
if "%iswindows%"=="1" if "%iskms38%"=="1" set heu=%heu% /k38 /lok
if "%isoffice%"=="1" set heu=%heu% /kof /ren /r2v
if "%heu%"=="" goto exit
echo 执行参数：%heu%
kms.exe %heu%
goto exit

:online
cls
title %ver% - 在线激活（请勿关闭此窗口）
echo 正在在线激活系统，请稍候...
echo 技术支持：KMS_VL_ALL_AIO by abbodi1406
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -hide -wait -timeout:120000 KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
) else (
    start /wait /min cmd /c KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
)
echo 正在进一步激活系统，请稍候...
if "%isoem%"=="1" call kms.exe /oem
if "%isdigital%"=="1" call kms.exe /dig
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
echo 激活完毕，如果还未激活，请使用桌面“常用工具”内的激活工具激活！
timeout -t 5 >nul 2>nul || ping 127.0.0.1 -n 5 >nul
exit

:windowsentg
if %osver% LEQ 3 goto windowsact
echo 正在获取当前的Windows SKU...
echo 正在获取当前的Windows SKU... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
for /F "tokens=3* delims=: " %%A in ('dism /english /online /Get-CurrentEdition ^| find /i "Current Edition :"') do set "WIN_SKU=%%A"
echo 当前的Windows SKU为：%WIN_SKU%
echo 当前的Windows SKU为：%WIN_SKU% >>"%systemdrive%\Windows\Setup\xrkmsini.log"
echo 正在检查是否需要转换...
echo 正在检查是否需要转换... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
if "%WIN_SKU%"=="EnterpriseG" (
    echo 当前的Windows已经是EnterpriseG SKU，无需转换。
    echo 当前的Windows已经是EnterpriseG SKU，无需转换。 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
) else (
    cd /d "%~dp0"
    echo 正在进行SKU转换...
    echo 正在进行SKU转换... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
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
