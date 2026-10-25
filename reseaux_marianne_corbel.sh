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
  docker network rm demo_front demo_back 2>/dev/null || true
}
trap cleanup EXIT

# Création + attente du fonctionnement de la base
start_db() {
  MSYS_NO_PATHCONV=1 docker run -d \
    --name demo-db \
    --network demo_back \
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
    --network demo_front \
    -p 8080:3000 \
    -e PGHOST=demo-db \
    -e PGUSER=$POSTGRES_USER \
    -e PGPASSWORD=$POSTGRES_PASSWORD \
    -e PGDATABASE=$POSTGRES_DB \
    demo-api:1.0

  # Connexion de l'API au second réseau (demo_back) pour joindre la base
  docker network connect demo_back demo-api

  until curl -sf localhost:8080/health >/dev/null; do
    sleep 1
  done
}

echo "[*] #0 Suppression des anciennes ressources si nécessaire..."
docker rm -f demo-db demo-api 2>/dev/null || true
docker network rm demo_front demo_back 2>/dev/null || true
echo ""

echo "[*] #1 Création des deux réseaux attendus..."
docker network create demo_front
docker network create demo_back
echo ""

echo "[*] #2 Lancement du conteneur Postgres (demo_back)..."
start_db
echo ""

echo "[*] #3 Lancement de l'API sur (demo_front)..."
start_api
echo ""

echo "--- Vérifications ---"
echo ""

echo "[*] Vérification 1 : demo-api joint demo-db par son nom :"
docker exec demo-api getent hosts demo-db
echo ""

echo "[*] Vérification 2 : Un conteneur tiers n'atteint pas demo-db :"
docker run --rm --network demo_front nicolaka/netshoot nc -zv demo-db 5432 || true
echo ""

echo "[*] Vérification 3 : Adresses IPv4 sur chaque réseau :"
echo "--- demo-db ---"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAMConfig}} {{.IPAddress}}{{"\n"}}{{end}}' demo-db
echo "--- demo-api ---"
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAMConfig}} {{.IPAddress}}{{"\n"}}{{end}}' demo-api
echo ""

echo "[*] Vérification 4 : Résultat de curl sur /products :"
curl -s localhost:8080/products
echo ""
echo ""

echo "--- Vérifications terminées ! ---"
echo ""

trap - EXIT

echo "[*] #4 Nettoyage final des conteneurs et des réseaux..."
docker rm -f demo-db demo-api
docker network rm demo_front demo_back
echo ""

echo "Terminé !"