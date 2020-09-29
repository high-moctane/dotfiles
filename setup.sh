#!/bin/bash

# Xonsh
pip_command=""
pip_command=$(which pip)
pip_command=$(which pip3)
if [ -n "$pip_command" ]; then
    "$pip_command" install xonsh[full]
fi

# Vim
mkdir ~/.vim/autoload
mkdir ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
