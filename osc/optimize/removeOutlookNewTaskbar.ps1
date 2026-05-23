param(
    [string]$StartsWith = "Outlook",
    [int]$TimeoutSeconds = 5,
    [switch]$HideTaskbar
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
# Taskbar Visibility Helper
# ===============================================

function Get-TaskbarVisibility {
    $hwnd = [Win32]::FindWindow("Shell_TrayWnd", [NullString]::Value)

    if ($hwnd -eq [IntPtr]::Zero) {
        return @{ Hwnd = [IntPtr]::Zero; Visible = $false; WasHidden = $false }
    }

    $visible = [Win32]::IsWindowVisible($hwnd)

    return @{ Hwnd = $hwnd; Visible = $visible; WasHidden = (-not $visible) }
}

function Hide-Taskbar {
    $hwnd = [Win32]::FindWindow("Shell_TrayWnd", [NullString]::Value)

    if ($hwnd -eq [IntPtr]::Zero) {
        Write-Host "[Taskbar] Shell_TrayWnd not found"
        return $false
    }

    $visible = [Win32]::IsWindowVisible($hwnd)

    if (-not $visible) {
        Write-Host "[Taskbar] Already hidden"
        return $true
    }

    [Win32]::ShowWindow($hwnd, [Win32]::SW_HIDE)

    Write-Host "[Taskbar] Hidden successfully"

    return $true
}

function Show-TaskbarTemporarily {
    param(
        [IntPtr]$Hwnd
    )

    if ($Hwnd -eq [IntPtr]::Zero) {
        return $false
    }

    [Win32]::ShowWindow($Hwnd, [Win32]::SW_SHOW)
    Start-Sleep -Milliseconds 300

    return $true
}

function Restore-TaskbarVisibility {
    param(
        [IntPtr]$Hwnd,
        [bool]$WasHidden
    )

    if ($Hwnd -eq [IntPtr]::Zero -or -not $WasHidden) {
        return
    }

    [Win32]::ShowWindowAsync($Hwnd, [Win32]::SW_HIDE) | Out-Null
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

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    public const int KEYEVENTF_KEYUP = 0x0002;

    public const byte VK_APPS = 0x5D;

    public const int SW_HIDE = 0;
    public const int SW_SHOW = 5;
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
        return $null
    }

    $buttons = $taskbar.FindAll(
        [System.Windows.Automation.TreeScope]::Descendants,
        (
            New-Object System.Windows.Automation.PropertyCondition(
                [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
                [System.Windows.Automation.ControlType]::Button
            )
        )
    )

    foreach ($btn in $buttons) {

        try {
            $name = $btn.Current.Name

            if (
                $name -and
                $name.StartsWith($StartsWith)
            ) {
                return $btn
            }

        }
        catch {}
    }

    return $null
}

function Invoke-UnpinTaskbarUIA {
    param(
        [string]$StartsWith,
        [int]$TimeoutSeconds
    )

    $script:uiaResult = $false

    Write-Host "[UIA] Searching taskbar button..."

    $target = Find-TaskbarButton -StartsWith $StartsWith

    if (-not $target) {
        Write-Host "[UIA] Target not found"
        return
    }

    $targetName = $target.Current.Name

    Write-Host "[UIA] Found => $targetName"

    # 把 taskbar 拉到前台
    $hwnd = [Win32]::FindWindow("Shell_TrayWnd", [NullString]::Value)

    if ($hwnd -ne [IntPtr]::Zero) {
        [Win32]::SetForegroundWindow($hwnd)
        Start-Sleep -Milliseconds 200
    }

    try { $target.SetFocus() } catch {}

    # 触发右键菜单
    press_key ([Win32]::VK_APPS)

    # 等待菜单出现（焦点离开任务栏按钮）
    $deadline = [DateTime]::Now.AddSeconds($TimeoutSeconds)
    $menuOpen = $false

    while ([DateTime]::Now -lt $deadline) {
        try {
            $f = [System.Windows.Automation.AutomationElement]::FocusedElement
            if ($f) {
                $fName = $f.Current.Name
                if ($fName -and $fName -ne $targetName) {
                    Write-Host "[UIA] Menu opened => $fName"
                    $menuOpen = $true
                    break
                }
            }
        }
        catch {}
        Start-Sleep -Milliseconds 100
    }

    if (-not $menuOpen) {
        Write-Host "[UIA] Menu not opened"
        return
    }

    # 用方向键遍历菜单项，用系统本地化字符串匹配
    # 不然无法获取到菜单项列表（坑）
    $found = $false
    $maxSteps = 10
    $unpinText = $script:UnpinLocalizedString

    for ($i = 0; $i -lt $maxSteps; $i++) {

        try {
            $f = [System.Windows.Automation.AutomationElement]::FocusedElement
            if ($f) {
                $fName = $f.Current.Name
                Write-Host "[UIA] [$i] => '$fName'"

                if ($fName) {
                    $nameStr = $fName.ToString()
                    $match = [string]::Equals($nameStr, $unpinText, [System.StringComparison]::OrdinalIgnoreCase)

                    Write-Host "[UIA] Compare '$nameStr' == '$unpinText' => $match"

                    if ($match) {
                        Write-Host "[UIA] FOUND! => $nameStr"
                        $found = $true
                        break
                    }
                }
            }
        }
        catch {}

        # 按下方向键
        press_key 0x28  # VK_DOWN
        Start-Sleep -Milliseconds 150
    }

    if (-not $found) {
        Write-Host "[UIA] Unpin item not found in menu"
        return
    }

    # 按回车确认
    Write-Host "[UIA] Pressing Enter..."
    press_key 0x0D  # VK_RETURN

    Start-Sleep -Milliseconds 300

    Write-Host "[UIA] Done"
    $script:uiaResult = $true
}

# ===============================================
# Main
# ===============================================

# 测试模式：隐藏任务栏
if ($HideTaskbar) {
    if (Hide-Taskbar) {
        Write-Host "[OK] Taskbar hidden"
        exit 0
    }
    else {
        Write-Host "[FAIL] Failed to hide taskbar"
        exit 1
    }
}

# 先尝试 COM 方法（不依赖任务栏可见性）
if (
    Invoke-UnpinTaskbarCOM `
        -StartsWith $StartsWith
) {
    Write-Host "[OK] COM success"
    exit
}

Write-Host "[Fallback] Switching to UIAutomation..."

# 检查任务栏可见性，如果被隐藏则临时显示
$taskbarState = Get-TaskbarVisibility

if ($taskbarState.WasHidden) {
    Write-Host "[Taskbar] Taskbar is hidden, temporarily showing..."
    Show-TaskbarTemporarily -Hwnd $taskbarState.Hwnd | Out-Null
}

$script:uiaResult = $false

try {
    Invoke-UnpinTaskbarUIA `
        -StartsWith $StartsWith `
        -TimeoutSeconds $TimeoutSeconds
}
finally {
    # 无论成功失败，都恢复任务栏原始状态
    if ($taskbarState.WasHidden) {
        Write-Host "[Taskbar] Restoring hidden state..."
        Restore-TaskbarVisibility `
            -Hwnd $taskbarState.Hwnd `
            -WasHidden $taskbarState.WasHidden
    }
}

if ($script:uiaResult -eq $true) {
    Write-Host "[OK] UIAutomation success"
    exit 0
}

Write-Host "[FAIL] Unpin failed"
exit 1