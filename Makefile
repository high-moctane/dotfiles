MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DST := $(HOME)
DOTFILES_DIR := $(DST)/dotfiles
BACKUP_DIR := $(DST)/.dotfiles_backup/$(shell date +%Y-%m-%d-%H-%M-%S)
PROTOCOL := ssh
DOTFILES_HTTPS := https://github.com/high-moctane/dotfiles.git
DOTFILES_SSH := git@github.com:high-moctane/dotfiles.git
BRANCH := master
DOCKER := 0

# src, dst
define backup-and-link
	mkdir -p $(BACKUP_DIR)/$(dir $2)
	-mv $(DST)/$2 $(BACKUP_DIR)/$2
	mkdir -p $(DST)/$(dir $2)
	ln -s $(DOTFILES_DIR)/$1 $(DST)/$2
endef

define sh-source
	. $(DOTFILES_DIR)/home/shell_common.sh
endef

define dotmake
	$(MAKE) -f $(DOTFILES_DIR)/Makefile
endef

# name, repo, version, env
define asdf-install-on-bash
	bash -c "$(call sh-source) && asdf plugin add $1 $2"
	bash -c "export $4 && $(call sh-source) && asdf install $1 $3"
	bash -c "$(call sh-source) && asdf global $1 $$($(call asdf-installed-latest-version,$1))"
endef

# name
define asdf-installed-latest-version
	bash -c "$(call sh-source) && asdf list $1 | tail -n 1 | sed -e 's/ //g'"
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
all: rust
all: skk
all: tmux
all: tool
all: vim
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

.PHONY: alacritty-link
alacritty-link: download
	$(call backup-and-link,alacritty/alacritty.yml,.config/alacritty/alacritty.yml)

.PHONY: alacritty-terminfo
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
asdf: $(DST)/.asdf asdf-install

$(DST)/.asdf:
	git clone https://github.com/asdf-vm/asdf.git $@
	cd $@ && git describe --abbrev=0 --tags
	cd $@ && git checkout $$(git describe --abbrev=0 --tags)

.PHONY: asdf-install
asdf-install: go-asdf luajit-asdf node-asdf python-asdf vim-asdf


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
#	Go
# ----------------------------------------------------------------------

.PHONY: go-asdf
go-asdf: download $(DST)/.asdf/installs/golang

