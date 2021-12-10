#!/bin/bash

###
### SIGPI
###
### install_devices
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Devices"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# AX.25 and utilities"

sudo apt-get install -y libncurses5 libax25 ax25-apps ax25-tools
echo "ax0 N0CALL-3 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports


# UHD

## DEPENDENCIES
#sudo apt-get install -y libboost-all-dev
#sudo apt-get install -y libusb-1.0-0-dev
#sudo apt-get install -y python3-mako

# INSTALL
#cd $SIGPI_SOURCE
#git clone --single-branch --branch UHD-3.15.LTS --depth 1 https://github.com/EttusResearch/uhd.git
#cd uhd/host
#mkdir build	&& cd build
#cmake -DCMAKE_CXX_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15 -Wno-psabi" \
#      -DCMAKE_C_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15 -Wno-psabi" \
#      -DCMAKE_ASM_FLAGS:STRING="-march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a15" \
#      -DCMAKE_BUILD_TYPE=Release ../
#sudo make install
#sudo cp /usr/local/lib/uhd/utils/uhd-usrp.rules /etc/udev/rules.d/
#sudo ldconfig
#uhd_images_downloader


# RTL-SDR

## DEPENDENCIES
sudo apt-get install -y libusb-1.0-0-dev
sudo pip3 install pyrtlsdr

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/osmocom/rtl-sdr.git
cd rtl-sdr
mkdir build	&& cd build
cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
make
sudo make install
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo ldconfig


# HackRF

## DEPENDENCIES
sudo apt-get install -y libusb-1.0-0-dev libfftw3-dev

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/mossmann/hackrf.git
cd hackrf/host
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


# PlutoSDR

## DEPENDENCIES
sudo apt-get install -y libaio-dev libusb-1.0-0-dev 
sudo apt-get install -y libserialport-dev libavahi-client-dev 
sudo apt-get install -y libxml2-dev bison flex libcdk5-dev 
#sudo apt-get install -y python3 python3-pip python3-setuptools

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/analogdevicesinc/libiio.git
cd libiio
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


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


# Ubertooth

## DEPENDENCIES
sudo apt-get install -y libusb-1.0-0-dev 
sudo apt-get install -y libbluetooth-dev 
sudo apt-get install -y python3-qtpy 
sudo apt-get install -y python3-distutils 
sudo apt-get install -y python3-setuptools

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/greatscottgadgets/ubertooth.git
cd ubertooth/host
mkdir build && cd build
cmake ..
make -j4
sudo make install


# SoapySDR

## DEPENDENCIES
sudo apt-get install -y swig
sudo apt-get install -y avahi-daemon
sudo apt-get install -y libavahi-client-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python-dev python3-dev

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
mkdir build && cd build
cmake ../ -Wno-dev -DCMAKE_BUILD_TYPE=Release
make -j4
sudo make install
sudo ldconfig
SoapySDRUtil --info

# SoapyRTLSDR
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyRTLSDR.git
cd SoapyRTLSDR
mkdir build && cd build
cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release
make
sudo make install
sudo ldconfig

# SoapyHackRF
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyHackRF.git
cd SoapyHackRF
mkdir build && cd build
cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release
make
sudo make install
sudo ldconfig

# SoapyPlutoSDR
sudo apt-get install -y libserialport-dev libavahi-client-dev 
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyPlutoSDR.git
cd SoapyPlutoSDR
mkdir build && cd build
cmake .. -Wno-dev
make
sudo make install
sudo ldconfig

# SoapyRemote
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyRemote.git
cd SoapyRemote
mkdir build && cd build
cmake .. -Wno-dev
make
sudo make install
sudo ldconfig

# GPS
sudo apt-get install -y gpsd chrony

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Devices Installed"
echo -e "${SIGPI_BANNER_RESET}"