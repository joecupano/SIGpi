#!/bin/bash

###
### SIGpi
###
### installer_ubertooth
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Ubertooth Tools"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/greatscottgadgets/ubertooth.git
cd ubertooth/host
mkdir build && cd build
cmake ..
make -j4
sudo make install


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Ubertooth Tools Installed"
echo -e "${SIGPI_BANNER_RESET}"