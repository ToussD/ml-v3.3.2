#!/usr/bin/env bash
# update.sh — Met à jour le paquet stagiaire depuis GitHub en préservant
# les notebooks d'exercice du stagiaire.
#
# Stratégie :
#   1. Refuse de tourner si Jupyter est lancé (container 'cours-ml' actif).
#   2. Sauvegarde tous les work/labs/**/*.ipynb qui ne sont pas des solutions
#      dans .backups/<timestamp>/.
#   3. git fetch + git reset --hard origin/main → tout le contenu formateur
#      (théorie, démos, solutions, HTML) est aligné sur GitHub.
#   4. Restaure les notebooks d'exercice depuis la sauvegarde — le travail
#      du stagiaire prime sur la version GitHub.
#
# Fichiers untracked (.backups/, notebooks créés par le stagiaire hors
# work/labs/) sont automatiquement préservés par `git reset --hard`.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ---- Couleurs --------------------------------------------------------------
if [ -t 1 ]; then
    RED=$'\033[31m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'
    BLUE=$'\033[34m'; BOLD=$'\033[1m'; RESET=$'\033[0m'
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; BOLD=""; RESET=""
fi

err()  { echo "${RED}✘${RESET} $*" >&2; }
ok()   { echo "${GREEN}✔${RESET} $*"; }
info() { echo "${BLUE}▶${RESET} $*"; }
warn() { echo "${YELLOW}⚠${RESET} $*"; }

# ---- Vérifications préliminaires ------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    err "git n'est pas installé."
    echo "  Installez-le : 'sudo apt install git' (Linux) ou via https://git-scm.com/"
    exit 1
fi

if [ ! -d "$ROOT/.git" ]; then
    err "Ce dossier n'est pas un dépôt git."
    echo "  La mise à jour automatique n'est possible que si le paquet a été"
    echo "  obtenu via 'git clone' ou décompressé depuis l'archive officielle."
    exit 1
fi

# Container Jupyter actif ?
if command -v docker >/dev/null 2>&1; then
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^cours-ml$'; then
        err "Jupyter est en cours d'exécution (container 'cours-ml')."
        echo ""
        echo "  Arrêtez-le avant de mettre à jour :"
        echo "    • Dans le terminal où Jupyter tourne : ${BOLD}Ctrl+C${RESET} puis ${BOLD}y${RESET}"
        echo "    • Ou en ligne de commande : ${BOLD}docker stop cours-ml${RESET}"
        exit 1
    fi
fi

# ---- 1. Sauvegarde des notebooks d'exercice -------------------------------

TS="$(date +%Y%m%d_%H%M%S)"
BACKUP="$ROOT/.backups/$TS"

mkdir -p "$BACKUP"
info "Sauvegarde des notebooks d'exercice → .backups/$TS/"

N_BACKED=0
if [ -d work/labs ]; then
    while IFS= read -r -d '' f; do
        mkdir -p "$BACKUP/$(dirname "$f")"
        cp "$f" "$BACKUP/$f"
        N_BACKED=$((N_BACKED + 1))
    done < <(find work/labs -name "*.ipynb" \
                 -not -name "*-solution.ipynb" \
                 -not -path "*/.ipynb_checkpoints/*" \
                 -print0)
fi

if [ "$N_BACKED" -gt 0 ]; then
    ok "$N_BACKED notebook(s) d'exercice sauvegardé(s)"
else
    info "Aucun notebook d'exercice à sauvegarder"
fi

# ---- 2. Récupération des mises à jour -------------------------------------

info "Récupération des mises à jour depuis GitHub..."
if ! git fetch origin --quiet 2>&1; then
    err "git fetch a échoué (pas de réseau ? clé SSH ?)"
    echo "  Votre sauvegarde est intacte dans : .backups/$TS/"
    exit 1
fi

# Branche par défaut (main ou master)
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then
    BRANCH="main"
fi

LOCAL="$(git rev-parse HEAD 2>/dev/null)"
REMOTE="$(git rev-parse "origin/$BRANCH" 2>/dev/null)"

if [ "$LOCAL" = "$REMOTE" ]; then
    ok "Vous êtes déjà à jour (rien à faire côté formateur)"
    if [ "$N_BACKED" -gt 0 ]; then
        info "Sauvegarde tout de même conservée : .backups/$TS/"
    else
        rmdir "$BACKUP" 2>/dev/null || true
        rmdir "$ROOT/.backups" 2>/dev/null || true
    fi
    exit 0
fi

# Diff résumé avant reset
N_CHANGED="$(git diff --name-only HEAD "origin/$BRANCH" 2>/dev/null | wc -l)"
info "$N_CHANGED fichier(s) à mettre à jour"

info "Alignement sur origin/$BRANCH (git reset --hard)..."
git reset --hard "origin/$BRANCH" --quiet

# ---- 3. Restauration des exercices ----------------------------------------

if [ "$N_BACKED" -gt 0 ]; then
    info "Restauration de vos notebooks d'exercice..."
    cd "$BACKUP"
    while IFS= read -r -d '' f; do
        rel="${f#./}"
        mkdir -p "$ROOT/$(dirname "$rel")"
        cp "$f" "$ROOT/$rel"
    done < <(find . -name "*.ipynb" -print0)
    cd "$ROOT"
    ok "Vos $N_BACKED notebook(s) d'exercice sont préservés"
fi

# ---- Fin ------------------------------------------------------------------

echo ""
ok "${BOLD}Mise à jour terminée.${RESET}"
echo "  • Théorie / démos / corrigés / HTML : à jour depuis GitHub"
if [ "$N_BACKED" -gt 0 ]; then
    echo "  • Vos notebooks d'exercice : préservés"
    echo "  • Sauvegarde : .backups/$TS/ (peut être supprimée avec 'make clean-backups')"
fi
echo ""
info "Si vous étiez sur un exercice, rouvrez-le dans Jupyter pour reprendre."
