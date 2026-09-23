# Termux Android GPU Setup

A practical documentation project for running Linux multimedia applications on Android using Termux, Termux:X11, Mesa, Zink, Turnip and Vulkan.

This repository records a working configuration tested on an Android device with a Qualcomm Adreno 650 GPU.

## Architecture

The graphics path tested in this project is:

1. Android
2. Termux
3. Termux:X11
4. Mesa
5. Zink
6. Vulkan
7. Mesa Turnip
8. Qualcomm Adreno 650 GPU
9. mpv

For OpenGL applications, Zink provides an OpenGL implementation on top of Vulkan. mpv can use Vulkan directly for video rendering.

## Tested Environment

| Component | Tested configuration |
|---|---|
| Platform | Android |
| Terminal | Termux |
| Display | Termux:X11 |
| Graphics | Mesa |
| OpenGL implementation | Zink |
| Vulkan driver | Mesa Turnip |
| GPU | Qualcomm Adreno 650 |
| Vulkan | 1.3 |
| Media player | mpv |

## GPU Verification

Run:



The tested configuration reported a renderer similar to:



This indicates that OpenGL is being provided through Zink using Vulkan and the Mesa Turnip driver.

## Check X11 Display

Run:



In the tested setup the X11 socket was , so the display was:



The display number can be different on other installations.

## mpv Vulkan Playback

The tested hardware-accelerated command is:



mpv detected the hardware GPU:



A software  device may also appear. The Turnip device is the hardware GPU path.

## Smart mpvx Launcher

This repository includes .

The script searches common Android storage locations and launches mpv using Vulkan GPU acceleration.

Example:



Install it into the Termux PATH:



Then use:



## Android Storage

After running:



Android shared storage is normally available through:



For example, Android  is normally accessible as:



## Graphics Pipeline

OpenGL applications using Zink follow this general path:



mpv Vulkan playback follows:



## Troubleshooting

### mpv uses llvmpipe

Check OpenGL:



Check Vulkan:



Make sure the Turnip GPU is detected.

### Check X11



If the socket is :



### Test mpv directly



### Legacy X11 fallback



This uses mpv's legacy X11 video output rather than the Vulkan GPU path.

## Important Notes

This repository documents one tested Android/Termux configuration.

Hardware, Android versions, Termux:X11 versions, Mesa versions and GPU drivers can behave differently on other devices.

The X11 display number is not guaranteed to be .

Do not upload API keys, passwords, private keys, authentication tokens, personal videos, large model files or private documents.

## Project Status

Tested:

- Termux
- Termux:X11
- Mesa
- Zink
- Turnip
- Vulkan 1.3
- Adreno 650
- mpv Vulkan playback
- Smart Usage: mpvx <filename> launcher

## License

MIT License
