$profileDir = Split-Path -parent $profile

.\functions.ps1

# Setup autohotkey auto start
$TargetFile = "$(Get-Location)\autohotkey.ahk"
$ShortcutFile = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\autohotkey.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1,deps.ps1,configureWindows.ps1"
# For some reason it requires admin rights even though it should work with developer mode enabled 
# https://github.com/PowerShell/PowerShell/pull/8534 So we just copy the file
# New-Item -ItemType SymbolicLink -Name ~/_vimrc -Target ./_vimrc 
Copy-Item ./_vimrc -Destination ~/_vimrc

RefreshEnv.cmd

. $profile

Remove-Variable profileDir
