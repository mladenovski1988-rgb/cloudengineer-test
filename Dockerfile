FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

ARG APP_VERSION=1.0.0

COPY src/*.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out /p:Version=$APP_VERSION

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .

EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
ENTRYPOINT ["dotnet", "TodoApi.dll"]

