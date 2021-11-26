#!/bin/bash

###
### SIGpi
###
### installer_sdrpp
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SDR++"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libglew-dev
sudo apt-get install -y libglfw3-dev
sudo apt-get install -y libsoapysdr-dev
sudo apt-get install -y libad9361-dev 
sudo apt-get install -y libairspyhf-dev 
sudo apt-get install -y librtaudio-dev
sudo apt-get install -y libcodec2-dev
sudo apt-get install -y libvolk2-bin libvolk2-dev

cd $SIGPI_SOURCE
git clone https://github.com/AlexandreRouma/SDRPlusPlus
cd SDRPlusPlus
mkdir build && cd build
cmake ../ -DOPT_BUILD_AUDIO_SINK=OFF \
-DOPT_BUILD_BLADERF_SOURCE=OFF \
-DOPT_BUILD_M17_DECODER=ON \
-DOPT_BUILD_NEW_PORTAUDIO_SINK=ON \
-DOPT_BUILD_PLUTOSDR_SOURCE=ON \
-DOPT_BUILD_PORTAUDIO_SINK=ON \
-DOPT_BUILD_SOAPY_SOURCE=ON \
-DOPT_BUILD_AIRSPY_SOURCE=OFF
make -j4
sudo make install
sudo ldconfig


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SDR+= Installed"
echo -e "${SIGPI_BANNER_RESET}"
