#!/bin/bash

###
### SIGpi
###
### installer_core2_dependencies
###


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Core Dependencies"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# Baseline
sudo apt-get install -y build-essential pkg-config git cmake g++ gcc autoconf automake libtool libgl1-mesa-dev 
sudo apt-get install -y libssl-dev libavahi-client-dev libavahi-common-dev libaio-dev
sudo apt-get install -y libtool libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev
sudo apt-get install -y libsamplerate-dev

# Ubuntu 20.04 LTS Desktop accomodations
#
# Following need to occur earlier in build
sudo apt-get install -y doxygen zlib1g zlib1g-dev libpng-dev libfaad-dev libfaac-dev faac faad pulseaudio pcmanfm
# libwxgtk3.0-dev has no candidate in Ubuntu 20.04, libwxgtk3.0-gtk3-dev is its replacement
sudo apt-get install -y libwxgtk3.0-gtk3-dev libgps-dev

# Qt5 Base Packages
sudo apt-get install -y qtbase5-dev 
sudo apt-get install -y qtchooser
sudo apt-get install -y qt5-qmake
sudo apt-get install -y qtbase5-dev-tools

# Python Baseline
sudo apt-get install -y python3-pip 
sudo apt-get install -y python3-cairocffi
sudo apt-get install -y python3-click
sudo apt-get install -y python3-click-plugins
sudo apt-get install -y python3-cycler
sudo apt-get install -y python3-gdal
sudo apt-get install -y python3-gi-cairo
sudo apt-get install -y python3-kiwisolver
sudo apt-get install -y python3-lxml python3-mako 
sudo apt-get install -y python3-matplotlib
sudo apt-get install -y python3-networkx
sudo apt-get install -y python3-nose
sudo apt-get install -y python3-numpy
sudo apt-get install -y python3-opengl
sudo apt-get install -y python3-pydot
sudo apt-get install -y python3-pygraphviz
sudo apt-get install -y python-qt4
sudo apt-get install -y python3-pyqt5
sudo apt-get install -y python3-pyqt5.qtopengl
sudo apt-get install -y python-pyside
sudo apt-get install -y python3-pyqtgraph
sudo apt-get install -y python3-scapy
sudo apt-get install -y python3-scipy
sudo apt-get install -y python3-setuptools
sudo apt-get install -y python3-sphinx
sudo apt-get install -y python3-tk
sudo apt-get install -y python3-tk-dbg
sudo apt-get install -y python3-tornado
sudo apt-get install -y python3-yaml
sudo apt-get install -y python3-zmq
sudo apt-get install -y python-cycler-doc 
sudo apt-get install -y python-docutils
sudo apt-get install -y python-gobject
sudo apt-get install -y python-matplotlib-data
sudo apt-get install -y python-matplotlib-doc
sudo apt-get install -y python-networkx-doc 
sudo apt-get install -y python3-dbg
sudo pip3 install pyinstaller
sudo pip3 install pygccxml
sudo pip3 install qtawesome


# SDRdevice Baseline

## RTLSDR
#sudo apt-get install -y libudev1 
#sudo apt-get install -y libusb-1.0-0 
#sudo apt-get install -y libusb-1.0-0-dev
#sudo apt-get install -y libusb-dev
#sudo pip3 install pyrtlsdr
## HackRF
#sudo apt-get install -y libusb-1.0-0-dev 
sudo apt-get install -y libfftw3-dev
## PlutoSDR
sudo apt-get install -y libaio-dev 
#sudo apt-get install -y libusb-1.0-0-dev 
sudo apt-get install -y libserialport-dev
sudo apt-get install -y libavahi-client-dev 
sudo apt-get install -y libxml2-dev bison flex libcdk5-dev 
## LimeSDR
sudo apt-get install -y swig
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y libi2c-dev
#sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y libwxgtk3.0-dev
sudo apt-get install -y freeglut3-dev
sudo apt-get install -y liboctave-dev
sudo apt-get install -y libfltk1.3-dev

## SoapySDR 
#sudo apt-get install -y swig
sudo apt-get install -y avahi-daemon
#sudo apt-get install -y libavahi-client-dev
#sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python-dev
sudo apt-get install -y python3-dev

# SDRapp Baseline
sudo apt-get install -y swig
sudo apt-get install -y pulseaudio
sudo apt-get install -y gir1.2-gtk-3.0
sudo apt-get install -y libportaudio2
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libzmq3-dev
sudo apt-get install -y libfftw3-dev
sudo apt-get install -y libgsl-dev
sudo apt-get install -y libcppunit-dev
sudo apt-get install -y libcomedi-dev
sudo apt-get install -y libqt4-opengl-dev
sudo apt-get install -y libqwt-dev
sudo apt-get install -y libsdl1.2-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y libasound2-dev
sudo apt-get install -y portaudio19-dev
sudo apt-get install -y libjack-dev
sudo apt-get install -y libgmp-dev
sudo apt-get install -y libsdl1.2-dev
sudo apt-get install -y liblog4cpp5-dev
sudo apt-get install -y libqwt-qt5-dev
sudo apt-get install -y libqt5opengl5-dev
sudo apt-get install -y libcodec2-dev
sudo apt-get install -y libgsm1-dev
sudo apt-get install -y libsndfile1-dev
#sudo apt-get install -y libsoapysdr-dev 
#sudo apt-get install -y libiio-dev
sudo apt-get install -y libad9361-dev
sudo apt-get install -y libspdlog-dev
sudo apt-get install -y python3-pip 
sudo apt-get install -y python3-numpy
sudo apt-get install -y python3-mako
sudo apt-get install -y python3-sphinx
sudo apt-get install -y python3-lxml
sudo apt-get install -y python3-pyqt5
sudo apt-get install -y python3-yaml
sudo apt-get install -y python3-click
sudo apt-get install -y python3-click-plugins
sudo apt-get install -y python3-zmq
sudo apt-get install -y python3-scipy
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-gi
sudo apt-get install -y python3-gi-cairo
sudo apt-get install -y pybind11-dev
sudo apt-get install -y python3-matplotlib
#sudo apt-get install -y soapysdr-tools
sudo pip3 install pygccxml
sudo pip3 install pyqtgraph

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Core Dependencies Installed"
echo -e "${SIGPI_BANNER_RESET}"
