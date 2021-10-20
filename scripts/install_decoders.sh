#!/bin/bash

###
### SIGpi
###
### installer_decoders
###

#
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install Decoders"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE

# APT
# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
cd $SIGPI_SOURCE
git clone https://github.com/srcejon/aptdec.git
cd aptdec
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# CM265cc
#
#--   No package 'fftw3f' found
#-- Could NOT find FFTW3F (missing: FFTW3F_LIBRARIES FFTW3F_INCLUDE_DIRS) 
#CMake Error at CMakeLists.txt:47 (message):
#  please install FFTW3

cd $SIGPI_SOURCE
git clone https://github.com/f4exb/cm256cc.git
cd cm256cc
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# LibDAB
cd $SIGPI_SOURCE
git clone https://github.com/srcejon/dab-cmdline.git
cd dab-cmdline/library
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# MBElib
cd $SIGPI_SOURCE
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# SerialDV
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/serialDV.git
cd serialDV
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# DSDcc
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/dsdcc.git
cd dsdcc
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# SGP4
# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
cd $SIGPI_SOURCE
git clone https://github.com/dnwrnr/sgp4.git
cd sgp4
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# Multimon-NG
if grep multimon-ng "$SIGPI_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/EliasOenal/multimon-ng.git
	cd multimon-ng
	mkdir build && cd build
	qmake ../multimon-ng.pro
	make
	sudo make install
fi

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"