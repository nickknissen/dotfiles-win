Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadlineOption -BellStyle None

function .. { cd .. }
function ... { cd .. ; cd .. }
function .... { cd .. ; cd .. ; cd .. }
function ..... { cd .. ; cd .. ; cd .. ; cd .. }
function home { cd $env:USERPROFILE }

Import-Module 'posh-git'
Import-Module 'oh-my-posh'
Set-Theme agnoster

# Helper function to show Unicode character
function U
{
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }
 
    throw "Invalid character code $Code"
}

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host

    if (Test-Administrator) {  # Use different username if elevated
        Write-Host "(Elevated) " -NoNewline -ForegroundColor White
    }

    Write-Host "$ENV:USERNAME@" -NoNewline -ForegroundColor DarkYellow
    Write-Host "$ENV:COMPUTERNAME" -NoNewline -ForegroundColor Magenta

    if ($s -ne $null) {  # color for PSSessions
        Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
        Write-Host "$($s.Name)" -NoNewline -ForegroundColor Yellow
        Write-Host ") " -NoNewline -ForegroundColor DarkGray
    }

    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\','\\'), "~") -NoNewline -ForegroundColor Blue
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host (Get-Date -Format G) -NoNewline -ForegroundColor DarkMagenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-VcsStatus

    Write-Host ""

    return "> "
}

# Start SshAgent if not already
# Need this if you are using github as your remote git repository
if (! (ps | ? { $_.Name -eq 'ssh-agent'})) {
    Start-SshAgent -Quiet
}

