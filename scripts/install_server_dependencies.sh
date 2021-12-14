#!/bin/bash

###
### SIGpi
###
### installer_server_dependencies
###


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Server Dependencies"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# Baseline
sudo apt-get install -y build-essential pkg-config git cmake g++ gcc autoconf automake libtool libgl1-mesa-dev 
sudo apt-get install -y libssl-dev libavahi-client-dev libavahi-common-dev libaio-dev
sudo apt-get install -y libtool libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev
sudo apt-get install -y libsamplerate-dev


#
# Ubuntu 20.04 LTS Desktop accomodations
#
# Following need to occur earlier in build
sudo apt-get install -y doxygen zlib1g zlib1g-dev libpng-dev libfaad-dev libfaac-dev faac faad pulseaudio
sudo apt-get install -y libgps-dev

# Python Baseline
sudo apt-get install -y python3-pip python3-cairocffi python3-click python3-click-plugins python3-cycler python3-gdal python3-gi-cairo python3-kiwisolver python3-lxml python3-mako \
python3-matplotlib python3-networkx python3-nose python3-numpy python3-opengl python3-pydot python3-pygraphviz python-pyside \
python3-pyqtgraph python3-scapy python3-scipy python3-setuptools python3-sphinx python3-tornado python3-yaml python3-zmq python-cycler-doc \
python-docutils python-gobject python-matplotlib-data python-matplotlib-doc python-networkx-doc 

sudo apt-get install -y python3-dbg

sudo pip3 install pyinstaller
sudo pip3 install pygccxml

# RTLSDR
sudo apt-get install -y libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev
sudo pip3 install pyrtlsdr

# HackRF
sudo apt-get install -y libusb-1.0-0-dev libfftw3-dev

# PlutoSDR
sudo apt-get install -y libaio-dev libusb-1.0-0-dev 
sudo apt-get install -y libserialport-dev libavahi-client-dev 
sudo apt-get install -y libxml2-dev bison flex libcdk5-dev 

# SoapySDR 
sudo apt-get install -y swig
sudo apt-get install -y avahi-daemon
sudo apt-get install -y libavahi-client-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python-dev python3-dev


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Server Dependencies Installed"
echo -e "${SIGPI_BANNER_RESET}"
