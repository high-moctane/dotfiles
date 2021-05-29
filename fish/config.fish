# ENVVAR

## Linuxbrew
if test (uname) = Linux
    if test -d $HOME/.linuxbrew
        eval ($HOME/.linuxbrew/bin/brew shellenv)
    end
    if test -d /home/linuxbrew/.linuxbrew
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    end
end

## Asdf
if test -d $HOME/.asdf
    source $HOME/.asdf/asdf.fish
end

## Local Path
fish_add_path $HOME/.local/bin

## Go
fish_add_path $HOME/go/bin

## Rust
fish_add_path $HOME/.cargo/bin

## LaTeX
fish_add_path /Library/TeX/texbin


# Utilities
set -x NEXTWORD_DATA_PATH $HOME/.local/share/nextword-data-large


# Alias
function d-c
    docker-compose $argv
end
