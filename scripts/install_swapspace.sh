#!/bin/bash

###
### SIGpi
###
### installer_swapspace
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Swapspace"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

if [ -f /swapfile ]; then
    echo "Removing existing swapfile"
    swapoff /swapfile
    sleep 5
    sudo rm -rf /swapfile
fi

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Swapspace Complete"
echo -e "${SIGPI_BANNER_RESET}"
