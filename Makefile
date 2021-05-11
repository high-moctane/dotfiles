MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DST := $(HOME)
DOTFILES_DIR := $(DST)/dotfiles
BACKUP_DIR := $(DST)/.dotfiles_backup/$(shell date +%Y-%m-%d-%H-%M-%S)
PROTOCOL := ssh
DOTFILES_HTTPS := https://github.com/high-moctane/dotfiles.git
DOTFILES_SSH := git@github.com:high-moctane/dotfiles.git
BRANCH := master
DOCKER := F

define backup-and-link
	mkdir -p $(BACKUP_DIR)/$(dir $2)
	-mv $(DST)/$2 $(BACKUP_DIR)/$2
	mkdir -p $(DST)/$(dir $2)
	ln -s $(DOTFILES_DIR)/$1 $(DST)/$2
endef

# name, repo, version, env
define asdf-install-on-bash
	bash -c ". $(DOTFILES_DIR)/home/shell_common.sh && asdf plugin add $1 $2"
	bash -c "export $4 && . $(DOTFILES_DIR)/home/shell_common.sh && asdf install $1 $3"
	bash -c ". $(DOTFILES_DIR)/home/shell_common.sh && asdf global $1 $$(bash -c ". $(DOTFILES_DIR)/home/shell_common.sh && asdf list $1 | tail -n 1")"
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
# all: nvim
# all: rust
all: skk
all: tmux
all: vim
all: vim-plugins
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
shell_common: download
	$(call backup-and-link,home/shell_common.sh,.shell_common.sh)


# ----------------------------------------------------------------------
#	Alacritty
# ----------------------------------------------------------------------

.PHONY: alacritty
alacritty: alacritty-link

.PHONY:
alacritty-link: download
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

.PHONY: asdf asdf-install
asdf: $(DST)/.asdf

$(DST)/.asdf:
	git clone https://github.com/asdf-vm/asdf.git $@
	cd $@ && git describe --abbrev=0 --tags
	cd $@ && git checkout $$(git describe --abbrev=0 --tags)

.PHONY: asdf-install
asdf-install: download
ifeq "$(DOCKER)" "F"
else
	# make luajit-asdf -f $(DOTFILES_DIR)/Makefile
	make node-asdf -f $(DOTFILES_DIR)/Makefile
	make vim-asdf -f $(DOTFILES_DIR)/Makefile
	# make nvim-asdf -f $(DOTFILES_DIR)/Makefile
endif

# ----------------------------------------------------------------------
#	Bash
# ----------------------------------------------------------------------

.PHONY: bash
bash: download
	$(call backup-and-link,bash/bash_profile,.bash_profile)


# ----------------------------------------------------------------------
#	Docker
# ----------------------------------------------------------------------

.PHONY: docker
docker: download
	$(call backup-and-link,docker/config.json,.docker/config.json)


# ----------------------------------------------------------------------
#	Git
# ----------------------------------------------------------------------

.PHONY: git
git: download
	$(call backup-and-link,git/gitconfig,.gitconfig)
	$(call backup-and-link,git/gitignore_global,.gitignore_global)


# ----------------------------------------------------------------------
#	Luajit
# ----------------------------------------------------------------------

