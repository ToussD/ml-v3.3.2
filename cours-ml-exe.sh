#!/usr/bin/env bash
# ============================================================================
# cours-ml-exe.sh — Script unique de la formation ML.
#
# Usage :
#     ./cours-ml-exe.sh              Jupyter (port 8888) avec toutes les deps
#     ./cours-ml-exe.sh sandbox      Shell interactif conda/pixi (TP module 6)
#
# Dépendances Python :
#     Le fichier requirements.txt à la racine du dossier est monté dans le
#     container et installé automatiquement au démarrage. Pour ajouter un
#     package, il suffit d'éditer ce fichier et de relancer le container.
#
# Cache :
#     Un volume Docker « cours-ml-pip-cache » persiste le cache pip entre les
#     redémarrages. Conséquence : la première exécution prend ~1-2 min
#     (téléchargement des packages), les suivantes sont quasi instantanées.
#
# Prérequis :
#     - Docker installé et fonctionnel
#     - Port 8888 libre (Jupyter)
# ============================================================================

set -e

# ---- Configuration --------------------------------------------------------

JUPYTER_IMAGE="quay.io/jupyter/scipy-notebook:2024-10-07"
SANDBOX_IMAGE="continuumio/miniconda3:latest"
JUPYTER_PORT=8888
PIP_CACHE_VOLUME="cours-ml-pip-cache"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="$SCRIPT_DIR/work"
REQUIREMENTS="$SCRIPT_DIR/requirements.txt"

# ---- Vérifications --------------------------------------------------------

if ! command -v docker >/dev/null 2>&1; then
    echo "✘ Docker n'est pas installé ou pas dans le PATH." >&2
    exit 1
fi

if [ ! -d "$WORK_DIR" ]; then
    echo "✘ Dossier work/ introuvable dans $(pwd)." >&2
    echo "  Lancez ce script depuis la racine du dossier de formation." >&2
    exit 1
fi

# ---- Mode sandbox (TP module 6) ------------------------------------------

if [ "${1:-}" = "sandbox" ]; then
    SANDBOX_DIR="$WORK_DIR/cours-exe/06-mise-en-production/tp-sandbox"

    if [ ! -d "$SANDBOX_DIR" ]; then
        echo "ℹ Création du dossier $SANDBOX_DIR"
        mkdir -p "$SANDBOX_DIR"
    fi

    echo "▶ Démarrage du sandbox (TP environnements Python)"
    echo "  Image  : $SANDBOX_IMAGE"
    echo "  Mount  : $SANDBOX_DIR → /workspace"
    echo "  Outils : python, conda, pixi, nano"
    echo "  Quitter : tapez 'exit'"
    echo

    docker container run -it --rm --name cours-ml-sandbox \
        --mount type=bind,source="$SANDBOX_DIR",target=/workspace \
        -w /workspace \
        "$SANDBOX_IMAGE" \
        bash -c '
            set -e

            MISSING=""
            command -v curl >/dev/null 2>&1 || MISSING="$MISSING curl"
            command -v nano >/dev/null 2>&1 || MISSING="$MISSING nano"
            if [ -n "$MISSING" ]; then
                echo "▶ Installation des outils manquants :$MISSING"
                apt-get update -qq >/dev/null
                apt-get install -y -qq $MISSING ca-certificates >/dev/null
                echo "  OK"
            fi

            if ! command -v pixi >/dev/null 2>&1; then
                echo "▶ Installation de pixi..."
                if PIXI_HOME=/usr/local curl -fsSL https://pixi.sh/install.sh | bash 2>/dev/null; then
                    command -v pixi >/dev/null 2>&1 && echo "  OK" || echo "  pixi introuvable"
                else
                    echo "  pixi non disponible (pas de réseau ?). venv et conda restent utilisables."
                fi
            fi

            echo
            echo "▶ Bienvenue dans le sandbox !"
            printf "  "; python --version
            printf "  "; conda --version
            command -v pixi >/dev/null 2>&1 && { printf "  "; pixi --version; } || echo "  pixi (non disponible)"
            echo
            echo "  Instructions du TP : voir le module 6 dans le site du cours."
            echo
            exec bash
        '
    exit 0
fi

# ---- Mode Jupyter (défaut) ------------------------------------------------

echo "▶ Démarrage de Jupyter pour la formation ML"
echo "  Image  : $JUPYTER_IMAGE"
echo "  Port   : http://localhost:$JUPYTER_PORT"
echo "  Work   : $WORK_DIR"

if [ -f "$REQUIREMENTS" ]; then
    echo "  Deps   : $REQUIREMENTS (installés au démarrage)"
else
    echo "  Deps   : aucun requirements.txt trouvé — packages de base uniquement"
fi

echo ""

docker container run -it -p ${JUPYTER_PORT}:8888 --rm --name cours-ml \
    --user root \
    -e GRANT_SUDO=yes \
    -e NB_UID=$(id -u) \
    -e NB_GID=$(id -g) \
    --mount type=bind,source="$WORK_DIR",target=/home/jovyan/work \
    --mount type=bind,source="$REQUIREMENTS",target=/tmp/requirements.txt,readonly \
    --mount type=volume,source="$PIP_CACHE_VOLUME",target=/tmp/pip-cache \
    "$JUPYTER_IMAGE" \
    bash -c '
        set -e

        # Installer graphviz (binaire « dot », nécessaire pour dtreeviz).
        # pixi est plus rapide que conda pour la résolution de dépendances.
        # On symlinke le binaire dans /opt/conda/bin/ pour que le kernel
        # Jupyter le trouve dans son PATH.
        if ! command -v dot >/dev/null 2>&1; then
            if ! command -v pixi >/dev/null 2>&1; then
                echo "▶ Installation de pixi..."
                curl -fsSL https://pixi.sh/install.sh | PIXI_HOME=/home/jovyan/.local bash >/dev/null 2>&1
                export PATH="/home/jovyan/.local/bin:$PATH"
            fi
            echo "▶ Installation de graphviz (pixi)..."
            pixi global install graphviz >/dev/null 2>&1
            # Rendre les binaires graphviz visibles au kernel Jupyter
            for bin in dot neato fdp sfdp circo twopi; do
                src="$(find /home/jovyan/.pixi /home/jovyan/.local -name "$bin" -type f 2>/dev/null | head -1)"
                [ -n "$src" ] && ln -sf "$src" /opt/conda/bin/"$bin" 2>/dev/null
            done
            echo "  OK"
        fi

        # Installer les dépendances Python du cours
        if [ -f /tmp/requirements.txt ]; then
            echo "▶ Installation des dépendances Python..."
            sudo chown -R "$(id -u):$(id -g)" /tmp/pip-cache 2>/dev/null || true
            pip install --quiet --cache-dir /tmp/pip-cache \
                -r /tmp/requirements.txt
            echo "  OK"
        fi

        echo ""
        echo "▶ Lancement de Jupyter..."
        exec start-notebook.sh \
            --NotebookApp.token="" \
            --NotebookApp.password=""
    '
