# Use official Node.js image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies with npm
RUN npm ci

# Copy the rest of your source code
COPY . .

# Build the app
RUN SKIP_PAYLOAD_INIT=true npm run build

# Expose the port
EXPOSE 3000

# Serve the app (production)
CMD ["npm", "run", "serve"]
