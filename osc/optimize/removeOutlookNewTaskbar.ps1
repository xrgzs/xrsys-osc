# ===========================================================
# 文件说明: 移除 Outlook 任务栏图标脚本
# 作者: 狂犬主子
# SPDX-License-Identifier: GPL-3.0-or-later
# 版权所有 (C) 潇然工作室
# 未经作者许可，不得删除或修改此文件中的版权和许可信息
# ===========================================================
param(
    [string]$StartsWith = "Outlook",
    [int]$TimeoutSeconds = 5
)

# ===============================================
# 本地化字符串（提前加载 DllCaller）
# ===============================================

try {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class DllCaller {
    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    internal static extern int LoadString(
        IntPtr hInstance,
        uint uID,
        StringBuilder lpBuffer,
        int nBufferMax
    );

    public static string GetString(uint strId)
    {
        IntPtr intPtr = GetModuleHandle("shell32.dll");
        StringBuilder sb = new StringBuilder(255);
        LoadString(intPtr, strId, sb, sb.Capacity);
        return sb.ToString();
    }
}
"@
}
catch {}

# 5387 = "Unpin from taskbar"
# 系统返回 "从任务栏取消固定(&K)"，去掉 (&X) 后缀以匹配实际菜单项
$rawUnpin = [DllCaller]::GetString(5387)
$script:UnpinLocalizedString = [regex]::Replace($rawUnpin, '\s*\(&?\w+\)$', '')
Write-Host "[Init] Unpin raw    => $rawUnpin"
Write-Host "[Init] Unpin clean  => $script:UnpinLocalizedString"

# ===============================================
# Common
# ===============================================

function Wait-Until {
    param(
        [scriptblock]$Condition,
        [int]$TimeoutSeconds = 5,
        [int]$IntervalMs = 100
    )

    $deadline = [DateTime]::Now.AddSeconds($TimeoutSeconds)

    while ([DateTime]::Now -lt $deadline) {

        try {
            $result = & $Condition

            if ($result) {
                return $result
            }
        }
        catch {}

        Start-Sleep -Milliseconds $IntervalMs
    }

    return $null
}

# ===============================================
# Try COM Method
# ===============================================

function Invoke-UnpinTaskbarCOM {
    param(
        [string]$StartsWith
    )

    Write-Host "[COM] Trying Shell.Application..."

    $items = (
        New-Object -ComObject Shell.Application
    ).NameSpace(
        "shell:::{4234d49b-0245-4df3-b780-3893943456e1}"
    ).Items()

    foreach ($item in $items) {

        if ($item.Name -notlike "$StartsWith*") {
            continue
        }

        Write-Host "[COM] Found => $($item.Name)"

        foreach ($verb in $item.Verbs()) {

            # 去掉 & 快捷键标记和 (&X) / (X) 后缀
            $verbName = $verb.Name.Replace("&", "").Trim()
            $verbName = [regex]::Replace($verbName, '\s*\(\w+\)$', '')

            Write-Host "[COM] Verb => $verbName"

            if ($verbName -eq $script:UnpinLocalizedString) {

                Write-Host "[COM] Invoke verb"

                $verb.DoIt()

                return $true
            }
        }
    }

    return $false
}

# ===============================================
# PECMD Wall.wcs Window Helper
# ===============================================

