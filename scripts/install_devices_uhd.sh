#!/bin/bash

###
### SIGPI
###
### install_devices_uhd
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install UHD"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# UHD

## DEPENDENCIES
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python3-mako

# INSTALL
cd $SIGPI_SOURCE
git clone --single-branch --branch UHD-3.15.LTS --depth 1 https://github.com/EttusResearch/uhd.git
cd uhd/host
mkdir build	&& cd build
cmake -DCMAKE_CXX_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15 -Wno-psabi" \
      -DCMAKE_C_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15 -Wno-psabi" \
      -DCMAKE_ASM_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15" \
      -DCMAKE_BUILD_TYPE=Release ../
sudo make install
sudo cp /usr/local/lib/uhd/utils/uhd-usrp.rules /etc/udev/rules.d/
sudo ldconfig
uhd_images_downloader
echo "ettus" >> $SIGPI_CONFIG 


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   UHD Installed"
echo -e "${SIGPI_BANNER_RESET}"