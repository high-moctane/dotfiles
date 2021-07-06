SHELL := /bin/bash

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))

DST := $(HOME)
DOTDIR := $(DST)/dotfiles
PURPOSE := HOME

.PHONY: all
all: brew


.PHONY: brew
brew:
ifeq "$(shell uname)" "Darwin"
	$(MAKE) -f $(MAKEFILE) brew-mac
else
	@echo "Invalid OS"
	@exit 1
endif


.PHONY: brew-mac
brew-mac:
	$(MAKE) -f $(MAKEFILE) brew-bundle-mac


.PHONY: brew-setup-mac
brew-setup-mac: /usr/local/Homebrew

/usr/local/Homebrew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


.PHONY: brew-bundle-mac
brew-bundle-mac: brew-setup-mac
	brew update
	brew upgrade
ifeq "$(PURPOSE)" "HOME"
	cat $(DOTDIR)/brew/Brewfile-{common,home} | brew bundle --cleanup --file=-
else
ifeq "$(PURPOSE)" "WORK"
	cat $(DOTDIR)/brew/Brewfile-{common,work} | brew bundle --cleanup --file=-
else
	@echo "Invalid PURPOSE"
	@exit 1
endif
endif
