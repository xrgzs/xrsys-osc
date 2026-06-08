chcp 936 > nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ==================== 最终电源偏好 ====================
echo [OSC]正在应用最终电源偏好...>"%SystemDrive%\Windows\Setup\wallname.txt"
set notebook=0
echo wxp-11判断是否为笔记本电脑
if exist "%SystemDrive%\Windows\System32\wbem\WMIC.exe" (
    for /f "tokens=2 delims={}" %%a in ('wmic PATH Win32_SystemEnclosure get ChassisTypes /value') do (
        if %%a GEQ 8 (
            for /f "tokens=2 delims==" %%b in ('wmic path Win32_Battery get BatteryStatus /value') do (
                if %%b GEQ 1 set notebook=1
            )
        )
    )
) else (
    if defined PSModulePath (
        for /f "tokens=*" %%a in ('PowerShell "(Get-WmiObject Win32_SystemEnclosure).ChassisTypes"') do (
            if %%a GEQ 8 (
                for /f "tokens=*" %%b in ('PowerShell "(Get-WmiObject Win32_Battery).BatteryStatus"') do (
                    if %%b GEQ 1 set notebook=1
                )
            )
        )
    )
)
@rem 防止意外将品牌机MoDT识别为笔记本
if exist "%SystemDrive%\Windows\Setup\zjsoftspoem.txt" set notebook=0

echo 切换到平衡电源计划
powercfg setactive SCHEME_BALANCED

if %notebook% GEQ 1 (
    echo 笔记本启用休眠
    powercfg /h on
    echo 笔记本禁用小键盘
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 0 /f
    echo 笔记本开启自动息屏
    POWERCFG /x monitor-timeout-dc 5
    POWERCFG /x standby-timeout-dc 30
    echo 笔记本开启快速启动
    reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f
) else (
    echo 台式机开启小键盘
    reg add "HKCU\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f
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

exit
