# ---------- 1. Build Stage ----------
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Build the React app (Vite creates 'dist' folder)
RUN npm run build

# ---------- 2. Production Stage ----------
FROM nginx:stable-alpine

# Copy build files from previous stage to Nginx folder
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
