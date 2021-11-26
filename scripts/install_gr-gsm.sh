#!/bin/bash

###
### SIGpi
###
### installer_gr-gsm
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install GR-GSM "
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y osmo-sdr libosmosdr-dev
sudo apt-get install -y libosmocore libosmocore-dev
sudo apt-get install -y libosmocore-utils
sudo dpkg -L libosmocore-utils
cd $SIGPI_SOURCE
git clone https://git.osmocom.org/gr-gsm
cd gr-gsm
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
echo 'export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH' >> ~/.bashrc


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   GR-GSM Installed"
echo -e "${SIGPI_BANNER_RESET}"