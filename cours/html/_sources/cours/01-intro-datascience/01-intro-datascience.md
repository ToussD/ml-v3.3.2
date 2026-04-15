# Introduction à la Data Science

## Objectifs

À la fin de ce module, vous saurez :

- Expliquer ce qu'est le Machine Learning à un collègue en 2 minutes
- Distinguer les grands types d'apprentissage (supervisé, non supervisé, etc.)
- Comprendre pourquoi les données sont au centre de tout
- Situer le rôle du Data Scientist et son processus de travail
- Avoir une vision claire du problème qu'on va résoudre ensemble tout au long de cette formation

## Notre fil rouge : les pompes à eau en Tanzanie

Tout au long de cette formation, on va travailler sur un **vrai problème** issu de données réelles.

**Le contexte** : en Tanzanie, des milliers de pompes à eau alimentent la population. Certaines fonctionnent, d'autres sont en panne, d'autres encore ont besoin de réparation. Le ministère de l'Eau dispose de données sur ces pompes (localisation GPS, type de pompe, qui l'a installée, qui la finance, la source d'eau, etc.) mais il y en a **plus de 59 000** et les équipes de maintenance ne peuvent pas tout vérifier sur le terrain.

**La question** : peut-on prédire quelles pompes sont en panne ou vont tomber en panne, pour envoyer les équipes de maintenance au bon endroit ?

**Pourquoi ce cas est parfait pour apprendre** :

- C'est un **vrai dataset** (issu de la compétition DrivenData "Pump it Up")
- Les données sont **sales** : valeurs manquantes, colonnes avec des milliers de catégories, coordonnées GPS erronées, doublons
- C'est un problème de **classification multi-classe** (3 états : fonctionnelle / à réparer / en panne) avec des classes déséquilibrées
- Il y a un **vrai enjeu humain et économique** : des gens n'ont plus accès à l'eau potable
- Les difficultés qu'on y rencontre sont exactement celles que vous retrouverez dans vos projets métier

```{admonition} Sur le terrain
:class: tip
Ce type de problème — prédire un état, une catégorie, un risque à partir de données historiques — c'est le quotidien du ML en entreprise. Que vous soyez dans l'industrie (maintenance prédictive), la banque (scoring de crédit), la santé (détection de pathologies) ou le retail (prédiction de churn), la mécanique est la même.
```
