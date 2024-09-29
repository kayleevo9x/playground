FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /App
EXPOSE 80

COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build /App/out .
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]