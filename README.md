# FPSPing

A simple World of Warcraft 1.12 addon that displays FPS and latency (MS).

## Features

- Real-time FPS and ping display
- Color-coded values
- Movable frame
- Vertical or horizontal layout
- Saved position and settings
- Lightweight and 1.12 compatible

## Installation

1. Copy the addon folder to:
   World of Warcraft/Interface/AddOns/FPSPing
2. Restart the game or run:
   /reload

## Usage

- Drag with left mouse button to move the frame
- Right-click to toggle layout
- Use this command to reset position: /fpsreset

## Color Rules

### FPS
- 0 to 30: red
- 31 to 45: orange
- 46 to 59: yellow
- 60 to 75: white
- 76 and above: green

### Latency (MS)
- 0 to 60: green
- 61 to 90: white
- 91 to 120: yellow
- 121 to 150: orange
- 151 and above: red

## Saved Variables

Stored in `FPSPingDB`:

- `position`
- `scale` (default 1.0)
- `layout` ("vertical" or "horizontal")

## Notes

- Uses `GetFramerate()` and `GetNetStats()`
- Updates FPS every 1 second
- Updates latency every 5 seconds
- Uses `OnUpdate` for compatibility with 1.12
- Relies on legacy globals like `this` and `arg1`

## License

Free to use and modify
