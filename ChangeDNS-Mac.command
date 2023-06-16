#!/bin/bash

# Get the list of network services
IFS=$'\n' read -d '' -r -a network_services < <(networksetup -listallnetworkservices)

# Prompt the user to choose a network service
echo "Available network services:"
for ((i=0; i<${#network_services[@]}; i++)); do
    echo "$(($i+1)). ${network_services[$i]}"
done
read -p "Enter the number corresponding to the network service: " choice

# Validate the user's choice
if [[ $choice =~ ^[1-9][0-9]*$ && $choice -le ${#network_services[@]} ]]; then
    networkservice=${network_services[$(($choice-1))]}
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Prompt the user to choose an option
echo "DNS options:"
echo "1. Set Shecan DNS"
echo "2. Set Custom DNS"
echo "3. Clear DNS"
read -p "Enter your choice (1, 2, or 3): " dns_choice

# Set the DNS based on the user's choice
case $dns_choice in
    1)
        dns_servers=("178.22.122.100" "185.51.200.2")
        networksetup -setdnsservers "$networkservice" "${dns_servers[@]}"
        ;;
    2)
        read -p "Enter the DNS servers separated by spaces: " -a dns_servers
        networksetup -setdnsservers "$networkservice" "${dns_servers[@]}"
        ;;
    3)
        dns_servers=()
        networksetup -setdnsservers "$networkservice" empty
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac


echo "DNS settings changed successfully."

