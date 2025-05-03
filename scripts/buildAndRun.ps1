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

$line = [string]::new('=', 80);
#-----
Write-Host $line;
Write-host "RUNNING container jdc.build.erd against mssql..."
$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=sa;Password=This-Is-A-Secure-Password;TrustServerCertificate=True;";
docker run -it --rm $containerName --provider SqlServer2022 --connectionstring $connectionString
#-----
Write-Host $line;
Write-host "RUNNING container jdc.build.erd against postgresql..."
$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=admin@localtest.me;Password=This-Is-A-Secure-Password;";
docker run -it --rm $containerName --provider PostgreSQL --connectionstring $connectionString
#-----
Write-Host $line;
Write-host "RUNNING published container jdc.build.erd against Postgresql..."
$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=admin@localtest.me;Password=This-Is-A-Secure-Password;";
docker run -it --rm ghcr.io/j-dc/jdc-build-erd:0.1.0-beta.15 --provider PostgreSQL --connectionstring $connectionString