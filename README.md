# Termux Android GPU Setup

A practical record of running Linux multimedia and GPU-accelerated applications on Android using Termux.

## Tested Environment

- Android
- Termux
- Termux:X11
- Mesa
- Zink
- Mesa Turnip
- Vulkan 1.3
- Adreno 650
- mpv

## GPU Verification

```bash
glxinfo -B
zink Vulkan 1.3
Turnip Adreno (TM) 650 (MESA_TURNIP)

export DISPLAY=:1
mpv --vo=gpu --gpu-api=vulkan "video.mp4"
ls -l $TMPDIR/.X11-unix/
X1
export DISPLAY=:1

### 2. Create the `mpvx` script

```bash
cat > mpvx.sh <<'EOF'
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
