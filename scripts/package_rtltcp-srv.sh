#!/bin/bash

###
### SIGPI
###
### package_rtltcp-srv
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if [ $1 = "remove" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove RTL_TCP Service"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo systemctl stop rtlsdr.service
    sleep 5
    sudo systemctl disable rtlsdr.service
    sudo rm -rf /etc/systemd/system/rtlsdr.service

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   RTL_TCP Service Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if [ $1 = "purge" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge RTL_TCP Service"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo systemctl stop rtlsdr.service
    sleep 5
    sudo systemctl disable rtlsdr.service
    sudo rm -rf /etc/systemd/system/rtlsdr.service

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   RTL_TCP Service Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install RTL_TCP Service"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES

## PACKAGE
sudo cp $SIGPI_SOURCE/scripts/rtlsdr.service /etc/systemd/system/rtlsdr.service
sudo systemctl enable rtlsdr.service
sudo systemctl start rtlsdr.service
sleep 5
sudo systemctl status rtlsdr.service

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   RTL_TCP Service Installed"
echo -e "${SIGPI_BANNER_RESET}"