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

# Hamlib
wget https://github.com/Hamlib/Hamlib/releases/download/4.3/hamlib-4.3.tar.gz -P $HOME/Downloads
tar -zxvf $HOME/Downloads/hamlib-4.3.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/hamlib-4.3
./configure --prefix=/usr/local --enable-static
make
sudo make install
sudo ldconfig

# LibSigMF
cd $SIGPI_SOURCE
git clone https://github.com/deepsig/libsigmf.git
cd libsigmf
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
	
# Liquid-DSP
cd $SIGPI_SOURCE
git clone https://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
./bootstrap.sh
./configure --enable-fftoverride 
make -j4
sudo make install
sudo ldconfig

# Bluetooth Baseband Library
cd $SIGPI_SOURCE
git clone https://github.com/greatscottgadgets/libbtbb.git
cd libbtbb
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Libraries Installed"
echo -e "${SIGPI_BANNER_RESET}"