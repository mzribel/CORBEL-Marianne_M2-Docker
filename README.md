# Quête 6 - Réseaux

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Livrables

### Script bash

```bash
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
```

### Sortie du script 

```bash
$ bash reseaux_marianne_corbel.sh
[*] #0 Suppression des anciennes ressources si nécessaire...

[*] #1 Création des deux réseaux attendus...
6c76188fd429f932f98eaac71912aa5d43cbee63bbc275473c722034d3d2df71
04241a256a701d8b6944e1c11e1933a0d288faaea9e85b3e884ebf2b1e3bfdef

[*] #2 Lancement du conteneur Postgres (demo_back)...
69ed84748bb01c46f4a99069d195401d8608734d1c5957a74c4bacebca378bef
/var/run/postgresql:5432 - rejecting connections
/var/run/postgresql:5432 - accepting connections

[*] #3 Lancement de l'API sur (demo_front)...
a7b0821c8680d83f97e650d05d0d5ff3de46c4b5d1f49ca385a8cd9e893e6680

--- Vérifications ---

[*] Vérification 1 : demo-api joint demo-db par son nom :
172.19.0.2        demo-db  demo-db

[*] Vérification 2 : Un conteneur tiers n'atteint pas demo-db :
nc: getaddrinfo for host "demo-db" port 5432: Name does not resolve

[*] Vérification 3 : Adresses IPv4 sur chaque réseau :
--- demo-db ---
<nil> 172.19.0.2

--- demo-api ---
{  []} 172.19.0.3
<nil> 172.18.0.2

[*] Vérification 4 : Résultat de curl sur /products :
[
  {"id":4,"name":"Casquette D�mo","price_cents":1200,"created_at":"2026-10-25T19:48:58.508Z"},
  {"id":3,"name":"T-shirt conteneur","price_cents":1990,"created_at":"2026-10-25T19:48:56.366Z"},
  {"id":2,"name":"Mug Docker","price_cents":990,"created_at":"2026-10-25T19:48:56.366Z"},
  {"id":1,"name":"Sticker Demo","price_cents":150,"created_at":"2026-10-25T19:48:56.366Z"}
]

--- Vérifications terminées ! ---

[*] #4 Nettoyage final des conteneurs et des réseaux...
demo-db
demo-api
demo_front
demo_back

Terminé !
```
