# jdc.build.erd
A simple tool to build a simple er diagram from a Relation Database server.

## Example:

using a localhost mssql

```
docker run -it --rm ghcr.io/j-dc/jdc-build-erd --provider SqlServer2022 --connectionstring "Server=localhost;Database=test;User Id=DBUser;Password=Password;"
```
result:

```
erDiagram
        "test.orders" {
                int     orderId
                int     customerId
                datetime        orderDate
                decimal(10_2)   totalAmount
        }
        "test.customers" {
                int     customerId
                nvarchar(100)   name
                nvarchar(100)   email
        }
        "test.orderItems" {
                int     orderItemId
                int     orderId
                nvarchar(100)   productName
                int     quantity
                decimal(10_2)   price
        }
"test.orders" }o..|| "test.customers" : ""
"test.orderItems" }o..|| "test.orders" : ""
```

## Usage:

`docker run -it --rm ghcr.io/j-dc/jdc-build-erd [options]`

### Options:
Options | Required | Description
--|--|--
  --provider <provider> |✅| The database to connect to <br> (PostgreSQL,  SqlServer2022)
  --connectionstring <connectionstring>|✅| The connectionstring to your database
  --version   | | Show version information
  -?, -h, --help | | Show help and usage information

## Versions & tags
https://ghcr.io/j-dc/jdc-build-erd
