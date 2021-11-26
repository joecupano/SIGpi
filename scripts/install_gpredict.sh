#!/bin/bash

###
### SIGPI
###
### installer_gpredict
###
#
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Gpredict"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y intltool
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libgoocanvas-2.0-dev

# INSTALL
cd $SIGPI_SOURCE
sudo apt-get install -y gpredict


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Gpredict Installed"
echo -e "${SIGPI_BANNER_RESET}"