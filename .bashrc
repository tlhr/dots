# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# General config
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

[ -f ~/.local.sh ] && source ~/.local.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.aliases.sh ] && source ~/.aliases.sh
[ -f ~/.functions.sh ] && source ~/.functions.sh

# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Shell stuff
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

export HISTFILE=~/.histfile
export HISTSIZE=1000000
export SAVEHIST=1000000
export FZF_COMPLETION_TRIGGER=''
export EDITOR=vim
