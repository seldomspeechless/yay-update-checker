# Bash/Yay (KDE) Updater

A lightweight, simple shell script designed to check for and display updates from both official Arch repositories and the AUR. Perfect for integration with KDE widgets (like custom buttons or executors) to check status at a glance and update with a single click.

---

## Features

* **Quick Checks:** Easily poll for pending updates.
* **Targeted Upgrades:** Choose between repo-only, AUR-only, or full system updates.
* **KDE Friendly:** Designed to output clean data easily parsed by desktop widgets.

## Requirements

* **Arch Linux** (or any Arch-based distribution)
* **`yay`** (AUR helper)
* **`bash`**
* **KDE Plasma** (Optional, for widget integration)

---

## Recommended KDE Setup

To display the script's output and trigger updates directly from your KDE Plasma panel or desktop, it is highly recommended to use the **[Command Output](https://github.com/Zren/plasma-applet-commandoutput)** plasma applet by Zren. 

This widget allows you to:
1. Run `./updater.sh` at regular intervals to display the number of pending updates.
2. Configure a click action to open a terminal and run the full update command.

---

## Usage

```bash
./updater.sh [flags]
