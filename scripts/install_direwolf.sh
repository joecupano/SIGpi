#!/bin/bash

###
### SIGPI
###
### installer_direwolf
###
#
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install DireWolf"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y libasound2-dev
sudo apt-get install -y libudev-dev
sudo apt-get install -y libgps-dev
sudo apt-get install -y libhamlib-dev

# INSTALL
cd $SIGPI_SOURCE
git clone https://www.github.com/wb2osz/direwolf.git
cd direwolf
mkdir build && cd build
cmake .. 
make -j4
sudo make install

sudo cp /usr/local/share/doc/direwolf/scripts/dw-start.sh /usr/local/bin/run_direwolf.sh
sudo mkdir /usr/local/etc/direwolf
sudo cp /usr/local/share/doc/direwolf/conf/* /usr/local/etc/direwolf


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   DireWolf Installed"
echo -e "${SIGPI_BANNER_RESET}"