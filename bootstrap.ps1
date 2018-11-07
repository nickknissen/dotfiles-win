function Verify-Elevated {
    # Get the ID and security principal of the current user account
    $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myPrincipal=new-object System.Security.Principal.WindowsPrincipal($myIdentity)
    # Check to see if we are currently running "as Administrator"
    return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}

# Set your PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

### Chocolatey
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}
#CLI
cinst curl --limit-output
cinst nvm.portable --limit-output
cinst git.install --limit-output
cinst vim --limit-output

cinst 7zip --limit-output
cinst conemu --limit-output
cinst autohotkey --limit-output

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

# Setup autohotkey auto start
$TargetFile = "$(Get-Location)\autohotkey.ahk"
$ShortcutFile = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\autohotkey.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()


Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module -Name 'posh-git' -Force
Install-Module -Name 'oh-my-posh' -Force
Install-Module -Name 'Get-ChildItemColor' -Force

if (!(Test-Path $env:USERPROFILE\Documents\WindowsPowerShell)) {
  mkdir $env:USERPROFILE\Documents\WindowsPowerShell
}

if (!(Test-Path $env:USERPROFILE\Documents\WindowsPowerShell\Modules\posh-git)) {
  Install-Module posh-git -Scope CurrentUser
}

copy Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

RefreshEnv.cmd

. $profile