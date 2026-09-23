#!/data/data/com.termux/files/usr/bin/bash

# Smart mpv launcher for Termux + Termux:X11 + Vulkan

set -u

# Detect an existing DISPLAY first
if [ -n "${DISPLAY:-}" ]; then
    display_socket="$TMPDIR/.X11-unix/X${DISPLAY#:}"
    if [ -S "$display_socket" ]; then
        export DISPLAY
    else
        unset DISPLAY
    fi
fi

# Automatically detect an X11 socket if DISPLAY is not valid
if [ -z "${DISPLAY:-}" ]; then
    socket=$(find "$TMPDIR/.X11-unix" -maxdepth 1 -type s -name 'X*' 2>/dev/null | sort | head -n 1)

    if [ -n "$socket" ]; then
        display_number="${socket##*X}"
        export DISPLAY=":${display_number}"
    fi
fi

# Make sure an X11 display was found
if [ -z "${DISPLAY:-}" ]; then
    echo "Error: Termux:X11 display not found."
    echo
    echo "Start Termux:X11 and try again."
    echo "Check with:"
    echo "  ls -l \$TMPDIR/.X11-unix/"
    exit 1
fi

# Require a filename/search term
if [ $# -eq 0 ]; then
    echo "Usage: mpvx <filename>"
    echo
    echo "Example:"
    echo "  mpvx Video_720p.mp4"
    exit 1
fi

query="$*"

# Search common Android storage locations
search_dirs=(
    "$HOME/storage/shared/Video"
    "$HOME/storage/shared/Movies"
    "$HOME/storage/shared/Download"
    "$HOME/storage/movies"
    "$HOME/storage/downloads"
    "$HOME/storage/dcim"
)

for dir in "${search_dirs[@]}"; do
    [ -d "$dir" ] || continue

    file=$(find "$dir" -type f -iname "*$query*" 2>/dev/null | head -n 1)

    if [ -n "$file" ]; then
        echo "Display : $DISPLAY"
        echo "Found   : $file"
        echo "Player  : mpv + Vulkan"

        exec mpv --vo=gpu --gpu-api=vulkan "$file"
    fi
done

echo "Video not found: $query"
echo
echo "Searched:"
for dir in "${search_dirs[@]}"; do
    [ -d "$dir" ] && echo "  $dir"
done

exit 1
