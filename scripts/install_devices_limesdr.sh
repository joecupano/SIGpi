#!/bin/bash

###
### SIGPI
###
### install_devices_limesdr
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install LimeSDR"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# LimeSDR

## DEPENDENCIES
sudo apt-get install -y swig
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y libi2c-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y liboctave-dev
sudo apt-get install -y libfltk1.3-dev
# sudo apt-get install -y libwxgtk3.0-dev
# Following is rpelacement fot libwxgtk3.0-dev
sudo apt-get install -y libwxbase3.0-0v5
sudo apt-get install -y freeglut3-dev

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite
git checkout stable
mkdir build-dir && cd build-dir
cmake ../
make -j4
sudo make install
sudo ldconfig

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   LimeSDR Installed"
echo -e "${SIGPI_BANNER_RESET}"