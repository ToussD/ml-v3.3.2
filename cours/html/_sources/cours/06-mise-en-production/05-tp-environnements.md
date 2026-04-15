# TP — Gérer ses environnements Python au terminal

```{admonition} Objectifs du TP
:class: tip
- Créer un environnement Python avec **trois outils différents** : `venv`, `conda`, `pixi`.
- Figer les dépendances dans un fichier versionnable (`requirements.txt`, `environment.yml`, `pixi.toml`).
- **Comparer par vous-même** la rapidité, l'ergonomie et la reproductibilité.
- Reproduire l'environnement à partir du fichier figé (le critère numéro 1 en production).
```

Ce TP se fait **entièrement dans un terminal** — pas dans un notebook. L'idée est d'utiliser les outils **comme vous le feriez sur une vraie machine de travail**, sans la couche Jupyter.

## Lancer le conteneur sandbox

Depuis la **racine du dossier stagiaire** (là où se trouvent `cours-ml-exe.sh` et `sandbox-exe.sh`), ouvrez un terminal et lancez :

```sh
./sandbox-exe.sh
```

Ce script démarre un conteneur `continuumio/miniconda3` interactif avec :

- **conda** et **Python 3.11** déjà installés ;
- **pixi** installé automatiquement au démarrage ;
- le dossier `tp-sandbox/` monté sur `/workspace` (les fichiers que vous créez persistent) ;
- un prompt `bash` dans lequel vous allez taper toutes les commandes.

Quand vous voyez le prompt `(base) $`, vous êtes dedans. Vérifiez que les trois outils fonctionnent :

```bash
python --version
conda --version
pixi --version
```

Les trois doivent répondre sans erreur. **Si c'est le cas, vous êtes prêt à commencer.** Pour quitter le conteneur, tapez `exit` — tout ce que vous avez créé dans `/workspace` reste sur votre machine hôte.

## Partie 1 — `venv` et `pip`

### Étape 1.1 : Créer un environnement venv

Placez-vous dans le dossier de travail et créez un premier environnement :

```bash
cd /workspace
mkdir projet-venv && cd projet-venv
python -m venv .venv
```

**Observez** ce qui a été créé :

```bash
ls -la .venv/
```

Vous voyez un dossier complet avec une copie de Python, ses bibliothèques standard, et un dossier `bin/` contenant `python`, `pip` et les scripts d'activation.

### Étape 1.2 : Activer et installer

```bash
source .venv/bin/activate
```

Le prompt doit maintenant afficher `(.venv) (base) $`. Installez quelques bibliothèques :

```bash
pip install scikit-learn pandas numpy
```

**Chronométrez** mentalement : combien de temps ça a pris ? (En général, 30–60 secondes selon votre connexion.)

### Étape 1.3 : Figer les dépendances

```bash
pip freeze > requirements.txt
cat requirements.txt
```

Vous obtenez un fichier listant **toutes** les bibliothèques installées, **avec leurs versions exactes**. Par exemple :

```
numpy==1.26.4
pandas==2.2.2
scikit-learn==1.5.0
...
```

