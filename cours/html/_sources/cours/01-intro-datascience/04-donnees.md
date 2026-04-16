# Les données

## Le carburant du Machine Learning

Sans données, pas de ML. Mais toutes les données ne se valent pas. Avant de se jeter sur les algorithmes, il faut comprendre **ce qu'on a entre les mains** et quelles difficultés on va rencontrer.

## Les types de données qu'on rencontre

### Données tabulaires (le quotidien du ML classique)

C'est le format qu'on va utiliser dans cette formation : des lignes (observations) et des colonnes (variables/features). Un tableau Excel, un export CSV, une table SQL.

Par exemple, un dataset classique comme celui des passagers du Titanic ressemble à ça :

| PassengerId | Survived | Pclass | Name | Sex | Age | SibSp | Parch | Fare | Cabin | Embarked |
|-------------|----------|--------|------|-----|-----|-------|-------|------|-------|----------|
| 1 | 0 | 3 | Braund, Mr. Owen Harris | male | 22 | 1 | 0 | 7.25 | NaN | S |
| 2 | 1 | 1 | Cumings, Mrs. John | female | 38 | 1 | 0 | 71.28 | C85 | C |
| 3 | 1 | 3 | Heikkinen, Miss. Laina | female | 26 | 0 | 0 | 7.92 | NaN | S |

Chaque ligne = un passager. Chaque colonne = une caractéristique. La colonne `Survived` = ce qu'on veut prédire (0 = décédé, 1 = survie).

### Autres types de données

Le ML ne se limite pas aux tableaux. On peut aussi travailler sur :
- **Du texte** : emails, avis clients, documents (NLP)
- **Des images** : photos satellites, radios médicales, contrôle qualité visuel
- **Des séries temporelles** : capteurs IoT, cours de bourse, consommation d'énergie
- **Des graphes** : réseaux sociaux, molécules, cartographies

Dans cette formation, on se concentre sur les **données tabulaires** car c'est le cas le plus fréquent en entreprise et c'est la base pour comprendre tout le reste.

## Les vrais problèmes avec les données

La théorie présente souvent des datasets propres. La réalité est très différente. Voici ce qu'on rencontre systématiquement :

### Valeurs manquantes

Certaines cellules sont vides (NaN). Pourquoi ? L'information n'a pas été enregistrée, le document a été perdu, la donnée n'existait pas à l'époque...

Dans le dataset Titanic par exemple : la colonne `Age` a environ **20% de valeurs manquantes** et la colonne `Cabin` environ **77% de NaN**. On ne peut pas les ignorer — il faudra décider quoi en faire.

### Données à haute cardinalité

Une colonne `Name` contient un nom unique par passager — inutilisable directement par un modèle. Mais elle peut contenir un titre (Mr., Mrs., Miss., Master...) qu'on peut extraire et qui est très informatif. C'est un cas classique : trop de valeurs distinctes pour être utilisées telles quelles, mais de l'information précieuse à en extraire.

### Données incohérentes

Des coordonnées GPS à (0, 0) — au milieu de l'océan Atlantique. Une population de "0" pour un village. Un installateur nommé "0" ou "-". Ces cas existent dans les vrais datasets et il faut les traiter.

### Déséquilibre des classes

Dans beaucoup de problèmes réels, les classes ne sont pas représentées de façon égale. Par exemple, sur les passagers du Titanic : ~62% sont décédés, ~38% ont survécu. Si le modèle prédit toujours "décédé", il a déjà raison dans plus de 6 cas sur 10 — mais il est inutile. En détection de fraude, c'est encore pire : 99,9% de transactions légitimes.

```{admonition} Point clé
:class: important
**La qualité des données détermine la qualité du modèle.** Un algorithme sophistiqué sur des données pourries donnera de moins bons résultats qu'un algorithme simple sur des données bien préparées. C'est pourquoi on passe en pratique **60 à 80% du temps** d'un projet ML sur la préparation des données.
```

## Le volume de données : ni trop, ni trop peu

On entend souvent parler de "Big Data" comme si c'était un prérequis du ML. **Ce n'est pas le cas.**

- Avec **trop peu** de données, le modèle n'a pas assez d'exemples pour apprendre des patterns fiables
- Avec **trop** de données non pertinentes, on ajoute du bruit sans améliorer les résultats
- Certains algorithmes fonctionnent très bien avec quelques centaines de lignes
- Un dataset de 891 lignes est un volume modeste mais suffisant pour du ML classique, surtout en classification binaire

Ce qui compte, c'est la **qualité** et la **représentativité** des données, pas uniquement leur volume.

```{admonition} Sur le terrain
:class: tip
Quand on vous dit "on a pas assez de données pour faire du ML", posez ces questions :
- **Combien d'exemples de chaque classe ?** 50 exemples par classe, c'est souvent un minimum viable. 500, c'est confortable.
- **Les données sont-elles représentatives ?** Si vous voulez prédire la survie mais que votre historique ne contient que des passagers de 1re classe, même 10 000 lignes ne suffira pas.
- **La qualité est-elle là ?** 1 000 lignes propres valent mieux que 100 000 lignes avec 90% de bruit.
```

## Les Vs du Big Data (pour la culture)

Le concept des "Vs" du Big Data reste utile pour **cadrer les contraintes** d'un projet data :

| V | Signification | Impact sur le ML |
|---|---------------|-----------------|
| **Volume** | Quantité de données | Certains algorithmes ne passent pas à l'échelle. A adapter. |
| **Vélocité** | Vitesse de production des données | Apprentissage batch vs temps réel — on en reparlera dans le module "mise en production" |
| **Variété** | Formats multiples (tableaux, images, texte...) | Détermine le choix de l'architecture ML |
| **Véracité** | Fiabilité des données | Le problème n°1 en pratique — c'est tout ce qu'on a vu sur les données sales |
| **Variabilité** | Les données changent avec le temps | Le modèle entraîné aujourd'hui peut devenir obsolète demain (model drift) |
| **Valeur** | Quel retour sur investissement ? | La question que votre manager va poser — et la plus dure à quantifier |

```{admonition} Sur le terrain
:class: tip
En entreprise, la **Véracité** et la **Valeur** sont vos deux vrais défis. Les discussions sur le Volume sont souvent un faux problème : la plupart des projets ML ne sont pas du Big Data. Par contre, la question "est-ce que mes données sont fiables ?" et "est-ce que ça vaut le coup ?" — celles-là, vous les aurez à chaque projet.
```
