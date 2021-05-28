MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DST := $(HOME)
DOTFILES_DIR := $(DST)/dotfiles
BACKUP_DIR := $(DST)/.dotfiles_backup/$(shell date +%Y-%m-%d-%H-%M-%S)
PROTOCOL := ssh
DOTFILES_HTTPS := https://github.com/high-moctane/dotfiles.git
DOTFILES_SSH := git@github.com:high-moctane/dotfiles.git
BRANCH := master
DOCKER := 0
USER := moctane

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

define do-bash
	bash -c "$(call, sh-source) && $1"
endef

define do-fish
	fish -c "$1"
endef

define dotmake
	$(MAKE) -f $(DOTFILES_DIR)/Makefile
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
all: fish
all: git
# all: nvim
# all: rust
all: skk
all: tmux
# all: tool
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
asdf: $(DST)/.asdf
# asdf: $(DST)/.asdf asdf-install

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
#	Fish
# ----------------------------------------------------------------------

.PHONY: fish
fish: fish-link fish-fisher

.PHONY: fish-link
fish-link: $(HOME)/.config
	mkdir -p $(DST)/.config/fish
	$(call backup-and-link,fish/config.fish,.config/fish/config.fish)
	$(call backup-and-link,fish/conf.d,.config/fish/conf.d)
	$(call backup-and-link,fish/functions,.config/fish/functions)

.PHONY: fish-fisher
fish-fisher: fish-link
	$(call do-fish,curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher)
	$(call do-fish,fisher update)

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
go-asdf: download
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) golang latest https://github.com/kennyp/asdf-golang.git


# ----------------------------------------------------------------------
#	Lua
# ----------------------------------------------------------------------

.PHONY: lua-asdf
lua-asdf: download
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) lua latest https://github.com/Stratus3D/asdf-lua.git



# ----------------------------------------------------------------------
#	Luajit
# ----------------------------------------------------------------------

.PHONY: luajit-asdf
luajit-asdf: download lua-asdf
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) luaJIT latest https://github.com/smashedtoatoms/asdf-luaJIT.git


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
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) neovim nightly


# ----------------------------------------------------------------------
#	Node.js
# ----------------------------------------------------------------------

.PHONY: node-asdf
node-asdf: download
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) nodejs latest


# ----------------------------------------------------------------------
#	Python
# ----------------------------------------------------------------------

.PHONY: python-asdf
python-asdf: download
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) python latest

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

.PHONY: vim-asdf
vim-asdf: download
	bash $(DOTFILES_DIR)/asdf/install-plugin.sh $(DOTFILES_DIR) vim latest

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
	apt-get install -y pandoc poppler-utils ffmpeg  # ripgrep-all


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
	$(call do-bash,go get -u -v github.com/jesseduffield/lazydocker)
	$(call do-bash,go get -u -v github.com/jesseduffield/lazygit)

.PHONY: tool-rust
tool-rust:
	$(call do-bash,cargo install --git https://github.com/ogham/dog.git dog)
	$(call do-bash,cargo install ag)
	$(call do-bash,cargo install bandwhich)
	$(call do-bash,cargo install bat)  # shell completion
	$(call do-bash,cargo install bingrep)
	$(call do-bash,cargo install bottom) # shell completion
	$(call do-bash,cargo install choose)
	$(call do-bash,cargo install csview)
	$(call do-bash,cargo install desed)
	$(call do-bash,cargo install drill)
	$(call do-bash,cargo install du-dust)
	$(call do-bash,cargo install fd-find)
	$(call do-bash,cargo install fselect)
	$(call do-bash,cargo install git-delta)
	$(call do-bash,cargo install git-interactive-rebase-tool)
	$(call do-bash,cargo install gping)
	$(call do-bash,cargo install grex)
	$(call do-bash,cargo install hexyl)
	$(call do-bash,cargo install httpie)
	$(call do-bash,cargo install hyperfine)
	$(call do-bash,cargo install hyperfine)
	$(call do-bash,cargo install lsd)
	$(call do-bash,cargo install mkfly)
	$(call do-bash,cargo install monolith)
	$(call do-bash,cargo install navi)
	$(call do-bash,cargo install oha)
	$(call do-bash,cargo install onefetch)
	$(call do-bash,cargo install procs)
	$(call do-bash,cargo install pueue)
	$(call do-bash,cargo install ripgrep)
	$(call do-bash,cargo install ripgrep-all)
	$(call do-bash,cargo install sd)
	$(call do-bash,cargo install silicon)
	$(call do-bash,cargo install skim)
	$(call do-bash,cargo install tealdeer)
	$(call do-bash,cargo install tokei)
	$(call do-bash,cargo install topgrade)
	$(call do-bash,cargo install watchexec-cli)
	$(call do-bash,cargo install xh)
	$(call do-bash,cargo install xsv)
