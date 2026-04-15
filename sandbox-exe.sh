#!/bin/sh
# Lance un conteneur sandbox pour le TP du module 6 (gestion d'environnements
# Python). L'image continuumio/miniconda3 fournit python + conda. `curl` et
# `pixi` sont installés au démarrage (miniconda3 ne les contient pas).
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
echo "  Outils : python, conda, pixi (installés à la volée)"
echo "  Pour quitter : tapez 'exit'"
echo

docker container run -it --rm --name cours-ml-sandbox \
    --mount type=bind,source="$SANDBOX_DIR",target=/workspace \
    -w /workspace \
    continuumio/miniconda3:latest \
    bash -c '
        set -e

        # curl nest pas dans limage miniconda3. On linstalle (~5 s) pour
        # pouvoir ensuite telecharger pixi depuis pixi.sh.
        if ! command -v curl >/dev/null 2>&1; then
            echo "▶ Installation de curl (prerequis pour pixi)..."
            apt-get update -qq >/dev/null
            apt-get install -y -qq curl ca-certificates >/dev/null
            echo "  OK"
        fi

        # pixi : binaire telecharge depuis pixi.sh et place dans /usr/local/bin
        # (PIXI_HOME=/usr/local -> linstalleur ecrit dans /usr/local/bin/pixi).
        if ! command -v pixi >/dev/null 2>&1; then
            echo "▶ Installation de pixi dans /usr/local/bin..."
            if PIXI_HOME=/usr/local curl -fsSL https://pixi.sh/install.sh | bash; then
                if command -v pixi >/dev/null 2>&1; then
                    echo "  OK"
                else
                    echo "  ATTENTION : installeur termine mais binaire introuvable."
                fi
            else
                echo "  ATTENTION : telechargement de pixi echoue (pas de reseau ?)."
                echo "  venv et conda restent disponibles pour le TP."
            fi
        fi

        echo
        echo "▶ Bienvenue dans le sandbox !"
        printf "  "; python --version
        printf "  "; conda --version
        if command -v pixi >/dev/null 2>&1; then
            printf "  "; pixi --version
        else
            echo "  pixi (non disponible)"
        fi
        echo
        echo "  Les instructions du TP sont dans le site du cours :"
        echo "  cours/html/cours/06-mise-en-production/05-tp-environnements.html"
        echo
        exec bash
    '
