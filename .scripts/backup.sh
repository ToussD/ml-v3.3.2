#!/usr/bin/env bash
# backup.sh — Sauvegarde manuelle de tous les notebooks d'exercice du
# stagiaire dans .backups/<timestamp>/. Filet de sécurité avant un
# manipulation à risque (test, commit local, etc.) sans toucher au reste.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ -t 1 ]; then
    GREEN=$'\033[32m'; BLUE=$'\033[34m'; RESET=$'\033[0m'
else
    GREEN=""; BLUE=""; RESET=""
fi

TS="$(date +%Y%m%d_%H%M%S)"
BACKUP="$ROOT/.backups/$TS"
mkdir -p "$BACKUP"

echo "${BLUE}▶${RESET} Sauvegarde des notebooks d'exercice → .backups/$TS/"

N=0
if [ -d work/labs ]; then
    while IFS= read -r -d '' f; do
        mkdir -p "$BACKUP/$(dirname "$f")"
        cp "$f" "$BACKUP/$f"
        N=$((N + 1))
    done < <(find work/labs -name "*.ipynb" \
                 -not -name "*-solution.ipynb" \
                 -not -path "*/.ipynb_checkpoints/*" \
                 -print0)
fi

if [ "$N" -gt 0 ]; then
    echo "${GREEN}✔${RESET} $N notebook(s) sauvegardé(s) dans .backups/$TS/"
else
    echo "  Aucun notebook d'exercice trouvé. Sauvegarde vide créée."
fi
