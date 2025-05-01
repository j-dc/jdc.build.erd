FROM mcr.microsoft.com/dotnet/sdk:8.0.408-alpine3.21-amd64@sha256:fd6c6120ee92499dee59210bcffe355ce3b7208f0fb051098756c236aea24b49 AS base

FROM base AS builder

ADD ./jdc.mssql.test /src/
WORKDIR /src

RUN dotnet publish -c Release -o /app 
#------------------------------------------------------------------------
FROM base AS final
RUN dotnet workload update
COPY --from=builder /app/jdc.mssql.test.dacpac /opt/jdc.mssql.test.dacpac

ENV PATH=/root/.dotnet/tools:$PATH

RUN dotnet tool install -g  microsoft.sqlpackage;
ENTRYPOINT ["sqlpackage","/Action:Publish","/SourceFile:/opt/jdc.mssql.test.dacpac"] 
