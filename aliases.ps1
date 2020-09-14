${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

${function:dl} = { Set-Location ~\Downloads }

# Missing Bash aliases
Set-Alias time Measure-Command


function cddash {
    if ($args[0] -eq '-') {
        $pwd = $OLDPWD;
    } else {
        $pwd = $args[0];
    }
    $tmp = Get-Location;

    if ($pwd) {
        Set-Location $pwd;
    }
    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

function DockerCompose-Exec() {
    docker-compose exec $args 
}

function DockerCompose-Exec-Php() {
    docker-compose exec php $args 
}

Set-Alias -Name cd -value cddash -Option AllScope

Set-Alias dc docker-compose
Set-Alias dce DockerCompose-Exec
Set-Alias dcep DockerCompose-Exec-Php

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
Set-Alias tig Run-Tig 
