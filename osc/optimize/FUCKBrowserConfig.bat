@echo off
chcp 936 > nul
set ver=FUCK Browser Config by Xiaoran Studio V2.15 (Build 2025.4.19)
title %ver%
mode con:cols=64
@rem  lines=25
color 1f

:silentset
rem ↓↓↓↓↓↓↓↓↓↓请输入修改的主页↓↓↓↓↓↓↓↓↓↓
set homepage=http://www.baidu.com
rem ↑↑↑↑↑↑↑↑↑↑请输入修改的主页↑↑↑↑↑↑↑↑↑↑
rem ↓↓↓↓↓↓↓↓↓↓封装/静默请去掉注释↓↓↓↓↓↓↓↓↓↓
rem set slientmode=true
rem ↑↑↑↑↑↑↑↑↑↑封装/静默请去掉注释↑↑↑↑↑↑↑↑↑↑
rem ↓↓↓↓↓↓↓↓↓↓PE下运行请预先设置盘符↓↓↓↓↓↓↓↓↓↓
rem set SystemDrive=C:
rem ↑↑↑↑↑↑↑↑↑↑PE下运行请预先设置盘符↑↑↑↑↑↑↑↑↑↑
rem 可以直接通过/S参数静默运行！
if /i "%1"=="/s" (
    set slientmode=true
)

:main
if "%slientmode%"=="true" (
    set mode=2
    goto run
)

cls
echo.
echo %ver%
echo.
echo 注意：
echo 1.此脚本文件会删除所有浏览器的的配置文件（包括收藏夹）, 
echo   以达到清理流氓书签配置推广的效果。
echo 2.目前支持清除各种浏览器的配置、注册表、IE收藏等流氓推广。
echo 3.请确保你已经将收藏夹导出为html文件，以便之后恢复收藏夹。
echo 4.如果你没有执行过导出备份操作，运行此脚本后，你将会丢失数据。
echo 5.请完全退出安全软件（尤其是360、2345）及浏览器的相关进程，
echo   卸载2345安全组件，以免造成干扰。
echo 6.如需静默调用，请自行修改此脚本文件。
echo.
echo 清理模式：
echo 1.安全模式：仅删除浏览器的数据目录（不会破坏浏览器的本体程序, 
echo   适用于已经安装好浏览器后被篡改的情况）
echo 2.严厉模式(推荐)：所有与浏览器有关的目录及注册表都将清除
echo   （会强制卸载浏览器，适用于原镜像没有安装浏览器的情况，
echo     强迫症福利）
if "%pemode%"=="" echo 3.PE模式：手动设置系统盘符，适用于系统盘符不是默认变量的情况
echo   当前系统盘符为：%SystemDrive%
echo.
echo.
echo 请输入清理模式的序号，并按回车键确认：
set /p mode=
goto run

:peset
cls
echo.
echo 请输入系统盘符，并按回车键确认：（例如：C:）
set /p SystemDrive=
set pemode=1
set mode=2
goto run

