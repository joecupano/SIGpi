#!/bin/bash

###
### SIGPI
###
### installer_libraries
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Libraries"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"


# LibSigMF
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   LibSigMF"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/deepsig/libsigmf.git
cd libsigmf
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
echo "libsigmf" >> $SIGPI_CONFIG 


# Liquid-DSP
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   LiquidDSP"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
./bootstrap.sh
./configure --enable-fftoverride 
make -j4
sudo make install
sudo ldconfig
echo "liquid-dsp" >> $SIGPI_CONFIG 


# Bluetooth Baseband Library
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   LibBTbb"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/greatscottgadgets/libbtbb.git
cd libbtbb
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
echo "libbtbb" >> $SIGPI_CONFIG 


# LibDAB
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   LibDAB"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libsndfile1-dev
sudo apt-get install -y libfftw3-dev portaudio19-dev
sudo apt-get install -y libfaad-dev zlib1g-dev
#sudo apt-get install -y mesa-common-dev libgl1-mesa-dev
cd $SIGPI_SOURCE
git clone https://github.com/JvanKatwijk/dab-cmdline.git
cd $SIGPI_SOURCE/dab-cmdline/library
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
cd $SIGPI_SOURCE/dab-cmdline/example-2
mkdir build && cd build
cmake .. -DRTLSDR=on
sudo make install
sudo ldconfig
echo "libdab" >> $SIGPI_CONFIG 


# SGP4
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SGP4"
echo -e "${SIGPI_BANNER_RESET}"

# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
cd $SIGPI_SOURCE
git clone https://github.com/dnwrnr/sgp4.git
cd $SIGPI_SOURCE/sgp4
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
echo "sgp4" >> $SIGPI_CONFIG 


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Libraries Installed"
echo -e "${SIGPI_BANNER_RESET}"