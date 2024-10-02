
#!/bin/bash

source ./base.sh

check_setup_complete

print_header "ALIEN"

echo "Enter your choice (1-3)"
echo "1) Create user"
echo "2) Update user"
echo "3) Delete user"

CHOICE=$(get_input "Enter your choice (1-3)")

case $CHOICE in
    1)
        source ./create_user.sh
        ;;
    2)
        source ./update_user.sh
        ;;
    3)
        source ./delete_user.sh
        ;;
    *)
        log "$RED" "Invalid choice. Exiting."
        exit 1
        ;;
esac
