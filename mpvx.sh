#!/data/data/com.termux/files/usr/bin/bash

export DISPLAY=:1

if [ $# -eq 0 ]; then
    echo "Usage: mpvx <filename>"
    exit 1
fi

q="$*"

for dir in \
    "$HOME/storage/shared/Video" \
    "$HOME/storage/movies" \
    "$HOME/storage/downloads" \
    "$HOME/storage/dcim" \
    "$HOME/storage/shared/Movies" \
    "$HOME/storage/shared/Download"
do
    [ -d "$dir" ] || continue

    file=$(find "$dir" -type f -iname "*$q*" 2>/dev/null | head -n 1)

    if [ -n "$file" ]; then
        echo "▶ Found: $file"
        mpv --vo=gpu --gpu-api=vulkan "$file"
        exit $?
    fi
done

echo "❌ Video not found: $q"
exit 1
