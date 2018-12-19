$profileDir = Split-Path -parent $profile

.\functions.ps1

# Setup autohotkey auto start
$TargetFile = "$(Get-Location)\autohotkey.ahk"
$ShortcutFile = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\autohotkey.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"

RefreshEnv.cmd

. $profile

Remove-Variable profileDir