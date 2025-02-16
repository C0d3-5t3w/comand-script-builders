#!/bin/bash

# check if user is root

if [ "$(id -u)" != "0" ]; then
    echo "Error: Run as root."
    exit 1
fi

# Prompt user for input and edit promt 1, 2, 3 with your own text

read -p "Prompt 1: " -r "CALL"

read -p "Prompt 2: " -r "CALL2"

read -p "Prompt 3: " -r "CALL3"

# Execute command with user input replace 'echo' with command and add options between $CALL's

echo "$CALL" "$CALL2" "$CALL3"

exit 0

# End of script