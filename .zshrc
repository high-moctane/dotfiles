### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-completions

zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-history-substring-search

zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit load zdharma/fast-syntax-highlighting

# zinit ice lucid atload'!_zsh_git_prompt_precmd_hook'
# zinit load woefe/git-prompt.zsh

zinit ice pick"async.zsh" src"pure.zsh"
zinit load sindresorhus/pure

zinit ice wait lucid
zinit load mollifier/cd-gitroot

# zinit ice wait lucid
# zinit load popstas/zsh-command-time

# required notify-send
zinit ice wait lucid
zinit load MichaelAquilina/zsh-auto-notify
export PATH="/usr/local/bin:$PATH"


# zinit load marlonrichert/zsh-autocomplete
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-complete

zinit ice wait lucid
zinit load Tarrasch/zsh-bd

zinit ice wait lucid
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zinit ice wait lucid
zinit load unixorn/fzf-zsh-plugin

# ----------------------------------------------------------------------

bindkey "^P" up-line-or-search

alias ls='ls -G'
alias ll='ls -l'
alias la='ls -la'

setopt auto_cd
setopt share_history