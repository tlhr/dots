# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Aliases
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

if [[ $(uname) != "Darwin" ]]; then
    alias ll='ls -lh --color=always --group-directories-first'
    alias la='ls -lA'
    alias l='ls -CF'
else
    alias la='ls -lhAG'
    alias ll='ls -lphG'
    alias ls='ls -G'
    alias updatedb='/usr/libexec/locate.updatedb'
fi

alias yolo='sudo $(fc -ln -1)'
alias vi='vim'
alias py='python3'
alias py2='python2.7'
alias pymol='pymol -M'
alias rm='rm -iv'
alias :q='exit'
alias r='ranger'
alias t='tmux'
alias pg='ping -c 3 www.google.com'
alias p8='ping -c 3 8.8.8.8'
alias wttr='curl -4 wttr.in/Cambridge'
alias gl='git log --graph --oneline --decorate'
alias gd='git diff --stat'
alias gst='git status'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias nicesim='for pid in $(ps | grep gmx | awk "{print $1}"); do sudo renice -20 -p $pid ; done'
