#             __
#    ___ ___ / /
#   /_ /(_-</ _ \
#   /__/___/_//_/
#
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

setopt autocd
setopt autopushd
setopt pushdignoredups
setopt cdablevars
setopt chaselinks
setopt pushdsilent
setopt alwaystoend
setopt globcomplete
setopt braceccl
setopt equals
setopt markdirs
setopt autocontinue
setopt checkjobs
setopt nomatch
setopt extendedglob
setopt shwordsplit
setopt completeinword
setopt completealiases
setopt promptsubst
setopt appendhistory
setopt histignoredups
setopt sharehistory

# SSH/SCP autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order \
       'hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns \
       '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns \
       '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' \
       '127.0.0.<->' \
       '255.255.255.255' \
       '::1' 'fe80::*'
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts \
       'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%% [# ]*}//,/ })'

# Menu
zstyle ':completion:*' menu select

# Case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Partial completion
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Privileged completion
zstyle ':completion::complete:*' gain-privileges 1

# Ignore CVS stuff
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Fuzzy matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Ignore non-existent functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# Find newly installed executables
zstyle ':completion:*' rehash true

# Ignore ../ when cd-ing
zstyle ':completion:*:cd:*' ignore-parents parent pwd

autoload -Uz compinit && compinit -i
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
autoload -U colors && colors

add-zsh-hook chpwd chpwd_recent_dirs

# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Misc
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

export HISTFILE=~/.histfile
export HISTSIZE=1000000
export SAVEHIST=1000000
export FZF_COMPLETION_TRIGGER=''
export EDITOR=vi

# Fix manpages
export MANPATH=

# FZF
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    bindkey '^T' fzf-completion
    bindkey '^I' $fzf_default_completion
fi

# Syntax highlighting
[ -f "$HIGHLIGHTING" ] && source "$HIGHLIGHTING"

# Prompt, git might not be installed
if [[ $(command -v __git_ps1) ]]; then
    PS1='%F{cyan}$(__git_ps1 "%s ")%f%B%F{black}%(?.%F{black}.%F{red})λ%b%f '
else
    PS1='%F{cyan}%f%B%F{black}%(?.%F{black}.%F{red})λ%b%f '
fi
RPS1="%F{brightblack}%~%f"

# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Functions
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

[ -f ~/.functions.sh ] && source ~/.functions.sh

# Don't drink and dd
protect_my_sda() {
  for p in "${@}"; do
    lsblk -lpn | grep -q "^${p#*=} " &&
    { echo "Not that one, you idiot!"
      return; }
  done
  dd $@
}

# Run a Jupyter notebook from cmdline
ipy() {
    jupyter notebook --browser=chrome "$1" &> /dev/null &
}

# emacsclient wrapper
e() {
    osascript -e 'tell application "Emacs" to activate'
    emacsclient -a "vi" -n "$@"
}

# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Aliases
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

[ -f ~/.aliases.sh ] && source ~/.aliases.sh

alias dd='protect_my_sda'
alias szsh='source ~/.zshrc'

alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."

alias -s txt=vi
alias -s dat=vi
alias -s mdp=vi
alias -s cpp=vi
alias -s md=vi

# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Keybindings
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

bindkey -e

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/thomas/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/thomas/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/thomas/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/thomas/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<