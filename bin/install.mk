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
	-mv $(DST)/$1 $(BACKUP_DIR)/$1
	ln -s $(DOTFILES_DIR)/$1 $(DST)/$1
endef

.PHONY: all
all: download
all: $(BACKUP_DIR)
all: dot-config
all: vim
all: nvim
all: skk
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

.PHONY: dot-config
dot-config:
	$(call backup-and-link,.config)

.PHONY: done
done:
	@echo done

# ----------------------------------------------------------------------
#	Vim
# ----------------------------------------------------------------------
.PHONY: vim
vim: vim-depends vim-link vim-install

.PHONY: vim-depends
vim-depends:
	$(call find-missing-command,requirements/vim-depends.txt)

.PHONY: vim-suggests
vim-suggests:
	$(call find-missing-command,requirements/vim-suggests.txt)

.PHONY: vim-link
vim-link: download
	$(call backup-and-link,.vimrc)
	$(call backup-and-link,.gvimrc)
	$(call backup-and-link,.vim)

.PHONY: vim-install
vim-install:
	-mkdir $(DST)/.vim/autoload
	-mkdir $(DST)/.vim/plugged
	curl -fLo $(DST)/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ----------------------------------------------------------------------
#	Neovim
# ----------------------------------------------------------------------

.PHONY: nvim
nvim: nvim-depends nvim-link nvim-install

.PHONY: nvim-depends
nvim-depends:
	$(call find-missing-command,requirements/nvim-depends.txt)

.PHONY: nvim-suggests
nvim-suggests:
	$(call find-missing-command,requirements/nvim-suggests.txt)

.PHONY: nvim-link
nvim-link: download

.PHONY: nvim-install
nvim-install:
	-mkdir $(DST)/.cache/dein
	-mkdir /tmp/high-moctane-dotfiles
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/high-moctane-dotfiles/installer.sh
	sh /tmp/high-moctane-dotfiles/installer.sh $(DST)/.cache/dein
	rm -rf /tmp/high-moctane-dotfiles


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
	git clone --depth 1 -b master $(SKK_REPO) $@

.PHONY: skk-build
skk-build: $(SKK_DIR)/SKK-JISYO.total

$(SKK_DIR)/SKK-JISYO.total: skk-depends $(SKK_DIR)/dict
	skkdic-expr2 \
		$(SKK_DIR)/dict/SKK-JISYO.L \
		$(SKK_DIR)/dict/SKK-JISYO.jinmei \
		$(SKK_DIR)/dict/SKK-JISYO.geo \
		$(SKK_DIR)/dict/SKK-JISYO.station \
		$(SKK_DIR)/dict/SKK-JISYO.propernoun \
		> $@

.PHONY: skk-depends
skk-depends:
	$(call find-missing-command,requirements/skk-depends.txt)

# ----------------------------------------------------------------------
#	Zsh
# ----------------------------------------------------------------------
.PHONY: zsh
zsh: zsh-depends zsh-link

.PHONY: zsh-link
zsh-link:
	$(call backup-and-link,.shell_common)
	$(call backup-and-link,.zshenv)
	$(call backup-and-link,.zshrc)

.PHONY: zsh-depends
zsh-depends:
	$(call find-missing-command,requirements/zsh-depends.txt)

.PHONY: zsh-suggests
	$(call find-missing-command,requirements/zsh-suggests.txt)
