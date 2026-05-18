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

if [[ $1 == "-c" || $1 == "--check" ]]; then
    check
elif [[ $1 == "-u" || $1 == "--update" ]]; then
    if [[ "$2" == "--repo-only" ]]; then
        update "--repo"
    elif [[ "$2" == "--aur-only" ]]; then
        update "--aur"
    else
        update
    fi
else
    help
fi
