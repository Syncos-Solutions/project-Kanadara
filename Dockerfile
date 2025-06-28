# ✅ Use Node >=18.12 to fix incompatibility with webpack-cli
FROM node:18.20.2-alpine as base

FROM base as builder

WORKDIR /home/node/app

# Copy package files
COPY package*.json ./
COPY yarn.lock ./

# ⚠️ Remove package-lock.json if present
RUN rm -f package-lock.json

# Copy rest of the app
COPY . .

# Install and build
RUN yarn install
RUN yarn build

FROM base as runtime

ENV NODE_ENV=production
ENV PAYLOAD_CONFIG_PATH=dist/payload.config.js

WORKDIR /home/node/app

# Copy only necessary files
COPY package*.json ./
COPY yarn.lock ./

# Install production deps only
RUN rm -f package-lock.json
RUN yarn install --production

# Copy built files
COPY --from=builder /home/node/app/dist ./dist
COPY --from=builder /home/node/app/build ./build

EXPOSE 3000

CMD ["node", "dist/server.js"]
