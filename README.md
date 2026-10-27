# Quête 4 : Multi-étapes et secrets

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Livrables

### Dockerfile lourd (node 22)

```bash
FROM node:22
WORKDIR /app
COPY . .
RUN npm ci
CMD ["node", "server.js"]
```

### Dockerfile léger et robuste (alpine)
```bash
# syntax=docker/dockerfile:1

# Étape 1 : Installation des dépendances (deps)
FROM node:22.11-alpine AS deps
WORKDIR /app

COPY package.json package-lock.json ./

# Secret sécurisé
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm ci --omit=dev && npm cache clean --force

# Étape 2 : Image durcie et plus légère 
FROM node:22.11-alpine
WORKDIR /app

COPY --chown=node:node --from=deps /app/node_modules ./node_modules
COPY --chown=node:node server.js db.js package.json ./

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/health').then(r => r.ok ? process.exit(0) : process.exit(1)).catch(() => process.exit(1))"

USER node

CMD ["node", "server.js"]
```

### Vérifications

Extrait du script `multistage_marianne_corbel.sh`:
```bash
--- Tableau comparatif des tailles ---
REPOSITORY   TAG        IMAGE ID       CREATED          SIZE
demo-api     multi      a2929c517932   1 second ago     228MB   <--
demo-api     naive      09adfc964027   11 seconds ago   1.64GB  <-- 
demo-api     hardened   6235113ff514   40 hours ago     249MB
demo-api     1.0        953fdfb7d209   41 hours ago     249MB

--- Vérifications de sécurité et du multi-étapes ---

[*] Vérification 1 : Preuve que le secret FAKE-123 n'apparaît pas dans l'historique :

[*] Vérification 2 : Preuve que /root/.npmrc n'existe pas dans l'image finale :
cat: can't open '/root/.npmrc': No such file or directory

[*] Vérification 3 : Contenu minimal de l'étape finale (/app) :
total 24
drwxr-xr-x    1 root     root          4096 Oct 27 12:40 .
drwxr-xr-x    1 root     root          4096 Oct 27 12:40 ..
-rwxr-xr-x    1 node     node          1326 Oct 25 19:31 db.js
drwxr-xr-x   84 node     node          4096 Oct 27 12:40 node_modules
-rwxr-xr-x    1 node     node           401 Oct 25 19:31 package.json
-rwxr-xr-x    1 node     node          2925 Oct 25 19:31 server.js

[*] Vérification 4 : Lancement et test de l'API multi-étapes sur le port 8080...
97a0822dd69198b190a7109c7425a39f2fbceb90832f2e892a741a3c9c5c7d08
[*] Résultat de curl sur /health :
{"status":"UP"}

--- Vérifications terminées ! ---
```