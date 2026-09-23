#!/data/data/com.termux/files/usr/bin/bash

# Smart mpv launcher for Termux + Termux:X11 + Vulkan

# Detect Termux:X11 display
if [ -z "${DISPLAY:-}" ]; then
    socket=$(find "$TMPDIR/.X11-unix" -maxdepth 1 -type s -name "X*" 2>/dev/null | sort | head -n 1)
    if [ -n "$socket" ]; then
        export DISPLAY=":${socket##*X}"
    fi
fi

if [ -z "${DISPLAY:-}" ]; then
    echo "Error: Termux:X11 display not found."
    echo "Start Termux:X11 and try again."
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Usage: mpvx <filename>"
    exit 1
fi

query="$*"
ANDROID_STORAGE="/storage/emulated/0"

file=$(find "$ANDROID_STORAGE" -type f -iname "*$query*" 2>/dev/null | head -n 1)

if [ -n "$file" ]; then
    echo "Display : $DISPLAY"
    echo "Found   : $file"
    echo "Player  : mpv + Vulkan"
    exec mpv --vo=gpu --gpu-api=vulkan "$file"
fi

echo "Video not found: $query"
echo "Searched: $ANDROID_STORAGE"
exit 1
