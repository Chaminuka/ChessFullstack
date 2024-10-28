# Use the official ASP.NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ChessBackende8/ChessBackende8.csproj", "ChessBackende8/"]
RUN dotnet restore "ChessBackende8/ChessBackende8.csproj"
COPY . .
WORKDIR "/src/ChessBackende8"
RUN dotnet build "ChessBackende8.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "ChessBackende8.csproj" -c Release -o /app/publish

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
