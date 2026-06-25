chcp 936 > nul
REM ===========================================================
REM 文件说明: 软件安装后优化脚本
REM 作者: 狂犬主子
REM SPDX-License-Identifier: GPL-3.0-or-later
REM 版权所有 (C) 潇然工作室
REM 未经作者许可，不得删除或修改此文件中的版权和许可信息
REM ===========================================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"
call "%~dp0..\..\common\env.bat" OSC
echo [OSC]正在进行软件安装后优化...>"%SystemDrive%\Windows\Setup\wallname.txt"
echo 正在安装低配机器优化组件...
if not "%isxp%"=="yes" if not "%isoffline%"=="1" if "%zjsoftxrgzs%"=="yes" (
    if defined PSModulePath (
        for /f %%a in ('powershell "(Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB -le 4 -or (Get-WmiObject -Class Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum -le 2"') do (
            if "%%a"=="True" (
                @rem echo [OSCol]正在安装低配机器优化组件...>"%SystemDrive%\Windows\Setup\wallname.txt"
                @rem %XRSYS_OSC_ARIA2_CMD% -o "MemReductSetup.exe" "%XRSYS_OSC_LINK_BASE_URL%/memreduct"
                @rem if exist "MemReductSetup.exe" start "" /wait "MemReductSetup.exe" /S
                @rem %XRSYS_OSC_ARIA2_CMD% -o "ProlassoSetup.exe" "%XRSYS_OSC_LINK_BASE_URL%/processlasso"
                @rem if exist "ProlassoSetup.exe" start "" /wait "ProlassoSetup.exe" /S
                ver | find /i "10.0." > nul && (
                    echo [OSCol]正在对低配机器做界面调整...>"%SystemDrive%\Windows\Setup\wallname.txt"
                    echo 关闭透明效果...
                    reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /f /v EnableTransparency /t REG_DWORD /d 0
                    echo 关闭动画效果...
                    reg.exe add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000"
                    :: for win7 mouse shadow: reg.exe add "HKCU\Control Panel\Desktop" /f /v "UserPreferencesMask" /t REG_BINARY /d "9032038010000000"
                    reg.exe add "HKCU\Control Panel\Desktop\WindowMetrics" /f /v MinAnimate /t REG_SZ /d 0
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\DWM /v EnableAeroPeek /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarAnimations /t REG_DWORD /d 0 /f
                    reg.exe add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects /f /v VisualFXSetting /t REG_DWORD /d 0x2
                )
            )
        )
    )
)

echo [OSCol]软件安装完成，正在处理已安装软件...>"%SystemDrive%\Windows\Setup\wallname.txt"

echo 尝试卸载OneDrive
taskkill /f /im OneDrive.exe
taskkill /f /im OneDrive*.exe
for /d %%f in ("%localappdata%\Microsoft\OneDrive\*") do (if exist "%%f\OneDriveSetup.exe" "%%f\OneDriveSetup.exe" /uninstall)
echo 关闭OneDrive开机自启
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDrive /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v OneDriveSetup /f
del /f /q "%SystemDrive%\Windows\System32\Tasks\OneDrive*"
echo 干掉OneDrive资源菜单
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
for /f "tokens=*" %%a in ('reg query HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace /s /f onedrive ^| find /i "HKEY_CURRENT_USER"') do reg delete "%%a" /f
echo 删除OneDrive残留
if not exist "%USERPROFILE%\Appdata\Local\Microsoft\OneDrive\OneDrive.exe" (
    del /f /q "%AppData%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
    rem rd /s /q "%USERPROFILE%\OneDrive"
    rd /s /q "%LocalAppData%\Microsoft\OneDrive"
    rd /s /q "%ProgramData%\Microsoft OneDrive"
    rd /s /q "%SystemDrive%\OneDriveTemp"
    REG Delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
    REG Delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
)
echo 关闭驱动面板开机自启
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RTHDVCPL /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v HotKeysCmds /f
echo 关闭腾信开机自启
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
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v "wpsphotoautoasso" /f
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
if "%softver%"=="onlineno" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.bak"
    del /f /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Bookmarks.msbak"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\360Bookmarks"
    del /f /q "%LOCALAPPDATA%\360ChromeX\Chrome\User Data\Default\Bookmarks"
    del /f /q "%APPDATA%\360se6\User Data\Default\360Bookmarks"
    del /f /q "%APPDATA%\360se6\User Data\Default\Bookmarks"
)
echo 清理重复的浏览器图标
if exist "%PUBLIC%\Desktop\Microsoft Edge.lnk" (
    if exist "%USERPROFILE%\Desktop\Microsoft Edge.lnk" del /f /q "%USERPROFILE%\Desktop\Microsoft Edge.lnk"
) else if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" (
    copy /y "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" "%PUBLIC%\Desktop\Microsoft Edge.lnk"
)
if exist "%PUBLIC%\Desktop\Google Chrome.lnk" if exist "%USERPROFILE%\Desktop\Google Chrome.lnk" del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"

echo 删除盗版提示
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticetext /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v legalnoticecaption /f
reg delete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /f
reg delete HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /f

echo 输出TAG
if not exist "%SystemDrive%\Windows\Version.txt" >"%SystemDrive%\Windows\Version.txt" echo 手动运行
echo zjsoft%softver% by xrosc on %date% at %time% >>"%SystemDrive%\Windows\Version.txt"
if exist "%~dp0..\Version.txt" >>"%SystemDrive%\Windows\Version.txt" type "%~dp0..\Version.txt"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.exe"
del /f /s /q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs"

exit
