#!/bin/bash

source ./base.sh

print_header "ALIEN SETUP"

check_root

# TODO: Assess if we need it, if not remove
# ROOT_USER=$(get_input "What is the name of the root user ? We will assign ownership of ssh files to this user" "ubuntu")

groups=("dev" "stage" "prod")

mkdir -p /etc/alien_ssh
chown "root:root" "/etc/alien_ssh"

# create groups and ssh key file for each group
for group in "${groups[@]}"; do
    if ! grep -q "^$group:" /etc/group; then
        groupadd "$group"
    fi

    echo "Enter SSH private key for servers in '$group' access level (paste and press Enter, then Ctrl+D):"

    priv_key=$(cat)

    if [ -z "$priv_key" ]; then
        echo "SSH key for '$group' cannot be empty"
        exit 1
    fi
    
    echo "$priv_key" > "/etc/alien_ssh/$group"
    chown "root:$group" "/etc/alien_ssh/$group"
    chmod 640 "/etc/alien_ssh/$group"

done

log "$GREEN" "Setup complete"