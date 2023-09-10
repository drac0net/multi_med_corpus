#!/bin/sh

walk_dir () {
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        elif [ -e "$pathname" ]; then
            case "$pathname" in
                *.flac|*.mp3)
                    sox "$pathname" "$pathname.wav"
            esac
        fi
    done
}

DOWNLOADING_DIR=/workspace/nemo/TFM/LibriSpeech/dev-other

walk_dir "$DOWNLOADING_DIR"