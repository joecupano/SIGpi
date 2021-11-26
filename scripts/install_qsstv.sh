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

sudo apt-get install -y libhamlib-dev libv4l-dev
sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev
wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/qsstv
qmake
make
sudo make install


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Installation Complete !!"
echo -e "${SIGPI_BANNER_RESET}"