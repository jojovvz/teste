# Backend build
FROM node:18 AS backend-build
WORKDIR /app/backend
COPY backend /app/backend
RUN npm install --force && npm run build

# Frontend build
FROM node:18 AS frontend-build
WORKDIR /app/frontend
COPY frontend /app/frontend
RUN npm install && npm run build

# Final production image
FROM node:18 AS production
WORKDIR /app
COPY --from=backend-build /app/backend /app/backend
COPY --from=frontend-build /app/frontend /app/frontend
RUN npm install -g pm2

# Expose necessary ports
EXPOSE 3000 4000

# Start backend and frontend
CMD ["pm2-runtime", "start", "--name", "backend", "/app/backend/dist/server.js", "--name", "frontend", "/app/frontend/dist/server.js"]