function Suspend-PECMDWindow {
    <#
    .SYNOPSIS
        找到潇然部署背景 PECMD 窗口，取消置顶并尝试最小化，
        确保任务栏可交互。
        注意：最小化只是附加优化，核心保障是取消置顶 + 焦点管理。
    .RETURNS
        成功返回 @{ Hwnd; WasMinimized }，失败返回 $null
    #>

    $hwnd = [Win32]::FindWindow([NullString]::Value, "潇然系统部署背景插件")

    if ($hwnd -eq [IntPtr]::Zero) {
        $hwnd = [Win32]::FindWindow("PECMD", [NullString]::Value)
        if ($hwnd -eq [IntPtr]::Zero) {
            $hwnd = [Win32]::FindWindow("PECMD_WIN1", [NullString]::Value)
        }
    }

    if ($hwnd -eq [IntPtr]::Zero) {
        Write-Host "[PECMD] Wall.wcs window not found"
        return $null
    }

    Write-Host "[PECMD] Found Wall.wcs window (0x$($hwnd.ToString('x8')))"

    # Step 1: 取消置顶（核心保障 - 让任务栏浮上来）
    [Win32]::SetWindowPos(
        $hwnd,
        [Win32]::HWND_NOTOPMOST,
        0, 0, 0, 0,
        [Win32]::SWP_NOSIZE -bor [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOACTIVATE
    ) | Out-Null

    # Step 2: 尝试最小化（WM_SYSCOMMAND SC_MINIMIZE）
    [Win32]::SendMessage(
        $hwnd,
        [Win32]::WM_SYSCOMMAND,
        [Win32]::SC_MINIMIZE,
        [IntPtr]::Zero
    ) | Out-Null

    Start-Sleep -Milliseconds 100

    # 验证是否真的最小化了
    $minimized = [Win32]::IsIconic($hwnd)

    if ($minimized) {
        Write-Host "[PECMD] Window minimized (IsIconic=true)"
    }
    else {
        Write-Host "[PECMD] Window NOT minimized (IsIconic=false) - continuing with NOTOPMOST only"
    }

    return @{ Hwnd = $hwnd; WasMinimized = $minimized }
}

function Restore-PECMDWindow {
    param(
        $State
    )

    if (-not $State -or $State.Hwnd -eq [IntPtr]::Zero) {
        return
    }

    # 恢复窗口（如果之前最小化了才需要恢复）
    if ($State.WasMinimized) {
        [Win32]::SendMessage(
            $State.Hwnd,
            [Win32]::WM_SYSCOMMAND,
            [Win32]::SC_RESTORE,
            [IntPtr]::Zero
        ) | Out-Null

        Start-Sleep -Milliseconds 100
    }

    # 重新置顶
    [Win32]::SetWindowPos(
        $State.Hwnd,
        [Win32]::HWND_TOPMOST,
        0, 0, 0, 0,
        [Win32]::SWP_NOSIZE -bor [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOACTIVATE
    ) | Out-Null

    Write-Host "[PECMD] Window restored and TOPMOST reapplied"
}

function Show-Taskbar {
    $hwnd = [Win32]::FindWindow("Shell_TrayWnd", [NullString]::Value)

    if ($hwnd -eq [IntPtr]::Zero) {
        return $false
    }

    [Win32]::ShowWindowAsync($hwnd, [Win32]::SW_SHOW) | Out-Null
    Start-Sleep -Milliseconds 500

    return $true
}

# ===============================================
# UIAutomation
# ===============================================

Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {

    [DllImport("user32.dll")]
    public static extern void keybd_event(
        byte bVk,
        byte bScan,
        uint dwFlags,
        UIntPtr dwExtraInfo
    );

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    public static extern bool ClientToScreen(IntPtr hWnd, ref POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT { public int x; public int y; }

    public const int KEYEVENTF_KEYUP = 0x0002;
    public const byte VK_APPS = 0x5D;
    public const byte VK_RETURN = 0x0D;
    public const byte VK_DOWN = 0x28;

    public const int SW_HIDE = 0;
    public const int SW_SHOWNORMAL = 1;
    public const int SW_SHOWMINIMIZED = 2;
    public const int SW_SHOW = 5;
    public const int SW_MINIMIZE = 6;
    public const int SW_RESTORE = 9;
    public const int SW_SHOWDEFAULT = 10;

    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
    public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);
    public static readonly IntPtr HWND_TOP = new IntPtr(0);
    public static readonly IntPtr HWND_BOTTOM = new IntPtr(1);

    public const uint SWP_NOSIZE = 0x0001;
    public const uint SWP_NOMOVE = 0x0002;
    public const uint SWP_NOZORDER = 0x0004;
    public const uint SWP_NOACTIVATE = 0x0010;
    public const uint SWP_SHOWWINDOW = 0x0040;
    public const uint SWP_HIDEWINDOW = 0x0080;

    public const uint WM_SYSCOMMAND = 0x0112;
    public static readonly IntPtr SC_MINIMIZE = new IntPtr(0xF020);
    public static readonly IntPtr SC_RESTORE = new IntPtr(0xF120);
}
"@

function press_key {
    param([byte]$Key)

    [Win32]::keybd_event(
        $Key,
        0,
        0,
        [UIntPtr]::Zero
    )

    Start-Sleep -Milliseconds 30

    [Win32]::keybd_event(
        $Key,
        0,
        [Win32]::KEYEVENTF_KEYUP,
        [UIntPtr]::Zero
    )
}

function Find-TaskbarButton {
    param(
        [string]$StartsWith
    )

    $root = [System.Windows.Automation.AutomationElement]::RootElement

    # 找 taskbar 窗口
    $taskbar = $root.FindFirst(
        [System.Windows.Automation.TreeScope]::Descendants,
        (
            New-Object System.Windows.Automation.PropertyCondition(
                [System.Windows.Automation.AutomationElement]::ClassNameProperty,
                "Shell_TrayWnd"
            )
        )
    )

    if (-not $taskbar) {
        Write-Host "[UIA] Shell_TrayWnd not found"
        return $null
    }

    # 找开始按钮作为参照（用于确认 taskbar 就绪）
    $startBtn = $taskbar.FindFirst(
        [System.Windows.Automation.TreeScope]::Descendants,
        (
            New-Object System.Windows.Automation.AndCondition(
                (New-Object System.Windows.Automation.PropertyCondition(
                    [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
                    [System.Windows.Automation.ControlType]::Button
                )),
                (New-Object System.Windows.Automation.PropertyCondition(
                    [System.Windows.Automation.AutomationElement]::NameProperty,
                    "Start"
                ))
            )
        )
    )

    if (-not $startBtn) {
        Write-Host "[UIA] Start button not found on taskbar (taskbar not ready)"
    }

    # Win11 24H2+ 任务栏按钮的层级变深了，在 TrayDesktopBand 或 Taskbar.TaskbarFrame 下
    # 我们递归搜索所有 TaskbarFrame 下的按钮
    $condButton = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Button
    )

    $buttons = $taskbar.FindAll(
        [System.Windows.Automation.TreeScope]::Descendants,
        $condButton
    )

    Write-Host "[UIA] Found $($buttons.Count) buttons on taskbar"

    foreach ($btn in $buttons) {
        try {
            $name = $btn.Current.Name

            if ($name -and $name.StartsWith($StartsWith)) {
                Write-Host "[UIA] Target button found => '$name'"
                return $btn
            }
        }
        catch {}
    }

    # 没找到：打印所有按钮名称用于调试
    Write-Host "[UIA] Target not found. Available buttons:"
    foreach ($btn in $buttons) {
        try { Write-Host "[UIA]   - '$($btn.Current.Name)'" } catch {}
    }

    return $null
}

function Find-ContextMenuItem {
    <#
    .SYNOPSIS
        在 UIA 树中搜索指定文本的上下文菜单项。
        上下文菜单可能是 Menu 或 PopupMenu 控件，也可能以 Pane 形式出现。
        本函数搜索整个 Root 树，按名称匹配 MenuItem。
    #>
    param(
        [string]$Text,
        [int]$TimeoutSeconds
    )

    $condMenuItem = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::MenuItem
    )
    $condName = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::NameProperty,
        $Text
    )
    $andCond = New-Object System.Windows.Automation.AndCondition($condMenuItem, $condName)

    $deadline = [DateTime]::Now.AddSeconds($TimeoutSeconds)

    while ([DateTime]::Now -lt $deadline) {

        try {
            $root = [System.Windows.Automation.AutomationElement]::RootElement
            $result = $root.FindFirst(
                [System.Windows.Automation.TreeScope]::Descendants,
                $andCond
            )

            if ($result -ne $null) {
                Write-Host "[UIA] Context menu item found => '$($result.Current.Name)'"
                return $result
            }
        }
        catch {
            Write-Host "[UIA] Search error: $_"
        }

        Start-Sleep -Milliseconds 150
    }

    return $null
}

