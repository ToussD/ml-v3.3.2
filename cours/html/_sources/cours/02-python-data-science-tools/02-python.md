# Python

## Généralités

- Créé en 1991 (actuellement en version 3.11)
- Open Source (Python Software Foundation License)
- Un langage de script généraliste
- Interprété
- Programmation impérative structurée
- Supporte le paradigme de la programmation fonctionnelle et objet
- Typage dynamique
- Gestion de la mémoire via un garbage collector
- Présent sur l'ensemble des OS
- Syntaxe épurée (plus simple que C)

## De nombreuses librairies qui étendent le langage

- Webscrapping : scrappy et beautyfulsoup
- Client HTTP : requests
- Analyse de trame réseau : scapy
- ...
- Un des langages phare pour le data scientist
  - De nombreuses librairies pour la data science

## Interpréteur

- Un interpréteur permet d'exécuter en mode pas à pas
- Un programme python peut être démarré en ligne de commande :
  - `python filename.py`

## Jupyter notebook

- Environnement de développement et d'exécution de vos applications python
- Très utilisé en data science pendant la phase exploratoire

## IDEs

### PyCharm

- Editeur Jetbrain
- Edition commerciale ou Community

### Visual Studio Code
- Editeur Microsoft
- Open Source
- Editeur de code extensible pour Windows, Linux et macOS

### code-oss

- Version open source de Visual Studio

### jupyter-lab

- Environnement de développement tournant dans un navigateur
- Essentiellement tourné vers le développement des notebooks jupyter


## Les identifiants en python

- Commencent par une lettre ou un '_', suivi par 0 ou plusieurs lettres ou chiffres
- Les signes '@', '$' et '%' ne peuvent pas être utilisés dans un identifiant
- Un identifiant est sensible à la casse

## Convention de nommage des classes

- Seul le nom d'une classe commence par une majuscule.
- Tous les autres identifiants démarrent par une minuscule (attributs, variables, ...)
- Un identifiant qui démarre par un '_' est considéré comme privé
- Un identifiant post-fixé par un double underscore __ est un identifiant prédéfini du langage.


## Mots réservés

![Mots réservés](../../images/reserved-words.png)

## Lignes et indentation

- Un bloc de code se démarque par des indentations
- Le nombre d'espaces de l'indentation peut varier, mais toutes les lignes d'un bloc doivent-être indentées avec le même nombre d'espaces

Exemple:

```
if True:
  print("True")
else:
  print("False")
```
## Suite

- Le regroupement de plusieurs commandes en python, qui composent un bloc de code, est appelé suite.
- Les structures de contrôle 'if', 'while', ... nécessitent une ligne d'entête ainsi qu'une suite.
- Une ligne d'entête commence par la commande et se termine par ':' et est suivie par une ou plusieurs lignes qui composent la suite
- Attention à l'indentation !

Exemple:

```
if True:              # ligne d'entête
  print("True")       # suite
  print("Yes, True")  # suite
```