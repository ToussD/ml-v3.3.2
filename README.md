# Pensez comme un Datascientist — support de cours

Bienvenue dans la formation data science / machine learning.

## Prérequis

- **Docker** installé et fonctionnel (`docker --version` doit répondre).
- Le port **8888** doit être libre sur votre machine.

## Démarrage

### 1. Lancer l'environnement Jupyter

Depuis ce dossier, dans un terminal :

```sh
./cours-ml-exe.sh
```

Au premier lancement, Docker télécharge l'image de base et installe les
dépendances Python du cours (~1-2 minutes). Les exécutions suivantes sont
quasi instantanées grâce au cache.

Une fois le message *« Jupyter Server is running »* affiché, ouvrez votre
navigateur sur : <http://localhost:8888>

Les notebooks à exécuter pendant la formation sont dans le dossier `work/`
(depuis Jupyter, ils s'affichent à la racine).

### 2. Consulter les supports de cours

Ouvrez `cours.html` dans votre navigateur (double-clic suffit). Ça redirige
vers le site complet de la formation, avec toute la théorie, les exercices
corrigés et les démos.

Vous pouvez lire le cours **sans** avoir Docker lancé — le site HTML
fonctionne hors ligne.

### 3. Lancer le sandbox du module 6 (TP environnements Python)

Le module 6 — *Mise en production* — propose un TP de gestion d'environnements
Python (`venv`, `conda`, `pixi`) qui se fait **directement dans un terminal**,
pas dans Jupyter. Un conteneur sandbox dédié est fourni.

Depuis ce dossier, dans un terminal séparé :

```sh
./cours-ml-exe.sh sandbox
```

Vous tombez dans un shell `bash` avec `python`, `conda` et `pixi` déjà prêts
à l'emploi. Les instructions pas-à-pas sont dans le chapitre
*« TP — Gérer ses environnements Python au terminal »* du site du cours
(module 6). Ouvrez-le dans votre navigateur pendant que vous tapez les
commandes dans le terminal.

Pour quitter : tapez `exit` dans le conteneur.

## Arborescence

```
.
├── cours.html                Redirige vers cours/html/intro.html
├── cours/html/               Site complet du cours (HTML statique)
├── cours-ml-exe.sh           Script de lancement (Jupyter + sandbox)
├── requirements.txt          Dépendances Python (modifiable)
└── work/                     Dossier monté dans Jupyter
    ├── cours-exe/            Notebooks d'exercices suivis en cours
    ├── labs/                 Exercices pratiques (+ solutions)
    ├── demos/                Démos complémentaires
    ├── data/                 Jeux de données
    └── images/               Images utilisées par les notebooks
```

## En cas de problème

- **`./cours-ml-exe.sh: Permission denied`** : `chmod +x cours-ml-exe.sh`
- **Port 8888 déjà utilisé** : éditer le script et changer `JUPYTER_PORT=8888`
  (par exemple en `JUPYTER_PORT=8889`) puis ouvrir <http://localhost:8889>.
- **Docker indisponible** : installer Docker Desktop (Windows/Mac) ou le
  paquet `docker.io` (Linux), puis démarrer le daemon.
- **Un package manque dans un notebook** : ajouter la ligne dans
  `requirements.txt` et relancer `./cours-ml-exe.sh`.

Bonne formation !
