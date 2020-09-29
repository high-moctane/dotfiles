#!/bin/bash

bash_exists=0
output=$(which bash) || bash_exists=$?

zsh_exists=0
output=$(which zsh) || bash_exists=$?

if [ "$zsh_exists" = "0" ]; then
    zsh
elif [ "$bash_exists" = "0" ]; then
    bash
fi
