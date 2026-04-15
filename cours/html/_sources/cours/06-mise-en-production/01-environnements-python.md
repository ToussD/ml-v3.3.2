# Gérer ses environnements Python

## Pourquoi c'est un sujet à part entière ?

Vous avez installé Python, vous avez `pip install` quelques bibliothèques, vos notebooks tournent. Jusqu'ici, tout va bien. Puis un jour :

- vous voulez tester **un autre projet** qui a besoin de `scikit-learn 1.1`, alors que votre premier projet est sur `1.5` ;
- vous envoyez votre code à un·e collègue et **ça ne marche pas chez elle** ;
- vous revenez sur un projet **six mois plus tard** et rien ne fonctionne plus — les bibliothèques ont changé de version entre-temps ;
- vous passez votre projet à **l'équipe ops** qui doit le déployer, et une dépendance oubliée fait tout planter en production.

Tous ces problèmes ont la même racine : **Python ne sait pas, par défaut, isoler les bibliothèques par projet**. Si vous installez `pandas` avec `pip install pandas`, il s'installe **globalement** — et un seul projet à la fois peut décider quelle version il veut.

> **L'analogie à garder en tête :** imaginez une cuisine partagée dans un grand immeuble. Chaque locataire prépare ses recettes avec les mêmes ingrédients communs. Si vous renversez du sel sur le sucre, **tous vos voisins** vont en pâtir. Un environnement Python, c'est votre propre **cuisine privée** : vos ingrédients, vos ustensiles, vos doses — personne ne peut venir y toucher.

C'est pour ça qu'on parle **d'environnements isolés** : chaque projet a sa propre boîte de bibliothèques, avec ses propres versions, sans interférer avec les autres.

## Les critères qui comptent en data science

Avant de comparer les outils, clarifions **ce qu'on attend** d'un bon gestionnaire d'environnements pour un projet ML :

| Critère | Pourquoi c'est important en ML |
|---|---|
| **Isolation** | Chaque projet a ses versions ; pas de conflit entre projets. |
| **Reproductibilité** | « Même fichier de deps = même environnement » — garanti, partout. |
| **Multi-OS** | L'équipe mélange Linux, macOS, Windows. L'environnement doit marcher partout. |
| **Bibliothèques scientifiques** | NumPy, SciPy, scikit-learn, OpenCV, PyTorch… souvent compilées avec C/Fortran/CUDA. Tout ne s'installe pas pareil qu'un package Python pur. |
| **Travail en équipe** | Un fichier à committer dans Git, tout le monde obtient le même env. |
| **Versioning fin** | Figer les versions exactes pour la reproductibilité (« lock file »). |
| **Rapidité** | Installer un env de 2 Go en 30 secondes plutôt qu'en 10 minutes. |

Gardez cette liste en tête : on va noter chaque outil dessus.

## `venv` — l'outil fourni avec Python

`venv` est le gestionnaire **livré par défaut** avec Python (depuis la 3.3). Il crée un dossier contenant une copie de Python et ses propres bibliothèques.

```bash
# Créer un environnement dans un dossier .venv
python3 -m venv .venv

# L'activer (Linux / macOS)
source .venv/bin/activate

# L'activer (Windows PowerShell)
.venv\Scripts\Activate.ps1

# Installer des dépendances dedans
pip install scikit-learn pandas

# Figer les versions installées
pip freeze > requirements.txt

# Désactiver
deactivate
```

Pour reproduire l'environnement ailleurs :

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Ce que fait venv :**
- crée un dossier isolé avec un interpréteur Python et ses paquets,
- combine parfaitement avec `pip` pour installer/figer des dépendances,
- fournit un fichier `requirements.txt` lisible et diffusable.

**Les limites :**
- **ne gère que Python et les paquets PyPI** — pas les bibliothèques système (OpenCV compilé, CUDA, ffmpeg…) ;
- **multi-OS compliqué** : un `requirements.txt` de Linux peut échouer sur Windows si des *wheels* n'existent pas pour une plateforme ;
- **pas de vrai lock file** : `pip freeze` donne les versions actuelles mais ne distingue pas les deps directes des deps transitives ;
- **gère une seule version de Python** : celle qui est installée sur votre machine.

> **🎯 Quand l'utiliser ?** Projets Python purs, équipes sur le même OS, déploiement serveur standardisé. C'est l'outil **par défaut** pour les projets simples — et ça suffit pour beaucoup de cas.

## `conda` — le gestionnaire scientifique

Conda a été créé par Anaconda spécifiquement pour **les environnements scientifiques**. Contrairement à pip, il gère aussi :

