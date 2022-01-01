#!/bin/bash

###
### SIGPI
###
### install_devices_rfm95w
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install RFM95W"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES
sudo apt-get -y install python3-pip
sudo apt-get -y install python3-pil
sudo pip3 install RPI.GPIO
sudo pip3 install spidev
sudo pip3 install adafruit-circuitpython-ssd1306
sudo pip3 install adafruit-circuitpython-framebuf
sudo pip3 install adafruit-circuitpython-rfm9x

# INSTALL
sudo pip3 install pyLoraRFM9x
echo "rfm95w" >> $SIGPI_CONFIG 

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   RFM95W Installed"
echo -e "${SIGPI_BANNER_RESET}"