# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy and restore dependencies
COPY ChessBackende8/ChessBackende8.csproj ./ChessBackende8/
RUN dotnet restore ChessBackende8/ChessBackende8.csproj

# Copy project files and build the app
COPY ChessBackende8/ ./ChessBackende8/
WORKDIR /app/ChessBackende8
RUN dotnet publish -c Release -o /app/out

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
