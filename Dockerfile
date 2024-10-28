# Build Stage for Backend
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS backend-build
WORKDIR /app

# Copy backend project files and restore dependencies
COPY ChessBackende8/ChessBackende8/ChessBackende8.csproj ./ChessBackende8/
RUN dotnet restore ChessBackende8/ChessBackende8.csproj

# Copy the entire backend project and build
COPY ChessBackende8/ ./ChessBackende8/
WORKDIR /app/ChessBackende8
RUN dotnet publish -c Release -o /app/out

# Build Stage for Frontend
FROM node:18 AS frontend-build
WORKDIR /frontend

# Copy frontend project files and install dependencies
COPY ChessFrontend8/package*.json ./
RUN npm install

# Copy the rest of the frontend files and build
COPY ChessFrontend8/ ./
RUN npm run build  # Adjust this to your frontend's build command

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Copy backend build output
COPY --from=backend-build /app/out .

# Copy frontend build output
COPY --from=frontend-build /frontend/build ./wwwroot  # Assuming frontend builds to `build` folder

# Entry point for the backend
ENTRYPOINT ["dotnet", "ChessBackende8.dll"]
