#!/bin/bash

###
### SIGPI
###
### installer_linpac
###
#
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Linpac"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
cd $SIGPI_SOURCE
sudo apt-get install -y linpac


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Linpac Installed"
echo -e "${SIGPI_BANNER_RESET}"