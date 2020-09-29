# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

if [ -d $HOME/go/bin ]; then
    export PATH=$PATH:$HOME/go/bin:$PATH
fi
