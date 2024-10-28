# Use the .NET SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project file into the container
COPY ChessBackende8/ChessBackende8/ChessBackende8.csproj ./ChessBackende8/

# Restore the dependencies
RUN dotnet restore ChessBackende8/ChessBackende8.csproj

# Copy the entire project folder
COPY ChessBackende8/ChessBackende8/. ./ChessBackende8/

# Build the application
RUN dotnet build ChessBackende8/ChessBackende8.csproj -c Release -o out

# Publish the application
FROM build AS publish
RUN dotnet publish ChessBackende8/ChessBackende8.csproj -c Release -o out

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /app/out .
ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
