# Use the Node alpine official image
FROM node:lts-alpine

ENV PORT=3000
ENV HOST=0.0.0.0

# Create and change to the app directory.
WORKDIR /app

# Copy dependency manifests first for better caching
COPY package*.json ./

# Install ALL dependencies (including dev) for build process
RUN npm ci

# Copy the rest of the application AFTER installing dependencies
COPY . ./

# Build the application with all dependencies available
RUN npm run build

# Remove dev dependencies after build to reduce image size
RUN npm prune --omit=dev && npm cache clean --force

EXPOSE $PORT

ENV NUXT_HOST=$HOST
ENV NUXT_PORT=$PORT

CMD ["node", ".output/server/index.mjs"]
