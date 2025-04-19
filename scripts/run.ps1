$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot './..'));
$composefile = Join-Path $root 'scripts/docker-compose.yaml'

#-----
Write-Host "Starting database constainer..."
docker compose -f $composefile up -d --build

#-----
Write-Host "Building mqsql project..."
$proj = Join-Path $root 'test/jdc.mssql.build.erd.test/jdc.mssql.build.erd.test.sqlproj'
$outputFolder = Join-Path $root 'test/artifacts';
New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null;

dotnet build $proj -c Release -o $outputFolder;

#-----
Write-Host "Publishing database"
$sqlPackagefile = Get-ChildItem $outputFolder -Filter '*.dacpac' | Select-Object -First 1;
$connectionString = "Server=localhost;User Id=sa;Database=jdc.build.erd.test;Password=This-Is-A-Secure-Password;TrustServerCertificate=True;";

Write-Host "Using sqlPackagefile: $($sqlPackagefile.FullName)";

dotnet tool install -g microsoft.sqlpackage;
sqlpackage /Action:Publish /SourceFile:$($sqlPackagefile.FullName) /TargetConnectionString:$connectionString

#-----
Write-host "Building container with jdc.build.erd..."
$containerName = 'localtest.me/jdc.build.erd:latest';

$dockerfile = Join-Path $root 'build/Dockerfile'
$containerName = 'localtest.me/jdc.build.erd:latest';

docker build -t $($containerName) -f $dockerfile $root

#-----
Write-host "RUNNING container jdc.build.erd..."

docker run -it $containerName --provider SqlServer2022 --connectionstring $connectionString