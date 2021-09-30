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

echo " - Remove GNUradio 3.7.X package"
echo " "
sudo apt-get remove -y gnuradio


echo " - Check Dependencies"
echo " "
sudo apt-get install -y git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako \
python3-sphinx python3-lxml doxygen libfftw3-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev \
libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml python3-click \
python3-click-plugins python3-zmq python3-scipy python3-pip python3-gi-cairo

echo " - Clone GNUradio 3.8"
echo " "
cd $SIGPI_SOURCE
git clone https://github.com/gnuradio/gnuradio.git
cd gnuradio
git checkout maint-3.8
git submodule update --init --recursive
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
make -j4
sudo make install
sudo ldconfig
cd ~
echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.6/dist-packages:$PYTHONPATH" >> .profile
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> .profile



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

sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" /usr/local/share/gnuradio-grc.desktop

echo "*** "
echo "*** "
echo "***   UPDATEE COMPLETE"
echo "*** "
echo "*** "
echo " "
exit 0