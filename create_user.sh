#!/bin/bash

check_root

source ./user_utils.sh

# base inputs
NEW_USER=$(get_input "Enter username for new user")
ALLOW_SUDO_ACCESS=$(get_input "Allow sudo access(yes/no)" "no")
ACCESS_LEVEL=$(get_input "Provide access level (dev/stage/prod)" "dev")

# ssh key input
print_header "SSH Key Setup"
echo "Enter your SSH public key (paste and press Enter, then Ctrl+D):"
SSH_PUBLIC_KEY=$(cat)
if [ -z "$SSH_PUBLIC_KEY" ]; then
    log "$RED" "No SSH key provided. Exiting."
    exit 1
fi

# create user
create_user "$NEW_USER"

# allow/revoke sudo access
update_user_sudo_access "$NEW_USER" "$ALLOW_SUDO_ACCESS"

# setup ssh key
setup_ssh_key "$NEW_USER" "$SSH_PUBLIC_KEY"

# update access level
update_access_level "$NEW_USER" "$ACCESS_LEVEL"