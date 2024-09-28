#!/bin/bash

check_setup_complete

update_access_level() {
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