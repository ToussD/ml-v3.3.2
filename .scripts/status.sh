#!/usr/bin/env bash
# status.sh — Affiche l'état du paquet stagiaire :
#   • container Jupyter actif ?
#   • mises à jour disponibles côté GitHub ?
#   • nombre de notebooks d'exercice modifiés
#   • taille des sauvegardes

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ -t 1 ]; then
    GREEN=$'\033[32m'; YELLOW=$'\033[33m'; BLUE=$'\033[34m'
    BOLD=$'\033[1m'; RESET=$'\033[0m'
else
    GREEN=""; YELLOW=""; BLUE=""; BOLD=""; RESET=""
fi

echo "${BOLD}État du paquet stagiaire${RESET}"
echo ""

# ---- Jupyter en cours ? ---------------------------------------------------
echo "${BOLD}Environnement Jupyter${RESET}"
if command -v docker >/dev/null 2>&1; then
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^cours-ml$'; then
        echo "  ${GREEN}●${RESET} Container 'cours-ml' actif → http://localhost:8888"
    else
        echo "  ○ Container 'cours-ml' arrêté ('make jupyter' pour démarrer)"
    fi
else
    echo "  ${YELLOW}⚠${RESET} Docker non détecté"
fi
echo ""

# ---- Mises à jour disponibles --------------------------------------------
echo "${BOLD}Mises à jour${RESET}"
if [ -d "$ROOT/.git" ] && command -v git >/dev/null 2>&1; then
    if git fetch origin --quiet 2>/dev/null; then
        BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
        LOCAL="$(git rev-parse HEAD 2>/dev/null)"
        REMOTE="$(git rev-parse "origin/$BRANCH" 2>/dev/null || echo "")"
        if [ -z "$REMOTE" ]; then
            echo "  ${YELLOW}⚠${RESET} Branche origin/$BRANCH introuvable"
        elif [ "$LOCAL" = "$REMOTE" ]; then
            echo "  ${GREEN}●${RESET} À jour"
        else
            N="$(git diff --name-only HEAD "origin/$BRANCH" 2>/dev/null | wc -l)"
            echo "  ${YELLOW}●${RESET} $N fichier(s) à mettre à jour → 'make update'"
        fi
    else
        echo "  ${YELLOW}⚠${RESET} Impossible de joindre GitHub (réseau ? SSH ?)"
    fi
else
    echo "  ${YELLOW}⚠${RESET} Pas un dépôt git — mise à jour automatique indisponible"
fi
echo ""

# ---- Notebooks d'exercice modifiés ----------------------------------------
echo "${BOLD}Vos notebooks d'exercice${RESET}"
N_MOD=0
if [ -d work/labs ] && [ -d "$ROOT/.git" ]; then
    # Compte les fichiers modifiés (par rapport au commit courant) dans labs/
    # qui ne sont pas des solutions.
    N_MOD="$(git -C "$ROOT" status --porcelain=v1 work/labs 2>/dev/null \
        | awk '{print $2}' \
        | grep -E '\.ipynb$' \
        | grep -v -- '-solution\.ipynb$' \
        | wc -l)"
fi
if [ "$N_MOD" -gt 0 ]; then
    echo "  ${BLUE}●${RESET} $N_MOD notebook(s) d'exercice modifié(s) — seront préservés au prochain update"
else
    echo "  ○ Aucune modification détectée"
fi
echo ""

# ---- Sauvegardes ---------------------------------------------------------
echo "${BOLD}Sauvegardes${RESET}"
if [ -d "$ROOT/.backups" ]; then
    N_BACK="$(find "$ROOT/.backups" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l)"
    SIZE="$(du -sh "$ROOT/.backups" 2>/dev/null | awk '{print $1}')"
    if [ "$N_BACK" -gt 0 ]; then
        echo "  $N_BACK sauvegarde(s) ($SIZE) — 'make clean-backups' pour purger"
    else
        echo "  Aucune sauvegarde"
    fi
else
    echo "  Aucune sauvegarde"
fi
