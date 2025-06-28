# Use Node.js 20 to fix engine compatibility issues
FROM node:20-alpine

# Install necessary build tools
RUN apk add --no-cache python3 make g++

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Set environment variables before install
ENV NODE_OPTIONS="--max-old-space-size=6144"
ENV SKIP_PAYLOAD_INIT=true

# Install ALL dependencies first (including devDependencies for build)
RUN npm ci --legacy-peer-deps --maxsockets 1 --network-timeout 600000 --prefer-offline

# Copy source code
COPY . .

# Set production environment for build
ENV NODE_ENV=production

# Build the application with fallback strategy
RUN npm run build || (echo "Build failed, trying individual steps..." && npm run build:payload && npm run build:server && npm run copyfiles && npm run build:next)

# Remove dev dependencies AFTER build to reduce image size
RUN npm prune --production

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
