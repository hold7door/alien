#!/bin/bash

check_root

source ./user_utils.sh

# base inputs
USER=$(get_input "Enter username of user to delete")

delete_user "$USER"