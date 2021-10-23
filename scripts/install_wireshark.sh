#!/bin/bash

###
### SIGpi
###
### installer_wireshark
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install Wireshark"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y wireshark wireshark-dev libwireshark-dev
cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbb
mkdir build && cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make -j4
sudo make install
	
# BTBR Plugin
cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbredr
mkdir build && cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make -j4
sudo make install

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"