# See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

#----------------------------------------------------------------------------------------
# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/runtime:9.0-alpine AS base
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV DOTNET_SYSTEM_GLOBALIZATION_USENLS=false

USER $APP_UID
WORKDIR /app

#----------------------------------------------------------------------------------------
# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV DOTNET_SYSTEM_GLOBALIZATION_USENLS=false

ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["jdc.build.erd/jdc.build.erd.csproj", "jdc.build.erd/"]
RUN dotnet restore "./jdc.build.erd/jdc.build.erd.csproj"
COPY . .
WORKDIR "/src/jdc.build.erd"
RUN dotnet build "./jdc.build.erd.csproj" -c $BUILD_CONFIGURATION -o /app/build

#----------------------------------------------------------------------------------------
# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./jdc.build.erd.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

#----------------------------------------------------------------------------------------
# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final

RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV DOTNET_SYSTEM_GLOBALIZATION_USENLS=false

WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jdc.build.erd.dll"]
