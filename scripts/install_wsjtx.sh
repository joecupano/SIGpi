#!/bin/bash

###
### SIGpi
###
### installer_wsjtx
###

cd $SIGPI_SOURCE

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install WSJT-X"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.5.1_armhf.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/wsjtx_2.5.1_armhf.deb
# Will get error next command fixes error and downloads dependencies
sudo apt-get --fix-broken install
sudo dpkg -i $HOME/Downloads/wsjtx_2.5.1_armhf.deb


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   WSJT-X Installed"
echo -e "${SIGPI_BANNER_RESET}"