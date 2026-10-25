# 1. Base épinglée
FROM node:22-alpine

WORKDIR /app

# 2. Copie des dépendances (utilisateur node)
COPY --chown=node:node package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# 3. Copie du code source avec le bon propriétaire
COPY --chown=node:node . .

# 4. Port exposé (≥ 1024)
EXPOSE 3000

# 5. Ajout d'un healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/health').then(r => r.ok ? process.exit(0) : process.exit(1)).catch(() => process.exit(1))"

# 6. Utilisateur non-root
USER node

# 7. Lancement de l'application
CMD ["node", "server.js"]