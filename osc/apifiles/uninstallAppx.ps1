
# Uninstall Appx from the computer for all users
# The Remove-AppxProvisionedPackage cmdlet removes app packages (.appx) from a Windows image.
# App packages will not be installed when new user accounts are created.
# Packages will not be removed from existing user accounts.
# To remove app packages (.appx) that are not provisioned or to remove a package for a particular user only, use Remove-AppxPackage instead.

Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Clipchamp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.549981C3F5F10*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.BingNews*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.BingWeather*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.GetHelp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Getstarted*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Microsoft3DViewer*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MicrosoftPCManager*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MicrosoftTeams*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MixedReality.Portal*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Office.OneNote*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.OneConnect*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.OutlookForWindows*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.People*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.PowerAutomateDesktop*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Print3D*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.SkypeApp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Todos*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.WindowsMaps*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.XboxApp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Wallet*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*MicrosoftCorporationII.MicrosoftFamily*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MSTeams*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*MicrosoftWindows.Client.WebExperience*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.WidgetsPlatformRuntime*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Windows.DevHome*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.windowscommunicationsapps*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Edge.GameAssist*"} | Remove-AppxProvisionedPackage -Online

# Uninstall Appx for the current user
# Remove-AppxPackage cmdlet removes an app package from a user account.

Get-AppxPackage *Clipchamp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.549981C3F5F10* -AllUsers | Remove-AppxPackage # Cortana
Get-AppxPackage *Microsoft.BingNews* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.GetHelp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Getstarted* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Microsoft3DViewer* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftPCManager* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftTeams* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.MixedReality.Portal* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Office.OneNote* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.OneConnect* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.People* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.PowerAutomateDesktop* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Print3D* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.SkypeApp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Todos* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsMaps* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.XboxApp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Wallet* -AllUsers | Remove-AppxPackage # Pay
Get-AppxPackage *MicrosoftCorporationII.MicrosoftFamily* -AllUsers | Remove-AppxPackage
Get-AppxPackage *MicrosoftTeams* -AllUsers | Remove-AppxPackage
Get-AppxPackage *MSTeams* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.OutlookForWindows* -AllUsers | Remove-AppxPackage
Get-AppxPackage *MicrosoftWindows.Client.WebExperience* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.WidgetsPlatformRuntime* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Windows.DevHome* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingWeather* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.windowscommunicationsapps* -AllUsers | Remove-AppxPackage  # 邮件和日历
Get-AppxPackage *Microsoft.Edge.GameAssist* -AllUsers | Remove-AppxPackage  # 邮件和日历
Get-AppxPackage *Microsoft.MicrosoftOfficeHub* -AllUsers | Remove-AppxPackage # Microsoft 365 Copilot
Get-AppxPackage *Microsoft.Copilot* -AllUsers | Remove-AppxPackage # Copilot
Get-AppxPackage *Microsoft.StartExperiencesApp* -AllUsers | Remove-AppxPackage # “开始体验”应用
# Get-AppxPackage *Microsoft.GamingApp* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.MicrosoftStickyNotes* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.Todos* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.WindowsFeedbackHub* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.Xbox* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.YourPhone* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *MicrosoftCorporationII.QuickAssist* -AllUsers | Remove-AppxPackage

# Import registry to disable Microsoft PC Manager
reg.exe import .\mspcmgr.reg /reg:32
