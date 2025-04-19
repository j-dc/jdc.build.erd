$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot './..'));

$dockerfile = Join-Path $root 'build/Dockerfile'

$containername = "localtest.me/jdc.build.erd:latest"

Write-Host $root;
write-host $dockerfile;

docker build -t $($containername) -f $dockerfile $root
