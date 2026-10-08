FROM node:22-alpine

WORKDIR /app

# Copie des fichiers de dépendances puis installation
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
# Copie du code source
COPY . .

#Port exposé
EXPOSE 3000

# Commandes après initialisation
CMD ["node", "server.js"]