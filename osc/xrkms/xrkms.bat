@echo off
chcp 936 > nul
cd /d "%~dp0"
setlocal enabledelayedexpansion
set ver=智能正版激活工具 V3.25.11.13
title %ver%（请勿关闭此窗口）
if exist "%systemdrive%\Windows\Setup\xrsysnokms.txt" exit
if exist "%SystemDrive%\wandrv\wall.exe" exit
if exist wbox.exe set wbox="%~dp0wbox.exe"

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
ver | find /i "5.1." > nul && set osver=1
ver | find /i "6.0." > nul && set osver=2
ver | find /i "6.1." > nul && set osver=2
ver | find /i "6.2." > nul && set osver=3
ver | find /i "6.3." > nul && set osver=3
ver | find /i "6.4." > nul && set osver=4
ver | find /i "10.0." > nul && set osver=4

:: KMS服务器，来自互联网
set serverlist=kms.03k.org kms.000606.xyz kms.ghpym.com kms.lotro.cc kms.sixyin.com kms.loli.best

:: Windows激活
set iswindows=1
set iswtsesu=0
set iswts=1
set iskms=1
set isoem=0
set isdigital=0
set isentg=0

:: Office激活
set isoffice=0
set isnewoffice=0
set isots=1
set isohk=0
set officepath=

echo 正在检测并设置激活方案...
echo 正在检测并设置激活方案... >>"%systemdrive%\Windows\Setup\xrkmsini.log"

call :isWinActivated
if %errorlevel% EQU 0 set iswindows=0

if %osver% EQU 2 set iskms=0
if %osver% EQU 2 set isoem=1
rem Windows 7上安装的Office被OSPP接管，不适用 TSForge
if %osver% EQU 2 set isots=0
if %osver% EQU 2 (
    systeminfo>>osinfo.txt
    type osinfo.txt | find /i "Windows 7 企业版" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 专业版" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Enterprise" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Windows 7 Professional" && (set iskms=1& set isoem=0)
    type osinfo.txt | find /i "Server 2008" && (set iskms=1& set isoem=0)
    bcdedit /enum {current} | find /i "path" | find /i ".efi" && set isoem=0
)
if %osver% GEQ 4 (
    ver | find /i "10.0.14393" && set iswtsesu=1
    ver | find /i "10.0.17763" && set iswtsesu=1
    ver | find /i "10.0.1904" && set iswtsesu=1
)

if exist "%systemdrive%\Windows\Setup\xrsysentg.txt" set isentg=1

if "%isentg%"=="1" call :convertWinEntG
call :checkMSOState

goto ping

:ping
set server=
if not exist vlmcs.exe goto offline
cls
title %ver% - 网络测试（请勿关闭此窗口）
echo 正在测试您的电脑是否能够连接到Internet...
ping www.baidu.com -n 1 >nul
if %errorlevel% NEQ 0 (
    echo 您的电脑不能够连接到Internet，即将为您本地激活
    echo 您的电脑不能够连接到Internet，即将为您本地激活 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
    goto offline
)
echo 您的电脑能够连接到Internet，即将为您在线激活
for %%s in (%serverlist%) do (
    echo 正在测试您的电脑是否能与激活服务器%%s连接...
    vlmcs.exe -l 1 %%s 2>nul | find /i "successful" 1>nul 2>nul && (
        echo 您的电脑能与激活服务器%%s连接，即将为您在线激活
        set server=%%s
        goto online
    )
    echo 您的电脑不能与激活服务器%%s连接，尝试下一个服务器...
)
echo 您的电脑不能与激活服务器连接，即将为您本地激活
echo 您的电脑不能与激活服务器连接，即将为您本地激活 >>"%systemdrive%\Windows\Setup\xrkmsini.log"
goto offline

:offline
cls
title %ver% - 离线激活（请勿关闭此窗口）
echo 正在离线激活系统，请稍候...
>Set.ini echo [Smart]
>>Set.ini echo HWID=0
>>Set.ini echo OHook=0
call :runHEU /smart
goto afteract

