# Makefile du paquet stagiaire — formation ML.
#
# Toutes les commandes utiles tiennent dans une seule commande `make` :
#
#   make            (ou `make help`) — Liste des commandes
#   make jupyter    — Démarre Jupyter (Docker)
#   make sandbox    — Démarre le sandbox conda/pixi (TP module 6)
#   make cours      — Ouvre le cours HTML dans votre navigateur
#   make update     — Met à jour le cours depuis GitHub
#                     (préserve vos notebooks d'exercice)
#   make backup     — Sauvegarde manuelle de vos notebooks d'exercice
#   make status     — Affiche l'état (Jupyter actif ? Mises à jour dispo ?)
#   make clean-backups — Purge les anciennes sauvegardes

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HTML := $(ROOT)/cours/html/intro.html
SCRIPTS := $(ROOT)/.scripts

# Détection de la commande d'ouverture de navigateur selon l'OS.
UNAME_S := $(shell uname -s 2>/dev/null)
ifeq ($(UNAME_S),Linux)
    OPEN := xdg-open
endif
ifeq ($(UNAME_S),Darwin)
    OPEN := open
endif
ifndef OPEN
    OPEN := xdg-open
endif

.DEFAULT_GOAL := help

.PHONY: help jupyter sandbox cours update backup clean-backups status

help: ## Affiche cette aide.
	@echo "Formation ML — commandes disponibles :"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36mmake %-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "Pour commencer : 'make jupyter' (Docker) ou 'make cours' (lecture HTML)."

jupyter: ## Démarre Jupyter dans Docker (port 8888).
	@./cours-ml-exe.sh

sandbox: ## Démarre le sandbox conda/pixi du TP module 6.
	@./cours-ml-exe.sh sandbox

cours: ## Ouvre le cours HTML dans votre navigateur.
	@if [ -f "$(HTML)" ]; then \
	    echo "▶ Ouverture de $(HTML)"; \
	    $(OPEN) "$(HTML)" >/dev/null 2>&1 & \
	else \
	    echo "✘ Cours HTML introuvable : $(HTML)"; \
	    echo "  Avez-vous bien décompressé tout le paquet ?"; \
	    exit 1; \
	fi

update: ## Met à jour depuis GitHub (préserve les exercices).
	@bash $(SCRIPTS)/update.sh

backup: ## Sauvegarde manuelle de vos notebooks d'exercice.
	@bash $(SCRIPTS)/backup.sh

clean-backups: ## Purge les anciennes sauvegardes (avec confirmation).
	@bash $(SCRIPTS)/clean-backups.sh

status: ## Affiche l'état de l'environnement et des mises à jour.
	@bash $(SCRIPTS)/status.sh
