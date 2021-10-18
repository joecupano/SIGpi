#!/bin/bash

###
### SIGpi
###
### installer_dependencies
###

# AX.25
echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Dependencies"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

sudo apt-get install -y git cmake g++ pkg-config autoconf automake libtool build-essential pulseaudio bison flex gettext ffmpeg
sudo apt-get install -y portaudio19-dev doxygen graphviz gnuplot gnuplot-x11 swig  icu-doc libjs-jquery-ui-docs tcl8.6 tk8.6 libvolk2-doc python-cycler-doc
sudo apt-get install -y tk8.6-blt2.5 ttf-bitstream-vera uhd-host dvipng texlive-latex-extra ttf-staypuft tix openssl
	
sudo apt-get install -y libusb-1.0-0 libusb-1.0-0-dev libusb-dev libudev1
sudo apt-get install -y libaio-dev libusb-1.0-0-dev libserialport-dev libxml2-dev libavahi-client-dev doxygen graphviz
sudo apt-get install -y libfltk1.3 libfltk1.3-dev 
sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev libv4l-dev
sudo apt-get install -y libsdl1.2-dev libfaad2 libfftw3-dev libfftw3-doc libfftw3-bin libfftw3-dev libfftw3-long3 libfftw3-quad3

sudo apt-get install -y libvolk2-bin libvolk2-dev libvolk2.2 libfaad-dev zlib1g zlib1g-dev libasound2-dev 
sudo apt-get install -y libopencv-dev libxml2-dev libaio-dev libnova-dev libwxgtk-media3.0-dev libcairo2-dev libavcodec-dev libpthread-stubs0-dev
sudo apt-get install -y libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev libopus-dev libavahi-common-dev libavahi-client-dev libavdevice-dev libavutil-dev
sudo apt-get install -y libsdl1.2-dev libgsl-dev liblog4cpp5-dev libzmq3-dev liborc-0.4 liborc-0.4-0 liborc-0.4-dev libsamplerate0-dev libgmp-dev
sudo apt-get install -y libpcap-dev libcppunit-dev libbluetooth-dev qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev
sudo apt-get install -y libgles1 libosmesa6 gmp-doc libgmp10-doc libmpfr-dev libmpfrc++-dev libntl-dev libcppunit-doc zlib-dev libpng-dev
	
sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk0 libcppunit-1.15-0 libcppunit-dev  
sudo apt-get install -y libfreesrp0 libglfw3 libgmp-dev libgmpxx4ldbl libhidapi-libusb0 libicu-dev libjs-jquery-ui 
sudo apt-get install -y liblog4cpp5-dev liblog4cpp5v5 faad libfaad2 libfaad-dev

sudo apt-get install -y python3-pip python3-numpy python3-mako python3-sphinx python3-lxml python3-yaml python3-click python3-click-plugins 
sudo apt-get install -y python3-zmq python3-scipy python3-scapy python3-setuptools python3-pyqt5 python3-gi-cairo python-docutils python-gobject python3-nose

sudo apt-get install -y python3-tornado texlive-extra-utils python-networkx-doc python3-gdal python3-pygraphviz python3-pydot libgle3 python-pyqtgraph-doc 
sudo apt-get install -y python-matplotlib-doc python3-cairocffi python3-tk-dbg python-matplotlib-data python3-cycler python3-kiwisolver python3-matplotlib python3-networkx 
sudo apt-get install -y python3-opengl python3-pyqt5.qtopengl python3-pyqtgraph python3-tk

sudo python3 -m pip install --upgrade pip
sudo pip3 install pyinstaller
sudo pip3 install pygccxml
sudo pip3 install qtawesome
sudo pip3 install PyQt5
sudo pip3 install PyQt4
sudo pip3 install PySide

# RTL-SDR Dependencies
sudo apt-get install -y libusb-1.0-0-dev

# APTdec dependencies
sudo apt-get install -y libsndfile-dev libpng-dev

# LibDAB dab-cmdline dependencies
sudo apt-get install -y pkg-config libsndfile1-dev libfftw3-dev portaudio19-dev libfaad-dev zlib1g-dev libusb-1.0-0-dev mesa-common-dev libgl1-mesa-dev libsamplerate0-dev

# MBElib, SerialDV, SGP4, LibTBB- no dependencies specified
	
# DSDcc - requires MBElib installed prior

# Liquid-DSP - prefers FFTW installed prior

# Codec2
sudo apt-get install -y octave octave-common octave-signal liboctave-dev gnuplot python3-numpy sox valgrind

# RPiTX
#
#sudo apt-get install -y ghostscript gsfonts imagemagick imagemagick-6-common imagemagick-6.q16 libheif1 libjxr-tools libjxr0 liblqr-1-0 libmagickcore-6.q16-6 \
#libmagickcore-6.q16-6-extra libmagickwand-6.q16-6 libnetpbm10 libpng12-0 libwmf0.2-7 netpbm

# SoapySDR
#
#sudo apt-get install -y swig avahi-daemon libavahi-client-dev libusb-1.0-0-dev

# GQRX
#
#sudo apt-get install -y libfftw3-dev libusb-1.0-0-dev libusb-dev qt5-default qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
#qttools5-dev qttools5-dev-tools libqt5opengl5-dev qtbase5-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev libqt5svg5-dev

# UHD
#
#sudo apt-get install -y libboost-all-dev libusb-1.0-0-dev python3-mako

# GNU Radio
#
#sudo apt-get install -y libboost-all-dev swig libzmq3-dev libfftw3-dev libgsl-dev libcppunit-dev libcomedi-dev libqt4-opengl-dev libqwt-dev libsdl1.2-dev \
#libusb-1.0-0-dev libasound2-dev portaudio19-dev libportaudio2 pulseaudio libjack-dev libgmp-dev libsdl1.2-dev liblog4cpp5-dev \
#libqwt-qt5-dev libqt5opengl5-dev python3-numpy python3-mako python3-sphinx python3-lxml python3-pyqt5 python3-yaml python3-click \
#python3-click-plugins python3-zmq python3-scipy python3-pip python3-gi-cairo

# SDRangel
#
#sudo apt-get install -y libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qttools5-dev qttools5-dev-tools libqt5opengl5-dev qtbase5-dev \
#libqt5quick5 libqt5charts5-dev qml-module-qtlocation qml-module-qtpositioning qml-module-qtquick-window2 qml-module-qtquick-dialogs qml-module-qtquick-controls \
#qml-module-qtquick-layouts libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libboost-all-dev libasound2-dev pulseaudio \
#libopencv-dev libxml2-dev bison flex ffmpeg libavcodec-dev libavformat-dev libopus-dev graphviz

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"