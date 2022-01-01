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


# Hamlib 4.4 (12/02/21)
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Hamlib 4.4"
echo -e "${SIGPI_BANNER_RESET}"

wget https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-4.4.tar.gz -P $HOME/Downloads
tar -zxvf $HOME/Downloads/hamlib-4.4.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/hamlib-4.4
./configure
make
sudo make install
sudo ldconfig


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


# APT
# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   APT-DEC"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libsndfile-dev libpng-dev
cd $SIGPI_SOURCE
git clone https://github.com/srcejon/aptdec.git
cd aptdec
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


# HD Radio
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   HD Radio"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libao-dev
cd $SIGPI_SOURCE
git clone https://github.com/theori-io/nrsc5.git
cd nrsc5
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


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


# Multimon-NG
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Multimon-NG"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/EliasOenal/multimon-ng.git
cd multimon-ng
mkdir build && cd build
cmake ..
make -j4
sudo make install

# OP25 ---- script crashes at next line and goes to and with EOF error
#if grep op25 "$SIGPI_CONFIG"
#then
#    cd $SIGPI_SOURCE
#	 git clone https://github.com/osmocom/op25.git
#	 cd op25
#	 if grep gnuradio-3.8 "$SIGPI_CONFIG"
#	 then
#	     cat gr3.8.patch | patch -p1
#		 ./install_sh
#	 else
#		 ./install.sh
#fi

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Libraries Installed"
echo -e "${SIGPI_BANNER_RESET}"