**Remarquez** : ce fichier inclut aussi les **dépendances transitives** (les bibliothèques installées parce qu'une autre en avait besoin). Impossible de distinguer, dans ce fichier, ce que **vous** avez demandé de ce qui a été installé **automatiquement**.

### Étape 1.4 : Reproduire l'environnement

Pour simuler un·e collègue qui clonerait votre projet :

```bash
deactivate
rm -rf .venv
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Ça doit marcher à l'identique. **C'est ça, la reproductibilité** — et c'est exactement ce que l'équipe ops fait quand elle déploie votre projet.

### ❓ Questions

1. Que se passe-t-il si vous installez sans activer l'environnement (`pip install xxx` dans un autre terminal, sans `source .venv/bin/activate`) ?
2. Le fichier `requirements.txt` est-il **portable** entre Linux, macOS et Windows ? Dans quels cas pourrait-il échouer ?

```bash
deactivate
cd /workspace
```

## Partie 2 — `conda`

### Étape 2.1 : Créer un environnement conda

```bash
cd /workspace
mkdir projet-conda && cd projet-conda
conda create -n ml-projet python=3.11 -y
conda activate ml-projet
```

Le prompt affiche maintenant `(ml-projet) (base) $`.

### Étape 2.2 : Installer depuis `conda-forge`

```bash
conda install -c conda-forge scikit-learn pandas numpy -y
```

**Chronométrez** : combien de temps cette fois ? (Souvent 1–3 min avec conda classique — c'est normal, c'est le défaut connu de conda.)

### Étape 2.3 : Figer avec `environment.yml`

```bash
conda env export --no-builds > environment.yml
cat environment.yml
```

Observez la différence avec `requirements.txt` :

- le fichier mentionne `python=3.11` **explicitement** (alors que venv ne le sauvegarde pas : vous êtes limité·e à la version installée sur la machine) ;
- il a deux sections : `dependencies` (conda) et `pip` (si vous aviez utilisé pip dans cet env) ;
- il mentionne les **channels** (`conda-forge`) — important pour que `conda env create` sache où chercher.

### Étape 2.4 : Reproduire

```bash
conda deactivate
conda env remove -n ml-projet -y
conda env create -f environment.yml
conda activate ml-projet
```

### ❓ Questions

1. Pourquoi l'option `--no-builds` dans l'export ? Testez sans : `conda env export > environment-full.yml`. Qu'est-ce qui change ? Pourquoi c'est moins portable ?
2. Quelle est la **taille** totale de l'environnement ? (`du -sh $(conda info --base)/envs/ml-projet`) — comparez avec venv (`du -sh /workspace/projet-venv/.venv`).

```bash
conda deactivate
cd /workspace
```

## Partie 3 — `pixi`

### Étape 3.1 : Initialiser un projet pixi

```bash
cd /workspace
pixi init projet-pixi
cd projet-pixi
ls -la
```

**Observez** : pixi a créé un `pixi.toml` (description du projet et des dépendances voulues) et vous n'avez **rien** installé encore. C'est une approche déclarative.

Regardez le fichier :

```bash
cat pixi.toml
```

### Étape 3.2 : Ajouter des dépendances

```bash
pixi add python=3.11 scikit-learn pandas numpy
```

**Chronométrez** : beaucoup plus rapide que conda, non ? (Quelques secondes en général, car pixi est écrit en Rust.)

Regardez les fichiers générés :

```bash
cat pixi.toml
ls pixi.lock
wc -l pixi.lock
```

Le **lock file** `pixi.lock` est le point clé : il fige les versions **exactes** résolues pour **chaque plateforme**, et c'est **lui** qui garantit la reproductibilité. Vous pouvez (et devez) le committer dans Git.

### Étape 3.3 : Entrer dans l'environnement et vérifier

```bash
pixi shell
python -c "import sklearn; print(sklearn.__version__)"
```

Pour quitter le shell pixi (sans quitter le conteneur) : `exit`.

### Étape 3.4 : Lancer des commandes sans shell

Alternative : sans entrer dans un shell, on peut lancer directement une commande dans l'environnement :

```bash
pixi run python -c "import pandas; print(pandas.__version__)"
```

Très pratique dans les scripts CI/CD.

### Étape 3.5 : Définir des tâches

Éditez `pixi.toml` et ajoutez une section à la fin :

```toml
[tasks]
check = "python -c 'import sklearn, pandas; print(\"OK\")'"
version = "python --version"
```

Lancez-les :

```bash
pixi run check
pixi run version
```

C'est l'équivalent des `npm run` / `make` / `cargo run` — un endroit central pour définir les commandes courantes du projet.

### Étape 3.6 : Reproduire l'environnement à partir du lock file

Pour simuler un·e collègue qui clone le projet :

```bash
cd /workspace
cp -r projet-pixi projet-pixi-clone
cd projet-pixi-clone
rm -rf .pixi   # on supprime l'environnement local
pixi install   # réinstalle depuis pixi.lock, identique au bit près
pixi run check
```

**C'est cette reproductibilité exacte qui fait la différence** avec `requirements.txt` et `environment.yml` : le lock file garantit que vous obtenez **strictement** le même environnement que votre collègue, quelle que soit la plateforme.

### ❓ Questions

1. Que contient `pixi.lock` ? Ouvrez-le avec `less pixi.lock` — remarquez les sections `[environments]` par plateforme.
2. Que se passe-t-il si vous supprimez `pixi.lock` et relancez `pixi install` ? Est-ce que vous obtenez forcément les mêmes versions ?

## Partie 4 — Comparer les trois approches

Maintenant que vous avez créé les trois environnements pour le même projet, faites le bilan **de votre propre expérience** :

### Tableau à remplir

| Critère | `venv + pip` | `conda` | `pixi` |
|---|---|---|---|
| Temps d'installation | … | … | … |
| Clarté du fichier de deps (direct vs transitif) | … | … | … |
| Taille de l'environnement (`du -sh`) | … | … | … |
| Rapidité de la résolution de dépendances | … | … | … |
| Commandes à retenir | … | … | … |
| Lock file natif ? | … | … | … |

### Questions de synthèse

1. **Pour un projet Python pur** (API web, script d'analyse de logs), lequel choisiriez-vous ? Pourquoi ?
2. **Pour un projet computer vision** qui a besoin de PyTorch + CUDA + OpenCV compilé, lequel choisiriez-vous ? Pourquoi ?
3. **Dans une équipe multi-OS** (un·e sur Windows, deux sur macOS, trois sur Linux), lequel est le plus sûr pour garantir que tout le monde a exactement le même environnement ?
4. **Votre entreprise travaille déjà avec conda depuis 5 ans**. Un nouveau projet démarre. Est-ce que vous imposez pixi ? Pourquoi (ou pourquoi pas) ?

## Partie 5 — Challenge : reproduire un environnement existant

Vous trouverez dans `/workspace/challenge/` trois fichiers qui correspondent **à un même projet** (simulé) :

- `requirements.txt` — la version `pip` ;
- `environment.yml` — la version `conda` ;
- `pixi.toml` — la version `pixi`.

**Votre mission :** créer **les trois environnements** à partir de ces fichiers, vérifier qu'ils installent les mêmes bibliothèques, et noter les différences que vous observez (versions exactes, latence, taille…).

```bash
cd /workspace/challenge
ls
```

Puis, pour chaque approche :

```bash
# Version pip
python -m venv .venv-challenge
source .venv-challenge/bin/activate
pip install -r requirements.txt
# ... vérifier, comparer
deactivate

# Version conda
conda env create -f environment.yml -n challenge-conda
conda activate challenge-conda
# ... vérifier, comparer
conda deactivate

# Version pixi
pixi install
pixi run python -c "import sklearn; print(sklearn.__version__)"
```

## 🎯 Ce que vous avez appris

- Les **trois outils principaux** sont disponibles en quelques commandes, avec leurs forces et leurs limites.
- **Le lock file** (pixi, ou `conda-lock` côté conda) est le vrai secret de la reproductibilité multi-OS.
- **Aucun outil n'est « le meilleur »** — ils répondent à des contextes différents (binaires scientifiques, équipe, volume, projet neuf ou legacy).
- **L'ergonomie compte** : si votre outil prend 3 minutes à résoudre des dépendances, vous allez l'éviter et perdre en discipline.
- **Ce que vous choisirez dépendra de votre équipe et de votre historique** — et c'est très bien comme ça.

Pour quitter le sandbox :

```bash
exit
```

Les fichiers que vous avez créés dans `/workspace` sont conservés dans le dossier `work/cours-exe/06-mise-en-production/tp-sandbox/` de votre machine — vous pouvez y revenir plus tard.
