# De la recherche à la production

## Le « dernier kilomètre » du ML

Vous avez un modèle qui donne de bons résultats dans votre notebook. Le métier a validé. Reste à le **mettre en production** — c'est-à-dire à le rendre utilisable **par d'autres personnes ou d'autres systèmes**, en dehors de votre ordinateur, sans votre présence, de façon **fiable et continue**.

C'est ce qu'on appelle souvent le **dernier kilomètre** du ML. Et c'est là que **la majorité des projets échouent** — pas parce que le modèle n'est pas assez bon, mais parce que personne n'avait prévu comment l'exploiter une fois fini.

> **L'analogie à garder en tête :** un modèle en notebook, c'est comme un **prototype de voiture dans un garage**. Il roule, oui, mais dans un garage, avec un mécanicien à côté. Le mettre en production, c'est le sortir sur la route, **24h/24**, avec n'importe quel conducteur, sur tous les types de terrain, **tout en continuant à le faire évoluer**. C'est un changement de métier, pas juste une étape de plus.

## Du notebook au code de production

### Le notebook est un outil d'exploration, pas de livraison

Un notebook Jupyter est **parfait pour explorer** : on y teste des idées, on visualise, on itère, on garde des traces. Mais il a des **défauts rédhibitoires** pour la production :

- **L'ordre des cellules est fragile** : il suffit d'exécuter les cellules dans un autre ordre pour obtenir un résultat différent.
- **État caché** : une variable définie il y a dix cellules et oubliée peut influencer silencieusement le résultat.
- **Pas de tests** : on ne peut pas écrire de tests unitaires propres sur un notebook.
- **Pas de réutilisation** : difficile d'importer une fonction d'un notebook dans un autre.
- **Revue de code impossible** : un diff de notebook est illisible (c'est du JSON avec des métadonnées partout).

Quand le modèle est validé, il faut donc **passer du notebook à des scripts Python** (`.py`) propres et testés. C'est ce qu'on appelle « notebook to code » — et c'est une **vraie étape de projet**, à budgétiser, pas une formalité.

### À quoi ressemble le projet « prod-ready »

Une arborescence typique :

```
mon_projet_ml/
├── data/
│   ├── raw/               # Données brutes (immuables)
│   └── processed/         # Données transformées (régénérables)
├── src/
│   ├── preprocessing.py   # Fonctions réutilisables
│   ├── train.py           # Script d'entraînement
│   └── predict.py         # Fonction / API de prédiction
├── models/
│   └── model_v1.joblib    # Modèle sérialisé
├── tests/
│   └── test_preprocessing.py
├── notebooks/
│   └── exploration.ipynb  # Archive du travail exploratoire
├── pyproject.toml         # Déps et config projet
├── Dockerfile             # Image de production
└── README.md
```

Trois grandes règles :
- **`data/raw/` est en lecture seule**. Si vous le modifiez, vous perdez la source de vérité.
- **`src/` contient du code de production** : testé, revu, sans cellule de debug oubliée.
- **`notebooks/` reste là** — mais **archivé** comme documentation vivante, pas comme code de référence.

### Sérialiser proprement le modèle

Pour ne pas ré-entraîner à chaque prédiction, on **sauvegarde** le pipeline complet dans un fichier :

```python
import joblib
joblib.dump(full_pipeline, "models/model_v1.joblib")
# Plus tard, n'importe où :
model = joblib.load("models/model_v1.joblib")
model.predict(new_data)
```

**Point crucial** : on sérialise **le pipeline complet** (preprocessing + modèle), pas juste le modèle final. Sinon vous perdez les transformations et vos prédictions seront fausses.

## Déploiement : quelles options ?

Il n'y a pas **une** façon de déployer un modèle ML — ça dépend de l'usage.

### Déploiement batch (le plus simple)

Le modèle tourne **périodiquement** sur un gros lot de données, et stocke les prédictions dans une base de données.

```
Toutes les nuits à 02:00 :
1. Lire la table `nouveaux_clients` du jour
2. Appliquer le modèle
3. Écrire les résultats dans `scores_risque`
4. L'équipe commerciale lit la table le matin
```

**Quand l'utiliser ?** Quand les prédictions ne sont pas urgentes (rapport quotidien/hebdomadaire/mensuel). **Simple, robuste, peu coûteux.** La majorité des projets ML en entreprise tournent en batch, pas en temps réel.

### Déploiement API (temps réel)

Le modèle est servi par une **API HTTP** : une application envoie une requête, reçoit une prédiction en quelques millisecondes.

```
Application mobile → POST /predict → API → modèle → réponse JSON
```

Outils classiques : **FastAPI**, Flask, BentoML, TorchServe. **Quand l'utiliser ?** Quand la prédiction doit être immédiate (détection de fraude en ligne, recommandation dans une app, chatbot…).

### Déploiement embarqué (edge)

Le modèle tourne **directement dans l'appareil** — téléphone, caméra, voiture, drone. Pas de serveur, pas de latence réseau.

Outils : **TensorFlow Lite**, **ONNX Runtime**, **Core ML**, **PyTorch Mobile**. **Quand l'utiliser ?** Quand la latence doit être ultra-faible, quand il n'y a pas de réseau, ou quand les données sont trop sensibles pour quitter l'appareil.

### Déploiement en streaming

Le modèle consomme un **flux** de messages (Kafka, Pulsar, Kinesis), applique une prédiction à chacun, et émet le résultat dans un autre flux.

**Quand l'utiliser ?** Quand on veut réagir à chaque événement dès qu'il arrive (événements financiers, IoT, logs…).

### Tableau récap

| Mode | Latence | Complexité infra | Coût | Exemple |
|---|---|---|---|---|
| **Batch** | Heures/jours | Faible | Faible | Scoring clients nocturne |
| **API temps réel** | 10–500 ms | Moyenne | Moyen | Détection de fraude en ligne |
| **Streaming** | Quelques ms | Élevée | Élevé | Télémétrie IoT temps réel |
| **Embarqué** | Instantané | Élevée | Faible à l'usage | Détection d'objets sur caméra |

**Dans 80 % des projets**, le batch suffit. Ne sur-dimensionnez pas votre infrastructure.

## Monitoring : garder un œil sur le modèle en production

Déployer n'est **pas la fin** du projet. C'est le **début de la maintenance**.

### Le model drift : l'ennemi silencieux

Un modèle entraîné sur des données de 2023 devient lentement **obsolète** en 2026. Les données changent :

- la **population** évolue (nouveaux clients, nouveaux comportements),
- le **contexte métier** change (nouveaux produits, nouvelles réglementations),
- les **capteurs** sont remplacés (valeurs légèrement différentes),
- les **usages** évoluent (pendant la crise Covid, les modèles de prévision de ventes ont tous cassé).

Ce phénomène s'appelle le **model drift** : la performance se dégrade **progressivement** et **silencieusement**. Le modèle continue à renvoyer des réponses qui ont l'air normales, mais leur qualité se détériore.

> **L'analogie à garder en tête :** un modèle en production, c'est comme une **boussole réglée en 1950**. Elle indiquait le nord magnétique exact à l'époque. Aujourd'hui, le nord magnétique a bougé de plusieurs centaines de kilomètres. La boussole marche toujours — mais elle ment de plus en plus.

On distingue deux types de drift :
- **Data drift** : les données d'entrée changent (la distribution des features évolue).
- **Concept drift** : la relation entre entrées et sorties change (ce qui prédisait « va acheter » hier ne le prédit plus aujourd'hui).

### Quoi monitorer

| Métrique | Ce qu'elle révèle | Alerter si |
|---|---|---|
| **Score de production** (quand on a des labels) | Performance réelle | Baisse > 5 % |
| **Distribution des features d'entrée** | Data drift | Écart statistique significatif avec l'entraînement |
| **Distribution des prédictions sorties** | Shift comportement du modèle | Déséquilibre soudain (95 % de classe 1 alors qu'on avait 50/50) |
| **Latence p95** | Stabilité du service | Dépassement de SLA |
| **Taux d'erreurs HTTP 5xx** | Disponibilité | > 1 % des requêtes |
| **Confiance moyenne des prédictions** | Incertitude du modèle | Baisse significative |

### Les outils

- **Prometheus + Grafana** — dashboards génériques, standard dans l'industrie.
- **MLflow tracking** — pour tracer chaque run et comparer les modèles.
- **Evidently AI** — spécialisé ML monitoring (data drift, performance, bias). Open-source + SaaS.
- **Arize AI**, **WhyLabs**, **Fiddler** — SaaS professionnels de monitoring ML.
- **Le simple fichier `logs.jsonl`** — qu'on agrège ensuite dans Loki ou Elasticsearch. Ça commence souvent comme ça avant d'industrialiser.

## La boucle de feedback utilisateur

### Pourquoi c'est le saint graal

Un modèle en production qui **ne reçoit jamais de retour** ne peut pas s'améliorer. Inversement, **chaque interaction utilisateur est une information** — il faut juste savoir la capturer.

Exemples de feedback précieux :

| Contexte | Signal de feedback |
|---|---|
| Détection de spam | L'utilisateur a marqué « ce n'est pas du spam » → label négatif |
| Recommandation produit | L'utilisateur a cliqué / acheté / ignoré → signal implicite |
| Classification de tickets | Le support a corrigé la catégorie assignée par l'IA → label explicite |
| Chatbot | L'utilisateur a reformulé sa question → signal d'échec |
| Détection de fraude | Un analyste a validé / infirmé l'alerte → label explicite |

Ces signaux, **collectés proprement et stockés**, deviennent le **dataset de demain** pour ré-entraîner le modèle.

### Concevoir la boucle dès le début

On ne rajoute pas une boucle de feedback à un modèle déjà en prod — **on la prévoit dès le cadrage** du projet :

1. **Quel signal** peut-on capter après chaque prédiction ?
2. **Comment le stocker** de façon structurée et sans dégrader l'UX ?
3. **Qui le relit** et corrige les faux positifs / faux négatifs ?
4. **À quelle fréquence** ré-entraîne-t-on avec ces nouvelles données ?

```{admonition} Sur le terrain
:class: important
Un des critères qui distingue un projet ML qui **dure** d'un projet ML « one-shot », c'est la **boucle de feedback**. Sans elle, le modèle se dégrade inévitablement. Avec elle, il s'améliore mois après mois, grâce aux corrections du métier et des utilisateurs.

**Si vous ne pouvez pas concevoir de boucle de feedback dès le début, posez-vous la question : est-ce que ce modèle vaut la peine d'être mis en production ?**
```

## Quand faut-il ré-entraîner ?

Il y a **quatre bons signaux** pour déclencher un ré-entraînement :

1. **Les performances baissent** sur les nouvelles données annotées (critère le plus direct).
2. **La distribution des features** a changé significativement (data drift détecté).
3. **De nouvelles données annotées** sont disponibles (il serait dommage de ne pas les utiliser).
4. **Le contexte métier** a changé (nouveau produit, nouveau pays, nouvelle réglementation).

Une cadence typique pour un projet « classique » : **ré-entraînement mensuel** avec les données du mois précédent. Pour des domaines très dynamiques (fraude, recommandation), ça peut être **quotidien** ou **continu**.

**Chaque ré-entraînement doit être validé comme un nouveau modèle** : même batterie de tests, même comparaison avec l'ancien sur un jeu de validation, même revue métier. Un ré-entraînement automatique qui casse silencieusement la performance en prod, c'est le pire scénario.

## 🎯 À retenir

- **Le notebook à la production, c'est une vraie phase de projet** — pas une formalité. Comptez du temps pour refactorer, tester, documenter.
- **Plusieurs modes de déploiement existent** : batch (le plus simple), API temps réel, streaming, embarqué. **Le batch suffit dans 80 % des cas.**
- **Déployer, c'est le début de la maintenance**, pas la fin. Un modèle en production se surveille.
- **Le model drift est inévitable** : prévoyez du monitoring et un plan de ré-entraînement.
- **La boucle de feedback utilisateur est le saint graal** : sans elle, le modèle se dégrade ; avec elle, il s'améliore dans le temps.
- **Le projet ML ne finit jamais vraiment** — il entre juste dans sa phase d'exploitation continue.

## Ce que vous avez appris dans ce module

Le module 6 vous a donné **la culture** du passage en production, sans (encore) coder l'API ou le pipeline CI/CD vous-même. Vous savez maintenant :

- gérer des **environnements Python** reproductibles (venv, conda, pixi) — et pourquoi ça compte,
- que **la méthodologie ML est différente** d'un projet logiciel classique (phase R&D, no-go possible),
- comment s'organise une **équipe ML** autour du compute, des données et du versioning,
- quels sont les **outils MLOps** modernes (Git + DVC, MLflow, LabelStudio…),
- quels **modes de déploiement** existent et lequel choisir,
- pourquoi le **monitoring et la boucle de feedback** sont au cœur de la durabilité d'un projet ML.

**Dans le TP qui suit** (chapitre 5), vous allez pratiquer la première brique — la gestion d'environnements — en créant successivement un `venv`, un `conda env` et un projet `pixi` dans un conteneur de sandbox.
