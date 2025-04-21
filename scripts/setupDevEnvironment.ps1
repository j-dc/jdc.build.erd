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
    Write-Host "🛠️  Building jdc.build.erd..."
    $dockerfile = Get-FullPath 'inittools/mssql/Dockerfile'
    $dockerroot = Get-FullPath 'inittools/mssql/'
    Write-Host $dockerfile;
    write-host $dockerroot;
    docker build -t $($mssqlInitName) -f $($dockerfile) $($dockerroot)
}
else{
    Write-Host "✅  Image already present..."
}
# $mssqlFolder = Get-FullPath './containers/mssql/';
# $mssqlSrc = (Get-FullPath './containers/mssql/jdc.mssql.test.dacpac');
# if(-not( test-path $mssqlSrc)){
#     Write-Host "Building mqsql project..."
#     $mssqlBuilder = 
#     docker run --it -f 
#     $proj = Get-FullPath './inittools/mssql/jdc.mssql.test/jdc.mssql.test.sqlproj'
#     New-Item -Path $mssqlFolder -ItemType Directory -Force | Out-Null;    
#     dotnet build $proj -c Release;
#     Copy-Item (Get-FullPath './inittools/mssql/jdc.mssql.test/bin/Release/jdc.mssql.test.dacpac') $mssqlSrc -Force;
# }
   

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

