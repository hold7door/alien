#!/bin/bash

create_user(){
    log "$GREEN" "Creating new user $NEW_USER..."
    local usr=$1
    adduser --gecos '' --disabled-password "$usr"
    log "$GREEN" "User created..."
}

update_user_sudo_access() {
    local usr=$1
    local sudo_access=$2

    log "$GREEN" "Updating sudo access..."
    if [ "$ALLOW_SUDO_ACCESS" = "yes" ]; then
        log "$GREEN" "Granting sudo access to $usr..."
    else
        log "$GREEN" "Sudo access revoked for $usr..."
    fi

    if [ "$sudo_access" = "yes" ]; then
        usermod -aG sudo "$usr"
        # Allow sudo without password
        echo "$usr ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$usr"
        chmod 0440 "/etc/sudoers.d/$usr"
    elif [ "$sudo_access" = "no" ]; then
        log "$GREEN" "Removing sudoers file for $usr..."
        rm -f "/etc/sudoers.d/$usr"
    else 
        log "$RED" "Invalid input. Exiting..."
        exit 1
    fi
    log "$GREEN" "Sudo access updated..."

}

setup_ssh_key() {
    log "$GREEN" "Setting up SSH..."
    local usr=$1
    local key_content=$2

    mkdir -p "/home/$usr/.ssh"
    echo "$key_content" > "/home/$usr/.ssh/authorised_keys"
    
    chown -R "$usr:$usr" "/home/$usr/.ssh"
    chmod 700 "/home/$usr/.ssh"
    chmod 600 "/home/$usr/.ssh/authorised_keys"
    log "$GREEN" "SSH key setup for new user $usr..."
}

update_access_level() {
    
    log "$GREEN" "Assigning access level $ACCESS_LEVEL to $NEW_USER..."
    local user=$1
    local access_level=$2

    # TODO: Additional security checks to limit it to 
    # TODO: external users only

    if [ "$access_level" = "dev" ]; then
        usermod -G "dev" "$user"
    elif [ "$access_level" = "stage" ]; then
        usermod -G "dev,stage" "$user"
    elif [ "$access_level" = "prod" ]; then
        usermod -G "dev,stage,prod" "$user"
    else
        log "$RED" "Invalid access level provided. Exiting.."  
    fi
}

delete_user() {
    log "$GREEN" "Deleting user $1..."
    local usr=$1

    if id "$usr" &>/dev/null; then
        log "$GREEN" "User $usr exists. Proceeding to delete..."

        # Remove the user and their home directory
        deluser --remove-home "$usr"

        # Optionally, remove sudo privileges if a sudoers file exists
        if [ -f "/etc/sudoers.d/$usr" ]; then
            log "$GREEN" "Removing sudoers file for $usr..."
            rm -f "/etc/sudoers.d/$usr"
        fi

        log "$GREEN" "User $usr deleted successfully."
    else
        log "$RED" "User $usr does not exist."
    fi
}
