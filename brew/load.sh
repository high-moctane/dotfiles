# Homebrew (Linux)
if [ $(uname) = "Linux" ]; then
    if [ -d ~/.linuxbrew ]; then
      eval $(~/.linuxbrew/bin/brew shellenv)
    fi
    if [ -d /home/linuxbrew/.linuxbrew ]; then
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    fi
    if [ -r ~/.bash_profile ]; then
      eval $($(brew --prefix)/bin/brew shellenv)
    fi
    eval $($(brew --prefix)/bin/brew shellenv)
fi
