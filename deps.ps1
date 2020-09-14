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
cup curl --limit-output
cup nvm.portable --limit-output
cup git.install --limit-output
cup vim-tux --limit-output
cup fzf --limit-output
cup rg --limit-output

cup 7zip --limit-output
cup conemu --limit-output
cup autohotkey --limit-output
cup install firefox --limit-output
cup install 1password --limit-output
cup install winscp.portable --limit-output
cup install openssh --limit-output
cup install microsoft-teams.install --limit-output
cup install neovim --limit-output

cup python3 --limit-output
cup install php --version 7.4 -my --limit-output
cup install php --version 7.3 -my --limit-output
cup composer --limit-output
cup install dotnetcore-sdk --limit-output
cup install vscode --limit-output
cup install microsoft-edge --limit-output

nvm on
$nodeLtsVersion = choco search nodejs-lts --limit-output | ConvertFrom-String -TemplateContent "{Name:package-name}\|{Version:1.11.1}" | Select -ExpandProperty "Version"
nvm install $nodeLtsVersion
nvm use $nodeLtsVersion
Remove-Variable nodeLtsVersion

pip install --upgrade pip 
pip install --upgrade mycli pgcli
pip install --upgrade mycli 

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
