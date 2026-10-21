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

# Fonction de nettoyage en cas de plantage
cleanup() {
  docker rm -f demo-db demo-api 2>/dev/null || true
  docker network rm demo-net 2>/dev/null || true
}
trap cleanup EXIT

# Création + attente du fonctionnement de la base
start_db() {
  MSYS_NO_PATHCONV=1 docker run -d \
    --name demo-db \
    --network demo-net \
    -v demo_pgdata:/var/lib/postgresql/data \
    -v "$PWD/demo-api/db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro" \
    -e POSTGRES_USER=$POSTGRES_USER \
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    -e POSTGRES_DB=$POSTGRES_DB \
    postgres:16-alpine

  until docker exec demo-db pg_isready -U $POSTGRES_USER; do
    sleep 1
  done
}

# Création + attente de fonctionnement de l'API
start_api() {
  docker rm -f demo-api 2>/dev/null || true
  docker run -d \
    --name demo-api \
    --network demo-net \
    -p 8080:3000 \
    -e PGHOST=demo-db \
    -e PGUSER=$POSTGRES_USER \
    -e PGPASSWORD=$POSTGRES_PASSWORD \
    -e PGDATABASE=$POSTGRES_DB \
    demo-api:1.0

  until curl -sf localhost:8080/health >/dev/null; do
    sleep 1
  done
}

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

echo "[*] #3 Création du conteneur Postgres..."
start_db
echo ""

echo "[*] #5 Création de l'API..."
start_api
echo ""

echo "[*] #6 Ajout d'un produit via l'API..."
curl -s -X POST -H 'content-type: application/json' \
  -d '{"name":"Casquette Démo","price_cents":1200}' \
  http://localhost:8080/products
echo ""
echo "" # smh

echo "[*] #7 Suppression du conteneur de base de données..."
docker rm -f demo-db

echo "[*] #7 Recréation du conteneur de base avec le même volume..."
start_db

echo "[*] #7 Relance de l'API..."
start_api
echo "" 

echo "[*] #8 Vérification du volume et test de persistance :"
docker volume ls | grep demo_pgdata
curl -s http://localhost:8080/products
echo ""

trap - EXIT

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

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/jd54uwzfxm9majrasslsjq2b8

[*] #2 Création du réseau et du named volume...
565a851032d05274f3a8501042e86fee8b7eaae133a13ef5ea051d3024dd96ef
demo_pgdata

[*] #3 Création du conteneur Postgres...
d030bba567ccd6ecf5514b5ade3ac9dd810828058ef665ce2428b34d3675f8a6
/var/run/postgresql:5432 - no response
/var/run/postgresql:5432 - accepting connections

[*] #5 Création de l'API...
31761fb73d4323d67f1898d1cc8e9966b7d63f259432654074ddb9d85b5ee196

[*] #6 Ajout d'un produit via l'API...
{"id":4,"name":"Casquette D�mo","price_cents":1200,"created_at":"2026-10-21T11:31:28.230Z"}

[*] #7 Suppression du conteneur de base de données...
demo-db
[*] #7 Recréation du conteneur de base avec le même volume...
02417be7f852a6b737b43e637a22f9ee3f0b8598d1fbcd111af849e5feee3c7c
/var/run/postgresql:5432 - no response
/var/run/postgresql:5432 - rejecting connections
/var/run/postgresql:5432 - rejecting connections
/var/run/postgresql:5432 - rejecting connections
/var/run/postgresql:5432 - accepting connections
[*] #7 Relance de l'API...
demo-api
26cf3e08384076efe0af4ae027550daaa9e63478e81e633ee4ab7135635c1cf2

[*] #8 Vérification du volume et test de persistance :
local     demo_pgdata
[
  {"id":4,"name":"Casquette D�mo","price_cents":1200,"created_at":"2026-10-21T11:31:28.230Z"},
  {"id":3,"name":"T-shirt conteneur","price_cents":1990,"created_at":"2026-10-21T11:31:23.576Z"},
  {"id":2,"name":"Mug Docker","price_cents":990,"created_at":"2026-10-21T11:31:23.576Z"},
  {"id":1,"name":"Sticker Demo","price_cents":150,"created_at":"2026-10-21T11:31:23.576Z"}
]
[*] Nettoyage final des conteneurs et du réseau...
demo-db
demo-api
demo-net

Terminé !
```