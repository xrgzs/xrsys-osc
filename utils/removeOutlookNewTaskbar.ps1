
# ===============================================
# Favorites
# ===============================================

$taskbandFavorites = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites"

$replaceFavorites = "00 AA 02 00 00 14 00 1F 80 9B D4 34 42 45 02 F3 4D B7 80 38 93 94 34 56 E1 94 02 00 00 00 01 41 50 50 53 EE 00 08 00 03 00 00 00 01 00 00 00 31 00 00 00 31 53 50 53 30 F1 25 B7 EF 47 1A 10 A5 F1 02 60 8C 9E EB AC 15 00 00 00 0A 00 00 00 00 1F 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 B9 00 00 00 31 53 50 53 55 28 4C 9F 79 9F 39 4B A8 D0 E1 D4 2D E1 D5 F3 9D 00 00 00 05 00 00 00 00 1F 00 00 00 46 00 00 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 00 00 00 00 00 00 00 00 00 00 98 00 00 00 1D 00 EF BE 02 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 06 01 10 00 00 00 2D 00 EF BE 02 00 31 00 00 00 06 01 3C 00 00 00 1E 00 EF BE 02 00 50 00 72 00 6F 00 67 00 72 00 61 00 6D 00 6D 00 61 00 62 00 6C 00 65 00 50 00 6C 00 61 00 63 00 65 00 68 00 6F 00 6C 00 64 00 65 00 72 00 00 00 06 01 12 00 00 00 2B 00 EF BE 46 A8 91 F3 AB 1F DB 01 06 01 98 00 00 00 1D 00 EF BE 02 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 06 01 00 00" -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }

$taskbandFavorites = $taskbandFavorites -join ',' -replace ($replaceFavorites -join ','), '' -replace ',,', ','

$taskbandFavorites = $taskbandFavorites -split ',' | ForEach-Object { [Convert]::ToByte($_, 10) }

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Value $taskbandFavorites

# ===============================================
# FavoritesResolve
# ===============================================

$taskbandFavoritesResolve = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites"

$replaceFavoritesResolve = "FC 02 00 00 4C 00 00 00 01 14 02 00 00 00 00 00 C0 00 00 00 00 00 00 46 81 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 AA 02 14 00 1F 80 9B D4 34 42 45 02 F3 4D B7 80 38 93 94 34 56 E1 94 02 00 00 00 01 41 50 50 53 EE 00 08 00 03 00 00 00 01 00 00 00 31 00 00 00 31 53 50 53 30 F1 25 B7 EF 47 1A 10 A5 F1 02 60 8C 9E EB AC 15 00 00 00 0A 00 00 00 00 1F 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 B9 00 00 00 31 53 50 53 55 28 4C 9F 79 9F 39 4B A8 D0 E1 D4 2D E1 D5 F3 9D 00 00 00 05 00 00 00 00 1F 00 00 00 46 00 00 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 00 00 00 00 00 00 00 00 00 00 98 00 00 00 1D 00 EF BE 02 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 06 01 10 00 00 00 2D 00 EF BE 02 00 31 00 00 00 06 01 3C 00 00 00 1E 00 EF BE 02 00 50 00 72 00 6F 00 67 00 72 00 61 00 6D 00 6D 00 61 00 62 00 6C 00 65 00 50 00 6C 00 61 00 63 00 65 00 68 00 6F 00 6C 00 64 00 65 00 72 00 00 00 06 01 12 00 00 00 2B 00 EF BE 46 A8 91 F3 AB 1F DB 01 06 01 98 00 00 00 1D 00 EF BE 02 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 5F 00 38 00 77 00 65 00 6B 00 79 00 62 00 33 00 64 00 38 00 62 00 62 00 77 00 65 00 21 00 4D 00 69 00 63 00 72 00 6F 00 73 00 6F 00 66 00 74 00 2E 00 4F 00 75 00 74 00 6C 00 6F 00 6F 00 6B 00 66 00 6F 00 72 00 57 00 69 00 6E 00 64 00 6F 00 77 00 73 00 00 00 06 01 00 00 00 00 00 00"

$taskbandFavoritesResolve = $taskbandFavoritesResolve -join ',' -replace ($replaceFavoritesResolve -join ','), '' -replace ',,', ','

$taskbandFavoritesResolve = $taskbandFavoritesResolve -split ',' | ForEach-Object { [Convert]::ToByte($_, 10) }

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -Value $taskbandFavoritesResolve

# ===============================================
# ComObject Method
# ===============================================

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class DllCaller {
    [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr GetModuleHandle(string lpModuleName);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);

    public static string GetString(uint strId)
    {
        IntPtr intPtr = GetModuleHandle("shell32.dll");
        StringBuilder sb = new StringBuilder(255);
        LoadString(intPtr, strId, sb, sb.Capacity);
        return sb.ToString();
    }
}
"@

$LocalizedString = [DllCaller]::GetString(5387)
(New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items() | Where-Object { $_.Name -match "Outlook" } | ForEach-Object {
    $_.Verbs() | Where-Object -FilterScript { $_.Name -eq $LocalizedString } | ForEach-Object -Process { $_.DoIt() }
}
