#!/bin/bash

###
### SIGpi Install GR_GSM
###
### 

###
###
### This script is part of the SIGbox Project.
###
### Applications and driver updates include
###
### - GR-GSM
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
echo "###  SIGpi - GR-GSM Install"
echo "### "
echo "### "
echo " "

#
# INSTALL GR-GSM (requires GNUradio 3.8)
#

echo " "
echo " ##"
echo " ##"
echo " - Install GR-GSM"
echo " ##"
echo " ##"
echo " "
sudo apt-get install -y osmo-sdr libosmosdr-dev
sudo apt-get install -y libosmocore libosmocore-dev
sudo apt-get install -y libosmocore-utils
sudo dpkg -L libosmocore-utils
cd $SIGPI_SOURCE
git clone https://git.osmocom.org/gr-gsm
cd gr-gsm
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig
echo 'export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH' >> ~/.bashrc

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