- **plusieurs versions de Python** dans des environnements différents (3.9, 3.10, 3.11…),
- les **bibliothèques non-Python** : compilateurs C, Fortran, CUDA, OpenCV, ffmpeg, libpng, MKL…

```bash
# Créer un environnement nommé "ml-projet"
conda create -n ml-projet python=3.11

# L'activer
conda activate ml-projet

# Installer depuis le canal conda-forge (recommandé)
conda install -c conda-forge scikit-learn pandas numpy

# Figer les versions dans un fichier
conda env export --no-builds > environment.yml

# Recréer l'environnement ailleurs
conda env create -f environment.yml
```

**Deux distributions** :
- **Anaconda** — tout-en-un, ~3 Go, inclut 250+ packages. Pratique mais lourd.
- **Miniconda** — installeur minimal, ~100 Mo, vous choisissez ce que vous installez. **C'est ce qu'on recommande en 2026.**

**Ce que fait conda :**
- gère **Python + les binaires système** (CUDA, OpenCV…) proprement,
- permet d'avoir **plusieurs versions de Python** sur la même machine,
- fonctionne sur Linux, macOS, Windows avec les mêmes commandes,
- `conda-forge` est une immense collection de paquets scientifiques bien testés.

**Les limites :**
- **lent** — résolution de dépendances historiquement lente (le nouveau solveur `mamba`/`libmamba` a bien amélioré ça, mais c'est toujours plus lent que pip),
- **fichiers `environment.yml` moins portables** que prévu : les builds de paquets diffèrent entre OS, donc un export précis ne recréera pas forcément à l'identique sur une autre plateforme,
- **pas de vrai lock file natif** (on peut contourner avec `conda-lock` mais ce n'est pas d'origine),
- **deux écosystèmes à connaître** : pip **et** conda (certains paquets n'existent que sur PyPI, d'autres que sur conda-forge).

> **🎯 Quand l'utiliser ?** Projets qui dépendent de **bibliothèques compilées** (OpenCV, PyTorch avec CUDA, GDAL…), environnements scientifiques lourds, ou équipes qui veulent une seule commande pour installer Python + tout le reste. C'est le choix historique en data science.

## `pixi` — le nouveau venu, pensé pour 2026

Pixi est un outil moderne **qui utilise conda-forge** comme source, mais avec une **expérience utilisateur** complètement refaite. Écrit en Rust, il est **beaucoup plus rapide** que conda, propose un **vrai lock file** par plateforme, et s'inspire des bonnes idées de `cargo` (Rust) et `npm` (Node.js).

```bash
# Installer pixi (une seule fois, sur votre machine)
curl -fsSL https://pixi.sh/install.sh | bash

# Créer un nouveau projet
pixi init ml-projet
cd ml-projet

# Ajouter des dépendances (elles sont écrites dans pixi.toml)
pixi add python=3.11 scikit-learn pandas numpy

# Entrer dans un shell avec l'environnement activé
pixi shell

# Ou lancer une commande sans shell
pixi run python mon_script.py
```

Un projet pixi contient :
- **`pixi.toml`** — la liste des dépendances voulues (équivalent `pyproject.toml`),
- **`pixi.lock`** — le lock file complet avec les versions **exactes** résolues pour **chaque plateforme** (Linux x86, macOS ARM, Windows…).

**Ce qui change par rapport à conda :**

- **Rapide** : résolution en secondes, pas en minutes ;
- **Lock file par plateforme** : on peut garantir que Linus (macOS M1) et Sophie (Windows x86) obtiennent **exactement** le même environnement ;
- **Commandes de tâches intégrées** : `pixi run train` peut remplacer `npm run` avec des tâches définies dans `pixi.toml` ;
- **Pas besoin de "conda activate"** : on utilise `pixi shell` ou `pixi run` ponctuellement ;
- **Un seul outil** à installer, même pas besoin de conda préalable.

**Les limites :**

- **Outil jeune** (première release stable en 2023) — l'écosystème de tutos et de ressources est encore en construction ;
- **Moins connu** — vos collègues devront apprendre un nouvel outil ;
- **Certains workflows conda avancés** (révisions d'historique, etc.) ne sont pas encore implémentés.

> **🎯 Quand l'utiliser ?** Nouveaux projets en 2026, équipes hétérogènes multi-OS qui veulent **une vraie garantie** de reproductibilité, ou quand vous en avez assez de la lenteur de conda. C'est l'outil qu'on recommande **pour démarrer un projet from scratch**.

## Les autres : `uv` et `poetry`, en un coup d'œil

Deux outils qu'on mentionne pour votre culture générale — vous les croiserez.

- **`poetry`** (2018) — gestionnaire de projets Python « tout-en-un » (deps, build, publish), très populaire chez les développeurs Python purs (web, backends). Utilise `pyproject.toml` + `poetry.lock`. **Faiblesse en data science** : il ne gère pas les bibliothèques non-Python (pas de CUDA, pas d'OpenCV compilé), donc peu utilisé pour du ML lourd.
- **`uv`** (2024) — très récent, développé par Astral (les gens de `ruff`). C'est un **remplacement ultra-rapide de pip + venv** écrit en Rust. Il combine `pip install`, `pip-tools`, `venv` et `pyenv` en une seule commande, **10 à 100 fois plus rapide**. Devient populaire pour les projets Python purs. **Même limite que poetry** : pas de binaires non-Python.

> **🎯 À retenir :** `poetry` et `uv` brillent sur des projets Python purs (web, API, scripts). Pour de la data science avec des dépendances scientifiques lourdes, `conda` et `pixi` restent plus robustes.

## Tableau comparatif

| Critère | `venv` + `pip` | `conda` | `pixi` | `uv` | `poetry` |
|---|---|---|---|---|---|
| Livré avec Python | ✅ | ❌ | ❌ | ❌ | ❌ |
| Installer Python lui-même | ❌ | ✅ | ✅ | ✅ | ❌ |
| Binaires scientifiques (CUDA, OpenCV…) | ❌ | ✅ | ✅ | ❌ | ❌ |
| Vraiment rapide (< 10 s) | ✅ | ❌ | ✅ | ✅✅ | ❌ |
| Lock file multi-OS | ❌ | ⚠️ (avec `conda-lock`) | ✅ | ⚠️ | ✅ (Linux seulement par défaut) |
| Tâches / scripts intégrés | ❌ | ❌ | ✅ | ❌ | ✅ |
| Maturité écosystème | ✅✅ | ✅✅ | ⚠️ (jeune) | ⚠️ (très jeune) | ✅ |
| Multi-versions Python | ❌ | ✅ | ✅ | ✅ | ✅ |

## Comment choisir ?

**Trois questions pour trancher :**

1. **Mon projet a-t-il besoin de bibliothèques non-Python ?** (OpenCV compilé, PyTorch + CUDA, GDAL, ffmpeg…)
    - **Oui** → `conda` ou `pixi` (obligatoire pour les binaires scientifiques)
    - **Non** → tous les outils conviennent

2. **Mon équipe travaille-t-elle sur plusieurs OS ?**
    - **Oui** → `pixi` (lock file par plateforme, vrai garantie)
    - **Non** → tous les outils conviennent

3. **Je démarre un nouveau projet ou je rejoins un projet existant ?**
    - **Nouveau projet en 2026** → `pixi` si ML / `uv` si Python pur
    - **Projet existant** → l'outil déjà utilisé par l'équipe, toujours (on ne change pas d'outil juste pour le plaisir)

```{admonition} Sur le terrain
:class: tip
Le meilleur gestionnaire d'environnements, c'est **celui qui est déjà utilisé dans votre équipe**. Imposer un nouvel outil à une équipe qui maîtrise conda depuis 5 ans va créer plus de problèmes que ça n'en résout.

Dans l'ordre de priorité quand vous rejoignez un projet :
1. **Reprenez l'outil du projet** tel qu'il est (même s'il n'est pas optimal).
2. **Proposez une amélioration** uniquement si vous mesurez un vrai gain (temps perdu, bugs récurrents, intégration CI cassée…).
3. **Ne proposez jamais un changement d'outil en fin de projet** — le coût est trop élevé pour les bénéfices.
```

## 🎯 À retenir

- **Python n'isole pas les dépendances par défaut** — il faut un gestionnaire d'environnements.
- **`venv` + `pip`** : simple, livré avec Python, suffit pour la plupart des projets Python purs.
- **`conda`** : la référence en data science depuis 10 ans, gère les binaires scientifiques, mais lent.
- **`pixi`** : le remplaçant moderne de conda, rapide, lock file multi-OS, la bonne option pour **démarrer en 2026**.
- **`uv` / `poetry`** : excellents pour les projets Python purs (API, web), mais limités pour la data science.
- **Le choix dépend du contexte** : binaires scientifiques ? équipe multi-OS ? projet neuf ou existant ?

Dans le TP en fin de module, vous allez **créer les trois** (venv, conda env, projet pixi) pour le même petit projet et comparer **vous-même** l'expérience.
