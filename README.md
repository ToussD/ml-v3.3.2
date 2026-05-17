# Pensez comme un Datascientist — support de cours

Bienvenue dans la formation data science / machine learning.

## Prérequis

- **Docker** installé et fonctionnel (`docker --version` doit répondre).
- **make** disponible (déjà présent sur Linux/macOS ; sur Windows, via WSL ou
  les *Build Tools for Visual Studio*).
- **git** installé (pour les mises à jour en cours de formation).
- Le port **8888** doit être libre sur votre machine.

## Démarrage rapide

Toutes les commandes utiles passent par `make` :

```sh
make            # Affiche la liste des commandes
make jupyter    # Démarre Jupyter dans Docker (http://localhost:8888)
make cours      # Ouvre le cours HTML dans votre navigateur
make sandbox    # Démarre le sandbox conda/pixi du TP module 6
make update     # Récupère les dernières mises à jour depuis GitHub
make status     # État (Jupyter actif ? Mises à jour dispo ?)
make backup     # Sauvegarde manuelle de vos notebooks d'exercice
make clean-backups  # Purge les anciennes sauvegardes
```

### 1. Lancer Jupyter

```sh
make jupyter
```

Au premier lancement, Docker télécharge l'image de base et installe les
dépendances Python du cours (~1-2 minutes). Les exécutions suivantes sont
quasi instantanées grâce au cache. Une fois *« Jupyter Server is running »*
affiché, ouvrez <http://localhost:8888>. Les notebooks sont dans `work/`.

### 2. Consulter les supports de cours

```sh
make cours
```

Ouvre `cours/html/intro.html` dans votre navigateur. Le cours est entièrement
hors ligne — pas besoin de Docker pour le lire.

### 3. Sandbox du module 6 (TP environnements Python)

```sh
make sandbox
```

Le module 6 — *Mise en production* — propose un TP de gestion d'environnements
Python (`venv`, `conda`, `pixi`) qui se fait directement dans un terminal,
pas dans Jupyter. Cette commande vous tombe dans un shell avec `python`,
`conda` et `pixi` prêts à l'emploi. Suivez les instructions pas-à-pas du
chapitre *« TP — Gérer ses environnements Python au terminal »* dans le
site du cours. Pour quitter : `exit`.

## Mettre à jour le cours pendant la formation

Le formateur peut publier des corrections / améliorations sur GitHub pendant
la formation. Pour récupérer les dernières mises à jour :

```sh
make update
```

**Ce qui est mis à jour** : la théorie, les démos, les corrigés d'exercice,
le site HTML, les datasets et images. Tout ce qui vient du formateur est
réaligné sur la version GitHub.

**Ce qui est préservé** : **vos notebooks d'exercice** (les `.ipynb` dans
`work/labs/` qui ne sont pas des solutions). Avant le `git reset`, ils sont
sauvegardés dans `.backups/<horodatage>/`, puis restaurés par-dessus le
contenu GitHub. Votre travail prime sur la version du formateur.

**Important** :

- **Arrêtez Jupyter avant de lancer `make update`** (Ctrl+C dans le terminal
  où il tourne, puis `y`). La commande refuse de démarrer sinon, pour éviter
  qu'un kernel écrive dans un notebook au moment où on le bouge.
- Les sauvegardes s'accumulent dans `.backups/` — utilisez `make clean-backups`
  pour purger.

## Arborescence

```
.
├── Makefile                  Commandes make (ce dont on parle ci-dessus)
├── cours.html                Redirige vers cours/html/intro.html
├── cours/html/               Site complet du cours (HTML statique)
├── cours-ml-exe.sh           Script de lancement Docker (utilisé par `make jupyter`)
├── requirements.txt          Dépendances Python (modifiable)
├── README.md                 Ce fichier
├── .scripts/                 Scripts utilisés par les cibles `make`
├── .backups/                 Sauvegardes des exercices (créé à la 1re update)
└── work/                     Dossier monté dans Jupyter
    ├── cours-exe/            Notebooks suivis en cours
    ├── labs/                 Exercices pratiques (+ solutions)
    ├── demos/                Démos complémentaires
    ├── data/                 Jeux de données
    └── images/               Images utilisées par les notebooks
```

## En cas de problème

- **`make: command not found`** : installer `make` (`sudo apt install make`
  sur Linux ; via *Xcode Command Line Tools* sur macOS ; via WSL sur Windows).
- **`./cours-ml-exe.sh: Permission denied`** : `chmod +x cours-ml-exe.sh`
- **Port 8888 déjà utilisé** : éditer `cours-ml-exe.sh` et changer
  `JUPYTER_PORT=8888` (par exemple en `JUPYTER_PORT=8889`), puis ouvrir
  <http://localhost:8889>.
- **Docker indisponible** : installer Docker Desktop (Windows/Mac) ou le
  paquet `docker.io` (Linux), puis démarrer le daemon.
- **Un package manque dans un notebook** : ajouter la ligne dans
  `requirements.txt` et relancer `make jupyter`.
- **`make update` refuse de tourner — "Jupyter est en cours d'exécution"** :
  c'est normal et c'est de la protection. Arrêtez Jupyter d'abord
  (`docker stop cours-ml` ou Ctrl+C dans son terminal).

Bonne formation !
