# Quête 5

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Livrables

### Script bash

```sh
# Chargement des variables sensibles depuis le fichier .env
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo "Erreur : Le fichier .env est introuvable."
  exit 1
fi

echo "[*] #0 Suppression des anciennes ressources si nécessaire..."
docker rm -f demo-db demo-api 2>/dev/null || true
docker network rm demo-net 2>/dev/null || true
docker volume rm demo_pgdata 2>/dev/null || true
echo "" 

echo "[*] #1 Construction de l'image Docker de l'API..."
docker build -t demo-api:1.0 ./demo-api/api
echo ""

echo "[*] #2 Création du réseau et du named volume..."
docker network create demo-net
docker volume create demo_pgdata
echo ""

echo "[*] #3 Lancement du conteneur Postgres..."
MSYS_NO_PATHCONV=1 docker run -d \
  --name demo-db \
  --network demo-net \
  -v demo_pgdata:/var/lib/postgresql/data \
  -v "$PWD/demo-api/db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  postgres:16-alpine
echo "" 

echo "[*] #4 En attente que PostgreSQL soit prêt..."
until docker exec demo-db pg_isready -U $POSTGRES_USER; do
  sleep 2
done
echo ""

echo "[*] #5 Lancement de l'API..."
docker run -d \
  --name demo-api \
  --network demo-net \
  -p 8080:3000 \
  -e PGHOST=demo-db \
  -e PGUSER=$POSTGRES_USER \
  -e PGPASSWORD=$POSTGRES_PASSWORD \
  -e PGDATABASE=$POSTGRES_DB \
  demo-api:1.0
echo ""

echo "[*] #6 Ajout d'un produit via l'API..."
curl -s -X POST -H 'content-type: application/json' \
  -d '{"name":"Casquette Démo","price_cents":1200}' \
  http://localhost:8080/products
echo ""

echo "[*] #7 Suppression du conteneur de base de données..."
docker rm -f demo-db

echo "[*] #7 Recréation du conteneur de base avec le même volume..."
docker run -d \
  --name demo-db \
  --network demo-net \
  -v demo_pgdata:/var/lib/postgresql/data \
  -v "$PWD/demo-api/db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  postgres:16-alpine

echo "[*] #7 Attente que la base recréée soit prête..."
until docker exec demo-db pg_isready -U $POSTGRES_USER; do
  sleep 2
done
echo ""

echo "[*] #8 Vérification du volume et test de persistance (GET products) :"
docker volume ls | grep demo_pgdata
curl -s http://localhost:8080/products
echo ""

echo "[*] Nettoyage final des conteneurs et du réseau..."
docker rm -f demo-db demo-api
docker network rm demo-net
# docker volume rm demo_pgdata
echo ""

echo "Terminé !"
```

### Sortie du script 
```sh
$ bash volumes_marianne_corbel.sh
[*] #0 Suppression des anciennes ressources si nécessaire...
demo_pgdata

[*] #1 Construction de l'image Docker de l'API...
#0 building with "desktop-linux" instance using docker driver
# ... 
#10 DONE 0.1s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/lm2kjrzwhbknj7kb8yx8uqr2n

[*] #2 Création du réseau et du named volume...
4976055c727796798fa1902d314903374d5c66b3f6b805e75fc1a69a683fcd22
demo_pgdata

[*] #3 Lancement du conteneur Postgres...
a44fec00edeb4d8a6a5db321da62f63453c06b885e0b89a2a622bd2b6bdb6e19

[*] #4 En attente que PostgreSQL soit prêt...
/var/run/postgresql:5432 - no response
/var/run/postgresql:5432 - accepting connections

[*] #5 Lancement de l'API...
97005410efdfed98e0ca1a7f0adac4adb11b7e0463b0bde3095f1382cfd05cec

[*] #6 Ajout d'un produit via l'API...

[*] #7 Suppression du conteneur de base de données...
demo-db
[*] #7 Recréation du conteneur de base avec le même volume...
51bd858f3dc84d017baf94c2d1a54709301460c4a0d1017c3aa52f8f4e540810
[*] #7 Attente que la base recréée soit prête...
/var/run/postgresql:5432 - rejecting connections
/var/run/postgresql:5432 - accepting connections

[*] #8 Vérification du volume et test de persistance (GET products) :
local     demo_pgdata
[
    {"id":3,"name":"T-shirt conteneur","price_cents":1990,"created_at":"2026-10-21T10:57:45.027Z"},
    {"id":2,"name":"Mug Docker","price_cents":990,"created_at":"2026-10-21T10:57:45.027Z"},
    {"id":1,"name":"Sticker Demo","price_cents":150,"created_at":"2026-10-21T10:57:45.027Z"}
]
[*] Nettoyage final des conteneurs et du réseau...
demo-db
demo-api
demo-net

Terminé !
```