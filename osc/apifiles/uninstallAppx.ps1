
# Uninstall Appx for the current user
# Remove-AppxPackage cmdlet removes an app package from a user account.

Get-AppxPackage *Clipchamp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Todos* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.BingNews* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.MicrosoftTeams* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.WindowsMaps* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Office.OneNote* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.PowerAutomateDesktop* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.People* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.SkypeApp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.GetHelp* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Getstarted* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.OneConnect* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.MixedReality.Portal* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Print3D* -AllUsers | Remove-AppxPackage
Get-AppxPackage *Microsoft.Microsoft3DViewer* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.549981C3F5F10* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.BingWeather* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.GamingApp* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.Xbox* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.YourPhone* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *Microsoft.WindowsFeedbackHub* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *MicrosoftCorporationII.QuickAssist* -AllUsers | Remove-AppxPackage
# Get-AppxPackage *MicrosoftWindows.Client.WebExperience* -AllUsers | Remove-AppxPackage

# Uninstall Appx from the computer for all users
# The Remove-AppxProvisionedPackage cmdlet removes app packages (.appx) from a Windows image.
# App packages will not be installed when new user accounts are created.
# Packages will not be removed from existing user accounts.
# To remove app packages (.appx) that are not provisioned or to remove a package for a particular user only, use Remove-AppxPackage instead.

Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Clipchamp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Todos*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.BingNews*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MicrosoftTeams*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.WindowsMaps*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Office.OneNote*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.PowerAutomateDesktop*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.People*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.SkypeApp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.GetHelp*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Getstarted*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.OneConnect*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.MixedReality.Portal*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Print3D*"} | Remove-AppxProvisionedPackage -Online
Get-AppxProvisionedPackage -Online | Where-Object {$_.packagename -like "*Microsoft.Microsoft3DViewer*"} | Remove-AppxProvisionedPackage -Online