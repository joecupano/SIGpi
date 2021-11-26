#!/bin/bash

###
### SIGPI
###
### installer_dump1090
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Dump1090"
echo -e "${SIGPI_BANNER_COLOR} #"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/antirez/dump1090
git clone https://github.com/antirez/dump1090.git
cd dump1090
make -j4
sudo cp dump1090 /usr/local/bin/dump1090


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Dump1090 Installed"
echo -e "${SIGPI_BANNER_RESET}"