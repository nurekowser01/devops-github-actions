FROM node:22-alpine AS builder
WORKDIR /build
COPY package*.json ./
RUN npm ci --omit=dev

FROM node:22-alpine AS runner
RUN apk add --no-cache dumb-init
ENV NODE_ENV=production
WORKDIR /app
COPY --from=builder /build/node_modules ./node_modules
COPY src ./src
COPY package.json ./
USER node
EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s --retries=3 \
  CMD node src/healthcheck.js

CMD ["dumb-init", "node", "src/server.js"]
