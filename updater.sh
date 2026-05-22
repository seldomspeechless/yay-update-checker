#!/usr/bin/env bash

readonly VERSION="0.30"
readonly LOGFILE="$HOME/.cache/yay_update.log"
if [ -t 1 ]; then # terminal is interactive (not file or pipe)
    BOLD=$(tput bold); RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RESET=$(tput sgr0)
else
    BOLD=""; RED=""; GREEN=""; RESET=""
fi

help() {
    local desc="Bash/Yay(KDE) Updater $VERSION\nSimple shellscript for checking/displaying updates provided thru AUR and upon click updating!\n"
    local flags="${BOLD}Usage: $0 [flags]${RESET}\n"
    flags+="-c|--check\tCheck for updates?\n"
    flags+="-h|--help\tShow this help.\n"
    flags+="-u|--update\tUpdate!\n"
    flags+="\nSpecial arguements:\n"
    flags+="--repo-only\tUpdate to core-repos\n"
    flags+="--aur-only\tUpdate only AUR-repos"

    printf "$desc\n$flags\n"
}

check() { # Periodicly run
    updates_found=$( (checkupdates; yay -Qua) | wc -l )
    case "$updates_found" in
        0) output="" ;;
        1) output="1 update" ;;
        *) output="$updates_found updates" ;;
    esac

    if [[ -n $output ]]; then
        if [[ $updates_found > 250 ]]; then
            echo -n ${RED}
        elif [[ $updates_found > 100 ]]; then
            echo -n ${YELLOW}
        fi
        echo $output ${RESET}
    fi
}

update() { # Run upon trigger/click
    local auto_flags=(--noconfirm --answerdiff None --answerclean None) #--overwrite="*" --ask 4

    if [[ -z $1 ]]; then #echo "Install ALL"
        if yay -Syu "${auto_flags[@]}" 2>> "$LOGFILE"; then
            notify-send -t 2500 "System Update" "✓ Upgrade completed successfully!" --icon=object-select
        else
            local last_err=$(tail -n 1 "$LOGFILE")
            notify-send "System Update" "❌ Upgrade failed!\nError: $last_err" --urgency=critical --icon=dialog-error
        fi
    else #echo "Install with custom flags: $1"
        if yay -Syu --answerdiff None --answerclean None "$@" 2>> "$LOGFILE"; then
            notify-send -t 2500 "System Update" "✓ Custom upgrade completed!" --icon=object-select
        else
            local last_err=$(tail -n 1 "$LOGFILE")
            notify-send "System Update" "❌ Custom upgrade failed!\nError: $last_err" --urgency=critical --icon=dialog-error
        fi
    fi
}

RUN_CHECK=false
RUN_UPDATE=false
UPDATE_TYPE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -c|--check)     RUN_CHECK=true;                     shift ;;
        -u|--update)    RUN_UPDATE=true;                    shift ;;
        --repo-only)    UPDATE_TYPE="--repo";               shift ;;
        --aur-only)     UPDATE_TYPE="--aur";                shift ;;
        -h|--help)      help;                               exit 0 ;;
        *)              echo "Unknown argument: $1"; help;  exit 1 ;;
    esac
done

if [ "$RUN_CHECK" = true ]; then
    check
elif [ "$RUN_UPDATE" = true ]; then
    update $UPDATE_TYPE
else
    help
fi
