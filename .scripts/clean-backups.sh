#!/usr/bin/env bash
# clean-backups.sh — Supprime toutes les sauvegardes du dossier .backups/
# après confirmation interactive.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$ROOT/.backups"

if [ -t 1 ]; then
    GREEN=$'\033[32m'; YELLOW=$'\033[33m'; BOLD=$'\033[1m'; RESET=$'\033[0m'
else
    GREEN=""; YELLOW=""; BOLD=""; RESET=""
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Aucun dossier .backups/ à nettoyer."
    exit 0
fi

N="$(find "$BACKUP_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l)"
if [ "$N" -eq 0 ]; then
    echo "Aucune sauvegarde dans .backups/."
    rmdir "$BACKUP_DIR" 2>/dev/null || true
    exit 0
fi

SIZE="$(du -sh "$BACKUP_DIR" 2>/dev/null | awk '{print $1}')"

echo "${BOLD}$N sauvegarde(s) trouvée(s)${RESET} dans .backups/ ($SIZE) :"
find "$BACKUP_DIR" -maxdepth 1 -mindepth 1 -type d -printf '  %f\n' 2>/dev/null | sort
echo ""
echo "${YELLOW}⚠${RESET} Cette action va ${BOLD}supprimer définitivement${RESET} ces sauvegardes."
printf "Continuer ? [o/N] "
read -r REPLY
case "$REPLY" in
    [oO]|[oO][uU][iI]|[yY]|[yY][eE][sS])
        rm -rf "$BACKUP_DIR"
        echo "${GREEN}✔${RESET} Sauvegardes supprimées."
        ;;
    *)
        echo "Annulé. Rien n'a été supprimé."
        ;;
esac
