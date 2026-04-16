# Intelligence Artificielle, Machine Learning et Data Science

> *"When you're fundraising, it's AI. When you're hiring, it's ML. When you're implementing, it's linear regression. When you're debugging, it's printf()."* — Baron Schwartz
>
> *"Quand tu lèves des fonds, c'est de l'IA. Quand tu recrutes, c'est du ML. Quand tu implémentes, c'est de la régression linéaire. Quand tu débogues, c'est un printf()."*

Cette citation résume bien la confusion qui règne autour de ces termes. Clarifions.

## Le goalpost qui se déplace : "ça, ce n'est pas vraiment de l'IA"

> *"As soon as it works, no one calls it AI anymore."* — John McCarthy (celui-là même qui a inventé le terme "Intelligence Artificielle" en 1956)
>
> *"Dès que ça fonctionne, plus personne n'appelle ça de l'IA."*

> *"AI is whatever hasn't been done yet."* — Larry Tesler (surnommé **"l'effet IA"**)
>
> *"L'IA, c'est tout ce qu'on n'a pas encore réussi à faire."*

Il y a un phénomène étrange dans l'histoire de l'IA : **à chaque fois qu'une machine réussit une tâche qu'on pensait réservée à l'intelligence humaine, on décide que finalement, cette tâche ne nécessite pas d'intelligence.** Les poteaux du but se déplacent en permanence.

Petit historique de ce qu'on a successivement décrété "pas vraiment de l'IA" :

- **Les échecs (1997)** : quand Deep Blue bat Kasparov, on dit "c'est juste de la force brute, il explore des millions de coups par seconde, un humain ne fait pas ça". Verdict : ce n'est pas de l'intelligence, c'est du calcul.
- **Jeopardy! (2011)** : Watson d'IBM gagne au jeu télévisé. "C'est juste de la recherche dans une base de données massive, pas de la compréhension."
- **Le jeu de Go (2016)** : AlphaGo bat Lee Sedol, un exploit qu'on pensait impossible avant 2030. "C'est du renforcement par self-play, le Go est juste un jeu fermé avec des règles parfaites."
- **StarCraft II (2019)** : AlphaStar bat les pros. "Le modèle triche avec des APM surhumains et voit toute la carte mieux que nous."
- **Le test de Turing (2023)** : les LLM passent le test de Turing dans des études contrôlées. "Le test de Turing n'était pas un bon test de toute façon."
- **ChatGPT et les LLM (2022-)** : "Ce ne sont que des **perroquets stochastiques**. Ils ne font que prédire le mot suivant. Il n'y a aucune compréhension, aucun raisonnement."
- **Les agents autonomes (2024-)** : "Ils ne font qu'enchaîner des appels à des outils, ce n'est pas de l'intelligence, c'est juste un workflow."

À chaque fois, la même musique. Et à chaque fois, les poteaux reculent un peu plus loin.

## Mais au fait, notre cerveau, il fait comment ?

C'est là que ça devient intéressant — et que j'aimerais qu'on prenne 5 minutes pour y réfléchir ensemble.

La critique la plus fréquente contre les LLM, c'est : *"Ils ne font que prédire le mot suivant en fonction de probabilités apprises sur des milliards de textes."* C'est factuellement vrai. Mais posons-nous une question dérangeante : **est-ce si différent de ce que fait notre cerveau ?**

### Petit test : complétez cette phrase

> *"Hier soir, j'avais faim, alors je me suis préparé une ..."*

Qu'est-ce qui vous est venu à l'esprit ? *Pâtes ? Omelette ? Salade ?* Votre cerveau a littéralement prédit le mot suivant. Il l'a fait à partir de votre expérience (ce que vous mangez d'habitude), du contexte (on parle de faim), et de statistiques implicites (les mots qui suivent "préparé une" dans votre vécu).

Est-ce que vous avez "compris" la phrase ? Oui, probablement. Mais au niveau mécanique, votre cerveau a fait quelque chose de remarquablement similaire à un LLM : **une prédiction conditionnée par le contexte**.

### Deuxième test : l'émotion par procuration

