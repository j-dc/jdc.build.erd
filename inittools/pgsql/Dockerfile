#FROM mcr.microsoft.com/dotnet/sdk:8.0.408-alpine3.21-amd64@sha256:fd6c6120ee92499dee59210bcffe355ce3b7208f0fb051098756c236aea24b49 AS base
FROM mcr.microsoft.com/dotnet/sdk:7.0.410-alpine3.19-amd64@sha256:2605dc846b8340ae6d7fb2900bde39b1b35fae087e5a049675ad4a62d47fa3a2 AS base

#------------------------------------------------------------------------
FROM base AS final
RUN dotnet workload update
ADD  ./sql /sql

ENV PATH=/root/.dotnet/tools:$PATH

RUN dotnet tool install --global Evolve.Tool;
ENTRYPOINT ["evolve","migrate","postgresql","-l","/sql","-s","public"]
#-c "Server=127.0.0.1;Database=db1;User Id=postgres;Password=postgres;" 
