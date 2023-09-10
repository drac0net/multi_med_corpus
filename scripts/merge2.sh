#!/bin/sh

walk_dir () {
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        elif [ -e "$pathname" ]; then
            case "$pathname" in
                *.txt|*.doc)
                    printf '%s\n' "$pathname"
            esac
        fi
    done
}

DOWNLOADING_DIR=/Users/richard/Downloads

walk_dir "$DOWNLOADING_DIR"