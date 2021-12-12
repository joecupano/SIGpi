#!/bin/bash

###
### SIGpi
###
### package_sdrpp
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if [ $1 = "remove" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove SDR++"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/sdrpp/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/sdrpp
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   SDR++ Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if [ $1 = "purge" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge SDR++"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/sdrpp/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/sdrpp
    
    rm -rf $HOME/.config/sdrpp
    sudo rm -rf $SIGPI_DESKTOP/sdrpp.desktop
    sudo rm -rf $DESKTOP_FILES/sdrpp.desktop

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   SDR++ Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SDR++"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y libglew-dev
sudo apt-get install -y libglfw3-dev
sudo apt-get install -y libsoapysdr-dev
sudo apt-get install -y libad9361-dev 
sudo apt-get install -y libairspyhf-dev 
sudo apt-get install -y librtaudio-dev
sudo apt-get install -y libcodec2-dev
sudo apt-get install -y libvolk2-bin libvolk2-dev

## PACKAGE 
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
echo -e "${SIGPI_BANNER_COLOR} ##   SDR++ Installed"
echo -e "${SIGPI_BANNER_RESET}"
