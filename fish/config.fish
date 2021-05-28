# ENVVAR

## Linuxbrew
if test (uname) = Linux
    if test -d $HOME/.linuxbrew
        eval ($HOME/.linuxbrew/bin/brew shellenv)
    end
    if test -d /home/linuxbrew/.linuxbrew
        eval (/home/linuxbrew/.linuxbrew shellenv)
    end
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


# Color
set black '#000000'
set gray1 '#262626'
set gray2 '#444444'
set gray4 '#808080'
set gray5 '#a8a8a8'
set gray6 '#d0d0d0'

set dark_green  '#005f00'
set green       '#87d787'
set blue        '#afafff'
set light_blue  '#87d7d7'
set purple      '#d787ff'
set dark_red    '#5f0000'
set red         '#ff8787'
set orange      '#d7af5f'
set dark_yellow '#5f5f00'
set yellow      '#878700'

set -g fish_color_normal         $gray6
set -g fish_color_command        $light_blue
set -g fish_color_keyword        $light_blue
set -g fish_color_quote          $green
set -g fish_color_redirection    $white
set -g fish_color_end            $white
set -g fish_color_error          $red
set -g fish_color_param          $white
set -g fish_color_comment        $gray4
set -g fish_color_selection      --background=$gray2
set -g fish_color_operator       $white
set -g fish_color_escape         $purple
set -g fish_color_autosuggestion $gray2
set -g fish_color_cwd            $blue
set -g fish_color_user           $blue
set -g fish_color_host           $blue
set -g fish_color_host_remote    $blue
set -g fish_color_cancel         $yellow
set -g fish_color_search_match   --background=$dark_yellow
