# ----- Makefile -----
#
#
BRANCH := $(shell git branch --show-current)
REMOTES := $(shell git remote)
.DEFAULT_GOAL := help

.PHONY: help install commit push push-lease

help:
	@echo "Options:"
	@echo
	@echo "  make install      -> Instala a configuração do NVim"
	@echo "  make commit       -> Commit automático"
	@echo "  make push         -> Faz o push remoto"
	@echo "  make push-lease   -> Faz o push remoto (lease mode)"

# ----- INSTALLER -----
install:
	chmod +x tools/installer.sh
	tools/installer.sh

# ----- GIT -----
commit:
	@if ! git diff-index --quiet HEAD --; then \
		git add .; \
		git commit -m "$$(date +Date:%Y-%m-%d-Time:%H:%M:%S)"; \
	else \
		echo "Nothing to commit"; \
	fi

push:
	@echo "Push normal → branch: $(BRANCH)"
	@for remote in $(REMOTES); do \
		echo "  pushing to $$remote..."; \
		git push $$remote $(BRANCH); \
	done

push-lease:
	@echo "Push --force-with-lease → branch: $(BRANCH)"
	@for remote in $(REMOTES); do \
		echo "  pushing to $$remote..."; \
		git push --force-with-lease $$remote $(BRANCH); \
	done
