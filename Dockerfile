FROM node:18

WORKDIR /usr/src/app

# Copy package.json + package-lock.json (instead of yarn.lock)
COPY package.json package-lock.json ./

# Install dependencies with npm
RUN npm ci

COPY . .

# Build with npm (and skip Payload init during build)
RUN SKIP_PAYLOAD_INIT=true npm run build

EXPOSE 3000

# Serve the app
CMD ["npm", "run", "serve"]
