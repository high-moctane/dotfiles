SHELL := /bin/bash

DST := $(HOME)
PURPOSE := HOME
PROTOCOL := ssh
BACKUPDIR := $(DST)/.dotfiles_backup/$(shell date +%F-%H-%M-%S)

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DOTDIR := $(DST)/dotfiles


# src, dst
define backup-and-deploy
	$(call backup,$2)
	$(call deploy,$1,$2)
endef


# target
define backup
	mkdir -p $(BACKUPDIR)/$(dir $1)
	-mv $(DST)/$1 $(BACKUPDIR)/$1
endef


# src, dst
define deploy
	mkdir -p $(DST)/$(dir $2)
	cat $1 > $(DST)/$2
endef


.PHONY: all
all: $(DOTDIR)
all: brew
all: alacritty
# all: fish
all: tmux
all: xonsh


$(DOTDIR):
ifeq "$(PROTOCOL)" "ssh"
	cd $(DST) && git clone git@github.com:high-moctane/dotfiles.git
else
ifeq "$(PROTOCOL)" "https"
	cd $(DST) && git clone https://github.com/high-moctane/dotfiles.git
else
	@echo "invalid PROTOCOL"
	@exit 1
endif
endif


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
	cat $(DOTDIR)/brew/Brewfile-{common,home} | brew bundle cleanup --file=-
	cat $(DOTDIR)/brew/Brewfile-{common,home} | brew bundle install --file=-
else
ifeq "$(PURPOSE)" "WORK"
	cat $(DOTDIR)/brew/Brewfile-{common,work} | brew bundle cleanup --file=-
	cat $(DOTDIR)/brew/Brewfile-{common,work} | brew bundle install --file=-
else
	@echo "Invalid PURPOSE"
	@exit 1
endif
endif
	brew cleanup


.PHONY: alacritty
alacritty:
	$(call backup-and-deploy,alacritty/alacritty.yml,.config/alacritty/alacritty.yml)


.PHONY: fish
fish: fish-deploy
fish: fish-fresco
fish: fish-fresco-plugins


.PHONY: fish-deploy
fish-deploy:
	$(call backup-and-deploy,fish/config.fish,.config/fish/config.fish)
	$(call backup-and-deploy,fish/conf.d/aliases.fish,.config/fish/conf.d/aliases.fish)
	$(call backup-and-deploy,fish/conf.d/colors.fish,.config/fish/conf.d/colors.fish)
	$(call backup-and-deploy,fish/fish_plugins,.config/fish/fish_plugins)


.PHONY: fish-fresco
fish-fresco:
	curl https://raw.githubusercontent.com/masa0x80/fresco/master/install | fish


.PHONY: fish-fresco-plugins
fish-fresco-plugins: fish-fresco
	$(MAKE) -f $(MAKEFILE) SHELL=$(shell which fish) fish-fresco-plugins-fish


.PHONY: fish-fresco-plugins-fish
fish-fresco-plugins-fish:
	fresco (cat $(DST)/.config/fish/fish_plugins | tr "\n" " ")


.PHONY: tmux
tmux:
	$(call backup-and-deploy,tmux/tmux.conf,.config/tmux/tmux.conf)


.PHONY: xonsh
xonsh: xonsh-deploy
xonsh: xonsh-xontribs


.PHONY: xonsh-deploy
xonsh-deploy:
	$(call backup-and-deploy,xonsh/rc.xsh,.config/xonsh/rc.xsh)


.PHONY: xonsh-xontribs
xonsh-xontribs:
	$(MAKE) -f $(MAKEFILE) SHELL=$(shell which xonsh) xonsh-xontribs-xonsh


.PHONY: xonsh-xontribs-xonsh
xonsh-xontribs-xonsh:
	# xpip install -U git+https://github.com/popkirby/xonsh-pure
