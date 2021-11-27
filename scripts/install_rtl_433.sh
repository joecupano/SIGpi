#!/bin/bash

###
### SIGPI
###
### installer_rtl_433
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install RTL_433"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y libtool libssl-dev

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/merbanan/rtl_433.git
cd rtl_433
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   RTL_433 Installed"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"