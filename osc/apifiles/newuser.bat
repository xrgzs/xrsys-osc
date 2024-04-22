@echo off
setlocal enabledelayedexpansion
chcp 936 > nul
cd /d "%~dp0"
title 创建用户 (Build 2024.4.23)
rem windows xp not create new user
ver | find /i "5.1." && exit
set name=User
set pcname=Admin-PC

:getxrsysadmintag
rem for xrsys preload admin api
if exist "%SystemDrive%\Windows\Setup\xrsysadmin.txt" ( 
    set name=Administrator
    del /f /q "%SystemDrive%\Windows\Setup\xrsysnewuser.txt"
)

:getxrsysnewusertag
rem for xrsys preload newuser api
if exist "%SystemDrive%\Windows\Setup\xrsysnewuser.txt" ( 
    set /P name=<"%SystemDrive%\Windows\Setup\xrsysnewuser.txt"
    del /f /q "%SystemDrive%\Windows\Setup\xrsysadmin.txt"
)

:getpcname
rem 生成四个随机字母
set str=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for /l %%a in (1 1 4) do (
    set /a n=!random!%%26
    call set random_letters=%%str:~!n!,1%%!random_letters!
)

rem preset pcname
if exist "%SystemDrive%\Windows\Setup\xrsyspcname.txt" (
    set /p pcname=<"%SystemDrive%\Windows\Setup\xrsyspcname.txt"
) else (
    set pcname=PC-%date:~0,4%%date:~5,2%%date:~8,2%%random_letters%
)

:getspoem
rem support oem special
if exist "%SystemDrive%\Windows\Setup\zjsoftseewo.txt" (
    set name=seewo
    set pcname=seewo-PC
    goto findok
) else if exist "%SystemDrive%\Windows\Setup\zjsofthite.txt" (
    set name=HiteVision
    set pcname=HiteVision-PC
    goto findok
) else if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" (
    set name=Admin
    set pcname=Admin-PC
    goto findok
)

:getdmi
rem use dmi get motherboard info
if exist DMI.exe (
    DMI.exe>DMI.txt
    copy /y DMI.txt "%SystemDrive%\Windows\Setup\DMI.txt"
)
if not exist DMI.txt (
    set name=User
    goto findok
)

:findbios
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"BIOS Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set biospinpai=%%b
	goto findxitong
)
:findxitong
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"System Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set xitongpinpai=%%b
	goto findzhuban
)

:findzhuban
rem get line number
FOR /F "tokens=1 delims=:" %%a IN ('findstr /i /n /c:"Base Board Information" DMI.txt') DO set l=%%a
rem get pinpai with first blank (need optimize)
FOR /F "skip=%l% tokens=1,2 delims=:" %%a IN (DMI.txt) DO (
	set zhubanpinpai=%%b
	goto matchoem
)

:matchoem
rem delete blank
set "pinpai=%zhubanpinpai: =% %xitongpinpai: =% %biospinpai: =%"
rem debugpinpai in dmi.txt
>>DMI.txt echo debug:%pinpai%
rem match pinpai
if "%pinpai%"=="" set name=User&& goto findok
echo %pinpai% | find /i "vmware" && set name=VMware&& goto findok
echo %pinpai% | find /i "lenovo" && set name=Lenovo&& goto findok
echo %pinpai% | find /i "Think" && set name=Think&& goto findok
echo %pinpai% | find /i "dell" && set name=Dell&& goto findok
echo %pinpai% | find /i "Alienware" && set name=Alienware&& goto findok
echo %pinpai% | find /i "HP" && set name=HP&& goto findok
echo %pinpai% | find /i "Hewlett-Packard" && set name=HP&& goto findok
echo %pinpai% | find /i "Apple" && set name=Apple&& goto findok
echo %pinpai% | find /i "acer" && set name=Acer&& goto findok
echo %pinpai% | find /i "Surface" && set name=Surface&& goto findok
echo %pinpai% | find /i "HUAWEI" && set name=Huawei&& goto findok
echo %pinpai% | find /i "honor" && set name=Honor&& goto findok
echo %pinpai% | find /i "xiaomi" && set name=Xiaomi&& goto findok
echo %pinpai% | find /i "redmi" && set name=Redmi&& goto findok
echo %pinpai% | find /i "MACHENIKE" && set name=Machenike&& goto findok
echo %pinpai% | find /i "ThundeRobot" && set name=ThundeRobot&& goto findok
echo %pinpai% | find /i "HASEE" && set name=Hasee&& goto findok
echo %pinpai% | find /i "ASUS" && set name=ASUS&& goto findok
echo %pinpai% | find /i "ROG" && set name=ROG&& goto findok
echo %pinpai% | find /i "ASRock" && set name=ASRock&& goto findok
echo %pinpai% | find /i "GIGABYTE" && set name=Gigabyte&& goto findok
echo %pinpai% | find /i "msi" && set name=Msi&& goto findok
echo %pinpai% | find /i "BIOSTAR" && set name=Biostar&& goto findok
echo %pinpai% | find /i "Soyo" && set name=Soyo&& goto findok
echo %pinpai% | find /i "Colorful" && set name=Colorful&& goto findok
echo %pinpai% | find /i "MAXSUN" && set name=Maxsun&& goto findok
echo %pinpai% | find /i "ONDA" && set name=Onda&& goto findok
echo %pinpai% | find /i "AZW" && set name=Beelink&& goto findok
echo %pinpai% | find /i "FUJITSU" && set name=Fujitsu&& goto findok
echo %pinpai% | find /i "Samsung" && set name=SAMSUNG&& goto findok
echo %pinpai% | find /i "seewo" && set name=seewo&& goto findok
echo %pinpai% | find /i "HiteVision" && set name=HiteVision&& goto findok
echo %pinpai% | find /i "WenXiang" && set name=WXKJ&& goto findok
set name=User
goto findok
:findok