:online
cls
title %ver% - 在线激活（请勿关闭此窗口）
echo 正在在线激活系统，请稍候...
call :runKVA
call :isWinActivated
if %errorlevel% EQU 0 goto afteract
echo 正在进一步激活系统，请稍候...
>Set.ini echo [Smart]
>>Set.ini echo OHook=0
>>Set.ini echo OfficeTSForge=0
>>Set.ini echo OfficeKMS=0
call :runHEU /smart
goto afteract

:afteract
cls
title %ver% - 后续处理（请勿关闭此窗口）
echo 正在进行后续处理，请稍候...
if "%iswtsesu%"=="1" (
   echo 正在激活 Windows ESU...
   call :runTS /Z-ESU
)
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

:runKVA
echo 技术支持：KMS_VL_ALL_AIO by abbodi1406
echo 服务器：%server%
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -hide -wait -timeout:120000 KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
) else (
    start /wait /min cmd /c KMS_VL_ALL_AIO.cmd /u /s /l /x /e %server%
)
goto :eof

:runHEU <*param>
echo 技术支持：HEU KMS Activator by 知彼而知己
echo 执行参数：%*
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -wait -timeout:120000 kms.exe %*
) else (
    start /wait kms.exe %*
)
goto :eof

:runTS
echo 技术支持：TSForge by Massgrave
echo 执行参数：%*
if defined pecmd (
    start "" /wait "%PECMD%" EXEC -hide -wait -timeout:120000 TSforge_Activation.cmd %*
) else (
    start /wait /min cmd /c TSforge_Activation.cmd %*
)
goto :eof

:convertWinEntG
if %osver% LEQ 3 goto :eof
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
set iswindows=1
goto :eof

:isWinActivated -> errorlevel EQU 0 ? true : false
:: XP 不激活 Windows
if %osver% EQU 1 (
    set errorlevel=0
    goto :eof
)
echo 正在检测Windows激活状态...
set errorlevel=
cscript.exe //nologo "%SystemDrive%\Windows\System32\slmgr.vbs" /xpr | find "    Windows "
if %errorlevel% EQU 0 (
    echo Windows未激活
    set errorlevel=1
) else (
    echo Windows已激活
    set errorlevel=0
)
goto :eof

:isMSOActivated -> errorlevel EQU 0 ? true : false
if not defined officepath (
    set errorlevel=0
    goto :eof
)
echo 正在检测Office激活状态...
cscript.exe //nologo "%officepath%\OSPP.VBS" /dstatus | find /i "LICENSE STATUS:  ---LICENSED---"
if %errorlevel% EQU 0 (
    echo Office未激活
    set errorlevel=1
) else (
    echo Office已激活
    set errorlevel=0
)
goto :eof

:checkMSOState
echo 正在获取当前的Office版本...
echo 正在获取当前的Office版本... >>"%systemdrive%\Windows\Setup\xrkmsini.log"
if exist "%SystemDrive%\Program Files\Microsoft Office\root\Office16\OSPP.VBS" (
    rem 新版 ospp 已改为 root 目录
    set "officepath=%SystemDrive%\Program Files\Microsoft Office\root\Office16"
    set isoffice=1
    set isnewoffice=1
) else if exist "%SystemDrive%\Program Files\Microsoft Office\Office16\OSPP.VBS" (
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
    rem Office 2010被OSPP接管，不适用 TSForge
    set isots=0
) else if exist "%SystemDrive%\Program Files (x86)\Microsoft Office\root\Office16\OSPP.VBS" (
    rem 新版 ospp 已改为 root 目录
    set "officepath=%SystemDrive%\Program Files (x86)\Microsoft Office\root\Office16"
    set isoffice=1
    set isnewoffice=1
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
if defined officepath echo Office路径：%officepath%>>"%systemdrive%\Windows\Setup\xrkmsini.log"
call :isMSOActivated
if %errorlevel% EQU 0 set isoffice=0
goto :eof
