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
all: docker
all: git
all: neovim
all: tmux
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
alacritty:
	$(call backup-and-link,alacritty/alacritty.yml,.config/alacritty/alacritty.yml)


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
#	Neovim
# ----------------------------------------------------------------------

.PHONY: neovim
neovim: neovim-link

.PHONY: neovim-link
neovim-link:
	$(call backup-and-link,nvim,.config/nvim)


# ----------------------------------------------------------------------
#	Tmux
# ----------------------------------------------------------------------

.PHONY: tmux
tmux:
	$(call backup-and-link,tmux/tmux.conf,.config/tmux/tmux.conf)


# ----------------------------------------------------------------------
#	Zsh
# ----------------------------------------------------------------------

.PHONY: zsh
zsh:
	$(call backup-and-link,zsh/zshenv,.zshenv)
	$(call backup-and-link,zsh/zshrc,.zshrc)
