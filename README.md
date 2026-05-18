# Bash/Yay (KDE) Updater

A lightweight, simple shell script designed to check for and display updates from both official Arch repositories and the AUR. Perfect for integration with KDE widgets (like custom buttons or executors) to check status at a glance and update with a single click.

---

## Features

*   **Quick Checks:** Easily poll for pending updates.
*   **Targeted Upgrades:** Choose between repo-only, AUR-only, or full system updates.
*   **KDE Friendly:** Designed to output clean data easily parsed by desktop widgets.

## Requirements

*   **Arch Linux** (or any Arch-based distribution)
*   `yay` (AUR helper)
*   `bash`
*   KDE Plasma (Optional, for widget integration)

---

## Usage

```bash
./updater.sh [flags]
