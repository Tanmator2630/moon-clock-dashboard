# 🌙 Terminal Moon Clock Dashboard

A sleek, interactive, and completely flicker-free full-screen ASCII moon phase tracker and live clock for your terminal, built entirely in Bash. 

---

## ✨ Features
* **Zero-Flicker Architecture**: Implements pinpoint cursor positioning via `tput` to refresh only the time line, removing the harsh screen blinking caused by traditional screen-clearing loops.
* **Top-Centered Interactive HUD Menu**: An elegant, distraction-free control panel pinned to the top of your layout.
* **Native Lunar Math**: Accurately tracks and projects current moon phases directly inside the terminal based on the Unix epoch clock.
* **Responsive Layout**: Dynamically senses changes in terminal geometry to keep the artwork and metadata perfectly centered.

---

## 🎮 Keyboard Controls
The dashboard listens for real-time keypresses without disrupting the time loop:
* `t` — Toggle between **12-hour** (`11:45:00 PM`) and **24-hour** (`23:45:00`) time formats.
* `d` — Toggle the calendar **Date** display header on or off.
* `m` — Toggle **Moon Size** scaling dynamically between a massive 40-line rendering and a compact 20-line fallback.
* `q` — Safely clear the layout, restore your cursor, and **Quit**.

---

## 🚀 Installation & Usage

### 1. Install Dependencies
This dashboard leverages the `ascii_moon` binary utility to generate the structural lunar art. You can install it from the AUR using `yay`:

```
yay -S ascii_moon

# Grant execution permissions
chmod +x moon_clock.sh

# Run the dashboard
./moon_clock.sh
