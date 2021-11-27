#!/bin/bash

###
### SIGpi
###
### installer_qsstv
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install QSSTV"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
sudo apt-get install -y g++ libfftw3-dev qtbase5-dev qtchooser \
qt5-qmake qtbase5-dev-tools libpulse-dev libhamlib-dev libasound2-dev \
libv4l-dev libopenjp2-7 libopenjp2-7-dev \

wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/qsstv
qmake
make
sudo make install


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Installation Complete !!"
echo -e "${SIGPI_BANNER_RESET}"