Vous lisez un roman. L'héroïne perd un être cher. Vous ne connaissez pas cette héroïne, vous n'avez peut-être jamais vécu ce deuil précis — et pourtant, vos yeux s'humidifient. Vous ressentez une émotion que vous n'avez **jamais vécue personnellement**, déclenchée par une suite de symboles sur une page.

Qu'est-ce qui s'est passé ? Votre cerveau a **simulé** une expérience à partir de descriptions textuelles, en reconstruisant une émotion par analogie avec ce qu'il connaît. Il a recombiné des fragments d'expériences pour créer quelque chose de nouveau.

Est-ce si différent de ce que fait un modèle qui "génère" une réponse jamais vue en recombinant des patterns appris ?

### Troisième test : d'où viennent vos idées ?

Essayez d'inventer une créature totalement nouvelle, qui ne ressemble à aucun animal existant. Essayez vraiment.

Vous allez probablement obtenir... un mélange. Des ailes d'oiseau, un corps de lézard, la fourrure d'un mammifère, des couleurs vues quelque part. Votre "créativité" est en grande partie une **recombinaison de choses déjà stockées**. Exactement comme un modèle génératif.

```{admonition} La question piège
:class: important
Si un LLM est "juste un perroquet stochastique qui prédit le mot suivant", et que notre cerveau fait (entre autres) quelque chose de très similaire... soit les deux sont intelligents, soit aucun des deux ne l'est. **Où place-t-on le curseur, et pourquoi ?**
```

### Alors, qu'est-ce qui nous distingue vraiment ?

Je ne prétends pas avoir la réponse — personne ne l'a. Mais voici quelques pistes sérieuses qui distinguent (pour l'instant) un cerveau humain d'un LLM :

