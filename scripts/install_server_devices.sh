#!/bin/bash

###
### SIGPI
###
### install_server_devices
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Server Devices"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# AX.25 and utilities"

sudo apt-get install -y libncurses5 libax25 ax25-apps ax25-tools
echo "ax0 N0CALL-3 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports

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