#!/bin/bash

# Symbolic link
cd ~/dotfiles
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -sfnv ~/dotfiles/$f ~/$f
done

# Xonsh
pip_command=""
output=$(which pip) && pip_command="pip"
output=$(which pip3) && pip_command="pip3"
if [ -n "$pip_command" ]; then
    "$pip_command" install xonsh[full]
fi

# vim
mkdir ~/.vim/autoload
mkdir ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
