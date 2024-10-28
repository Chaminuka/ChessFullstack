# Backend Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS backend-build
WORKDIR /app

# Copy and restore dependencies
COPY ChessBackende8/ChessBackende8.csproj ./ChessBackende8/
RUN dotnet restore ./ChessBackende8/ChessBackende8.csproj

# Copy and build backend project
COPY ChessBackende8/ ./ChessBackende8/
WORKDIR /app/ChessBackende8
RUN dotnet publish -c Release -o /app/out

# Frontend Build Stage
FROM node:18 AS frontend-build
WORKDIR /frontend

# Install dependencies and build
COPY ChessFrontend8/package*.json .
RUN npm install
COPY ChessFrontend8/ .
RUN npm run build  # Adjust if necessary

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy backend output
COPY --from=backend-build /app/out .

# Copy frontend build output (adjust folder if needed)
COPY --from=frontend-build /frontend/build ./wwwroot

ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
