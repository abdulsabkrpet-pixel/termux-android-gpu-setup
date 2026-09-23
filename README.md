# Termux Android GPU Setup

A documented setup for using Android GPU acceleration from Termux with Termux:X11, Mesa, Zink, Vulkan, Mesa Turnip, and mpv.

This project was tested on an Android device using a Qualcomm Adreno 650 GPU.

## Architecture

The tested graphics stack is:

1. Android
2. Termux
3. Termux:X11
4. Mesa
5. Zink
6. Vulkan
7. Mesa Turnip
8. Qualcomm Adreno 650 GPU
9. mpv

For OpenGL applications, Zink provides OpenGL on top of Vulkan. mpv can use Vulkan directly for video rendering.

## Tested Environment

| Component | Tested configuration |
|---|---|
| Platform | Android |
| Terminal | Termux |
| Display | Termux:X11 |
| Graphics stack | Mesa |
| OpenGL implementation | Zink |
| Vulkan driver | Mesa Turnip |
| GPU | Qualcomm Adreno 650 |
| Vulkan | 1.3 |
| Media player | mpv |

## GPU Verification

The OpenGL renderer was verified with:

```bash
glxinfo -B
```

Expected renderer:

```text
OpenGL renderer string: zink Vulkan 1.3(Turnip Adreno (TM) 650 (MESA_TURNIP))
```

This confirms the OpenGL path:

```text
OpenGL → Zink → Vulkan → Mesa Turnip → Adreno 650
```

## Termux:X11 Display

The tested Termux:X11 socket was:

```text
$TMPDIR/.X11-unix/X1
```

Therefore the active display was:

```text
:1
```

You can check the display with:

```bash
echo "$DISPLAY"
```

## Vulkan Verification

Check available Vulkan devices with:

```bash
vulkaninfo
```

The tested hardware device was:

```text
Turnip Adreno (TM) 650
```

The system may also report `llvmpipe`. That is a software Vulkan renderer and does not mean that Turnip is unavailable.

## mpv Vulkan Playback

Direct Vulkan playback was tested with:

```bash
mpv --vo=gpu --gpu-api=vulkan "/storage/emulated/0/Movies.webm"
```

The successful mpv output included:

```text
GPU 0: Turnip Adreno (TM) 650 v1.3.354 (integrated)
GPU 1: llvmpipe (LLVM 21.1.8, 128 bits) v1.4.354 (software)
VO: [gpu] 720x1280 yuv420p
```

This confirms that mpv initialized Vulkan and detected the Adreno 650 through Mesa Turnip.

## Smart `mpvx` Launcher

This repository includes `mpvx.sh`.

The launcher:

- Detects the Termux:X11 display.
- Searches Android shared storage.
- Finds a video using a search term.
- Starts mpv with Vulkan rendering.
- Uses Mesa Turnip when available.

Example:

```bash
./mpvx.sh "Movies.webm"
```

Example successful configuration:

```text
Display : :1
Found   : /storage/emulated/0/Movies.webm
Player  : mpv + Vulkan
```

The playback path is:

```text
mpvx.sh → mpv → Vulkan → Mesa Turnip → Adreno 650
```

## Installing `mpvx`

Make the script executable:

```bash
chmod +x mpvx.sh
```

Run it from the repository:

```bash
./mpvx.sh "video-name"
```

If you later install it into the Termux executable path, it can be run as:

```bash
mpvx "video-name"
```

## Android Storage

Android shared storage is available directly at:

```text
/storage/emulated/0
```

For example:

```text
/storage/emulated/0/Movies.webm
/storage/emulated/0/Movies.mp4
```

The launcher searches this location.

If storage access has not been enabled, run:

```bash
termux-setup-storage
```

Then allow Termux to access your files.

## Useful Verification Commands

Check OpenGL:

```bash
glxinfo -B
```

Check Vulkan:

```bash
vulkaninfo
```

Check mpv:

```bash
mpv --version
```

Check available mpv video outputs:

```bash
mpv --vo=help
```

Check the X11 display:

```bash
echo "$DISPLAY"
```

Test Vulkan playback:

```bash
mpv --vo=gpu --gpu-api=vulkan "/storage/emulated/0/Movies.webm"
```

## Troubleshooting

### mpv cannot connect to X11

Start Termux:X11 and check:

```bash
echo "$DISPLAY"
```

The tested configuration used:

```text
:1
```

### mpv uses software rendering

Check Vulkan devices:

```bash
vulkaninfo
```

Look for:

```text
Turnip Adreno (TM) 650
```

Also check mpv output for:

```text
GPU 0: Turnip Adreno (TM) 650
```

If `llvmpipe` is listed, remember that it is a software renderer. Its presence alone does not indicate that Turnip failed.

### `mpvx.sh` cannot find a video

Check the actual Android storage path:

```bash
find /storage/emulated/0 -type f -iname "*.mp4" 2>/dev/null | head
```

Then test mpv directly with the returned path.

### Termux storage permission

Run:

```bash
termux-setup-storage
```

and grant the requested Android permission.

## Verified Working Configuration

The following configuration was successfully tested on the target Android device:

- Termux:X11 display detected as `:1`
- Android shared storage detected at `/storage/emulated/0`
- `mpvx.sh` successfully located and played `Movies.webm`
- mpv successfully initialized Vulkan rendering
- Mesa Turnip detected the Qualcomm Adreno 650 GPU
- Detected GPU: `Turnip Adreno (TM) 650 v1.3.354`
- Video output: `VO: [gpu] 720x1280 yuv420p`
- Audio output: OpenSL ES, 48 kHz stereo

This is a documented test result from the author's Android/Termux environment. Results may differ on other devices, Android versions, Termux versions, and Mesa/Turnip versions.

## Important Notes

- GPU support depends on the Android device and its GPU driver.
- Qualcomm Adreno devices may use Mesa Turnip for Vulkan.
- Zink is useful for OpenGL applications that need to run through Vulkan.
- mpv can bypass the OpenGL/Zink path and use Vulkan directly.
- `llvmpipe` is a software renderer and is useful as a fallback, but it does not provide hardware GPU acceleration.
- Commands and package names can change between Termux and Mesa releases.

## Project Status

The setup documented in this repository has been tested on the author's Android device with a Qualcomm Adreno 650 GPU.

The current focus of the project is:

- Termux GPU acceleration
- Termux:X11
- Mesa and Zink
- Vulkan and Mesa Turnip
- mpv Vulkan playback
- Simple video playback automation with `mpvx.sh`

## License

This project is intended to be released under the MIT License.
