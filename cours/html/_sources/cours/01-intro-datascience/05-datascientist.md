# Le Data Scientist et son processus de travail

## Ce que fait un Data Scientist (en vrai)

On imagine souvent le data scientist comme quelqu'un qui passe ses journées à entraîner des modèles. En réalité, voici à quoi ressemble une semaine type :

| Activité | Temps passé | Ce que ça implique |
|----------|------------|-------------------|
| Comprendre le problème métier | 10-15% | Discuter avec les experts du domaine, définir la question |
| Récupérer et nettoyer les données | 30-40% | SQL, APIs, nettoyage, gestion des manquants, corrections |
| Explorer et visualiser | 15-20% | Statistiques descriptives, graphiques, recherche de patterns |
| Modéliser | 10-15% | Entraîner des modèles, tester des algorithmes |
| Évaluer et itérer | 10% | Métriques, cross-validation, ajustements |
| Communiquer les résultats | 5-10% | Présentations, rapports, discussions avec les décideurs |

Le modèle, c'est **15% du travail**. Le reste, c'est du travail de terrain avec les données et les métiers.

## Les compétences nécessaires

Un data scientist se situe à l'intersection de trois domaines :

![Compétences Datascientist](../../images/competences-datascientist.png)

- **Statistiques et mathématiques** : comprendre les algorithmes, interpréter les résultats, éviter les erreurs statistiques
- **Programmation et informatique** : Python, SQL, manipulation de données, mise en production
- **Expertise métier** : comprendre le domaine d'application pour poser les bonnes questions et interpréter les résultats

```{admonition} Point clé
:class: important
On n'a pas besoin d'être expert dans les trois domaines. Un data scientist qui comprend bien le métier mais qui utilise des algorithmes "standards" sera souvent plus utile qu'un expert en deep learning qui ne comprend pas le problème qu'il essaie de résoudre.
```

## Le processus : CRISP-DM

CRISP-DM (Cross Industry Standard Process for Data Mining) est la méthodologie de référence pour structurer un projet de data science. C'est un processus **itératif** — on ne fait pas les étapes une seule fois, on boucle.

![CRISP-DM](https://upload.wikimedia.org/wikipedia/commons/e/e5/Diagramme_du_Processus_CRISP-DM.png)

### Les 6 étapes, illustrées sur un exemple concret

Prenons un cas classique : une banque veut prédire quels clients risquent de ne pas rembourser leur crédit.

**1. Compréhension métier** — *Qu'est-ce qu'on essaie de résoudre ?*
> Réduire le taux de défaut de paiement en identifiant les dossiers à risque avant l'octroi du crédit. L'objectif n'est pas d'avoir le modèle le plus précis possible, c'est de **prendre de meilleures décisions d'octroi**.

**2. Compréhension des données** — *Qu'est-ce qu'on a ?*
> 50 000 dossiers de crédit historiques, 30 variables (revenus, ancienneté, nombre de crédits en cours, historique d'incidents...), et on sait lesquels ont fait défaut. Beaucoup de valeurs manquantes sur les revenus déclarés.

**3. Préparation des données** — *Comment les rendre exploitables ?*
> Gérer les revenus manquants, encoder les variables catégorielles (type de contrat, secteur d'activité), créer de nouvelles features (ratio dette/revenu, ancienneté chez l'employeur actuel).

**4. Modélisation** — *Quel algorithme choisir ?*
> On teste plusieurs approches : régression logistique pour l'interprétabilité, Random Forest pour la performance, Gradient Boosting pour grappiller quelques points.

**5. Évaluation** — *Est-ce que ça marche ?*
> On regarde les métriques sur le jeu de test. Mais surtout : est-ce que le modèle est **utile** pour le métier ? Si on refuse trop de bons clients, le coût commercial dépasse le gain sur les impayés.

**6. Déploiement** — *Comment on l'utilise au quotidien ?*
> Intégrer le score de risque dans le workflow d'octroi de crédit. Monitorer les performances dans le temps — la population de demandeurs évolue.

```{admonition} Ce qui change en pratique
:class: warning
CRISP-DM montre un cycle propre. En réalité :
- Vous allez **revenir en arrière** constamment : un modèle qui marche mal vous ramène à l'étape 3 (préparation des données)
- L'étape 1 (compréhension métier) n'est **jamais terminée** : vous apprenez des choses sur le problème en explorant les données
- L'étape 6 (déploiement) est souvent **sous-estimée** : on y consacrera un module entier en fin de formation
```

## Les pièges classiques d'un projet ML

Avant de se lancer dans le technique, voici les erreurs qu'on voit le plus souvent sur le terrain :

### 1. Ne pas parler au métier
Le data scientist construit un modèle techniquement parfait... mais qui ne répond pas à la bonne question. Toujours commencer par "quel problème métier on essaie de résoudre ?".

### 2. Sous-estimer la préparation des données
"J'ai les données, je commence à modéliser." Non. Les données sont toujours plus sales qu'on le croit. Prévoyez la moitié du projet juste pour ça.

### 3. Confondre corrélation et causalité
Le modèle trouve que les passagers de 1re classe du Titanic survivent plus souvent. Est-ce que la classe **cause** la survie ? Ou est-ce que les cabines de 1re classe étaient simplement plus proches des canots de sauvetage ?

### 4. Ignorer le déploiement
Un modèle dans un notebook Jupyter ne sert à personne. Il faut penser dès le début à comment il sera utilisé en production.

### 5. Ne pas monitorer après le déploiement
Les données changent avec le temps. Un modèle entraîné en 2023 peut devenir mauvais en 2025 parce que la distribution des données en production a évolué. C'est le **model drift**.

```{admonition} Sur le terrain
:class: tip
**Les 5 questions à 1000 euros pour démarrer un projet ML dans votre entreprise :**

1. Quel est le problème métier ? (pas "je veux faire du ML", mais "je veux réduire le taux d'erreur de 20%")
2. Est-ce que j'ai des données historiques avec la réponse que je veux prédire ?
3. Qu'est-ce qu'on fait aujourd'hui sans ML ? (c'est votre baseline à battre)
4. Si le modèle se trompe, quelles sont les conséquences ? (un faux positif en détection de fraude = un client bloqué injustement)
5. Qui va utiliser les résultats et comment ?

Si vous savez répondre à ces 5 questions, vous avez un projet ML viable.
```
