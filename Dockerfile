# Use official Node.js image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and lock file
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Build the app — run the *production build* script
RUN SKIP_PAYLOAD_INIT=true npm run build

# Expose port
EXPOSE 3000

# Start the production server
CMD ["npm", "run", "start"]
