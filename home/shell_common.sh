# Local Path
if [ -d $HOME/.local/bin ]; then
    export PATH=$HOME/.local/bin:$PATH
fi

# Asdf
if [ -d $HOME/.asdf ]; then
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
fi

# Homebrew (Linux)
if [[ $(uname) == "Linux" ]]; then
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && eval $($(brew --prefix)/bin/brew shellenv)
    eval $($(brew --prefix)/bin/brew shellenv)
fi

# Language Setup

## Go
if [ -d $HOME/go/bin ]; then
    export PATH=$PATH:$HOME/go/bin
fi

## Rust
if [ -d $HOME/.cargo/bin ]; then
    . "$HOME/.cargo/env"
fi

## LaTeX
if [ -d /Library/TeX/texbin ]; then
    export PATH=$PATH:/Library/TeX/texbin
fi

# Utility Setup

## Nextword
export NEXTWORD_DATA_PATH=$HOME'/.local/share/nextword-data-large'

# Environment

which nvim 2>&1 > /dev/null && EDITOR=nvim
