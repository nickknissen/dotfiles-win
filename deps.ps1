. "$PSScriptRoot\functions.ps1"
# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}
### Chocolatey
if ((Get-Command cinst -ErrorAction SilentlyContinue | Select-Object Definition) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
} else {
    choco feature enable -n=allowGlobalConfirmation
}
#CLI
cinst curl --limit-output
cinst nvm.portable --limit-output
cinst git.install --limit-output
cinst vim-tux --limit-output
cinst fzf --limit-output

cinst 7zip --limit-output
cinst conemu --limit-output
cinst autohotkey --limit-output

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module -Name 'posh-git' -Scope CurrentUser -Force
Install-Module -Name 'oh-my-posh' -Scope CurrentUser -Force
Install-Module -Name 'Get-ChildItemColor' -Scope CurrentUser -Force

Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Hyper-V-All" | Out-Null


New-Item -Force -ItemType directory -Path ~\vimfiles\autoload | Out-Null
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile(
  $uri,
  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\vimfiles\autoload\plug.vim"
  )
)
