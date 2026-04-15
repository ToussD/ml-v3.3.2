# La méthodologie d'un projet ML

## Un projet ML n'est pas un projet logiciel classique

Si vous avez déjà participé à un projet de développement — site web, application mobile, logiciel métier — vous connaissez le cycle classique :

```
Spécifications → Conception → Développement → Tests → Livraison
```

Chaque étape a un livrable clair, un planning, des critères d'acceptation. Le client sait ce qu'il va recevoir. L'équipe sait quand elle aura fini. **Le résultat est essentiellement prévisible** : on sait qu'on est capable de faire une page de connexion, un formulaire, un panier d'achat — c'est « juste » une question de temps et de rigueur.

**Un projet ML, c'est fondamentalement différent.** On part d'une question du type :

> « Est-ce qu'on peut prédire le risque de panne d'un équipement à partir des capteurs ? »
> « Est-ce qu'on peut détecter automatiquement les fraudes dans nos transactions ? »
> « Est-ce qu'on peut classer les tickets support par thème pour accélérer le routage ? »

La réponse honnête, au démarrage du projet, c'est : **« On ne sait pas. Il faut essayer. »**

> **L'analogie à garder en tête :** un projet logiciel classique, c'est comme **construire une maison**. L'architecte dessine, les maçons posent les briques, la maison finit par exister. Un projet ML, c'est comme **monter une expédition scientifique** : vous avez une hypothèse (« il y a peut-être un gisement là-bas »), vous partez avec du matériel, mais **vous ne savez pas à l'avance si vous allez trouver quelque chose**. Parfois oui. Parfois non. Parfois ce qu'on trouve n'a rien à voir avec ce qu'on cherchait.

## La phase de R&D : l'ingrédient qui change tout

Un projet ML commence **toujours** par une phase de **recherche & développement** — même sur des sujets qui paraissent simples. Cette phase répond à trois questions :

1. **Les données existent-elles ?** (et sont-elles utilisables)
2. **Le signal est-il assez fort** pour qu'un modèle l'apprenne ?
3. **La performance atteignable** est-elle suffisante pour l'usage visé ?

Tant qu'on n'a pas répondu à ces trois questions, **on ne peut pas promettre de résultat**. C'est la différence fondamentale avec un projet logiciel classique : en ML, la faisabilité **doit être démontrée expérimentalement**, elle ne se déduit pas d'une spécification.

### Exemple : un projet de maintenance prédictive

Imaginons une usine qui veut prédire les pannes d'une machine à partir de ses capteurs de température, vibration et pression. Les étapes réalistes :

1. **Semaine 1–2** : comprendre le métier, les pannes, les données existantes. *Conclusion possible : les capteurs n'enregistrent des valeurs que toutes les 10 minutes, or les pannes durent 30 secondes. Les données sont inutilisables telles quelles.*
2. **Semaine 3–4** : récupérer les historiques, nettoyer, labéliser les incidents. *Conclusion possible : on n'a que 40 incidents en 2 ans. C'est trop peu pour apprendre.*
3. **Semaine 5–6** : construire un premier modèle baseline, mesurer le recall et la précision. *Conclusion possible : on détecte 30 % des pannes 1h avant, avec 50 % de faux positifs. Est-ce utile pour l'usine ?*

À chaque étape, **le projet peut s'arrêter** — c'est parfaitement normal, et même sain.

## Le projet peut être « no go » — et c'est OK

Dans un projet logiciel classique, dire au client « finalement on ne fait pas » est presque un aveu d'échec. En ML, **c'est une conclusion parfaitement acceptable** — à condition de l'avoir démontrée proprement.

Trois raisons typiques de déclarer un « no go » :

- **Données insuffisantes ou inutilisables** (pas assez de volume, pas de labels, qualité douteuse, fuite de données…)
- **Signal trop faible** (même le meilleur modèle imaginable ne dépasse pas 55 % sur un problème binaire où il faut 90 %)
- **Performance atteignable insuffisante pour l'usage** (on sait faire mais l'usage métier demande 99 %, on plafonne à 80 %)

```{admonition} Sur le terrain
:class: important
Un « no go » bien documenté est un **livrable à part entière** :

- il explique **pourquoi** ça ne marche pas (données, signal, faisabilité, latence, coût),
- il dit **ce qu'il faudrait** pour que ça marche (plus de données, un meilleur capteur, un autre approche, un budget différent),
- il **évite de brûler du budget** sur un projet voué à l'échec.

Un data scientist senior est capable, dans 80 % des cas, de pressentir un no go **avant** la phase d'ingénierie. Ne cachez pas les mauvaises nouvelles — annoncez-les tôt et clairement. C'est ça qui crée la confiance avec les métiers.
```

## Le cycle réaliste d'un projet ML

Voici le cycle tel qu'il se passe vraiment — beaucoup plus itératif qu'un projet logiciel classique :

