# Use the official ASP.NET Core runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file for caching
COPY ChessBackende8/ChessBackende8/ChessBackende8.csproj ChessBackende8/ChessBackende8/

# Restore dependencies
RUN dotnet restore "ChessBackende8/ChessBackende8/ChessBackende8.csproj"

# Copy the entire backend project and build
COPY ChessBackende8/ChessBackende8/ ChessBackende8/ChessBackende8/
WORKDIR "/src/ChessBackende8/ChessBackende8"
RUN dotnet build "ChessBackende8.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "ChessBackende8.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
