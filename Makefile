MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DST := $(HOME)
DOTFILES_DIR := $(DST)/dotfiles
BACKUP_DIR := $(DST)/.dotfiles_backup/$(shell date +%Y-%m-%d-%H-%M-%S)
PROTOCOL := ssh
DOTFILES_HTTPS := https://github.com/high-moctane/dotfiles.git
DOTFILES_SSH := git@github.com:high-moctane/dotfiles.git
BRANCH := master

define find-missing-command
	@cat $(DOTFILES_DIR)/$1 | \
		xargs -L 1 -I COMMAND sh -c "which COMMAND > /dev/null || (echo COMMAND not found && false)"
endef

define backup-and-link
	mkdir -p $(BACKUP_DIR)/$(dir $2)
	-mv $(DST)/$2 $(BACKUP_DIR)/$2
	mkdir -p $(DST)/$(dir $2)
	ln -s $(DOTFILES_DIR)/$1 $(DST)/$2
endef

.PHONY: all
all: download
all: $(BACKUP_DIR)
all: $(HOME)/.config
all: home
all: alacritty
all: asdf
all: bash
all: docker
all: git
all: nvim
# all: rust
all: skk
all: tmux
all: vim-plugins
# all: zellij
all: zsh
all: done

.PHONY: download
download: $(DOTFILES_DIR)

$(DOTFILES_DIR):
ifeq "$(PROTOCOL)" "https"
	git clone $(DOTFILES_HTTPS) $@
else
ifeq "$(PROTOCOL)" "ssh"
	git clone $(DOTFILES_SSH) $@
else
	@echo "invalid git protocol: $(PROTOCOL)"
	@false
endif
endif
	cd $@ && git checkout $(BRANCH)

$(BACKUP_DIR):
	mkdir -p $(BACKUP_DIR)

$(HOME)/.config:
	mkdir -p $(HOME)/.config

.PHONY: done
done:
	@echo ""
	@echo DOTFILES INSTALL DONE!


# ----------------------------------------------------------------------
#	HOME
# ----------------------------------------------------------------------

.PHONY: home
home: shell_common

.PHONY: shell_common
shell_common:
	$(call backup-and-link,home/shell_common,.shell_common)


# ----------------------------------------------------------------------
#	Alacritty
# ----------------------------------------------------------------------

.PHONY: alacritty
alacritty: alacritty-link alacritty-terminfo

.PHONY:
alacritty-link:
	$(call backup-and-link,alacritty/alacritty.yml,.config/alacritty/alacritty.yml)

alacritty-terminfo:
	mkdir -p /tmp/dotfiles-alacritty
	curl -L https://github.com/alacritty/alacritty/raw/master/extra/alacritty.info \
		> /tmp/dotfiles-alacritty/alacritty.info
	tic -xe alacritty,alacritty-direct /tmp/dotfiles-alacritty/alacritty.info
	rm -rf /tmp/dotfiles-alacritty


# ----------------------------------------------------------------------
#	Asdf
# ----------------------------------------------------------------------

.PHONY: asdf
asdf: $(DST)/.asdf

$(DST)/.asdf:
	git clone https://github.com/asdf-vm/asdf.git $@
	cd $@ && git describe --abbrev=0 --tags
	cd $@ && git checkout `git describe --abbrev=0 --tags)`



# ----------------------------------------------------------------------
#	Bash
# ----------------------------------------------------------------------

.PHONY: bash
bash:
	$(call backup-and-link,bash/bash_profile,.bash_profile)


# ----------------------------------------------------------------------
#	Docker
# ----------------------------------------------------------------------

.PHONY: docker
docker:
	$(call backup-and-link,docker/config.json,.docker/config.json)


# ----------------------------------------------------------------------
#	Git
# ----------------------------------------------------------------------

.PHONY: git
git:
	$(call backup-and-link,git/gitconfig,.gitconfig)
	$(call backup-and-link,git/gitignore_global,.gitignore_global)


# ----------------------------------------------------------------------
#	LuaJIT
# ----------------------------------------------------------------------

.PHONY: luajit
luajit: asdf
	bash -c ". $(DST)/.asdf/asdf.sh && asdf package add luaJIT https://github.com/smashedtoatoms/asdf-luaJIT.git"
	bash -c ". $(DST)/.asdf/asdf.sh && asdf install luaJIT latest"
	bash -c ". $(DST)/.asdf/asdf.sh && asdf global luaJIT `asdf latest luaJIT`"


# ----------------------------------------------------------------------
#	Neovim
# ----------------------------------------------------------------------

NVIM_TAG := nightly
NVIM_APPIMAGE := https://github.com/neovim/neovim/releases/download/$(NVIM_TAG)/nvim.appimage
NVIM_PACKER_REPO := https://github.com/wbthomason/packer.nvim
NVIM_PACKER_DST := $(DST)/.local/share/nvim/site/pack/packer/start/packer.nvim

