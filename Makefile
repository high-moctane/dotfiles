SHELL := /bin/bash

PURPOSE := HOME
PROTOCOL := ssh
BACKUPDIR := $(HOME)/.dotfiles_backup/$(shell date +%F-%H-%M-%S)

MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DOTDIR := $(HOME)/dotfiles
DOTMAKE := $(DOTDIR)/Makefile


# src, dst
define backup-and-deploy
	$(call backup,$2)
	$(call deploy,$1,$2)
endef


# target
define backup
	mkdir -p $(BACKUPDIR)/$(dir $1)
	-mv $(HOME)/$1 $(BACKUPDIR)/$1
endef


# src, dst
define deploy
	mkdir -p $(HOME)/$(dir $2)
	cp -r $1 $(HOME)/$2
endef


.PHONY: all
all: $(DOTDIR)
all: brew
all: xonsh
all: alacritty
all: asdf
# all: fish
all: skk
all: tmux
all: vim

all: python


$(DOTDIR):
ifeq "$(PROTOCOL)" "ssh"
	cd $(HOME) && git clone git@github.com:high-moctane/dotfiles.git
else
ifeq "$(PROTOCOL)" "https"
	cd $(HOME) && git clone https://github.com/high-moctane/dotfiles.git
else
	@echo "invalid PROTOCOL"
	@exit 1
endif
endif


.PHONY: brew
brew: $(DOTDIR)
ifeq "$(shell uname)" "Darwin"
	$(MAKE) -f $(DOTMAKE) brew-mac
else
	@echo "Invalid OS"
	@exit 1
endif


.PHONY: brew-mac
brew-mac:
	$(MAKE) -f $(DOTMAKE) brew-bundle-mac


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
alacritty: alacritty-deploy
alacritty: alacritty-terminfo


.PHONY: alacritty-deploy
alacritty-deploy:
	$(call backup-and-deploy,alacritty/alacritty.yml,.config/alacritty/alacritty.yml)


.PHONY: alacritty-terminfo
alacritty-terminfo:
	mkdir -p /tmp/dotfiles-alacritty
	curl -L https://github.com/alacritty/alacritty/raw/master/extra/alacritty.info \
		> /tmp/dotfiles-alacritty/alacritty.info
	tic -xe alacritty,alacritty-direct /tmp/dotfiles-alacritty/alacritty.info
	rm -rf /tmp/dotfiles-alacritty


.PHONY: asdf
asdf: $(DOTDIR)
	$(MAKE) -f $(DOTMAKE) SHELL=$(shell which xonsh) asdf-xonsh


.PHONY: asdf-xonsh
asdf-xonsh: asdf-python


.PHONY: asdf-python
asdf-python:
	-asdf plugin add python
	asdf install python latest
	asdf install python 3.9.2
	asdf global python latest


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
	$(MAKE) -f $(DOTMAKE) SHELL=$(shell which fish) fish-fresco-plugins-fish


.PHONY: fish-fresco-plugins-fish
fish-fresco-plugins-fish:
	fresco (cat $(HOME)/.config/fish/fish_plugins | tr "\n" " ")


.PHONY: git
git:
	$(call backup-and-deploy,git/gitconfig,.gitconfig)
	$(call backup-and-deploy,git/gitignore_global,.gitignore_global)


.PHONY: python
python:
	pip3 install -U black ipython isort pipenv py-spy


SKK_REPO := https://github.com/skk-dev/dict.git
SKK_DIR := $(HOME)/.local/share/skk


.PHONY: skk
skk: skk-build


.PHONY: skk-update
skk-update: skk-dict-pull skk-build


.PHONY: skk-dict-pull
skk-dict-pull: skk-download
	cd $(SKK_DIR)/dict && git pull


.PHONY: skk-download
skk-download: $(SKK_DIR)/dict


$(SKK_DIR)/dict:
	mkdir -p $(SKK_DIR)
	git clone --depth 1 $(SKK_REPO) $@


.PHONY: skk-build
skk-build: $(SKK_DIR)/SKK-JISYO.total


$(SKK_DIR)/SKK-JISYO.total: $(SKK_DIR)/dict
	skkdic-expr2 \
		$(SKK_DIR)/dict/SKK-JISYO.L \
		$(SKK_DIR)/dict/SKK-JISYO.jinmei \
		$(SKK_DIR)/dict/SKK-JISYO.geo \
		$(SKK_DIR)/dict/SKK-JISYO.station \
		$(SKK_DIR)/dict/SKK-JISYO.propernoun \
		> $@


.PHONY: tmux
tmux: tmux-deploy
tmux: tmux-terminfo


.PHONY: tmux-deploy
tmux-deploy:
	$(call backup-and-deploy,tmux/tmux.conf,.config/tmux/tmux.conf)


.PHONY: tmux-terminfo
tmux-terminfo:
	mkdir -p /tmp/dotfiles-tmux
	curl -L https://github.com/tmux/tmux/files/1725937/tmux-256color.terminfo.txt \
		> /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	tic /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	rm -rf /tmp/dotfiles-tmux


.PHONY: vim
vim: vim-deploy
vim: vim-plug


.PHONY: vim-deploy
vim-deploy:
	$(call backup-and-deploy,vim/vimrc,.vimrc)
	$(call backup-and-deploy,vim/vim/_config,.vim/_config)
	$(call backup-and-deploy,vim/vim/ftplugin,.vim/ftplugin)
	$(call backup-and-deploy,vim/vim/coc-settings.json,.vim/coc-settings.json)


.PHONY: vim-plug
vim-plug:
	mkdir -p $(HOME)/.vim/plugged
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


.PHONY: xonsh
xonsh: xonsh-deploy
xonsh: xonsh-xontribs


.PHONY: xonsh-deploy
xonsh-deploy:
	$(call backup-and-deploy,xonsh/rc.xsh,.config/xonsh/rc.xsh)


.PHONY: xonsh-xontribs
xonsh-xontribs:
	$(MAKE) -f $(DOTMAKE) SHELL=$(shell which xonsh) xonsh-xontribs-xonsh


.PHONY: xonsh-xontribs-xonsh
xonsh-xontribs-xonsh:
	# xpip install -U git+https://github.com/popkirby/xonsh-pure
	xpip install -U xontrib-zoxide
