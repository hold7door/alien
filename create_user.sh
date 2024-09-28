#!/bin/bash

check_root

source ./access_level.sh

NEW_USER=$(get_input "Enter username for new user")
ALLOW_SUDO_ACCESS=$(get_input "Allow sudo access(yes/no)" "no")
ACCESS_LEVEL=$(get_input "Provide access level (dev/stage/prod)" "dev")

print_header "SSH Key Setup"

echo "Enter your SSH public key (paste and press Enter, then Ctrl+D):"

SSH_PUBLIC_KEY=$(cat)

if [ -z "$SSH_PUBLIC_KEY" ]; then
    log "$RED" "No SSH key provided. Exiting."
    exit 1
fi

log "$GREEN" "Creating new user $NEW_USER..."

adduser --gecos '' --disabled-password "$NEW_USER"

if [ "$ALLOW_SUDO_ACCESS" = "yes" ]; then
    log "$GREEN" "Granting sudo access to $NEW_USER..."

    usermod -aG sudo "$NEW_USER"
    # Allow sudo without password
    echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$NEW_USER"
    chmod 0440 "/etc/sudoers.d/$NEW_USER"

fi

setup_ssh_key() {
    local key_content=$1

    mkdir -p "/home/$NEW_USER/.ssh"
    echo "$key_content" > "/home/$NEW_USER/.ssh/authorised_keys"
    
    chown -R "$NEW_USER:$NEW_USER" "/home/$NEW_USER/.ssh"
    chmod 700 "/home/$NEW_USER/.ssh"
    chmod 600 "/home/$NEW_USER/.ssh/authorised_keys"

    log "$GREEN" "SSH key setup for new user $NEW_USER"
}

setup_ssh_key "$SSH_PUBLIC_KEY"


log "$GREEN" "Assigning access level $ACCESS_LEVEL to $NEW_USER..."

update_access_level "$NEW_USER" "$ACCESS_LEVEL"

log "$GREEN" "User created"