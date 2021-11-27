#!/bin/bash

###
### SIGpi
###
### installer_wsjtx
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install WSJT-X"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y gfortran fftw3-dev qtbase5-dev qttools5-dev libqt5serialport5-dev  qtmultimedia5-dev 
sudo apt-get install -y libqt5multimedia5-plugins libqt5sql5-sqlite autoconf automake libtool texinfo
sudo apt-get install -y libusb-1.0-0-dev libudev-dev libboost-all-dev asciidoctor

# INSTALL
cd $SIGPI_SOURCE
wget https://www.physics.princeton.edu/pulsar/k1jt/wsjtx-2.5.2.tgz -P $HOME/Downloads
tar -zxvf $HOME/Downloads/wsjtx-2.5.2.tgz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/wsjtx-2.5.2
mkdir build && cd build
cmake -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF ..
cmake --build .
sudo cmake --build . --target install


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   WSJT-X Installed"
echo -e "${SIGPI_BANNER_RESET}"