#!/bin/bash

# check if user is root
# remove if not needed

if [ "$(id -u)" != "0" ]; then
    echo "Error: Run as root."
    exit 1
fi

# edit promt 1, 2, 3 with your own command option requirements

read -p "Prompt 1: " -r "CALL"

read -p "Prompt 2: " -r "CALL2"

read -p "Prompt 3: " -r "CALL3"

# Execute command with user input replace 'echo' with command and add options between $CALL's

echo "$CALL" "$CALL2" "$CALL3"

exit 0

# End of script

# EXAMPLE!
#
# if [ "$EUID" -ne 0 ]
#   then echo "Please run as root"
#   exit
# fi
#
# read -p "Enter Bluetooth device MAC (e.g., A1:11:1B:C1:D1:E1): " -r BT_DEVICE
# read -p "Enter phone connection name (e.g., 5T3W): " -r CONNECTION_NAME
# read -p "Enter static ip (e.g., 172.20.10.6 for ios 192.168.44.1 for andriod): " -r STATIC_IP
# read -p "Enter gateway (e.g., 255.255.255.0): " -r GATEWAY_IP
#
# nmcli connection modify "$CONNECTION_NAME Network" connection.autoconnect "yes" connection.type "bluetooth" bluetooth.type "panu" bluetooth.bdaddr "$BT_DEVICE" ipv4.method "manual" ipv4.dns "8.8.8.8" ipv4.addresses "$STATIC_IP/24" ipv4.gateway "$GATEWAY_IP" ipv4.route-metric "100"