.PHONY: luajit-asdf
luajit-asdf: download
	$(call asdf-install-on-bash,luaJIT,https://github.com/smashedtoatoms/asdf-luaJIT.git,latest,)

# ----------------------------------------------------------------------
#	Neovim
# ----------------------------------------------------------------------

NVIM_PACKER_REPO := https://github.com/wbthomason/packer.nvim
NVIM_PACKER_DST := $(DST)/.local/share/nvim/site/pack/packer/start/packer.nvim

.PHONY: nvim
nvim: nvim-link nvim-packer

.PHONY: nvim-link
nvim-link: download
	$(call backup-and-link,nvim,.config/nvim)

.PHONY: nvim-packer
nvim-packer: $(NVIM_PACKER_DST)

$(NVIM_PACKER_DST):
	git clone $(NVIM_PACKER_REPO) $@

.PHONY: nvim-asdf
nvim-asdf: download
	$(call asdf-install-on-bash,neovim,,nightly,)


# ----------------------------------------------------------------------
#	Node.js
# ----------------------------------------------------------------------

.PHONY: node-asdf
node-asdf: download
	$(call asdf-install-on-bash,nodejs,,latest,)


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
tmux: tmux-link tmux-terminfo

.PHONY: tmux-link
tmux-link: download
	$(call backup-and-link,tmux/tmux.conf,.config/tmux/tmux.conf)

.PHONY: tmux-terminfo
tmux-terminfo:
	mkdir -p /tmp/dotfiles-tmux
	curl -L https://github.com/tmux/tmux/files/1725937/tmux-256color.terminfo.txt \
		> /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	tic /tmp/dotfiles-tmux/tmux-256color.terminfo.txt
	rm -rf /tmp/dotfiles-tmux


# ----------------------------------------------------------------------
#	Vim
# ----------------------------------------------------------------------

.PHONY: vim
vim: vim-link vim-plug

.PHONY: vim-link
vim-link:
	$(call backup-and-link,vim/vimrc,.vimrc)
	$(call backup-and-link,vim/vim,.vim)

ASDF_VIM_CONFIG := \
	--enable-fail-if-missing \
	--with-tlib=ncurses \
	--with-compiledby=asdf \
	--enable-multibyte \
	--enable-cscope \
	--enable-terminal \
	--enable-luainterp \
	--with-luajit \
	--enable-gui=no \
	--without-x

# TODO vim のバージョンをどうにかする
.PHONY: vim-asdf
vim-asdf: download
	$(call asdf-install-on-bash,vim,,8.2.2846,ASDF_VIM_CONFIG='$(ASDF_VIM_CONFIG)')

.PHONY: vim-plug
vim-plug:
	mkdir -p $(DST)/.vim/plugged
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


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
#	Zsh
# ----------------------------------------------------------------------

.PHONY: zsh
zsh: download
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
	apt-get install -y dirmngr gawk git gpg procps skktools sudo zsh
	# which python3 && true || apt-get install -y python3 python3-dev python3-pip // TODO vim を +python3 でビルドしたい
	which luajit && true || apt-get install -y libluajit-5.1-dev luajit


# --------------------------------------------------
#	Homebrew
# --------------------------------------------------

.PHONY: brew
brew: brew-setup brew-install

.PHONY: brew-setup
brew-setup: download
ifeq "$(shell uname)" "Linux"
	make -f $(DOTFILES_DIR)/Makefile brew-setup-linux
else
	make -f $(DOTFILES_DIR)/Makefile brew-setup-mac
endif

.PHONY: brew-setup-linux
brew-setup-linux: /home/linuxbrew/.linuxbrew

/home/linuxbrew/.linuxbrew:
	-sudo useradd -m linuxbrew
	echo | sudo -u linuxbrew /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: brew-setup-mac
brew-setup-mac: /usr/local/bin/brew

/usr/local/bin/brew:
	echo | /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: brew-install
brew-install: download
	. $(DOTFILES_DIR)/home/shell_common.sh && brew update
ifeq "$(DOCKER)" "F"
	. $(DOTFILES_DIR)/home/shell_common.sh && brew bundle --file $(DOTFILES_DIR)/brew/Brewfile
else
	. $(DOTFILES_DIR)/home/shell_common.sh && brew bundle --file $(DOTFILES_DIR)/brew/Brewfile-docker
endif


# ----------------------------------------------------------------------
#	Language development
# ----------------------------------------------------------------------


# --------------------------------------------------
#	Python
# --------------------------------------------------

.PHONY: python-dev
python-dev:
	pip3 install black ipython isort
