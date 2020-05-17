# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=
# Functions
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=

# Extract files
ex() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xvjf $1 ;;
            *.tar.gz) tar xvzf $1 ;;
            *.tar.xz) tar xvJf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xvf $1 ;;
            *.tbz2) tar xvjf $1 ;;
            *.tgz) tar xvzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *.xz) unxz $1 ;;
            *.exe) cabextract $1 ;;
            *) echo "\`$1': unrecognized file compression" ;;
        esac
    else
        echo "\`$1' is not a valid file"
    fi
}


# Colored Man Pages
man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

# fo - fuzzy open/edit - CTRL-O to open, CTRL-E or Enter to open with $EDITOR
fo() {
    local out file key
    out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
    key=$(head -1 <<< "$out")
    file=$(head -2 <<< "$out" | tail -1)
    if [ -n "$file" ]; then
        [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
    fi
}

# fh - fuzzy repeat history
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fkill - fuzzy kill process
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]
    then
        kill -${1:-9} $pid
    fi
}

# fd - fuzzy cd
fd() {
    local dir
    dir=$(find ~ -type d -path "*/\.*" -prune -o -print 2> /dev/null | fzf +m)
    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

# fd - fuzzy cd (+ hidden)
fdh() {
    local dir
    dir=$(find ~ -type d -o -print 2> /dev/null | fzf +m)
    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}

# fdr - cd to selected parent directory
fdr() {
    local declare dirs=()
    get_parent_dirs() {
        if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
        if [[ "${1}" == '/' ]]; then
            for _dir in "${dirs[@]}"; do echo $_dir; done
        else
            get_parent_dirs $(dirname "$1")
        fi
    }
    local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
    cd "$DIR"
}

# fe - fuzzy file edit
fe() {
    local file
    file=$(find ~ -type f -path "*/\.*" -prune -o -print 2> /dev/null | fzf +m)
    if [ -n "$file" ]; then
        vi "$file"
    fi
}

# fe - fuzzy file edit (+ hidden)
feh() {
    local file
    file=$(find ~ -type f 2> /dev/null | fzf)
    if [ -n "$file" ]; then
        vi "$file"
    fi
}

# Change dir when exiting ranger
rcd() {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# mkdir and cd in one
mc() {
    mkdir -p $1
    cd $1
}

# cd, regardless of dir or file
goto() { [[ -d "$1" ]] && cd "$1" || cd "$(dirname "$1")"; }

# lookup word
dict() { curl -s dict://dict.org/d:${1}:wn | sed '/^[0-9]/d'; }