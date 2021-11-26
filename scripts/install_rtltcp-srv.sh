#!/bin/bash

###
### SIGPI
###
### install_rtltcp-srv
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install RTL_TCP Service"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# RTL-SDR Service
sudo cp $SIGPI_SOURCE/scripts/rtlsdr.service /etc/systemd/system/rtlsdr.service
sudo systemctl enable rtlsdr.service
sudo systemctl start rtlsdr.service
#sudo systemctl disable rtlsdr.service
#sudo systemctl status rtlsdr.service

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   RTL_TCP Service Installed"
echo -e "${SIGPI_BANNER_RESET}"