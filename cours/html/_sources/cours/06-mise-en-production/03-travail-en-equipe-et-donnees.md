# Travailler en équipe sur du ML

## Ce qu'on a appris seul et ce qui change en équipe

Jusqu'ici, vos notebooks tournaient **sur votre machine**, avec **vos données** dans un dossier local, **votre modèle** sérialisé à côté. C'est parfait pour apprendre — pas pour travailler à plusieurs. Dès qu'une équipe de deux à cinq personnes touche au même projet, trois grandes questions se posent :

1. **Où fait-on tourner les calculs ?** (compute)
2. **Comment partage-t-on les données ?** (accès, confidentialité, volumétrie)
3. **Comment garde-t-on tout le monde synchronisé ?** (versioning code / données / modèles)

Ce chapitre fait le tour de ces trois blocs. Pas de code — **c'est de l'organisation et de la culture**, les briques qu'on installe avant de commencer à coder.

## Machines de calcul : où fait-on tourner les modèles ?

### Le problème

Un laptop, c'est **très bien pour explorer** 10 000 lignes sur CPU. Dès qu'on parle de :

- **100 Go** de données à charger en mémoire,
- un modèle deep learning qui demande un GPU à 16 Go de VRAM,
- un entraînement qui prend **12 heures** à chaque itération,

…votre laptop devient un goulot d'étranglement. Il faut des **machines dédiées**.

### Les grandes options

| Option | Pour qui | Avantages | Limites |
|---|---|---|---|
| **Workstation équipe** (GPU sur site) | Petites équipes, données très sensibles | Pas de coût cloud, accès immédiat | Contention quand plusieurs data scientists travaillent, maintenance matérielle |
| **Cloud à la demande** (AWS / GCP / Azure) | La plupart des équipes | Scalable, payer à la durée d'usage, choix du GPU | Coûts qui dérapent si on oublie d'éteindre, gouvernance RGPD |
| **Cluster HPC on-prem** | Grosses organisations, recherche | Haute performance, confidentialité | Lourd à provisionner, compétences DevOps requises |
| **Services managés** (SageMaker, Vertex AI, Databricks) | Équipes qui veulent aller vite | Notebook + compute + stockage intégrés, moins de plomberie | Vendor lock-in, coût par heure élevé |

### Le piège du « ça tourne sur mon laptop »

Un travers très fréquent : « mon script tourne chez moi, donc il est prêt ». Sauf que **votre laptop n'est pas représentatif** de l'environnement cible :

