#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    local msg=$1
    echo
    echo -e "${BLUE}==== $msg ====${NC}"
    echo
}

# Function to print logs with timestamp and color
log() {
    local color=$1
    local msg=$2
    printf "%b[%s]%b %s\n" "$color" "$(date -u +"%Y-%m-%d %H:%M:%S UTC")" "$NC" "$msg"
}

# Function to get user input
get_input() {
    local prompt=$1
    local default=$2
    local result

    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " result
        result=${result:-$default}
    else
        read -p "$prompt: " result
    fi

    while [ -z "$result" ]; do
        read -p "This field cannot be empty. $prompt: " result
    done

    echo "$result"
}

# Check if script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
       log "$RED" "This script must be run as root"
       exit 1
    fi
}


check_setup_complete() {
    groups=("dev" "stage" "prod")

    # check if all necessary groups where created
    for group in "${groups[@]}"; do
        if ! grep -q "^$group:" /etc/group; then
            log "$RED" "Setup incomplete. Group '$group' does not exist."
            log "$RED" "You need to run setup.sh first."
            exit 1
        fi
    done
}