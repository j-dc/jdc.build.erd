$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot './..'));

function Get-FullPath {
    param (
        [string]$Path
    )
    return [System.IO.Path]::GetFullPath((Join-Path $root $Path))
}

Write-Host "Building container with jdc.build.erd..."
$containerName = 'localtest.me/jdc.build.erd:latest';
$dockerfile = Get-FullPath 'build/Dockerfile'

docker build -t $($containerName) -f $dockerfile $root

#-----
Write-host "RUNNING container jdc.build.erd..."
$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=sa;Password=This-Is-A-Secure-Password;TrustServerCertificate=True;";
docker run -it $containerName --provider SqlServer2022 --connectionstring $connectionString
