#!/usr/bin/env bash
set -e

# Fonction de nettoyage complète (stoppe et supprime tout ce qui gêne)
cleanup() {
  docker rm -f api-test 2>/dev/null || true
}

# Trap en cas de plantage 
trap cleanup EXIT

# Faux secret
prepare_secret() {
  echo "//registry.npmjs.org/:_authToken=FAKE-123" > ~/.npmrc
}

echo "[*] Nettoyage des conteneurs de test existants..."
cleanup

echo "[*] #0 Préparation du faux secret ~/.npmrc..."
prepare_secret
echo ""

echo "[*] #1 Construction de l'image naïve (Dockerfile.naive)..."
docker build -q -f demo-api/api/Dockerfile.naive -t demo-api:naive ./demo-api/api/
echo ""

echo "[*] #2 Construction de l'image multi-étapes (Dockerfile.multi)..."
docker build -q --secret id=npmrc,src="$HOME/.npmrc" -f demo-api/api/Dockerfile.multi -t demo-api:multi ./demo-api/api/
echo ""

echo "--- Tableau comparatif des tailles ---"
docker image ls demo-api
echo ""

echo "--- Vérifications de sécurité et du multi-étapes ---"
echo ""

echo "[*] Vérification 1 : Preuve que le secret FAKE-123 n'apparaît pas dans l'historique :"
docker history --no-trunc demo-api:multi | grep -i FAKE-123 || true
echo ""

echo "[*] Vérification 2 : Preuve que /root/.npmrc n'existe pas dans l'image finale :"
MSYS_NO_PATHCONV=1 docker run --rm -u root demo-api:multi sh -c 'cat /root/.npmrc 2>&1' || true
echo ""

echo "[*] Vérification 3 : Contenu minimal de l'étape finale (/app) :"
MSYS_NO_PATHCONV=1 docker run --rm demo-api:multi ls -la /app
echo ""

echo "[*] Vérification 4 : Lancement et test de l'API multi-étapes sur le port 8080..."
docker run -d --name api-test -p 8080:3000 demo-api:multi

until curl -sf localhost:8080/health >/dev/null; do
  sleep 1
done

echo "[*] Résultat de curl sur /health :"
curl -s localhost:8080/health
echo ""
echo ""

echo "--- Vérifications terminées ! ---"
echo ""

trap - EXIT

echo "[*] #3 Nettoyage final des conteneurs de test..."
cleanup
echo ""

echo "Terminé !"