#!/usr/bin/env bash

readonly VERSION="0.23"

help() {
    local desc="Bash/Yay(KDE) Updater $VERSION\nSimple shellscript for checking/displaying updates provided thru AUR and upon click updating!\n"
    local flags="Usage: $0 [flags]\n"
    flags+="-c|--check\tCheck for updates?\n"
    flags+="-h|--help\tShow this help.\n"
    flags+="-u|--update\tUpdate!\n"
    flags+="\nSpecial arguements:\n"
    flags+="--repo-only\tUpdate to core-repos\n"
    flags+="--aur-only\tUpdate only AUR-repos"

    printf "$desc\n$flags\n"
}

check() {
    # Periodicly run
    updates_found=$(yay -Qu | wc -l)
    case "$updates_found" in
        0) output="" ;;
        1) output="1 update" ;;
        *) output="$updates_found updates" ;;
    esac

    if [[ -n $output ]]; then
        echo $output
    fi
}

update() {
    # Run on click-events; takes 1 arguement for limiting installs
    if [[ -z $1 ]]; then
        #echo "Install ALL"
        yes | yay -Syu
    else
        #echo "Install with custom flags: $1"
        yay -Squ $1
    fi
}

# Initialize our control variables as false
RUN_CHECK=false
RUN_UPDATE=false
UPDATE_TYPE=""

# Loop through all arguments provided to the script
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
    # Default fallback if they ran the script with no arguments at all
    help
fi