function Invoke-UnpinTaskbarUIA {
    <#
    .SYNOPSIS
        使用 UIA 自动化从任务栏取消固定目标程序。
        核心思路：
        1. 最小化 PECMD 背景窗口，显示任务栏
        2. 通过 UIA 找到任务栏按钮
        3. 触发右键菜单 (VK_APPS)
        4. 通过 UIA 树直接搜索菜单项 → InvokePattern
        5. 恢复 PECMD 窗口
    #>
    param(
        [string]$StartsWith,
        [int]$TimeoutSeconds
    )

    # ===========================================
    # Step 1: PECMD 窗口处理 + 显示任务栏
    # ===========================================
    $pecmdState = Suspend-PECMDWindow
    Show-Taskbar | Out-Null
    Start-Sleep -Milliseconds 300

    # ===========================================
    # Step 2: 找任务栏按钮
    # ===========================================
    Write-Host "[UIA] Searching taskbar button..."
    $target = Find-TaskbarButton -StartsWith $StartsWith

    if (-not $target) {
        Write-Host "[UIA] Target button not found"
        Restore-PECMDWindow -State $pecmdState
        return $false
    }

    $targetName = $target.Current.Name
    Write-Host "[UIA] Found => '$targetName'"

    # 获取按钮位置（用于调试）
    try {
        $bbox = $target.Current.BoundingRectangle
        Write-Host "[UIA] Button rect: left=$($bbox.Left) top=$($bbox.Top) w=$($bbox.Width) h=$($bbox.Height)"
    }
    catch {}

    # ===========================================
    # Step 3: 聚焦按钮 → 触发右键菜单
    # ===========================================

    # 尝试把 taskbar 窗口拉到前台
    $taskbarHwnd = [Win32]::FindWindow("Shell_TrayWnd", [NullString]::Value)
    if ($taskbarHwnd -ne [IntPtr]::Zero) {
        [Win32]::SetForegroundWindow($taskbarHwnd)
        Start-Sleep -Milliseconds 200
    }

    # 设置焦点到目标按钮
    try {
        $target.SetFocus()
        Start-Sleep -Milliseconds 100
    }
    catch {
        Write-Host "[UIA] SetFocus failed: $_"
    }

    # 发送 Apps 键（右键菜单）
    Write-Host "[UIA] Sending VK_APPS..."
    press_key ([Win32]::VK_APPS)
    Start-Sleep -Milliseconds 200

    # ===========================================
    # Step 4: 直接搜菜单项
    # ===========================================
    $unpinText = $script:UnpinLocalizedString
    Write-Host "[UIA] Searching menu item: '$unpinText'"

    $menuItem = Find-ContextMenuItem -Text $unpinText -TimeoutSeconds $TimeoutSeconds

    if (-not $menuItem) {
        Write-Host "[UIA] Menu item not found in UIA tree"

        # 备用方案：模拟 Shift+F10（有时候比 VK_APPS 好用）
        # 注意：必须按住 Shift 再按 F10，press_key 会松手所以不能用
        Write-Host "[UIA] Retry with Shift+F10..."
        try { $target.SetFocus() } catch {}
        Start-Sleep -Milliseconds 100
        [Win32]::keybd_event(0x10, 0, 0, [UIntPtr]::Zero)          # Shift down
        Start-Sleep -Milliseconds 30
        [Win32]::keybd_event(0x79, 0, 0, [UIntPtr]::Zero)          # F10 down
        Start-Sleep -Milliseconds 30
        [Win32]::keybd_event(0x79, 0, [Win32]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)  # F10 up
        Start-Sleep -Milliseconds 30
        [Win32]::keybd_event(0x10, 0, [Win32]::KEYEVENTF_KEYUP, [UIntPtr]::Zero)  # Shift up

        Start-Sleep -Milliseconds 300

        $menuItem = Find-ContextMenuItem -Text $unpinText -TimeoutSeconds ($TimeoutSeconds)
    }

    if (-not $menuItem) {
        Write-Host "[UIA] Menu item not found after retry"
        Restore-PECMDWindow -State $pecmdState
        return $false
    }

    # ===========================================
    # Step 5: Invoke 菜单项
    # ===========================================
    try {
        $invokePattern = $menuItem.GetCurrentPattern(
            [System.Windows.Automation.InvokePattern]::Pattern
        )
        $invokePattern.Invoke()

        Write-Host "[UIA] InvokePattern.Invoke() succeeded"
        Start-Sleep -Milliseconds 500

        Restore-PECMDWindow -State $pecmdState
        return $true
    }
    catch {
        Write-Host "[UIA] InvokePattern failed: $_"
    }

    # ===========================================
    # 最后的备用：Enter 键（如果焦点恰好在菜单项上）
    # ===========================================
    try {
        $menuItem.SetFocus()
        Start-Sleep -Milliseconds 100
        press_key ([Win32]::VK_RETURN)
        Write-Host "[UIA] Enter fallback used"
        Start-Sleep -Milliseconds 500
        Restore-PECMDWindow -State $pecmdState
        return $true
    }
    catch {}

    Restore-PECMDWindow -State $pecmdState
    return $false
}

# ===============================================
# Main
# ===============================================

# 先尝试 COM 方法（不依赖任务栏可见性）
if (
    Invoke-UnpinTaskbarCOM `
        -StartsWith $StartsWith
) {
    Write-Host "[OK] COM success"
    exit
}

Write-Host "[Fallback] Switching to UIAutomation..."

$result = $false

try {
    $result = Invoke-UnpinTaskbarUIA `
        -StartsWith $StartsWith `
        -TimeoutSeconds $TimeoutSeconds
}
catch {
    Write-Host "[UIA] Unhandled error: $_"
}

if ($result) {
    Write-Host "[OK] UIAutomation success"
    exit 0
}

Write-Host "[FAIL] Unpin failed"
exit 1