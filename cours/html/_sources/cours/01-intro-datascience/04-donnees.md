# Les données

## Le carburant du Machine Learning

Sans données, pas de ML. Mais toutes les données ne se valent pas. Avant de se jeter sur les algorithmes, il faut comprendre **ce qu'on a entre les mains** et quelles difficultés on va rencontrer.

## Les types de données qu'on rencontre

### Données tabulaires (le quotidien du ML classique)

C'est le format qu'on va utiliser dans cette formation : des lignes (observations) et des colonnes (variables/features). Un tableau Excel, un export CSV, une table SQL.

Notre dataset Water Pump ressemble à ça :

| id | amount_tsh | funder | installer | longitude | latitude | population | status_group |
|----|-----------|---------|-----------|-----------|----------|-----------|--------------|
| 69572 | 6000 | Roman | Roman | 34.93 | -9.85 | 321 | functional |
| 8776 | 0 | Grumeti | GRUMETI | 34.69 | -2.14 | 25 | functional needs repair |
| 34310 | 25 | Lindi | ... | 35.41 | -7.98 | 0 | non functional |

Chaque ligne = une pompe. Chaque colonne = une caractéristique de cette pompe. La dernière colonne (`status_group`) = ce qu'on veut prédire.

### Autres types de données

Le ML ne se limite pas aux tableaux. On peut aussi travailler sur :
- **Du texte** : emails, avis clients, documents (NLP)
- **Des images** : photos satellites, radios médicales, contrôle qualité visuel
- **Des séries temporelles** : capteurs IoT, cours de bourse, consommation d'énergie
- **Des graphes** : réseaux sociaux, molécules, cartographies

Dans cette formation, on se concentre sur les **données tabulaires** car c'est le cas le plus fréquent en entreprise et c'est la base pour comprendre tout le reste.

## Les vrais problèmes avec les données

La théorie présente souvent des datasets propres. La réalité est très différente. Voici ce qu'on rencontre systématiquement — et qu'on va vivre avec le Water Pump :

### Valeurs manquantes

Certaines cellules sont vides. Pourquoi ? Le capteur était en panne, l'opérateur a oublié de remplir le champ, l'information n'existait pas à l'époque...

Dans notre dataset : la colonne `funder` (qui finance la pompe) a des centaines de valeurs manquantes. On ne peut pas les ignorer — il faudra décider quoi en faire.

### Données incohérentes

Des coordonnées GPS à (0, 0) — au milieu de l'océan Atlantique. Une population de "0" pour un village. Un installateur nommé "0" ou "-". Ces données existent dans le vrai dataset et il faudra les traiter.

### Cardinalité élevée

La colonne `installer` (qui a installé la pompe) contient **plus de 2 000 valeurs différentes**, avec des variantes comme "Government", "GOVERNMENT", "Goverment", "government of tanzania"... C'est le même installateur écrit de 4 façons différentes.

### Déséquilibre des classes

Sur nos 59 400 pompes :
- ~54% sont fonctionnelles
- ~38% sont en panne
- ~7% ont besoin de réparation

La classe "à réparer" est sous-représentée. Si le modèle prédit toujours "fonctionnelle", il a déjà raison dans plus de la moitié des cas — mais il est inutile.

```{admonition} Point clé
:class: important
**La qualité des données détermine la qualité du modèle.** Un algorithme sophistiqué sur des données pourries donnera de moins bons résultats qu'un algorithme simple sur des données bien préparées. C'est pourquoi on passe en pratique **60 à 80% du temps** d'un projet ML sur la préparation des données.
```

## Le volume de données : ni trop, ni trop peu

On entend souvent parler de "Big Data" comme si c'était un prérequis du ML. **Ce n'est pas le cas.**

- Avec **trop peu** de données, le modèle n'a pas assez d'exemples pour apprendre des patterns fiables
- Avec **trop** de données non pertinentes, on ajoute du bruit sans améliorer les résultats
- Certains algorithmes fonctionnent très bien avec quelques milliers de lignes
- Notre dataset de 59 400 lignes est un volume tout à fait raisonnable pour du ML classique

Ce qui compte, c'est la **qualité** et la **représentativité** des données, pas uniquement leur volume.

```{admonition} Sur le terrain
:class: tip
Quand on vous dit "on a pas assez de données pour faire du ML", posez ces questions :
- **Combien d'exemples de chaque classe ?** 50 exemples par classe, c'est souvent un minimum viable. 500, c'est confortable.
- **Les données sont-elles représentatives ?** Si vous voulez prédire des pannes mais que votre historique ne contient que des pompes neuves, même 1 million de lignes ne suffira pas.
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
