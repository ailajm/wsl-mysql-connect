#!/bin/bash

# This is a script to programmatically fetch the IP address of the active interface (Ethernet/Wireless), plug it into the command to connect to the mysql instance hosted there, and login.  Specifically in the case of a MySql server being hosted on the Windows host of an Ubuntu instance running in WSL.  Author: Coty McKinney 

# Get the IP address of the Ethernet or Wi-Fi network adapter on the Windows host
win_eth_ip_address=$(powershell.exe -Command "(Get-NetIPAddress -InterfaceAlias 'Ethernet' -AddressFamily IPv4 | Select-Object -First 1).IPAddress")
win_wifi_ip_address=$(powershell.exe -Command "(Get-NetIPAddress -InterfaceAlias 'Wi-Fi' -AddressFamily IPv4 | Select-Object -First 1).IPAddress")

# Remove any carriage return characters
win_eth_ip_address=$(echo "$win_eth_ip_address" | tr -d '\r')
win_wifi_ip_address=$(echo "$win_wifi_ip_address" | tr -d '\r')

# Discard APIPA address
if [[ $win_eth_ip_address != 169.254.* ]]; then
  win_ip_address=$win_eth_ip_address
else
  win_ip_address=$win_wifi_ip_address
fi

# connect to MySQL using the IP address of the Ethernet or Wi-Fi network adapter on the Windows host
/usr/bin/mysql -h $win_ip_address -u admin -p