- vous avez 32 Go de RAM, le serveur en a 16 ;
- vous avez une SSD NVMe, le serveur lit depuis un NFS lent ;
- vous avez sklearn 1.4, le serveur est en 1.2 ;
- vous avez 4 cœurs, le serveur en a 32 (et votre code n'est pas parallélisé).

D'où l'importance des **environnements reproductibles** (chapitre précédent) et des **conteneurs Docker** : ce qui tourne dans votre conteneur tournera à l'identique sur le serveur.

```{admonition} Sur le terrain
:class: tip
Règle pratique : **dès que vous dépassez 1 Go de données ou 10 min d'entraînement**, arrêtez de tout faire sur votre laptop. Demandez un accès à une machine partagée, un cluster, ou une VM cloud. C'est moins gênant et plus rapide que de faire tourner votre laptop pendant 12h en espérant qu'il ne crashe pas.
```

## Les données : le nerf de la guerre

### Récupérer les données réelles : l'obstacle #1

On pense souvent que le plus dur en ML, c'est **le modèle**. En vrai, sur la plupart des projets, **c'est l'accès aux données** :

- **Confidentialité / RGPD.** Les données clients ne peuvent pas circuler librement. Il faut souvent **anonymiser**, **agréger**, **signer des NDA**, passer par des avocats.
- **Connaissance métier cachée.** « Ah au fait, la colonne `status` a quatre valeurs historiques qu'il faut mapper sur deux. Personne ne te l'a dit ? ». Ce genre de savoir vit dans la tête des gens, pas dans la doc.
- **Accès à l'infra.** Les données sont dans un data warehouse ? Il faut les droits. Dans une base applicative de prod ? Il faut un export supervisé. Dans des logs ? Il faut les parser. Dans du S3 ? Il faut le bon rôle IAM. **Comptez en semaines, pas en heures.**
- **Volumétrie.** 500 Go de logs à télécharger sur votre laptop, ça ne marche pas. Il faut soit **échantillonner**, soit **traiter sur place** (sur la machine qui héberge déjà les données).
- **Formats obscurs.** Dates en 12 formats différents, encodages cassés, colonnes fantômes, doublons. La moitié du projet est consacrée à **démêler l'existant**.
- **Données manquantes ou biaisées.** Les données qu'on peut récupérer sont **les données qu'on a bien voulu stocker** — pas forcément celles dont on a besoin.

```{admonition} Sur le terrain
:class: important
**L'accès aux données est la première chose à vérifier**, avant même de parler d'algorithmes.

Posez ces questions dès le cadrage :
1. Les données existent-elles ? *(Souvent la réponse est « oui on stocke tout dans des logs pas exploitables ».)*
2. Ai-je le droit d'y accéder ? *(RGPD, NDA, gouvernance interne.)*
3. Combien de temps pour obtenir l'accès ? *(Si c'est > 6 semaines, prévenez le client tout de suite.)*
4. Ai-je besoin d'aide d'un·e expert·e métier pour les comprendre ? *(Presque toujours oui.)*
5. Le volume est-il gérable ? *(Sinon, prévoir un compute adapté.)*

Un projet qui démarre l'entraînement du modèle **avant** d'avoir répondu à ces cinq questions est un projet qui va perdre des semaines.
```

### Volumétrie : les trois régimes

La stratégie change selon la taille des données :

| Volume | Régime | Outils typiques |
|---|---|---|
| **< 1 Go** | Tient en mémoire sur un laptop | pandas, scikit-learn |
| **1 Go – 100 Go** | Ne tient plus en mémoire mais sur disque | polars, DuckDB, Dask, Spark |
| **> 100 Go** | Traitement distribué obligatoire | Spark, BigQuery, Snowflake, Databricks |

Ne partez pas sur Spark si vos données tiennent en mémoire — c'est surdimensionné et ça ralentit tout. Mais ne vous entêtez pas sur pandas pour 80 Go non plus.

## Versioner l'intégralité du projet : code, données, modèles

Un projet ML a **trois choses** à versionner — et chaque brique a son outil préféré.

### 1. Le code : Git, comme d'habitude

Rien de nouveau si vous connaissez déjà Git : **chaque** projet ML doit être dans un dépôt Git dès le premier jour. Commit fréquents, messages clairs, branches par fonctionnalité, revue de code entre pairs. C'est la **brique de base**.

Ce qu'on **n'y met pas** :
- les fichiers de données (trop gros),
- les modèles sérialisés (binaires, trop gros),
- les secrets (clés API, tokens, mots de passe → utiliser `.env` et `.gitignore`).

### 2. Les données : DVC ou Git LFS

**Git LFS** (Large File Storage) — extension de Git qui stocke les gros fichiers à part. Simple mais limité : pas pensé pour les workflows data science (pas de pipelines, pas de métadonnées d'expérience).

**DVC** (Data Version Control) — outil spécialisé pensé pour le ML. Fonctionne en tandem avec Git :

- Git stocke un petit fichier `.dvc` (quelques octets) qui pointe vers la donnée réelle ;
- la donnée réelle est stockée ailleurs (S3, GCS, NFS, un serveur local…) ;
- DVC gère aussi des **pipelines** (« quand `data/raw.csv` change, relancer `preprocess.py` et `train.py` »).

```bash
# Versionner un dataset
dvc add data/raw/users.csv
git add data/raw/.gitignore data/raw/users.csv.dvc
git commit -m "Add users dataset v1"

# Partager via un remote (S3, GCS, etc.)
dvc push
```

N'importe qui qui clone le repo peut ensuite `dvc pull` pour récupérer les données correspondant au commit actuel. C'est **la** façon propre de versionner de la donnée en équipe en 2026.

### 3. Les modèles et les expériences : MLflow, W&B, Neptune

À chaque entraînement, vous devez pouvoir **retrouver** :
- quelles données ont été utilisées,
- quels hyperparamètres,
- quel code (commit Git),
- quels scores obtenus (CV, test, production).

Au début d'un projet, un **simple fichier `experiments.jsonl`** avec une ligne par entraînement suffit. Quand le projet grossit, passez à un outil dédié :

- **MLflow** — standard open-source, s'installe facilement, UI web pour comparer les runs. **Choix par défaut.**
- **Weights & Biases (W&B)** — SaaS très poli, dashboards superbes, collaboration en temps réel, freemium.
- **Neptune** — équivalent de W&B, moins connu mais excellent.
- **Comet** — autre alternative SaaS avec des graphs live.

Tous ces outils font la même chose à 90 % : **logger** chaque entraînement avec les paramètres, les métriques, les artefacts, et offrir une UI pour comparer.

## Labéliser les données : la tâche invisible qui coûte cher

### Le problème

En apprentissage supervisé, le modèle apprend à partir **d'exemples labélisés** : des données où quelqu'un a déjà écrit la bonne réponse. Ce « quelqu'un », souvent, **c'est un humain**. Labéliser :

- **prend du temps** (1 à 10 secondes par exemple simple, plusieurs minutes pour des cas ambigus),
- **demande de l'expertise métier** (un médecin pour annoter des radios, un juriste pour classer des contrats…),
- **est fastidieux** : la qualité chute après quelques heures, il faut des pauses, des rotations, du contrôle qualité.

Pour un projet ML moyen, on parle de **semaines** voire **mois** de travail d'annotation. Et ce travail **ne peut pas toujours être sous-traité** — pour des données sensibles ou très spécialisées, il faut des annotateurs internes.

### Les outils

- **LabelStudio** (open-source) — couvre tous les types de données (texte, image, audio, vidéo, séries temporelles). Déployable on-premise, adapté aux données sensibles. **Souvent le premier choix.**
- **Roboflow** (SaaS, focus vision) — excellent pour les projets computer vision, workflow complet de l'annotation à l'entraînement, intégrations YOLO et autres.
- **Prodigy** (commercial, édité par Explosion) — très efficace pour du NLP, intègre de l'**active learning** pour annoter en priorité les exemples les plus informatifs.
- **Amazon SageMaker Ground Truth** / **Google Vertex Data Labeling** — services managés cloud.
- **Sous-traitance** (Amazon Mechanical Turk, Appen, Toloka…) — quand vous avez besoin de milliers de labels simples.

```{admonition} Sur le terrain
:class: tip
**Règles d'or de l'annotation** :

1. **Annoter à plusieurs** les mêmes exemples (au moins 2 annotateurs) et **mesurer l'accord inter-annotateurs** (Cohen's kappa, IoU…). Si l'accord est faible, le problème est mal défini — revenez sur les consignes.
2. **Commencer par un petit batch** (100–200 exemples) et le revoir en équipe avant de lancer l'annotation massive.
3. **Active learning** : demander au modèle quels exemples sont les plus ambigus, et annoter en priorité ceux-là. On gagne énormément d'efficacité.
4. **Documenter les consignes d'annotation** comme une vraie spec (cas limites, exemples positifs et négatifs, arbre de décision). C'est de la documentation métier à part entière.
```

## Une équipe type sur un projet ML

Voici la composition qu'on rencontre le plus souvent sur des projets de taille moyenne (3–8 personnes) :

| Rôle | Ce qu'il fait | Part du temps projet |
|---|---|---|
| **Product owner / métier** | Définit le besoin, valide les résultats | ~10 % |
| **Data engineer** | Récupère, nettoie, orchestre les flux de données | ~30 % |
| **Data scientist** | Explore, prototype, entraîne les modèles | ~30 % |
| **ML engineer** | Industrialise, déploie, monitore | ~20 % |
| **DevOps / MLOps** | Infrastructure, compute, sécurité | ~10 % |
| **Annotateur·rice·s** | Labélisent les données | temporaire mais lourd |

Sur un petit projet, une même personne porte plusieurs rôles. **Ce qui ne change pas**, c'est que toutes ces activités **doivent exister** — si personne ne fait la partie « data engineering », elle reste à faire quand même, et ça retombe en général sur le data scientist qui perd son temps au lieu de modéliser.

## 🎯 À retenir

- **Le compute** peut être local, cloud ou cluster — le choix dépend de la taille des données, des contraintes de confidentialité, et du budget.
- **L'accès aux données est le premier obstacle** à lever dans un projet ML — souvent bien avant les questions d'algorithme.
- **Trois briques à versionner** : le code (Git), les données (DVC / Git LFS), les expériences et modèles (MLflow, W&B, Neptune).
- **L'annotation est un vrai métier** qui coûte du temps, des compétences, et une gouvernance sérieuse. LabelStudio, Roboflow, Prodigy sont les outils standards.
- **Un projet ML n'est jamais l'affaire d'une seule personne** : il faut au moins du métier, de la data engineering, du modélisation et du déploiement — même si c'est la même personne qui enchaîne les casquettes.

Dans le chapitre suivant, on se concentre sur la phase finale : **la mise en production** et tout ce qui vient avec (monitoring, drift, feedback, ré-entraînement).
