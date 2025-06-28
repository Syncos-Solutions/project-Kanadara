# Use Node.js 20 to fix engine compatibility issues
FROM node:20-alpine

# Install necessary build tools
RUN apk add --no-cache python3 make g++

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Set environment variables before install
ENV NODE_ENV=production
ENV NODE_OPTIONS="--max-old-space-size=6144"
ENV SKIP_PAYLOAD_INIT=true

# Install dependencies with optimized settings
RUN npm ci --legacy-peer-deps --maxsockets 1 --network-timeout 600000 --prefer-offline

# Copy source code
COPY . .

# Build with verbose logging and timeout handling
RUN timeout 600 npm run build || (echo "Build timed out, retrying..." && npm run build:payload && npm run build:server && npm run copyfiles && npm run build:next)

# Remove dev dependencies to reduce image size
RUN npm prune --production

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
