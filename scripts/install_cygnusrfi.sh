#!/bin/bash

###
### SIGpi
###
### install_cygnusrf
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install CygnusRFI"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/0xCoto/CygnusRFI.git


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   CygnusRFI Installed"
echo -e "${SIGPI_BANNER_RESET}"
