# jdc.build.erd
A simple tool to build a simple er diagram from a Relation Database server.

## Example:

using a localhost postgres

```
docker run -it --rm ghcr.io/j-dc/jdc-build-erd --provider PostgreSQL --connectionstring "Server=localhost;Database=test;User Id=DBUser;Password=Password;"
```

## Usage:

&#9; `docker run -it --rm ghcr.io/j-dc/jdc-build-erd [options]`

### Options:
Options | Required | Description
--|--|--
  --provider <provider> |✅| The database to connect to <br> (PostgreSQL,  SqlServer2022)
  --connectionstring <connectionstring>|✅| The connectionstring to your database
  --version   | | Show version information
  -?, -h, --help | | Show help and usage information

## Versions
https://ghcr.io/j-dc/jdc-build-erd
