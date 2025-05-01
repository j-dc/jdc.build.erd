$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot './..'));
function Get-FullPath {
    param (
        [string]$Path
    )
    return [System.IO.Path]::GetFullPath((Join-Path $root $Path))
}


# first we check if the needed db init tools are present
Write-host ([string]::new('=', 80));
Write-Host "Checking for the needed init tools ..."

Write-host ([string]::new('-', 80));
Write-Host "----mssql----"
$mssqlInitName = 'localtest.me/jdc.mssql.test:latest';
$img = ((docker images) | Select-String -Pattern $mssqlInitName -Raw -NoEmphasis );
if($null -eq $img -or "" -eq $img){
    Write-Host "🛠️  Building jdc.mssql.test..."
    $dockerfile = Get-FullPath 'inittools/mssql/Dockerfile'
    $dockerroot = Get-FullPath 'inittools/mssql/'
    Write-Host $dockerfile;
    write-host $dockerroot;
    docker build -t $($mssqlInitName) -f $($dockerfile) $($dockerroot)
}
else{
    Write-Host "✅  Image already present..."
}

Write-host ([string]::new('-', 80));
Write-Host "----pgsql----"
$pgsqlInitName = 'localtest.me/jdc.pgsql.test:latest';
$img = ((docker images) | Select-String -Pattern $pgsqlInitName -Raw -NoEmphasis );
if($null -eq $img -or "" -eq $img){
    Write-Host "🛠️  Building jdc.pgsql.test..."
    $dockerfile = Get-FullPath 'inittools/pgsql/Dockerfile'
    $dockerroot = Get-FullPath 'inittools/pgsql/'
    Write-Host $dockerfile;
    write-host $dockerroot;
    docker build -t $($pgsqlInitName) -f $($dockerfile) $($dockerroot)
}
else{
    Write-Host "✅  Image already present..."
}
   

$composefile =  Get-FullPath './containers/docker-compose.yaml'

#-----
Write-host ([string]::new('=', 80));
Write-Host "Starting database containers..."
docker compose -f $composefile up -d --build
Write-host ([string]::new('-', 80));
Write-Host "----containers:----"
docker compose -f $composefile ps --format '{{.Name}}\t{{.State}}'

#-----

#-----
Write-host ([string]::new('=', 80));
Write-Host "Initializeing databases..."
Write-host ([string]::new('-', 80));
Write-host "----mssql----"

$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=sa;Password=This-Is-A-Secure-Password;TrustServerCertificate=True;";
docker run $mssqlInitName /TargetConnectionString:$connectionString

Write-host ([string]::new('-', 80));
Write-host "----pgsql----"
Write-host "Publishe to database 'jdc.build.erd.test' on server 'host.docker.internal'"
$connectionString = "Server=host.docker.internal;Database=jdc.build.erd.test;User Id=admin@localtest.me;Password=This-Is-A-Secure-Password;";
docker run $pgsqlInitName -c $connectionString
