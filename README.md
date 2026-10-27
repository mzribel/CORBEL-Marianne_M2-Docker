# Quête 7 : Docker Composz

Attention : Afin de ne pas renseigner de secret dans le script, celui-ci utilise un fichier `.env`.
Pensez à créer celui-ci avant de lancer le script, en utilisant `.env.example` comme base.

## Prérequis

Installés sur la machine : 
- Docker & Docker Compose

Copier le fichier de variables d'environnements et en modifier les valeurs :
```bash
cp demo-api/.env.example demo-api/.env
```

Créer le fichier contenant le mdp de la base (en remplaçant `valeur` par le vrai mdp) : 
```
mkdir -p demo-api/secrets
echo "valeur" > secrets/db_password.txt
```

## Script
Pour aller dans la continuité des TP précédents, un petit script `compose_marianne_corbel` a été créé.
    
Il vérifie l'existence des variables d'environnement et de `db_password.txt`, et propose la création de celui-ci s'il existe pas.

Il réalise ensuite toutes les commandes de vérifications demandées dans les consignes du TP.

## Vérification du fonctionnement 

Extrait de la sortie du script `compose_marianne_corbel.sh`:
```bash
--- Vérifications du TP ---

[*] Vérification 1 : État des services :
NAME                 IMAGE                COMMAND                  SERVICE   CREATED         STATUS                           PORTS
demo-api-adminer-1   adminer:4            "entrypoint.sh docke…"   adminer   7 seconds ago   Up 6 seconds                     0.0.0.0:8081->8080/tcp, [::]:8081->8080/tcp
demo-api-api-1       demo-api-api         "docker-entrypoint.s…"   api       7 seconds ago   Up 1 second (health: starting)   0.0.0.0:8080->3000/tcp, [::]:8080->3000/tcp
demo-api-db-1        postgres:16-alpine   "docker-entrypoint.s…"   db        7 seconds ago   Up 6 seconds (healthy)

[*] Vérification 2 : GET /products :
[
    {"id":3,"name":"T-shirt conteneur","price_cents":1990,"created_at":"2026-10-27T16:26:39.233Z"},
    {"id":2,"name":"Mug Docker","price_cents":990,"created_at":"2026-10-27T16:26:39.233Z"},
    {"id":1,"name":"Sticker Demo","price_cents":150,"created_at":"2026-10-27T16:26:39.233Z"}
]

[*] Vérification 3 : POST /products (ajout de « Gourde ») :
{"id":4,"name":"Gourde","price_cents":900,"created_at":"2026-10-27T16:26:44.902Z"}

[*] Vérification 4 : Persistance après down puis up :
[+] Running 5/5
 ✔ Container demo-api-api-1        Removed 0.4s
 ✔ Container demo-api-adminer-1    Removed 0.5s
 ✔ Container demo-api-db-1         Removed 0.2s
 ✔ Network demo-api_demo_front     Removed 0.5s
 ✔ Network demo-api_demo_back      Removed 0.2s
[+] Running 5/5
 ✔ Network demo-api_demo_back    Created                                                                                                                                                                                                                                  0.0s
 ✔ Network demo-api_demo_front   Created                                                                                                                                                                                                                                  0.0s
 ✔ Container demo-api-db-1       Healthy                                                                                                                                                                                                                                  5.9s
 ✔ Container demo-api-api-1      Started                                                                                                                                                                                                                                  6.1s
 ✔ Container demo-api-adminer-1  Started                                                                                                                                                                                                                                  0.6s
db : healthy
api : répond sur le port 8080
[
    {"id":4,"name":"Gourde","price_cents":900,"created_at":"2026-10-27T16:26:44.902Z"},
    {"id":3,"name":"T-shirt conteneur","price_cents":1990,"created_at":"2026-10-27T16:26:39.233Z"},
    {"id":2,"name":"Mug Docker","price_cents":990,"created_at":"2026-10-27T16:26:39.233Z"},
    {"id":1,"name":"Sticker Demo","price_cents":150,"created_at":"2026-10-27T16:26:39.233Z"}
]

--- Vérifications terminées ! ---
```