```
┌─── Cadrage métier ───┐
│                      ▼
│             Exploration données
│                      │
│                      ▼
│          ┌──── Prototype modèle ──→ No go ? ──→ 🛑 Arrêt propre
│          │           │                            (livrable de synthèse)
│          │           ▼
│          │     Validation métier ←──── Feedback utilisateur
│          │           │
│          │           ▼
│          │     Industrialisation
│          │     (scripts, CI, déploiement)
│          │           │
│          │           ▼
│          │     Production & monitoring
│          │           │
│          └───────────┤
│                      │
└── Ré-entraînement ◄──┘  (le projet ne finit jamais vraiment)
```

Quelques différences majeures avec un projet logiciel classique :

| Projet logiciel classique | Projet ML |
|---|---|
| Spécifications complètes au départ | Hypothèses floues, à valider expérimentalement |
| Planning prévisible | Planning par **jalons** et **go/no-go** |
| Livrable = code + UI | Livrable = **modèle + données + code** (triple) |
| « Fini » = déployé | « Fini » = **jamais** (ré-entraînement continu) |
| Tests unitaires / intégration | Tests de **performance** sur données de validation |
| Bug = ligne de code à corriger | « Bug » = souvent un problème de **données** |

## Les phases qu'on ne saute pas

### 1. Cadrage métier (1–2 semaines)

Avant d'écrire une ligne de code : **comprendre le problème métier**.

- **Quelle est la question à laquelle on répond ?** (prédire quoi, pour qui, quand)
- **Qu'est-ce qu'une « bonne » prédiction pour le métier ?** (seuil de précision ? rappel prioritaire ? latence max ?)
- **Qui va utiliser le modèle et comment ?** (alerte en temps réel ? rapport hebdomadaire ?)
- **Quelles actions** seront prises sur la base des prédictions ? (automatiques ? humain dans la boucle ?)
- **Quel est le coût d'un faux positif et d'un faux négatif ?** (pas du tout la même chose en médecine, en fraude, en marketing)

Cette phase **n'a rien à voir avec le ML** — c'est du dialogue métier. Et pourtant, **c'est elle qui fait la différence entre un projet utile et une démo gadget**.

### 2. Exploration des données (2–4 semaines)

- D'où viennent les données ? Qui les produit ? Comment sont-elles collectées ?
- Quelle est la **qualité** ? (manquants, incohérences, changements de format au cours du temps)
- Y a-t-il des **biais** cachés ? (sous-représentation de certaines populations, survivor bias, data leakage…)
- Y a-t-il **assez** de données ? De **labels** ?

Cette phase révèle presque toujours des surprises — et parfois décide à elle seule de la faisabilité du projet.

### 3. Prototypage (2–6 semaines)

On construit un premier modèle, aussi simple que possible, pour **répondre à la question de faisabilité**. L'objectif n'est **pas** d'avoir un modèle parfait : c'est de **savoir s'il y a du signal**.

C'est le moment où un **baseline simple** (régression logistique, arbre de décision) est ami : s'il obtient déjà 75 % sur un problème qui en demande 80 %, la suite est une question d'optimisation. S'il est à 51 % sur un problème binaire, **il n'y a peut-être rien à apprendre** — ou alors vos données ne portent pas le signal que vous cherchez.

### 4. Validation métier (1–2 semaines)

On présente le prototype au métier. Ils testent, ils critiquent, ils donnent leur avis. **C'est ici qu'on décide go/no-go** sur l'industrialisation.

Souvent le métier pointe des cas limites auxquels le data scientist n'avait pas pensé (« Attention, ce cas-là on ne doit JAMAIS le classer comme positif, ça casserait la relation client »). Ces retours sont **cruciaux** et **précieux** — ils obligent à raffiner ou recalibrer.

### 5. Industrialisation (4–12 semaines)

On transforme le prototype en code de production — c'est la phase où intervient tout le module 6 : structurer en scripts, sérialiser, déployer, monitorer (voir chapitres suivants). Cette phase est **beaucoup plus proche d'un projet logiciel classique** : on sait ce qu'on veut, il faut le construire proprement.

### 6. Production & monitoring (permanent)

Le modèle est en prod. On surveille ses performances, on collecte les retours utilisateurs, on prépare le ré-entraînement. **Ce n'est pas la fin du projet — c'est son nouveau rythme de croisière.**

## 🎯 À retenir

- **Un projet ML n'est pas un projet logiciel classique** : sa faisabilité se démontre, elle ne se déduit pas d'un cahier des charges.
- **La phase de R&D est obligatoire** — même courte, elle répond aux questions « a-t-on les données ? y a-t-il du signal ? l'usage est-il possible ? ».
- **Un « no go » bien argumenté est un livrable valide** — il évite de brûler du budget sur un projet voué à l'échec.
- **Le cycle est itératif** : cadrage → exploration → prototype → validation métier → industrialisation → production. Et on recommence.
- **Le livrable final n'est pas seulement du code**, c'est le triplet **données + code + modèle**, chacun versionné indépendamment.

Dans le chapitre suivant, on regarde comment une équipe ML s'organise concrètement autour de ces contraintes — compute, accès aux données, travail en équipe, versioning.
