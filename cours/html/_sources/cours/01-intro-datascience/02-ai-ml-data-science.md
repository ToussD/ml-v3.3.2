# Intelligence Artificielle, Machine Learning et Data Science

> "When you're fundraising, it's AI. When you're hiring, it's ML. When you're implementing, it's linear regression. When you're debugging, it's printf()." — Baron Schwartz

Cette citation résume bien la confusion qui règne autour de ces termes. Clarifions.

## IA, ML, Data Science : qui fait quoi ?

Ces trois termes sont souvent utilisés de façon interchangeable, alors qu'ils désignent des choses différentes :

**L'Intelligence Artificielle (IA)** est le concept le plus large : c'est l'idée de créer des systèmes capables de résoudre des problèmes qu'on associe habituellement à l'intelligence humaine. Reconnaître un visage, comprendre une phrase, jouer aux échecs — tout ça relève de l'IA.

**Le Machine Learning (ML)** est une **façon de faire de l'IA**. Au lieu de programmer des règles à la main ("si le mot *gratuit* apparaît, c'est un spam"), on donne des exemples à un algorithme et il apprend les règles tout seul à partir des données. C'est le cœur de cette formation.

**La Data Science** est la **discipline** qui utilise le ML (entre autres outils) pour **extraire de la valeur à partir de données** et aider à la prise de décision. Un data scientist ne fait pas que des modèles : il explore les données, les nettoie, les visualise, communique ses résultats, et s'assure que tout ça a du sens métier.

```{admonition} En résumé
:class: important
- **IA** = le grand chapeau (faire des trucs "intelligents")
- **ML** = une technique pour y arriver (apprendre à partir de données)
- **Data Science** = le métier qui utilise tout ça pour résoudre des problèmes concrets
```

## L'IA dans l'histoire : des règles manuelles au Machine Learning

Historiquement, l'IA a évolué en plusieurs vagues :

### Les systèmes à base de règles (années 1970-80)

Des experts codent leurs connaissances sous forme de règles `SI ... ALORS ...`. Par exemple, un système expert médical : "si le patient a de la fièvre ET des boutons, alors c'est peut-être la varicelle".

**Le problème** : ça marche quand le domaine est simple et bien compris. Mais dès que ça se complique (reconnaître un chat sur une photo, traduire un texte), il faudrait écrire des millions de règles — et on ne saurait même pas lesquelles.

### Le Machine Learning (années 1990-aujourd'hui)

L'approche inverse : au lieu de dire à la machine **comment** faire, on lui donne des **exemples** et elle apprend. On lui montre 10 000 photos de chats et 10 000 photos de chiens, et elle trouve elle-même les critères qui les distinguent.

C'est l'approche qu'on va utiliser pour nos pompes à eau : on ne va pas coder "si la pompe a plus de 10 ans ET qu'elle est de type X, alors elle est en panne". On va donner au modèle les données de 59 000 pompes avec leur état, et il va apprendre tout seul les patterns.

### Le Deep Learning (années 2010-aujourd'hui)

Un cas particulier du ML, inspiré du fonctionnement des neurones biologiques. Très performant pour les images, le texte et le son. On en parlera en fin de formation — pour la plupart des problèmes métier "classiques" (données tabulaires), le ML classique reste souvent le meilleur choix.

```{admonition} Sur le terrain
:class: tip
Ne tombez pas dans le piège du "il me faut du Deep Learning". Pour des données tabulaires (les tableurs Excel, les bases de données, les exports CSV que vous avez en entreprise), les algorithmes classiques comme les Random Forests ou le Gradient Boosting sont souvent **plus performants**, **plus rapides** et **plus faciles à expliquer** que le Deep Learning.
```

## La Data Science : on rentre dans le monde de l'incertain

La Data Science, c'est accepter qu'on ne va pas trouver la vérité absolue. On va trouver le **modèle le moins faux possible** étant donné les données dont on dispose.

Concrètement, un data scientist :

- **Explore** les données pour comprendre ce qu'elles racontent (et ce qu'elles ne racontent pas)
- **Nettoie et transforme** les données pour les rendre exploitables par les algorithmes
- **Construit et évalue** des modèles de Machine Learning
- **Communique** ses résultats et leurs limites aux décideurs
- **Met en production** ses modèles pour qu'ils servent au quotidien

Ce n'est pas un processus linéaire — c'est un cycle d'itérations. On va le vivre tout au long de cette formation.

```{admonition} Données → Information → Connaissance → Décision
:class: note
- **Données** : "la pompe #4238 est de type *communal standpipe*, installée en 2003 à la latitude -8.93"
- **Information** : "les pompes communales installées avant 2005 dans cette région ont un taux de panne de 45%"
- **Connaissance** : "l'âge et le type de pompe sont de bons prédicteurs de panne dans les régions à faible altitude"
- **Décision** : "on envoie l'équipe de maintenance en priorité sur les pompes communales d'avant 2005 de la zone côtière"
```
