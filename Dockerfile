# Build Stage for Backend
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS backend-build
WORKDIR /app

# Copy backend project files and restore dependencies
COPY ChessBackende8/ChessBackende8/ChessBackende8.csproj ./ChessBackende8/ChessBackende8/
RUN dotnet restore ./ChessBackende8/ChessBackende8/ChessBackende8.csproj

# Copy the entire backend project and build
COPY ChessBackende8/ ./ChessBackende8/
WORKDIR /app/ChessBackende8/ChessBackende8
RUN dotnet publish -c Release -o /app/out

# Optional: Debugging command to check the directory contents before proceeding
RUN ls -R /app  # Lists all files in /app directory

# Build Stage for Frontend
FROM node:18 AS frontend-build
WORKDIR /frontend

# Copy frontend dependencies and install
COPY ChessFrontend8/ChessFrontend8/package*.json ./ # Adjusted to copy package.json from the correct path
RUN npm install # Now installs in the current directory (which is /frontend)

# Copy the rest of the frontend files and build
COPY ChessFrontend8/ ./ChessFrontend8/
RUN npm run build --prefix ./ChessFrontend8  # Build command should run within ChessFrontend8

# Optional: Debugging command to check the frontend build output
RUN ls -R /frontend  # Lists all files in /frontend directory

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy backend build output
COPY --from=backend-build /app/out .

# Copy frontend build output to the wwwroot folder of the backend
COPY --from=frontend-build /frontend/ChessFrontend8/build ./wwwroot  # Adjust build output path if necessary

# Entry point for the backend
ENTRYPOINT ["dotnet", "ChessBackende8/ChessBackende8.dll"]