:run
mode con:cols=64
cls
if "%mode%"=="1" (
    set clean="115chrome\User Data","360Chrome\Chrome\User Data","360Chrome\User Data","360ChromeX\Chrome\User Data","360ChromeX\User Data","360se6\User Data",360se5,360se,2345chrome,2345Explorer,"Apple Computer",Baidu\BaiduBrowser,DCBrowser,"Microsoft\Edge\User Data",hao123JuziBrowser,JuziBrowser,"Google\Chrome\User Data","Google\Chrome Dev\User Data","Google\Chrome SxS\User Data","Chrome\User Data","Google Chrome",liebao,liebao7,TaoBrowser,"Tencent\QQBrowser","TheWorld7\User Data","TheWorld6\User Data",UCBrowser,YYExplorer,Maxthon6,Maxthon5,Maxthon4,Maxthon3,Maxthon,Mozilla,"Opera Software",Shouxin,"SogouExplorer\User Data","Sogou\SogouExplorer\User Data","CentBrowser\User Data","User Data",secoresdk,"IQIYI Video","Qingniao Chrome\User Data","TSBrowser\User Data","ChromeCore\User Data",CEF,"BaiBeiBrowser\User Data","Chromium\User Data","Chromium\GbrowserData","Huawei\HuaweiBrowser\User Data","Lenovo\SLBrowser\User Data","Twinkstar\User Data","xbbrowser\User Data","极速浏览器\User Data","360gt\User Data"
    set "cleans=rd /s /q %clean%"
    set kill=false
    set bm=true
    set reg=false
    set hp=false
    goto delete
)
if "%mode%"=="2" (
    set clean=115chrome,360Chrome,360ChromeX,360se6,360se5,360se,2345chrome,2345Explorer,"Apple Computer",Baidu,DCBrowser,Microsoft\Edge,hao123JuziBrowser,JuziBrowser,google,"Google Chrome",Chrome,liebao,liebao7,TaoBrowser,"Tencent\QQBrowser",TheWorld7,TheWorld6,UCBrowser,YYExplorer,Maxthon6,Maxthon5,Maxthon4,Maxthon3,Maxthon,Mozilla,"Opera Software",Shouxin,SogouExplorer,Sogou,CentBrowser,"User Data",secoresdk,"IQIYI Video","Qingniao Chrome",TSBrowser,ChromeCore,CEF,"BaiBeiBrowser","Chromium","Huawei\HuaweiBrowser","Lenovo\SLBrowser","Twinkstar","xbbrowser","极速浏览器","360gt"
    set "cleans=rd /s /q %clean%"
    set kill=true
    set bm=true
    set reg=true
    set hp=true
    goto delete
)
if "%mode%"=="3" goto peset
if "%mode%"=="" exit

:delete
if "%pemode%"=="1" goto bm

:kill
if "%kill%"=="true" (
    TASKKILL /IM 360se.exe /F
    TASKKILL /IM 360cse.exe /F
    TASKKILL /IM 360Chrome.exe /F
    TASKKILL /IM 360ChromeX.exe /F
    TASKKILL /IM 360bdoctor.exe /F
    TASKKILL /IM sesvc.exe /F
    TASKKILL /IM 2345Explorer.exe /F
    TASKKILL /IM 2345SafeCenterSvc.exe /F
    TASKKILL /IM 2345SafeSvc.exe /F
    TASKKILL /IM msedge.exe /F
    TASKKILL /IM edge.exe /F
    TASKKILL /IM chrome.exe /F
    TASKKILL /IM QQBrowser.exe /F
    TASKKILL /IM QQBrowserFix.exe /F
    TASKKILL /IM QQBrowserLiveup.exe /F
    TASKKILL /IM DelayUpdate.exe /F
    TASKKILL /IM SougouExplorer.exe /F
    TASKKILL /IM DCBrowser.exe /F
    TASKKILL /IM DCBrowserSvr.exe /F
    TASKKILL /IM firefox.exe /F
    TASKKILL /IM iexplore.exe /F
)

:bm
if "%bm%"=="true" (
    echo Win7+系统清理
    for %%i in ("%USERPROFILE%\AppData\Local" "%USERPROFILE%\AppData\Roaming" "%LOCALAPPDATA%" "%APPDATA%" "%SystemDrive%\Users\Default\AppData\Local" "%SystemDrive%\Users\Default\AppData\Roaming" "%SystemDrive%\Users\Administrator\AppData\Local" "%SystemDrive%\Users\Administrator\AppData\Roaming") do (
        cd /d "%%~i"
        for %%a in (%clean%) do (
            if exist "%%~a" (
                echo 正在清理%%~a
                attrib -S -H "%%~a" /S /D
                rd /s /q "%%~a"
            )
        )
        for %%b in (360,Huawei,Lenovo,Tencent,Google,Sogou) do (dir /a /b %%b 2>nul|findstr .* >nul||rd /s /q %%b)
    )
    echo 清理IE浏览器收藏
    rd /s /q "%SystemDrive%\Users\Administrator\Favorites"
    rd /s /q "%SystemDrive%\Users\Public\Favorites"
    rd /s /q "%SystemDrive%\Users\Default\Favorites"
    rd /s /q "%USERPROFILE%\Favorites"
    rd /s /q "D:\Backup\Favorites"
    echo WinXP系统清理
    for %%i in ("%SystemDrive%\Documents and Settings\Administrator\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\Administrator\Application Data" "%SystemDrive%\Documents and Settings\All Users\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\All Users\Application Data" "%ALLUSERSPROFILE%\Local Settings\Application Data" "%ALLUSERSPROFILE%\Application Data" "%USERPROFILE%\Local Settings\Application Data" "%USERPROFILE%\Application Data" "%SystemDrive%\Documents and Settings\Default User\Local Settings\Application Data" "%SystemDrive%\Documents and Settings\Default User\Application Data") do (
        cd /d "%%~i"
        for %%a in (%clean%) do (
            if exist "%%~a" (
                echo 正在清理%%~a
                attrib -S -H "%%~a" /S /D
                rd /s /q "%%~a"
            )
        )
    )
)

