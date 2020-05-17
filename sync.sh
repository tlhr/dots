#!/bin/sh

BASEDIR=$(dirname "$0")
SCRIPTNAME=$(basename "$0")
OLDDIR=$(pwd)
TARGET="$HOME"
BACKUPDIR="$HOME/.dots.bck/"

_link ()
{
    for file in $(ls -A "$1"); do
        [[ ! -d "$TARGET/$1" ]] && mkdir -p "$TARGET/$1"
        link="$TARGET/$1/$file" 
        if [[ -d "$1/$file" ]]; then
            mkdir -p "$link"
            _link "$1/$file"
        else
            if [[ "$file" != "$SCRIPTNAME" ]]; then
                if [[ -L "$link" ]]; then
                    ln -fs "$(pwd)/$1/$file" "$TARGET/$1"
                    echo "Linking: $(pwd)/$1/$file to $TARGET/$1"
                elif [[ -f "$link" ]]; then
                    [[ ! -d "$BACKUPDIR" ]] && mkdir -p "$BACKUPDIR"
                    mv "$link" "$BACKUPDIR"
                    echo "Backed up $link to $BACKUPDIR"
                    ln -s "$(pwd)/$1/$file" "$TARGET/$1"
                    echo "Linking: $(pwd)/$1/$file to $TARGET/$1"
                else
                    ln -s "$(pwd)/$1/$file" "$TARGET/$1"
                    echo "Linking: $(pwd)/$1/$file to $TARGET/$1"
                fi
            fi
        fi
    done
}

cd "$BASEDIR"
[[ ! -e "$TARGET" ]] && mkdir "$TARGET"
_link .
cd "$OLDDIR"
