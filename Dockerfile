FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["CICD-API/CICD-API.csproj", "CICD-API/"]
COPY ["CICD-Core/CICD-Core.csproj", "CICD-Core/"]
RUN dotnet restore "./CICD-API/CICD-API.csproj"
COPY . .
WORKDIR "/src/CICD-API"
RUN dotnet build "./CICD-API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./CICD-API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CICD-API.dll"]