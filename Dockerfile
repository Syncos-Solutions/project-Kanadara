# Use official Node.js image
FROM node:18

# Create app directory
WORKDIR /usr/src/app

# Copy package.json and yarn.lock / package-lock.json
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the app source code
COPY . .

# Expose the port your app runs on
EXPOSE 3000

# Run your dev script (npm run dev or yarn dev)
CMD ["yarn", "dev"]
