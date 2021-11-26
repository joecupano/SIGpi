#!/bin/bash

###
### SIGPI
###
### install_soapysdr_srv
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SoapySDR Service"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# SoapySDRServer Service
sudo cp $SIGPI_SOURCE/scripts/soapysdr.service /etc/systemd/system/soapysdr.service
sudo systemctl enable soapysdr.service
sudo systemctl start soapysdr.service
#sudo systemctl disable soapysdr.service
#sudo systemctl status soapysdr.service

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SoapySDR Service Installed"
echo -e "${SIGPI_BANNER_RESET}"