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

### Les 6 étapes, appliquées à notre fil rouge

**1. Compréhension métier** — *Qu'est-ce qu'on essaie de résoudre ?*
> Le ministère de l'Eau veut savoir quelles pompes envoyer en maintenance. L'objectif n'est pas d'avoir le modèle le plus précis possible, c'est d'**optimiser l'allocation des équipes de terrain**.

**2. Compréhension des données** — *Qu'est-ce qu'on a ?*
> 59 400 pompes, 40 variables, des données GPS, des catégories textuelles, des dates. Beaucoup de bruit.

**3. Préparation des données** — *Comment les rendre exploitables ?*
> Nettoyer les coordonnées GPS aberrantes, regrouper les installateurs qui ont 50 orthographes différentes, encoder les variables catégorielles, gérer les valeurs manquantes.

**4. Modélisation** — *Quel algorithme choisir ?*
> On teste plusieurs approches : arbre de décision pour comprendre, Random Forest pour la performance, Gradient Boosting pour grappiller quelques points.

**5. Évaluation** — *Est-ce que ça marche ?*
> On regarde les métriques sur le jeu de test. Mais surtout : est-ce que le modèle est **utile** pour le métier ? Si on prédit bien les pompes fonctionnelles mais mal celles en panne, ça ne sert à rien.

**6. Déploiement** — *Comment on l'utilise au quotidien ?*
> Mettre le modèle en production pour qu'il soit utilisé par les équipes de terrain. Monitorer ses performances dans le temps.

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
Le modèle trouve que les pompes proches d'une route sont plus souvent en panne. Est-ce que la route **cause** la panne ? Ou est-ce que les pompes proches des routes sont juste plus visibles et donc plus souvent inspectées ?

### 4. Ignorer le déploiement
Un modèle dans un notebook Jupyter ne sert à personne. Il faut penser dès le début à comment il sera utilisé en production.

### 5. Ne pas monitorer après le déploiement
Les données changent avec le temps. Un modèle entraîné en 2023 peut devenir mauvais en 2025 parce que les types de pompes installées ont évolué. C'est le **model drift**.

```{admonition} Sur le terrain
:class: tip
**La question à 1000 euros pour démarrer un projet ML dans votre entreprise :**

1. Quel est le problème métier ? (pas "je veux faire du ML", mais "je veux réduire les pannes de 20%")
2. Est-ce que j'ai des données historiques avec la réponse que je veux prédire ?
3. Qu'est-ce qu'on fait aujourd'hui sans ML ? (c'est votre baseline à battre)
4. Si le modèle se trompe, quelles sont les conséquences ? (prédire qu'une pompe marche alors qu'elle est en panne = des gens sans eau)
5. Qui va utiliser les résultats et comment ?

Si vous savez répondre à ces 5 questions, vous avez un projet ML viable.
```
