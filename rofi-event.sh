#!/usr/bin/env bash

readonly LOGFILE="$HOME/.cache/yay_update.log"

yay -Syy
mapfile -t updates < <(yay -Qu)
if (( ${#updates[@]} == 0 )); then
    notify-send -t 2500 "Your system is fully up to date!"
    exit 0
fi
updates=("None" "All" "${updates[@]}") # add extreme alternatives

selected=$(printf "%s\n" "${updates[@]}" | rofi -dmenu -p "Select an update to install:" -theme-str 'inputbar { children: [ prompt ]; }')

auto_flags=(--noconfirm --answerdiff None --answerclean None)
extreme_measures=(--mflags --skipchecksums) # unused

if [[ -z "$selected" || "$selected" == "None" ]]; then
    exit 0
elif [[ "$selected" == "All" ]]; then
    notify-send -t 2500 "Updating everything.. this can take a while."

    if yay -Syu "${auto_flags[@]}" 2>> "$LOGFILE"; then
        notify-send -t 2500 "System Update" "✓ Upgrade completed successfully!" --icon=object-select
    else
        last_err=$(tail -n 1 "$LOGFILE")
        notify-send "System Update" "❌ Upgrade failed!\nError: $last_err" --urgency=critical --icon=dialog-error
    fi
else
    read -r package current_version _ new_version <<< "$selected"
    notify-send -t 2500 "Install this specific package: $package" --icon=object-select

    if yay -S "${auto_flags[@]}" "$package" 2>> "$LOGFILE"; then
        notify-send -t 2500 "Update Successful" "Successfully installed $package" --icon=object-select
    else
        notify-send -u critical "Update Failed" "Check $LOGFILE for details" --urgency=critical --icon=dialog-error
    fi
fi
