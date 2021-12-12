#!/bin/bash

###
### SIGPI
###
### package_soapysdr_srv
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if [ $1 = "remove" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove SoapySDR Service"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo systemctl stop soapysdr.service
    sleep 5
    sudo systemctl disable soapysdr.service
    sudo rm -rf /etc/systemd/system/soapysdr.service

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   SoapySDR Service Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if [ $1 = "purge" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge SoapySDR Service"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo systemctl stop soapysdr.service
    sleep 5
    sudo systemctl disable soapysdr.service
    sudo rm -rf /etc/systemd/system/soapysdr.service

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   SoapySDR Service Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SoapySDR Service"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES

## PACKAGE
sudo cp $SIGPI_SOURCE/scripts/soapysdr.service /etc/systemd/system/soapysdr.service
sudo systemctl enable soapysdr.service
sudo systemctl start soapysdr.service
sleep 5
sudo systemctl status soapysdr.service

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SoapySDR Service Installed"
echo -e "${SIGPI_BANNER_RESET}"