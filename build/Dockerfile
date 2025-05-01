FROM mcr.microsoft.com/dotnet/sdk:9.0.203-alpine3.21@sha256:33be1326b4a2602d08e145cf7e4a8db4b243db3cac3bdec42e91aef930656080 AS builder

RUN apk add --no-cache clang build-base zlib-dev icu-libs

ENV APPNAME=jdc.build.erd
ENV BUILD_CONFIGURATION=Release
ENV BUILD_PROJECT=/src/$APPNAME/$APPNAME.csproj
ENV TARGETRUNTIME=linux-musl-x64

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV DOTNET_SYSTEM_GLOBALIZATION_USENLS=false

COPY src /src

WORKDIR /

RUN dotnet restore ${BUILD_PROJECT} --runtime ${TARGETRUNTIME}
RUN dotnet publish ${BUILD_PROJECT} --runtime ${TARGETRUNTIME} -c ${BUILD_CONFIGURATION} --no-restore --self-contained true -p:DebugSymbols=false
RUN dotnet publish ${BUILD_PROJECT} --runtime ${TARGETRUNTIME} -c ${BUILD_CONFIGURATION} -o /app --no-restore --no-build --self-contained true -p:DebugSymbols=false

###### ACTUAL CONTAINER ######

FROM mcr.microsoft.com/dotnet/runtime-deps:9.0.4-alpine3.21-amd64@sha256:37831f154882a94d3cc5e86ef64038b3c94eb56ccc175423b9b8a1e311e97667 AS final

RUN apk add --no-cache icu-libs

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=0
ENV DOTNET_SYSTEM_GLOBALIZATION_USENLS=false


COPY --from=builder /app /app
WORKDIR /app

USER app:app
ENTRYPOINT [ "/app/jdc.build.erd" ]
