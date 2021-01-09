MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
DST := $(HOME)
DOTFILES_DIR := $(DST)/dotfiles
PROTOCOL := ssh
DOTFILES_HTTPS := https://github.com/high-moctane/dotfiles.git
DOTFILES_SSH := git@github.com:high-moctane/dotfiles.git
BRANCH := master

define find-missing-command
	@cat $(DOTFILES_DIR)/$1 | \
		xargs -L 1 -I COMMAND sh -c "which COMMAND > /dev/null || (echo COMMAND not found && false)"
endef


.PHONY: all
all: download
all: vim

.PHONY: download
download: $(DOTFILES_DIR)

$(DOTFILES_DIR):
ifeq "$(PROTOCOL)" "https"
	git clone $(DOTFILES_HTTPS) $(DOTFILES_DIR)
else
ifeq "$(PROTOCOL)" "ssh"
	git clone $(DOTFILES_SSH) $(DOTFILES_DIR)
else
	@echo "invalid git protocol: $(PROTOCOL)"
	@false
endif
endif
	cd $(DOTFILES_DIR) && git checkout $(BRANCH)

# ----------------------------------------------------------------------
#	Vim
# ----------------------------------------------------------------------
.PHONY: vim
vim: vim-link vim-install

.PHONY: vim-link
vim-link: download vim-depends
	ln -fs $(DOTFILES_DIR)/.vimrc $(DST)/.vimrc
	ln -fs $(DOTFILES_DIR)/.gvimrc $(DST)/.gvimrc
	ln -fs $(DOTFILES_DIR)/.vim $(DST)/.vim

.PHONY: vim-install
vim-install: vim-suggests vim-link vim-install-plug

.PHONY: vim-install-plug
vim-install-plug: vim-depends vim-suggests vim-link
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir $(DST)/.vim/plugged

.PHONY: vim-depends
vim-depends:
	$(call find-missing-command,requirements/vim-depends.txt)

.PHONY: vim-suggests
vim-suggests:
	$(call find-missing-command,requirements/vim-suggests.txt)