.PHONY: nvim
nvim: nvim-link nvim-appimage nvim-packer luajit nodejs

.PHONY: nvim-link
nvim-link:
	$(call backup-and-link,nvim,.config/nvim)

.PHONY: nvim-appimage
nvim-appimage:
ifeq "$(shell uname)" "Linux"
	mkdir -p $(DST)/.local/lib/nvim
	curl -L -o $(DST)/.local/lib/nvim/nvim.appimage $(NVIM_APPIMAGE)
	chmod u+x $(DST)/.local/lib/nvim/nvim.appimage
	cd $(DST)/.local/lib/nvim && ./nvim.appimage --appimage-extract
	mkdir -p $(DST)/.local/bin
	ln -sf $(DST)/.local/lib/nvim/squashfs-root/usr/bin/nvim $(DST)/.local/bin/nvim
endif

.PHONY: nvim-packer
nvim-packer: $(NVIM_PACKER_DST)

$(NVIM_PACKER_DST):
	git clone $(NVIM_PACKER_REPO) $@


# ----------------------------------------------------------------------
#	Node.js
# ----------------------------------------------------------------------

.PHONY: nodejs
nodejs: asdf
	bash -c ". $(DST)/.asdf/asdf.sh && asdf package add nodejs"
	bash -c ". $(DST)/.asdf/asdf.sh && asdf install nodejs latest"
	bash -c ". $(DST)/.asdf/asdf.sh && asdf global nodejs `asdf latest nodejs`"


# ----------------------------------------------------------------------
#	Rust
# ----------------------------------------------------------------------

.PHONY: rust
rust: $(DST)/.cargo

$(DST)/.cargo:
	mkdir -p /tmp/dotfiles-rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/dotfiles-rust/rustup-init
	sh /tmp/dotfiles-rust/rustup-init -y
	rm -rf /tmp/dotfiles-rust


# ----------------------------------------------------------------------
#	SKK
# ----------------------------------------------------------------------

SKK_REPO := https://github.com/skk-dev/dict.git
SKK_DIR := $(DST)/.local/share/skk

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


# ----------------------------------------------------------------------
#	Tmux
# ----------------------------------------------------------------------

.PHONY: tmux
tmux: tmux-install tmux-link tmux-terminfo

.PHONY: tmux-install
tmux-install: asdf
	bash -c "asdf plugin add tmux https://github.com/aphecetche/asdf-tmux.git"
	bash -c "asdf install tmux latest"
	bash -c "asdf global tmux `asdf latest tmux`"

.PHONY: tmux-link
	$(call backup-and-link,tmux/tmux.conf,.config/tmux/tmux.conf)

.PHONY: tmux-terminfo
tmux-terminfo:
	mkdir -p /tmp/dotfiles-tmux
	curl -L https://github.com/tmux/tmux/files/1725937/tmux-256color.terminfo.txt \
		> /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	tic /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	rm -rf /tmp/dotfiles-tmux


# ----------------------------------------------------------------------
#	Vim plugins
# ----------------------------------------------------------------------

.PHONY: vim-plugins
vim-plugins: anthraxylon

ANTHRAXYLON_HTTPS := https://github.com/high-moctane/anthraxylon.git
ANTHRAXYLON_SSH := git@github.com:high-moctane/anthraxylon.git

.PHONY: anthraxylon
anthraxylon: $(DST)/Documents/projects/anthraxylon

$(DST)/Documents/projects/anthraxylon:
ifeq "$(PROTOCOL)" "https"
	git clone $(ANTHRAXYLON_HTTPS) $@
else
ifeq "$(PROTOCOL)" "ssh"
	git clone $(ANTHRAXYLON_SSH) $@
else
	@echo "invalid git protocol: $(PROTOCOL)"
	@false
endif
endif

# ----------------------------------------------------------------------
#	Zellij
# ----------------------------------------------------------------------

.PHONY: zellij
zellij: zellij-install

.PHONY: rust zellij-install
zellij-install:
	cargo install zellij

.PHONY: rust zellij-update
zellij-update:
	cargo update zellij

# ----------------------------------------------------------------------
#	Zsh
# ----------------------------------------------------------------------

.PHONY: zsh
zsh:
	$(call backup-and-link,zsh/zshenv,.zshenv)
	$(call backup-and-link,zsh/zshrc,.zshrc)


# ----------------------------------------------------------------------
#	Install dependencies
# ----------------------------------------------------------------------

# --------------------------------------------------
#	Apt
# --------------------------------------------------

.PHONY: apt
apt:
	apt-get update
	apt-get install -y bash zsh git skktools build-essential htop
