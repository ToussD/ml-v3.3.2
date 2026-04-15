#!/bin/sh
# Lance un conteneur sandbox pour le TP du module 6 (gestion d'environnements
# Python). L'image continuumio/miniconda3 fournit python + conda ; pixi est
# installé au démarrage via le script officiel.
#
# Usage (depuis la racine du dossier stagiaire) :
#     ./sandbox-exe.sh
#
# Vous tombez dans un shell bash dans /workspace, avec python, conda et pixi
# disponibles. Les fichiers que vous créez dans /workspace persistent dans
# work/cours-exe/06-mise-en-production/tp-sandbox/ de votre machine.
#
# Pour quitter : tapez `exit`.

set -e

SANDBOX_DIR="$(cd "$(dirname "$0")" && pwd)/work/cours-exe/06-mise-en-production/tp-sandbox"

if [ ! -d "$SANDBOX_DIR" ]; then
    echo "✘ Dossier introuvable : $SANDBOX_DIR" >&2
    echo "  Êtes-vous bien à la racine du dossier stagiaire ?" >&2
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "✘ Docker n'est pas installé ou pas dans le PATH." >&2
    exit 1
fi

echo "▶ Démarrage du conteneur sandbox (TP environnements Python)"
echo "  Image  : continuumio/miniconda3"
echo "  Mount  : $SANDBOX_DIR → /workspace"
echo "  Outils : python, conda, pixi (installé à la volée)"
echo "  Pour quitter : tapez 'exit'"
echo

docker container run -it --rm --name cours-ml-sandbox \
    --mount type=bind,source="$SANDBOX_DIR",target=/workspace \
    -w /workspace \
    continuumio/miniconda3:latest \
    bash -c '
        set -e
        if ! command -v pixi >/dev/null 2>&1; then
            echo "▶ Installation de pixi (une seule fois par session)..."
            curl -fsSL https://pixi.sh/install.sh | bash >/dev/null 2>&1 || {
                echo "  ⚠ Installation de pixi échouée (pas de réseau ?). venv et conda restent dispos."
            }
            export PATH="/root/.pixi/bin:$PATH"
            if command -v pixi >/dev/null 2>&1; then
                echo "  pixi $(pixi --version | cut -d\" \" -f2)"
            fi
        fi
        export PATH="/root/.pixi/bin:$PATH"
        echo
        echo "▶ Bienvenue dans le sandbox !"
        echo "  python $(python --version 2>&1 | cut -d\" \" -f2)"
        echo "  conda  $(conda --version | cut -d\" \" -f2)"
        if command -v pixi >/dev/null 2>&1; then
            echo "  pixi   $(pixi --version | cut -d\" \" -f2)"
        fi
        echo
        echo "  Les instructions du TP sont dans le site du cours :"
        echo "  cours/html/cours/06-mise-en-production/05-tp-environnements.html"
        echo
        exec bash
    '
