#!/bin/bash

xonsh=$(which xonsh)
zsh=$(which zsh)
bash=$(which bash)

if [ -n "$xonsh" ]; then
    "$xonsh"
elif [ -n "$zsh" ]; then
    "$zsh"
elif [ -n "$bash" ]; then
    "$bash"
else
    /bin/sh
fi
