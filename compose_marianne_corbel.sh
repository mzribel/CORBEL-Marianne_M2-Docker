#!/usr/bin/env bash
set -e

PROJECT_DIR="demo-api"
COMPOSE="docker compose -f $PROJECT_DIR/compose.yml"
SECRET_FILE="$PROJECT_DIR/secrets/db_password.txt"

# Chargement des variables depuis demo-api/.env
if [ -f "$PROJECT_DIR/.env" ]; then
  set -a
  . "$PROJECT_DIR/.env"
  set +a
else
  echo "Erreur : $PROJECT_DIR/.env est introuvable (cp $PROJECT_DIR/.env.example $PROJECT_DIR/.env)."
  exit 1
fi
API_PORT="${API_PORT:-8080}"

# Fonction de nettoyage
cleanup() {
  $COMPOSE down 2>/dev/null || true
}

# Trap en cas de plantage
trap cleanup EXIT

wait_db_healthy() {
  for i in $(seq 1 60); do
    status=$(docker inspect -f '{{.State.Health.Status}}' "$($COMPOSE ps -q db)" 2>/dev/null || true)
    if [ "$status" = "healthy" ]; then
      echo "db : healthy"
      return 0
    fi
    sleep 1
  done
  echo "Erreur : db n'est pas healthy après 60 s."
  $COMPOSE logs db | tail -20
  exit 1
}

# Attente que l'API réponde (60s max)
wait_api() {
  for i in $(seq 1 60); do
    if curl -sf "localhost:$API_PORT/health" >/dev/null; then
      echo "api : répond sur le port $API_PORT"
      return 0
    fi
    sleep 1
  done
  echo "Erreur : l'API ne répond pas après 60 s."
  $COMPOSE logs api | tail -20
  exit 1
}

create_secret() {
  if [ ! -t 0 ]; then
    echo "Erreur : saisie impossible (script non interactif)."
    echo "Créez-le avec : mkdir -p $(dirname "$SECRET_FILE") && printf '%s' 'mot-de-passe' > $SECRET_FILE"
    exit 1
  fi

  while true; do
    read -r -s -p "Mot de passe de la base : " password
    echo ""
    if [ -z "$password" ]; then
      echo "Le mot de passe ne peut pas être vide."
      continue
    fi
    read -r -s -p "Confirmation : " confirm
    echo ""
    if [ "$password" = "$confirm" ]; then
      break
    fi
    echo "Les deux saisies diffèrent, recommencez."
  done
  unset confirm

  mkdir -p "$(dirname "$SECRET_FILE")"
  printf '%s' "$password" > "$SECRET_FILE"
  chmod 644 "$SECRET_FILE"
  unset password
}

echo "--- Vérifications préalables ---"
echo ""

echo "[*] Présence du secret $SECRET_FILE :"
if [ -s "$SECRET_FILE" ]; then
  echo "OK : le fichier existe et n'est pas vide."
else
  echo "Absent ou vide : création du secret."
  create_secret
  echo "OK : $SECRET_FILE créé."
  echo "Pour le lire (connexion Adminer) : cat $SECRET_FILE"
fi
echo ""

echo "[*] Validation du compose.yml (docker compose config) :"
$COMPOSE config >/dev/null
echo "OK : configuration valide."
echo ""

echo "[*] #0 Nettoyage complet (down -v)..."
$COMPOSE down -v 2>/dev/null || true
echo ""

echo "[*] #1 Construction et lancement de la stack..."
$COMPOSE build -q
$COMPOSE up -d
wait_db_healthy
wait_api
echo ""

echo "--- Vérifications du TP ---"
echo ""

echo "[*] Vérification 1 : État des services :"
$COMPOSE ps
echo ""

echo "[*] Vérification 2 : GET /products :"
curl -s "localhost:$API_PORT/products"
echo ""
echo ""

echo "[*] Vérification 3 : POST /products (ajout de « Gourde ») :"
curl -s -X POST -H 'content-type: application/json' \
  -d '{"name":"Gourde","price_cents":900}' "localhost:$API_PORT/products"
echo ""
echo ""

echo "[*] Vérification 4 : Persistance après down puis up :"
$COMPOSE down
$COMPOSE up -d
wait_db_healthy
wait_api
curl -s "localhost:$API_PORT/products"
echo ""
echo ""

echo "--- Vérifications terminées ! ---"
echo ""

trap - EXIT

echo "[*] #2 Nettoyage final (down, le volume pgdata est conservé)..."
cleanup
echo ""

echo "Terminé !"