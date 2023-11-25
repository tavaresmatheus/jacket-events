FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /JacketEvents
ENV ASPNETCORE_URLS=http://+:80 \
DOTNET_RUNNING_IN_CONTAINER=true
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["JacketEvents.csproj", "./"]
RUN dotnet restore "./JacketEvents.csproj"
COPY . .
RUN dotnet build "JacketEvents.csproj" -c Release -o /JacketEvents

FROM build AS publish
RUN dotnet publish "JacketEvents.csproj" -c Release -o /JacketEvents

FROM base AS final
WORKDIR /JacketEvents
COPY --from=publish /JacketEvents .
ENTRYPOINT ["dotnet", "JacketEvents.dll"]