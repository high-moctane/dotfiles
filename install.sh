#!/bin/bash

# Symbolic link
cd ~/dotfiles
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -sfnv ~/dotfiles/$f ~/$f
done
