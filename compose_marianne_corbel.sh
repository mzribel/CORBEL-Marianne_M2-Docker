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

# Fonction de nettoyage (supprime conteneurs + réseaux, garde le volume)
cleanup() {
  $COMPOSE down 2>/dev/null || true
}

# Trap en cas de plantage
trap cleanup EXIT

# Attente que db soit "healthy" (60 s max)
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

# Attente que l'API réponde (60 s max)
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

echo "[*] Le mot de passe ne doit pas être en clair dans .env :"
if grep -q '^POSTGRES_PASSWORD=' "$PROJECT_DIR/.env"; then
  echo "Attention : POSTGRES_PASSWORD est encore défini dans $PROJECT_DIR/.env."
else
  echo "OK : pas de POSTGRES_PASSWORD dans .env."
fi
echo ""

echo "[*] .env et le secret doivent être ignorés par Git :"
# Un appel par fichier : avec plusieurs chemins, check-ignore réussit dès qu'UN seul est ignoré
for f in "$PROJECT_DIR/.env" "$SECRET_FILE"; do
  git check-ignore -v "$f" || {
    echo "Erreur : $f n'est pas ignoré par Git (voir .gitignore)."
    exit 1
  }
done
echo ""

echo "[*] Validation du compose.yml (docker compose config) :"
$COMPOSE config >/dev/null
echo "OK : configuration valide."
echo ""

echo "[*] #0 Nettoyage complet (down -v : on repart d'une base vide)..."
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

echo "[*] Vérification 1 : État des services (db healthy, api Up) :"
$COMPOSE ps
echo ""

echo "[*] Vérification 2 : GET /products (données de init.sql) :"
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
if curl -s "localhost:$API_PORT/products" | grep -q '"Gourde"'; then
  echo "OK : « Gourde » est toujours présente (volume pgdata conservé)."
else
  echo "Erreur : « Gourde » a disparu après down/up."
  exit 1
fi
echo ""

echo "[*] Vérification 5 : Le secret est monté dans db (sans afficher son contenu) :"
$COMPOSE exec -T db sh -c 'test -s /run/secrets/db_password && echo "OK : /run/secrets/db_password présent"'
echo ""

echo "[*] Vérification 6 : Variables de mot de passe visibles dans db (seulement _FILE attendu) :"
$COMPOSE exec -T db env | grep PASSWORD || true
echo ""

echo "[*] Vérification 7 : Aucun mot de passe dans l'environnement déclaré des conteneurs (docker inspect) :"
for svc in db api; do
  if docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' "$($COMPOSE ps -q $svc)" \
      | grep -E '^(POSTGRES_PASSWORD|PGPASSWORD)='; then
    echo "Attention : mot de passe en clair dans l'environnement de $svc."
  else
    echo "OK : pas de mot de passe en clair dans l'environnement de $svc."
  fi
done
echo ""

echo "[*] Vérification 8 : db n'est pas publiée sur l'hôte :"
if $COMPOSE port db 5432 >/dev/null 2>&1; then
  echo "Attention : le port 5432 de db est publié."
else
  echo "OK : aucun port publié pour db."
fi
echo ""

echo "--- Vérifications terminées ! ---"
echo ""

trap - EXIT

echo "[*] #2 Nettoyage final (down, le volume pgdata est conservé)..."
cleanup
echo ""

echo "Terminé !"