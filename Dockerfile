# Use Node.js 20 to fix engine compatibility issues
FROM node:20-alpine

# Install necessary build tools
RUN apk add --no-cache python3 make g++

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies with increased memory and timeout
RUN npm ci --legacy-peer-deps --maxsockets 1 --network-timeout 600000

# Copy source code
COPY . .

# Set build environment variables
ENV NODE_ENV=production
ENV SKIP_PAYLOAD_INIT=true
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start the application
CMD ["npm", "run", "start"]
