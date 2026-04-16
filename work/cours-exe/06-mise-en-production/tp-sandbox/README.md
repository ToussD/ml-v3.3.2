# TP — Environnements Python (sandbox)

Ce dossier est **votre bac à sable** pour le TP du module 6. Il est monté en
lecture/écriture sur `/workspace` à l'intérieur du conteneur lancé par
`cours-ml-exe.sh sandbox` (depuis la racine du dossier stagiaire).

## Lancer le sandbox

Depuis la racine du dossier stagiaire :

```sh
./cours-ml-exe.sh sandbox
```

Vous tombez dans un shell `bash` avec `python`, `conda` et `pixi` déjà
installés. Le présent dossier est accessible dans `/workspace`.

## Organisation

```
tp-sandbox/
├── README.md        ← ce fichier
├── challenge/       ← 3 fichiers de deps à reproduire (Partie 5 du TP)
│   ├── requirements.txt
│   ├── environment.yml
│   └── pixi.toml
└── (vos créations)  ← tout ce que vous ajoutez pendant le TP
```

Les instructions complètes du TP sont dans le chapitre
[« TP — Gérer ses environnements Python au terminal »](../../../cours/html/cours/06-mise-en-production/05-tp-environnements.html)
du site du cours. Ouvrez-le **dans votre navigateur** pendant que vous tapez
les commandes dans le terminal du sandbox.

## À savoir

- Tout ce que vous créez dans `/workspace` **persiste** sur votre machine
  hôte (c'est un bind-mount).
- Les environnements créés à la volée (`.venv/`, `.pixi/`, environnements
  conda nommés) sont donc conservés d'une session à l'autre.
- Pour repartir sur une table rase : `rm -rf /workspace/projet-*` depuis le
  conteneur, ou supprimez les dossiers depuis votre machine hôte.
- Pour quitter le conteneur : tapez `exit`.
