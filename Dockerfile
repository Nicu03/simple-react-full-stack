FROM node:18-alpine AS build

WORKDIR /app
COPY package*.json ./
RUN npm ci && npm cache clean --force
COPY . .
RUN npm run build


FROM node:18-alpine AS production

RUN addgroup -g 1001 -S nodejs && \
    adduser -S -G nodejs -u 1001 reactuser
WORKDIR /app
COPY --from=build --chown=reactuser:nodejs /app/dist ./dist
COPY --from=build --chown=reactuser:nodejs /app/src/server ./src/server
COPY --from=build --chown=reactuser:nodejs /app/package*.json ./
RUN npm ci --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*
USER reactuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080 || exit 1
CMD ["node", "src/server/index.js"]