:reg
echo 删除右键菜单百度搜索
REG DELETE "HKEY_CLASSES_ROOT\Directory\Background\shell\{E82A1BA7-3493-47e1-A673-9277E8695AFA}" /f
del /f /q "%SystemDrive%\Windows\Web\ico\b.ico"
echo 删除Edge由你的组织管理
REG DELETE HKCU\Software\Policies\Microsoft\Edge /f
REG DELETE HKLM\Software\Policies\Microsoft\Edge /f
REG DELETE HKCU\Software\Policies\Microsoft\EdgeUpdate /f
REG DELETE HKLM\Software\Policies\Microsoft\EdgeUpdate /f
for %%a in ("%SystemDrive%\Program Files","%SystemDrive%\Program Files (x86)") do (
    del /f /q "%%~a\Microsoft\Edge\Application\*preferences"
    del /f /q "%%~a\Microsoft\Edge Beta\Application\*preferences"
    del /f /q "%%~a\Microsoft\Edge Dev\Application\*preferences"
    del /f /q "%%~a\Google\Chrome\Application\*preferences"
    del /f /q "%%~a\Google\Chrome Dev\Application\*preferences"
)

if "%reg%"=="true" (
    echo 系统推广谷歌浏览器
    rd /s /q "%LOCALAPPDATA%\Google\Chromebin"
    rd /s /q "%LOCALAPPDATA%\Google Chrome\Chromebin"
    del /f /q "%USERPROFILE%\Desktop\谷歌浏览器.lnk"
    del /f /q "%PUBLIC%\Desktop\谷歌浏览器.lnk"
    if exist "%SystemDrive%\Program Files\Google Chrome\Chrome\App\version.dll" (
        rd /s /q "%SystemDrive%\Program Files\Google Chrome"
        del /f /q "%USERPROFILE%\Desktop\Google Chrome.lnk"
        del /f /q "%PUBLIC%\Desktop\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Google Chrome.lnk"
        del /f /q "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\chrome.lnk"
    )
    echo 清理注册表
    REG DELETE HKCU\Software\2345.com /f
    REG DELETE HKCU\Software\2345Explorer /f
    REG DELETE HKCU\Software\360 /f
    REG DELETE HKCU\Software\360Chrome /f
    REG DELETE HKCU\Software\360ChromeX /f
    REG DELETE HKCU\Software\360se5 /f
    REG DELETE HKCU\Software\360se6 /f
    REG DELETE HKCU\Software\2345Explorer /f
    REG DELETE HKCU\Software\Chromium /f
    REG DELETE HKCU\Software\Google\Chrome /f
    REG DELETE HKCU\Software\Mozilla /f
    REG DELETE HKCU\Software\Netscape /f
    REG DELETE HKCU\Software\Tencent\QQBrowser /f
    REG DELETE HKCU\Software\Microsoft\Edge /f
    REG DELETE HKCU\Software\PPStream /f
    REG DELETE HKLM\SOFTWARE\2345Explorer /f
    REG DELETE HKLM\SOFTWARE\HaoZip /f
    REG DELETE HKLM\SOFTWARE\Google\Chrome /f
    REG DELETE HKLM\SOFTWARE\Tencent\QQBrowser /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKLM\SOFTWARE\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Start Page" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Search" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\EUPP\DSP" /v "BackupDefaultSearchScope" /f
    REG DELETE "HKLM\SOFTWARE\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" /f
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\360ChromeX" /f
    REG DELETE "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\360Chrome" /f
)

:hp
if "%hp%"=="true" (
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /d "%homepage%" /f
    REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Start Page" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Search Page" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Search_URL" /d "%homepage%" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\MAIN" /v "Default_Page_URL" /d "%homepage%" /f
)

:exit
echo 清理完成，上面为程序执行的日志！
if "%slientmode%"=="true" (
    exit
)
pause
exit