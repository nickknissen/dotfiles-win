# Basic commands
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
function touch($file) { "" | Out-File $file -Encoding ASCII }

# Reload the Shell
function Reload-Powershell {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = "-nologo";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

### Environment functions
### ----------------------------

# Reload the $env object from the registry
function Refresh-Environment {
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)
            Set-Item -Path Env:\$name -Value $value
        }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Verify-Elevated {
    # Get the ID and security principal of the current user account
    $myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myPrincipal=new-object System.Security.Principal.WindowsPrincipal($myIdentity)
    # Check to see if we are currently running "as Administrator"
    return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
    Set-ItemProperty "HKCU:\Environment" $variable $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$env:${variable} = `"$value`""
}

function Get-WslExe {
    return Get-Command "wsl.exe" -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Definition
}

function Invoke-WslCommand {
    [CmdletBinding()]
    param (
        [string]$WslCommand,
        [string]$Arguments,
        [string]$PowerShellFallback = ""
    )

    $wsl = Get-WslExe

    if ([string]::IsNullOrEmpty($wsl)) {
        # wsl.exe is not installed, so Run the PowerShellFallback
        # First, if the PowerShellFallback is blank, try a sane default
        if ([string]::IsNullOrEmpty($PowerShellFallback)) {
            if ($PowerShellFallback.StartsWith("ls ")) {
                $PowerShellFallback = "Get-ChildItem"
            }
            else {
                $PowerShellFallback = "$WslCommand"
            }
        }

        Invoke-Expression "$PowerShellFallback $Arguments"
    }
    else {
        Invoke-Expression "wsl.exe $WslCommand $Arguments"
    }
}

function Run-Tig { Invoke-WslCommand "tig" "-d Ubuntu-16.04" }
