#!/bin/bash

###
### SIGpi
###
### installer_sdrpp
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install SDR++"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
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

# SDRplusplus dependencies
#sudo apt-get install -y libfftw3-dev libglfw3-dev libglew-dev libvolk2-dev libsoapysdr-dev libairspyhf-dev libiio-dev libad9361-dev librtaudio-dev libhackrf-dev
#
#wget https://github.com/AlexandreRouma/SDRPlusPlus/releases/download/1.0.3/sdrpp_ubuntu_focal_amd64.deb -D $HOME/Downloads
#sudo dpkg -i $HOME/Downloads/sdrpp_ubuntu_focal_amd64.deb


# Copy Menu items into relevant directories
sudo cp $SIGPI_SOURCE/SDRPlusPlus/build/sdrpp.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"
