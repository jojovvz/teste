# Etapa para build do backend
FROM node:18 AS backend-build
WORKDIR /app/backend
COPY backend /app/backend
RUN npm install --force && npm run build

# Etapa para build do frontend
FROM node:18 AS frontend-build
WORKDIR /app/frontend
COPY frontend /app/frontend
RUN npm install && npm run build

# Imagem final para produção
FROM node:18 AS production
WORKDIR /app

# Copiar os builds do backend e frontend
COPY --from=backend-build /app/backend /app/backend
COPY --from=frontend-build /app/frontend /app/frontend

# Instalar PM2 para gerenciar os processos
RUN npm install -g pm2

# Expor as portas configuráveis
EXPOSE ${BACKEND_PORT} ${FRONTEND_PORT}

# Usar variáveis de ambiente para iniciar a aplicação
CMD ["pm2-runtime", "start", "--name", "backend", "/app/backend/dist/server.js", "--name", "frontend", "/app/frontend/dist/server.js"]
