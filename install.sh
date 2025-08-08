#!/bin/bash

set -euo pipefail

err()
{
    local message="$1"
    echo "ERROR: $(basename "$0"): $message" 1>&2
    exit 1
}

if [ "$(whoami)" = "root" ]; then
    DEST=/usr/local/bin
else
    DEST=~/.local/bin
    [ -d $DEST ] || err "$DEST doesn't exist, aborting"
fi


PATH_TO_DIR="$(cd "$(dirname "$0")"; pwd)"

for EXECUTABLE in devcon devcon-proxy; do
    ln -sf "$PATH_TO_DIR/$EXECUTABLE" $DEST
done
