# ---------- 1. Build Stage ----------
FROM node:20 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (better caching)
COPY package*.json ./

# Install dependencies (safer than npm ci for now)
RUN npm install --legacy-peer-deps

# Copy the rest of the project
COPY . .

# Build the React app (Vite -> dist folder)
RUN npm run build


# ---------- 2. Production Stage ----------
FROM nginx:stable-alpine

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files from previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose container port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
