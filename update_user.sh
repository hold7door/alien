#!/bin/bash

check_root

source ./user_utils.sh

# base inputs
USER=$(get_input "Enter username of user for whom access is to be updated")
ALLOW_SUDO_ACCESS=$(get_input "Allow sudo access(yes/no)" "no")
ACCESS_LEVEL=$(get_input "Provide access level (dev/stage/prod)" "dev")

# allow/revoke sudo access
update_user_sudo_access "$USER" "$ALLOW_SUDO_ACCESS"

# update access level
update_access_level "$USER" "$ACCESS_LEVEL"