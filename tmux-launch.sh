#!/bin/bash

zsh=$(which zsh)
bash=$(which bash)

if [ -n "$zsh" ]; then
    exec "$zsh"
elif [ -n "$bash" ]; then
    exec "$bash"
else
    exec sh
fi