:oobe
if exist "%systemdrive%\Windows\System32\osk.exe" start osk.exe
rem ask pcname
if not exist "%SystemDrive%\Windows\Setup\xrsyspcname.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - 机器名设置" "$input" "请输入您要设置的机器名：^^ - 机器名请勿包含中文/空格；^^ - 目前没有防呆机制，输错后果自负 ^^ - 15s内未做出反应则保持默认" "%pcname%" /screen /FS^=12 /length:24 /timeout^=15s') do set "pcnameinput=%%a"
rem ask user
if not exist "%SystemDrive%\Windows\Setup\xrsysnewuser.txt" if not exist "%SystemDrive%\Windows\Setup\xrsysadmin.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - 用户创建" "$input" "请输入您要创建的用户名：^^ - 用户名请勿包含中文/标点/空格；^^ - 目前没有防呆机制，输错会导致系统安装失败 ^^ - 15s内未做出反应则保持默认" "%name%" /screen /FS^=12 /length:24 /timeout^=15') do set "nameinput=%%a"
rem ask passwd
if not exist "%SystemDrive%\Windows\Setup\xrsyspasswd.txt" if exist Winput.exe for /f "tokens=1" %%a in ('Winput.exe "OOBE - 用户密码设置" "$input" "请输入您要设置的密码：^^ - 密码请勿包含中文/空格；^^ - 目前没有防呆机制，输错后果自负 ^^ - 15s内未做出反应则保持默认" "" /screen /FS^=12 /length:255 /timeout^=15s') do set "passinput=%%a"
taskkill /f /im osk.exe
rem write xrsyspasswd tag
if defined passinput >"%SystemDrive%\Windows\Setup\xrsyspasswd.txt" echo %passinput%
rem clear passwd var
set passinput=
rem delete blank
if defined nameinput set "name=%nameinput%"
if defined pcnameinput set "pcname=%pcnameinput%"
rem backup var
if defined name >"%SystemDrive%\Windows\Setup\xrsysnewuser.txt" echo %name%
if defined pcname >"%SystemDrive%\Windows\Setup\xrsyspcname.txt" echo %pcname%
rem detect rdp
if exist "%SystemDrive%\Windows\Setup\xrsysrdp.txt" if not exist "%SystemDrive%\Windows\Setup\xrsyspasswd.txt" echo 1 >"%SystemDrive%\Windows\Setup\xrsyspasswd.txt"
goto setname

:setname
rem check var
if not defined name set name=User
rem active admin
if not "%name%"=="Administrator" (
    NET USER Administrator /ACTIVE:NO
) else (
    NET USER Administrator /ACTIVE:yes
    echo isadmin >"%SystemDrive%\Windows\Setup\xrsysadmin.txt"
)
rem user group config
NET ACCOUNTS /MAXPWAGE:UNLIMITED
NET USERS %name% /ADD /ACTIVE:YES /EXPIRES:NEVER /PASSWORDCHG:YES /PASSWORDREQ:NO /LOGONPASSWORDCHG:NO 
NET USERS %name% /ADD 
NET USERS %name% /ACTIVE:YES
NET USERS %name% /EXPIRES:NEVER
NET USERS %name% /PASSWORDCHG:YES
NET USERS %name% /PASSWORDREQ:NO
NET USERS %name% /LOGONPASSWORDCHG:NO 
NET LOCALGROUP Administrators %name% /ADD
rem password no expiration
NET Accounts /MaxPwAge:Unlimited
NetUser.exe %name% /pwnexp:y

@REM 不生效，unattend会强制覆盖
@REM :setpcname
@REM if defined pcname set "pcname=%pcname: =%"
@REM wmic computersystem where "caption='%computername%'" call Rename name='%pcname%'
@REM reg add "HKCU\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Services\Eventlog" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /f /v "ComputerName" /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "NV Hostname" /t REG_SZ /d "%pcname%"
@REM reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /f /v "Hostname" /t REG_SZ /d "%pcname%"
@REM reg add "HKU\.DEFAULT\Software\Microsoft\Windows\ShellNoRoam" /f /ve /t REG_SZ /d "%pcname%"

endlocal
exit