# Les outils Python pour la data science

## Ce que couvre ce module

Ce module présente l'écosystème Python utilisé en data science : le langage lui-même, les environnements de développement (Jupyter), et les bibliothèques spécialisées qui font de Python l'outil de référence du data scientist.

## La boîte à outils du data scientist

Voici les bibliothèques que vous allez utiliser tout au long de cette formation :

| Bibliothèque | Rôle | Analogie |
|---|---|---|
| **NumPy** | Calcul numérique rapide (tableaux, algèbre linéaire) | La calculatrice scientifique |
| **Pandas** | Manipulation de données tabulaires (CSV, SQL, Excel) | Le tableur surpuissant |
| **Matplotlib** | Graphiques de base | Le papier millimétré |
| **Seaborn** | Graphiques statistiques élégants | Le designer graphique |
| **Scikit-learn** | Algorithmes de Machine Learning | La boîte à outils ML |

Il y en a d'autres — **SciPy** pour le calcul scientifique et les statistiques, **Statsmodels** pour les modèles statistiques, **XGBoost** pour les modèles avancés — mais ces cinq-là couvrent 90% de ce qu'on fait au quotidien.

### Comment elles s'emboîtent

Pensez à ces bibliothèques comme une chaîne de montage :

1. **Pandas** charge et nettoie vos données (un fichier CSV, une base de données...)
2. **NumPy** fait les calculs lourds sous le capot (Pandas l'utilise en interne)
3. **Matplotlib / Seaborn** vous permettent de *voir* ce qui se passe dans vos données
4. **Scikit-learn** entraîne des modèles sur vos données préparées

On ne les utilise pas une par une dans l'ordre — on navigue entre elles en permanence. Mais cette logique **charge → explore → modélise** est le fil conducteur de cette formation.
