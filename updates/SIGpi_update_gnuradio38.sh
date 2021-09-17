#!/bin/bash

###
### SIGpi Update GNUradio 3.8
###
### 

###
###
### This script is part of the SIGbox Project.
###
### Applications and driver updates include
###
### - GNUradio 3.8
###

##
## INIT VARIABLES AND DIRECTORIES
##

# Package Versions

# Source Directory
SIGPI_SOURCE=$HOME/source

# Executable Directory (will be created as root)
SIGPI_OPT=/opt/SIGpi
SIGPI_EXE=$SIGPI_OPT/bin

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Desktop directories
SIGPI_DESKTOP=$SIGPI_HOME/desktop
SIGPI_BACKGROUNDS=$SIGPI_DESKTOP/backgrounds
SIGPI_ICONS=$SIGPI_DESKTOP/icons
SIGPI_LOGO=$SIGPI_DESKTOP/logo
SIGPI_MENU=$SIGPI_DESKTOP/menu

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi

# SigPi SSL Cert and Key
SIGPI_API_SSL_KEY=$SIGPI_HOME/SIGpi_api.key
SIGPI_API_SSL_CRT=$SIGPI_HOME/SIGpi_api.crt


##
## START
##

echo "### "
echo "### "
echo "###  SIGpi Update - GNUradio 3.8 Install"
echo "### "
echo "### "
echo " "

#
# INSTALL GNUradio 3.8
#

echo " "
echo " ##"
echo " ##"
echo " - Install GNUradio 3.8"
echo " ##"
echo " ##"
echo " "

echo " - Setup Temporary Swap"
echo " "
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo " - Check Dependencies"
echo " "
sudo apt update --allow-releaseinfo-change
sudo apt upgrade
sudo apt install git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
libudev-dev python3-setuptools build-essential liborc-0.4-0 liborc-0.4-dev \
python3-gi-cairo

echo " - Clone GNUradio 3.8"
echo " "
cd $SIGPI_SOURCE
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
git checkout maint-3.8
git submodule update --init --recursive
mkdir build && cd 
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j4
sudo make install
sudo ldconfig


#
# Copy Menuitems into relevant directories
# 

#sudo cp $SIGPI_MENU/sigpi_example.desktop $DESKTOP_FILES
sudo cp $SIGPI_MENU/SigPi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_MENU/SigPi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
sudo cp /usr/local/share/Lime/Desktop/lime-suite.desktop $DESKTOP_FILES
sudo cp $SIGPI_MENU/*.desktop $DESKTOP_FILES
sudo ln -s $DESKTOP_XDG_MENU/SigPi.menu /etc/xdg/menus/applications-merged/SigPi.menu

#
# Add SigPi Category for each installed application
#

sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/radiosonde.desktop


# Make python scripts executable in /opt/SIGpi/bin
cd $SIGPI_EXE
sudo chmod 755 *py 
cd $SIGPI_HOME

# Shutoff and delete swapfile

echo "*** "
echo "*** "
echo "***   UPDATEE COMPLETE"
echo "*** "
echo "*** "
echo " "
exit 0