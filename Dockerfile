# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the entire app
COPY . .

# Build app (skip Payload init at build time)
RUN SKIP_PAYLOAD_INIT=true yarn build

# Expose port
EXPOSE 3000

# Start the production server
CMD ["yarn", "serve"]
