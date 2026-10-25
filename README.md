# Quête 3 : Sécurité

Suivant les rendus précédents et par simplicité, un script `securite_marianne_corbel.sh` regroupe toutes les commandes utilisées.

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Livrables

### Dockerfile

```bash
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
```

### Lancement de l'API

```bash
start_api() {
  docker run -d \
    --name demo-api \
    --network demo_net \
    -p 8080:3000 \
    --read-only \
    --tmpfs /tmp:size=16m \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    --pids-limit 200 \
    --memory 256m \
    --cpus 1 \
    -e PGHOST=demo-db \
    -e PGUSER=$POSTGRES_USER \
    -e PGPASSWORD=$POSTGRES_PASSWORD \
    -e PGDATABASE=$POSTGRES_DB \
    demo-api:hardened

  until curl -sf localhost:8080/health >/dev/null; do
    sleep 1
  done
}
```
(extrait du script)

### Vérifications du script 

```bash
--- Vérifications du durcissement ---

[*] Vérification 1 : Preuve du non-root (id) :
uid=1000(node) gid=1000(node) groups=1000(node)

[*] Vérification 2 : Résultat de curl sur /health :
{"status":"UP"}

[*] Vérification 3 : Test d'écriture sur le rootfs :
touch: /app/x: Read-only file system
rootfs read-only OK

[*] Vérification 4 : Docker inspect (ReadonlyRootfs et CapDrop) :
readonly=true capdrop=[ALL]

--- Vérifications terminées ! ---
```