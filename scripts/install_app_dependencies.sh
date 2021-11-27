#!/bin/bash

###
### SIGpi
###
### installer_app_dependencies
###


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Dependencies"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# Baseline
sudo apt-get install -y build-essential pkg-config git cmake g++ gcc autoconf automake libtoollibgl1-mesa-dev 
sudo apt-get install -y libssl-dev libavahi-client-dev libavahi-common-dev libaio-dev
sudo apt-get install -y libtool libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Qt5 Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Qt5 Base Packages
sudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Python Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Python Baseline
sudo apt-get install -y python3-pip python3-cairocffi python3-click python3-click-plugins python3-cycler python3-gdal python3-gi-cairo python3-kiwisolver python3-lxml python3-mako \
python3-matplotlib python3-networkx python3-nose python3-numpy python3-opengl python3-pydot python3-pygraphviz python-qt4 qt5-default python3-pyqt5 python3-pyqt5.qtopengl python-pyside \
python3-pyqtgraph python3-scapy python3-scipy python3-setuptools python3-sphinx python3-tk python3-tk-dbg python3-tornado python3-yaml python3-zmq python-cycler-doc \
python-docutils python-gobject python-matplotlib-data python-matplotlib-doc python-networkx-doc 

sudo apt-get install -y python3-dbg

sudo pip3 install pyinstaller
sudo pip3 install pygccxml
sudo pip3 install qtawesome

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Device Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# RTLSDR
sudo apt-get install -y libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev
sudo pip3 install pyrtlsdr

# HackRF
sudo apt-get install -y libusb-1.0-0-dev libfftw3-dev

# PlutoSDR
sudo apt-get install -y libaio-dev libusb-1.0-0-dev 
sudo apt-get install -y libserialport-dev libavahi-client-dev 
sudo apt-get install -y libxml2-dev bison flex libcdk5-dev 

# LimeSDR
sudo apt-get install -y swig
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y libi2c-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y libwxgtk3.0-dev
sudo apt-get install -y freeglut3-dev

# SoapySDR 
sudo apt-get install -y swig
sudo apt-get install -y avahi-daemon
sudo apt-get install -y libavahi-client-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python-dev python3-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Library Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# APTDEC
sudo apt-get install -y cmake git gcc libsndfile-dev libpng-dev

# HD Radio
sudo apt-get install -y libao-dev

# LibDAB
sudo apt-get install -y libsndfile1-dev
sudo apt-get install -y libfftw3-dev portaudio19-dev
sudo apt-get install -y libfaad-dev zlib1g-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Packet Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# DireWolf
sudo apt-get install -y git gcc g++ make cmake libasound2-dev libudev-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   SDR Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# RTL_433
sudo apt-get install -y libtool libssl-dev

# GnuRadio 3.X
sudo apt-get install -y libboost-all-dev swig libzmq3-dev libfftw3-dev libgsl-dev libcppunit-dev libcomedi-dev
sudo apt-get install -y libqt4-opengl-dev libqwt-dev libsdl1.2-dev libusb-1.0-0-dev libasound2-dev portaudio19-dev libportaudio2 pulseaudio libjack-dev
sudo apt-get install -y libgmp-dev libsdl1.2-dev liblog4cpp5-dev libqwt-qt5-dev libqt5opengl5-dev python3-numpy python3-mako python3-sphinx python3-lxml
sudo apt-get install -y python3-pyqt5 python3-yaml python3-click python3-click-plugins python3-zmq python3-scipy python3-pip python3-gi-cairo

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   SDRangel Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# SDRangel
sudo apt-get install -y libfftw3-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y libusb-dev
sudo apt-get install -y qt5-default
sudo apt-get install -y qtbase5-dev
sudo apt-get install -y qtchooser
sudo apt-get install -y libqt5multimedia5-plugins
sudo apt-get install -y qtmultimedia5-dev
sudo apt-get install -y libqt5websockets5-dev
sudo apt-get install -y qttools5-dev
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y libqt5opengl5-dev
sudo apt-get install -y qtbase5-dev
sudo apt-get install -y libqt5quick5
sudo apt-get install -y libqt5charts5-dev
sudo apt-get install -y qml-module-qtlocation
sudo apt-get install -y qml-module-qtpositioning
sudo apt-get install -y qml-module-qtquick-window2
sudo apt-get install -y qml-module-qtquick-dialogs
sudo apt-get install -y qml-module-qtquick-controls
sudo apt-get install -y qml-module-qtquick-layouts
sudo apt-get install -y libqt5serialport5-dev
sudo apt-get install -y qtdeclarative5-dev
sudo apt-get install -y qtpositioning5-dev
sudo apt-get install -y qtlocation5-dev
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libasound2-dev
sudo apt-get install -y pulseaudio
sudo apt-get install -y libopencv-dev
sudo apt-get install -y libxml2-dev
sudo apt-get install -y bison
sudo apt-get install -y flex
sudo apt-get install -y ffmpeg
sudo apt-get install -y libavcodec-dev
sudo apt-get install -y libavformat-dev
sudo apt-get install -y libopus-dev
sudo apt-get install -y graphviz

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   SDR++ Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# SDR++
sudo apt-get install -y libglew-dev
sudo apt-get install -y libglfw3-dev
sudo apt-get install -y libsoapysdr-dev
sudo apt-get install -y libad9361-dev 
sudo apt-get install -y libairspyhf-dev 
sudo apt-get install -y librtaudio-dev
sudo apt-get install -y libcodec2-dev
sudo apt-get install -y libvolk2-bin libvolk2-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Fldigi Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Fldigi
sudo apt-get install -y libfltk1.3-dev libjpeg9-dev libxft-dev libxinerama-dev libxcursor-dev 
sudo apt-get install -y libsndfile1-dev libsamplerate0-dev portaudio19-dev libjpeg62-turbo-dev libusb-1.0-0-dev libpulse-dev libudev-dev texinfo

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   QSSTV Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# QSSTV
sudo apt-get install -y g++ libfftw3-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libpulse-dev libhamlib-dev libasound2-dev
sudo apt-get install -y libv4l-dev libopenjp2-7 libopenjp2-7-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   WSJT-X Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# WSJT-X
sudo apt-get install -y gfortran fftw3-dev qtbase5-dev qttools5-dev libqt5serialport5-dev  qtmultimedia5-dev 
sudo apt-get install -y libqt5multimedia5-plugins libqt5sql5-sqlite autoconf automake libtool texinfo
sudo apt-get install -y libusb-1.0-0-dev libudev-dev libboost-all-dev asciidoctor

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Gpredict Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Gpredict
sudo apt-get install -y intltool libcurl4-openssl-dev libgoocanvas-2.0-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   Kismet Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Kismet
sudo apt-get install -y libwebsockets-dev zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev libdw-dev libsqlite3-dev
sudo apt-get install -y libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libsensors4-dev python3-protobuf
sudo apt-get install -y python3-serial python3-usb python3-dev python3-websockets librtlsdr0 libubertooth-dev libbtbb-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #####   WireShark Dependencies"
echo -e "${SIGPI_BANNER_RESET}"

# Wireshark
sudo apt-get install -y wireshark wireshark-dev libwireshark-dev


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Dependencies Installed"
echo -e "${SIGPI_BANNER_RESET}"
