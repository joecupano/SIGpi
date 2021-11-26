#!/bin/bash

###
### SIGpi
###
### installer_cygnusrf
###

# Artemis
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install CygnusRF"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE

git clone https://github.com/0xCoto/CygnusRFI


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   CygnusRF Installed"
echo -e "${SIGPI_BANNER_RESET}"
