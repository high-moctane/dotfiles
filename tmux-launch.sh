#!/bin/bash

xonsh=$(which xonsh)
zsh=$(which zsh)
bash=$(which bash)

if [ -n "$xonsh" ]; then
    exec "$xonsh"
elif [ -n "$zsh" ]; then
    exec "$zsh"
elif [ -n "$bash" ]; then
    exec "$bash"
else
    exec sh
fi