- **L'incarnation** : nous avons un corps qui ressent, qui bouge, qui interagit avec le monde physique. Nos concepts sont ancrés dans cette expérience sensorielle.
- **Les objectifs intrinsèques** : nous avons faim, peur, envie. Un LLM n'a aucun désir propre, seulement l'objectif technique de prédire le token suivant.
- **La mémoire à long terme et la continuité** : nous avons une histoire personnelle qui évolue. Un LLM repart de zéro à chaque conversation (pour l'instant).
- **La conscience (quoi que ça veuille dire)** : c'est le mystère central, et on ne sait toujours pas comment la mesurer, même chez les humains.
- **La capacité à reconnaître qu'on ne sait pas** : un humain peut dire "je ne sais pas" honnêtement. Un LLM hallucine avec aplomb.

Mais remarquez : aucune de ces distinctions n'est sur *"la machine fait juste des prédictions statistiques"*. Parce que nous aussi, en grande partie, nous faisons des prédictions statistiques.

```{admonition} Pourquoi je vous pose ces questions
:class: tip
Parce qu'en tant que futurs data scientists, vous allez construire des modèles qui "prédisent" des choses. Et vous allez entendre deux discours opposés :

- **Les technophiles** : "C'est de l'intelligence ! C'est révolutionnaire !"
- **Les sceptiques** : "Ce n'est que des statistiques, il n'y a aucune compréhension."

Les deux ont tort et raison à la fois. Votre job, ce n'est pas de trancher ce débat philosophique. C'est de **comprendre ce que vos modèles font vraiment, leurs limites réelles, et ce qu'ils peuvent ou ne peuvent pas apporter à un problème métier concret**. Pas plus, pas moins.
```

Gardez cette nuance en tête pendant toute la formation. On va manipuler des outils puissants — ni magiques, ni triviaux.

## IA, ML, Data Science : qui fait quoi ?

Ces trois termes sont souvent utilisés de façon interchangeable, alors qu'ils désignent des choses différentes :

**L'Intelligence Artificielle (IA)** est le concept le plus large : c'est l'idée de créer des systèmes capables de résoudre des problèmes qu'on associe habituellement à l'intelligence humaine. Reconnaître un visage, comprendre une phrase, jouer aux échecs — tout ça relève de l'IA.

**Le Machine Learning (ML)** est une **façon de faire de l'IA**. Au lieu de programmer des règles à la main ("si le mot *gratuit* apparaît, c'est un spam"), on donne des exemples à un algorithme et il apprend les règles tout seul à partir des données. C'est le coeur de cette formation.

**La Data Science** est la **discipline** qui utilise le ML (entre autres outils) pour **extraire de la valeur à partir de données** et aider à la prise de décision. Un data scientist ne fait pas que des modèles : il explore les données, les nettoie, les visualise, communique ses résultats, et s'assure que tout ça a du sens métier.

```{admonition} En résumé
:class: important
- **IA** = le grand chapeau (faire des trucs "intelligents")
- **ML** = une technique pour y arriver (apprendre à partir de données)
- **Data Science** = le métier qui utilise tout ça pour résoudre des problèmes concrets
```

## L'IA dans l'histoire : 80 ans de hauts et de bas

L'Intelligence Artificielle n'est pas née avec ChatGPT. Elle a une histoire longue, chaotique, avec des promesses démesurées, des déceptions brutales, et des renaissances inattendues. Comprendre cette histoire, c'est comprendre pourquoi on en est là aujourd'hui — et pourquoi il faut rester humble.

### 1943 — Le premier neurone artificiel

Bien avant qu'on parle d'IA, deux chercheurs posent les fondations : **Warren McCulloch** (neurophysiologiste) et **Walter Pitts** (logicien). Dans un article intitulé *"A Logical Calculus of the Ideas Immanent in Nervous Activity"*, ils proposent un modèle mathématique simplifié d'un neurone biologique.

Leur idée : un neurone reçoit des signaux, les additionne, et s'active (ou non) selon un seuil. C'est binaire, rudimentaire — mais c'est la première fois qu'on montre qu'un réseau de neurones artificiels peut, en théorie, calculer n'importe quelle fonction logique.

```{admonition} Le neurone de McCulloch-Pitts
:class: note
entrées (0 ou 1) → somme pondérée → si somme ≥ seuil alors 1, sinon 0

C'est exactement le principe des neurones modernes (à quelques raffinements près). 80 ans plus tard, ça reste le fondement du Deep Learning.
```

### 1950 — Turing pose la question

**Alan Turing**, déjà célèbre pour avoir contribué à casser Enigma pendant la Seconde Guerre mondiale, publie *"Computing Machinery and Intelligence"*. Il y pose la question : **"Les machines peuvent-elles penser ?"** Pour éviter le débat philosophique sur ce que signifie "penser", il propose un test pragmatique — le fameux **test de Turing** : si un humain qui converse à l'aveugle avec une machine ne peut pas la distinguer d'un autre humain, alors on peut considérer qu'elle est "intelligente".

Turing ne parle pas encore d'IA — le terme n'existe pas — mais il vient d'en poser les bases philosophiques.

### 1956 — Dartmouth : la naissance officielle de l'IA

Été 1956, **Dartmouth College** (New Hampshire, USA). Un jeune chercheur nommé **John McCarthy** organise un atelier d'été de deux mois avec **Marvin Minsky**, **Claude Shannon** (l'inventeur de la théorie de l'information) et **Nathaniel Rochester** (IBM). Ils réunissent une dizaine de chercheurs pour explorer une idée nouvelle.

Dans la proposition de l'atelier, McCarthy écrit le terme **"Artificial Intelligence"** pour la première fois. L'ambition est folle :

> *"Every aspect of learning or any other feature of intelligence can in principle be so precisely described that a machine can be made to simulate it."*
>
> *"Tout aspect de l'apprentissage, ou toute autre caractéristique de l'intelligence, peut en principe être décrit avec une telle précision qu'une machine peut être construite pour le simuler."*

L'atelier de Dartmouth est considéré comme **l'acte de naissance officiel de l'IA** en tant que discipline. Les participants repartent convaincus qu'une machine aussi intelligente qu'un humain sera construite "d'ici une génération".

### 1958 — Le Perceptron de Rosenblatt

**Frank Rosenblatt**, psychologue à Cornell, construit le **Perceptron** : la première machine capable d'**apprendre**. C'est un neurone artificiel à la McCulloch-Pitts, mais avec une nouveauté géniale : il ajuste automatiquement ses poids en fonction de ses erreurs. On lui montre des exemples, il se trompe, il corrige — et il finit par reconnaître des motifs simples.

Le *New York Times* titre en 1958 :

> *"The Navy revealed the embryo of an electronic computer today that it expects will be able to walk, talk, see, write, reproduce itself and be conscious of its existence."*
>
> *"La Marine a dévoilé aujourd'hui l'embryon d'un ordinateur électronique dont elle espère qu'il pourra marcher, parler, voir, écrire, se reproduire et être conscient de sa propre existence."*

L'euphorie est à son comble. On promet des machines intelligentes pour bientôt.

### 1969 — Le premier hiver de l'IA

Patatras. Marvin Minsky et Seymour Papert publient un livre, *"Perceptrons"*, qui démontre mathématiquement les **limites fondamentales** du Perceptron. Il ne peut pas, par exemple, apprendre une fonction aussi simple que le XOR (OU exclusif). Le livre est dévastateur.

Les financements s'effondrent. Le **rapport Lighthill** (1973) enterre définitivement les espoirs au Royaume-Uni en concluant que l'IA n'a tenu aucune de ses promesses. La DARPA américaine coupe les budgets. C'est le **premier "hiver de l'IA"** : de 1974 à ~1980, les chercheurs qui travaillent sur les réseaux de neurones sont marginalisés, voire ridiculisés.

```{admonition} Un hiver de l'IA, c'est quoi ?
:class: warning
Ce n'est pas une métaphore. C'est une période où les investissements, les publications et l'intérêt pour l'IA s'effondrent, parce que les promesses n'ont pas été tenues. Il y en aura au moins deux.
```

### Années 1980 — Le retour par les systèmes experts

L'IA renaît sous une forme différente : les **systèmes experts**. L'idée : au lieu d'essayer de reproduire l'intelligence générale, on encode les connaissances d'un expert dans un domaine précis sous forme de règles `SI ... ALORS ...`.

Le système **MYCIN** (Stanford, années 70-80) diagnostique des infections bactériennes mieux que certains médecins. **XCON** (Digital Equipment Corporation) configure des ordinateurs et fait économiser des millions. Les entreprises s'arrachent les systèmes experts. Un marché de plusieurs milliards de dollars émerge autour du langage LISP et des "machines LISP" spécialisées.

En parallèle, **Rumelhart, Hinton et Williams** publient en 1986 un article décisif sur la **rétropropagation du gradient** (backpropagation), qui permet d'entraîner des réseaux de neurones à plusieurs couches. On sait enfin dépasser les limites du Perceptron. Mais la communauté reste méfiante, et les ordinateurs de l'époque sont trop lents pour en profiter.

### Fin des années 1980 — Le deuxième hiver

Les systèmes experts craquent sous leur propre poids. Maintenir des milliers de règles écrites à la main devient un cauchemar. Les "machines LISP" sont ringardisées par les PC qui deviennent plus puissants et moins chers. Le marché s'effondre vers 1987-1993. **Deuxième hiver de l'IA**.

```{admonition} La leçon à retenir
:class: important
Les systèmes à base de règles ont échoué parce qu'on **ne peut pas écrire à la main toutes les règles du monde réel**. Reconnaître un chat sur une photo ? Des millions de règles. Comprendre une phrase ? Idem. C'est ce mur qui va pousser la communauté vers une approche radicalement différente : **laisser la machine apprendre les règles elle-même**.
```

### Années 1990-2000 — La revanche discrète du Machine Learning

Pendant que les systèmes experts meurent, une autre approche monte en puissance : le **Machine Learning statistique**. Au lieu d'encoder des règles, on donne des exemples à des algorithmes et on les laisse trouver les patterns.

Quelques dates clés :

- **1995** : Vapnik et Cortes publient les **Support Vector Machines (SVM)**, qui vont dominer la classification pendant une décennie.
- **1997** : **Deep Blue** (IBM) bat Garry Kasparov aux échecs. C'est un système expert surboosté, pas du ML — mais ça relance l'intérêt du grand public pour l'IA.
- **2001** : Leo Breiman publie l'algorithme **Random Forest**. Simple, robuste, efficace : encore aujourd'hui l'un des meilleurs algorithmes pour les données tabulaires.
- **2006** : Geoffrey Hinton publie un article sur les **réseaux de croyances profonds** et relance l'idée qu'on peut entraîner des réseaux de neurones à beaucoup de couches. Le terme **"Deep Learning"** commence à s'imposer.

Cette période est celle où l'IA cesse d'être une discipline de laboratoire pour devenir un outil industriel. Google, Amazon, Netflix l'utilisent en production pour la recherche, la recommandation, le filtrage de spam.

### 2012 — La révolution Deep Learning

**Septembre 2012**. La compétition **ImageNet** oppose des algorithmes sur la tâche de classifier 1,2 million d'images en 1 000 catégories. Les meilleurs systèmes jusque-là plafonnaient autour de 26% d'erreur.

**Alex Krizhevsky**, étudiant de Geoffrey Hinton à Toronto, présente **AlexNet** : un réseau de neurones convolutif entraîné sur des GPU. Taux d'erreur : **15,3%**. Un gain gigantesque. La communauté de la vision par ordinateur bascule du jour au lendemain.

Ce qui a changé depuis les années 60 :
1. **Les données** : internet a généré des millions d'images étiquetées (ImageNet, CIFAR...).
2. **Le calcul** : les GPU permettent d'entraîner des réseaux 100x plus gros.
3. **Les algorithmes** : backpropagation, ReLU, dropout — une série de raffinements qui rendent l'entraînement stable.

Les années suivantes voient une cascade de percées : reconnaissance vocale, traduction automatique, AlphaGo (2016) qui bat le champion du monde de Go, GANs qui génèrent des images réalistes.

### 2017-aujourd'hui — L'ère des Transformers et des LLM

**2017** : une équipe de Google publie *"Attention is All You Need"*, qui introduit l'architecture **Transformer**. Tout va s'accélérer.

- **2018** : BERT (Google) révolutionne le traitement du langage naturel.
- **2020** : GPT-3 (OpenAI) montre qu'un modèle assez gros peut faire presque n'importe quoi avec quelques exemples.
- **2022** : ChatGPT démocratise l'IA générative auprès du grand public.
- **2023-2024** : les LLM s'intègrent partout — code, image, audio, vidéo.

```{admonition} Sommes-nous dans un nouvel hiver qui approche ?
:class: note
Certains chercheurs s'inquiètent : les investissements sont gigantesques, les attentes démesurées, et les limites des LLM (hallucinations, coûts, raisonnement) réelles. L'histoire nous dit qu'après chaque emballement, il y a un retour de bâton. C'est pour ça qu'il faut rester lucide sur ce que l'IA peut et ne peut pas faire.
```

### Ce qu'il faut retenir de cette histoire

1. **L'IA n'est pas une discipline jeune.** 80 ans de recherche, avec des hauts et des bas. Les idées d'aujourd'hui (neurones, apprentissage, perceptron) datent des années 40-50.
2. **Deux grandes approches coexistent :** les systèmes à règles (symboliques) et l'apprentissage statistique. Le ML a pris le dessus depuis les années 90, mais les deux se complètent encore.
3. **Les progrès viennent autant des données et du matériel que des algorithmes.** Le Perceptron existait en 1958 ; il a fallu 50 ans pour avoir assez de données et de GPU pour qu'il donne ses vrais résultats.
4. **Les promesses excessives mènent aux hivers.** Restez humble. Un modèle qui marche sur un jeu de test ne marche pas forcément en production.

Dans cette formation, on va faire du **Machine Learning classique** (pas du Deep Learning) sur des données tabulaires. C'est l'héritier direct des travaux des années 90-2000 — et c'est encore aujourd'hui la meilleure approche pour la plupart des problèmes métier concrets.

Au lieu de coder des règles à la main ("si le client a plus de 3 impayés ET qu'il est là depuis moins d'un an, alors risque élevé"), on va donner au modèle des exemples historiques avec leurs résultats, et il va apprendre tout seul les patterns.

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
Prenons un exemple en banque :
- **Données** : "le client #4238 a 3 crédits en cours, un revenu de 2 800 €/mois, 2 incidents de paiement en 6 mois"
- **Information** : "les clients avec plus d'un incident et un ratio dette/revenu > 40% ont un taux de défaut de 35%"
- **Connaissance** : "le nombre d'incidents récents et le ratio d'endettement sont les meilleurs prédicteurs de défaut"
- **Décision** : "on refuse le nouveau crédit ou on propose un montant réduit avec un suivi renforcé"
```
