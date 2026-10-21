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