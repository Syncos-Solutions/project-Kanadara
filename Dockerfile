# Use Node.js 20 to fix engine compatibility issues
FROM node:20-alpine

# Install necessary build tools
RUN apk add --no-cache python3 make g++

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Set environment variables
ENV NODE_OPTIONS="--max-old-space-size=6144"
ENV SKIP_PAYLOAD_INIT=true
ENV NODE_ENV=production

# Install ALL dependencies first (including devDependencies for build)
RUN npm ci --legacy-peer-deps --maxsockets 1 --network-timeout 600000

# Copy source code
COPY . .

# Build only Next.js and copy files - skip TypeScript server compilation
RUN npm run copyfiles && npm run build:next

# Create a simple start script that uses ts-node for runtime
RUN echo '#!/bin/sh\nexec npx ts-node --transpile-only src/server.ts' > start.sh && chmod +x start.sh

# Expose port
EXPOSE 3000

# Start with ts-node at runtime instead of compiled JS
CMD ["./start.sh"]
