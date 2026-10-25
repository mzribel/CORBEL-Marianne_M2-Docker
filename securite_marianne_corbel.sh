#!/usr/bin/env bash
set -e

# Chargement des variables sensibles depuis le fichier .env
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo "Erreur : Le fichier .env est introuvable."
  exit 1
fi

# Fonction de nettoyage complète (stoppe et supprime tout ce qui gêne)
cleanup() {
  docker rm -f demo-db demo-api api 2>/dev/null || true
  docker network rm demo_net 2>/dev/null || true
}

# Trap en cas de plantage inattendu du script
trap cleanup EXIT

# Création + attente du fonctionnement de la base
start_db() {
  MSYS_NO_PATHCONV=1 docker run -d \
    --name demo-db \
    --network demo_net \
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

# Création + attente de fonctionnement de l'API durcie
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

echo "[*] Nettoyage des conteneurs et réseaux existants..."
cleanup

echo "[*] #0 Construction de l'image Docker durcie..."
docker build -t demo-api:hardened -f demo-api/api/Dockerfile demo-api/api/
echo ""

echo "[*] #1 Création du réseau commun..."
docker network create demo_net
echo ""

echo "[*] #2 Lancement du conteneur Postgres..."
start_db
echo ""

echo "[*] #3 Lancement de l'API durcie..."
start_api
echo ""

echo "--- Vérifications du durcissement ---"
echo ""

echo "[*] Vérification 1 : Preuve du non-root (id) :"
docker run --rm demo-api:hardened id
echo ""

echo "[*] Vérification 2 : Résultat de curl sur /health :"
curl -s localhost:8080/health
echo ""
echo ""

echo "[*] Vérification 3 : Test d'écriture sur le rootfs (doit être refusé) :"
docker exec demo-api sh -c 'touch /app/x 2>&1 || echo "rootfs read-only OK"'
echo ""

echo "[*] Vérification 4 : Docker inspect (ReadonlyRootfs et CapDrop) :"
docker inspect -f 'readonly={{.HostConfig.ReadonlyRootfs}} capdrop={{.HostConfig.CapDrop}}' demo-api
echo ""

echo "--- Vérifications terminées ! ---"
echo ""

trap - EXIT

echo "[*] #4 Nettoyage final des conteneurs et des réseaux..."
cleanup
echo ""

echo "Terminé !"