$(DST)/.asdf/installs/golang:
	$(call asdf-install-on-bash,golang,https://github.com/kennyp/asdf-golang.git,latest,)


# ----------------------------------------------------------------------
#	Lua
# ----------------------------------------------------------------------

MACOSX_SDK_VERSION := $(shell sw_vers -productVersion | sed -e "s/\.[0-9]*$$//")

.PHONY: lua-asdf
luajit-asdf: download $(DST)/.asdf/installs/lua

$(DST)/.asdf/installs/lua:
ifeq "$(shell uname)" "Linux"
	$(call asdf-install-on-bash,lua,https://github.com/Stratus3D/asdf-lua.git,latest,)
else
	$(call asdf-install-on-bash,lua,https://github.com/Strauts3D/asdf-lua.git,latest,MACOSX_DEPLOYMENT_TARGET=$(MACOSX_SDK_VERSION))
endif


# ----------------------------------------------------------------------
#	Luajit
# ----------------------------------------------------------------------

.PHONY: luajit-asdf
luajit-asdf: download lua-asdf $(DST)/.asdf/installs/luaJIT

$(DST)/.asdf/installs/luaJIT:
ifeq "$(shell uname)" "Linux"
	$(call asdf-install-on-bash,luaJIT,https://github.com/smashedtoatoms/asdf-luaJIT.git,latest,)
else
	$(call asdf-install-on-bash,luaJIT,https://github.com/smashedtoatoms/asdf-luaJIT.git,latest,MACOSX_DEPLOYMENT_TARGET=$(MACOSX_SDK_VERSION))
endif


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
nvim-asdf: download $(DST)/.asdf/installs/nvim

$(DST)/.asdf/installs/nvim:
	$(call asdf-install-on-bash,neovim,,nightly,)


# ----------------------------------------------------------------------
#	Node.js
# ----------------------------------------------------------------------

.PHONY: node-asdf
node-asdf: download $(DST)/.asdf/installs/nodejs

$(DST)/.asdf/installs/nodejs:
	$(call asdf-install-on-bash,nodejs,,latest,)


# ----------------------------------------------------------------------
#	Python
# ----------------------------------------------------------------------

.PHONY: python-asdf
python-asdf: download $(DST)/.asdf/installs/python

$(DST)/.asdf/installs/python:
	$(call asdf-install-on-bash,python,,latest,)

.PHONY: python-dev
python-dev:
	pip3 install black ipython isort pipenv py-spy


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
	--with-lua-prefix=$(DST)/.asdf/installs/luaJIT/$(ASDF_LUAJIT_VERSION) \
	--enable-gui=no \
	--without-x

.PHONY: vim-asdf
vim-asdf: download $(DST)/.asdf/installs/vim

$(DST)/.asdf/installs/vim:
	$(call asdf-install-on-bash,vim,,latest,ASDF_VIM_CONFIG='$(ASDF_VIM_CONFIG)')

.PHONY: vim-plug
vim-plug:
	mkdir -p $(DST)/.vim/plugged
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# ----------------------------------------------------------------------
#	Zsh
# ----------------------------------------------------------------------

.PHONY: zsh
zsh: download
	$(call backup-and-link,zsh/zshenv,.zshenv)
	$(call backup-and-link,zsh/zshrc,.zshrc)
	cat $(DOTFILES_DIR)/{home/shell_common,zsh/zsh{env,rc}} | zsh -


# ----------------------------------------------------------------------
#	Package manager
# ----------------------------------------------------------------------

# --------------------------------------------------
#	Apt
# --------------------------------------------------

.PHONY: apt
apt:
	apt-get update
	apt-get install -y git gpg less skktools sudo zsh
	apt-get install -y dirmngr gpg  # Node.js
	apt-get install -y pandoc poppler tesseract ffmpeg  # ripgrep-all


# --------------------------------------------------
#	Homebrew
# --------------------------------------------------

.PHONY: brew
brew: brew-setup brew-install

.PHONY: brew-setup
brew-setup: download
ifeq "$(shell uname)" "Linux"
	$(call dotmake) brew-setup-linux
else
	$(call dotmake) brew-setup-mac
endif

.PHONY: brew-setup-linux
brew-setup-linux: download /home/linuxbrew/.linuxbrew
ifeq "$(shell whoami)" "root"
	$(call dotmake) /home/linuxbrew/.linuxbrew
else
	$(call dotmake) /home/$(shell whoami)/.linuxbrew
endif

/home/linuxbrew/.linuxbrew:
	-sudo useradd -m linuxbrew
	echo | sudo -u linuxbrew /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

/home/$(shell whoami)/.linuxbrew:
	echo | /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: brew-setup-mac
brew-setup-mac: /usr/local/bin/brew

/usr/local/bin/brew:
	echo | /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: brew-install
brew-install: download
	$(call sh-source) && brew update
ifeq "$(DOCKER)" "0"
	$(call sh-source) && brew bundle --file $(DOTFILES_DIR)/brew/Brewfile
else
	$(call sh-source) && brew bundle --file $(DOTFILES_DIR)/brew/Brewfile-docker
endif


# ----------------------------------------------------------------------
#	Tools
# ----------------------------------------------------------------------

.PHONY: tool
tool: tool-go tool-rust

.PHONY: tool-go
tool-go:
	go get github.com/jesseduffield/lazydocker
	go get github.com/jesseduffield/lazygit

.PHONY: tool-rust
tool-rust:
	cargo install --git https://github.com/ClementTsang/bottom # shell completion
	cargo install --git https://github.com/XAMPPRocky/tokei.git tokei
	cargo install --git https://github.com/ogham/dog
	cargo install ag
	cargo install bandwhich
	cargo install bat
	cargo install bat # shell completion
	cargo install bingrep
	cargo install bottom
	cargo install choose
	cargo install csview
	cargo install desed
	cargo install drill
	cargo install du-dust
	cargo install fd-find
	cargo install fselect
	cargo install git-delta
	cargo install git-interactive-rebase-tool
	cargo install gping
	cargo install grex
	cargo install hexyl
	cargo install httpie
	cargo install hyperfine
	cargo install hyperfine
	cargo install lsd
	cargo install mkfly
	cargo install monolith
	cargo install navi
	cargo install oha
	cargo install onefetch
	cargo install procs
	cargo install pueue
	cargo install ripgrep
	cargo install ripgrep-all
	cargo install sd
	cargo install silicon
	cargo install skim
	cargo install tealdeer
	cargo install topgrade
	cargo install watchexec-cli
	cargo install xh
	cargo install xsv
