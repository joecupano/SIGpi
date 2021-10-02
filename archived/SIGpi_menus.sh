#!/bin/bash

###
### SIGpi_menus
### 

###
###   REVISION: 20211001-1020 
###

###
### INIT VARIABLES AND DIRECTORIES
###

# Package Versions
HAMLIB_PKG="hamlib-4.3.tar.gz"
FLXMLRPC_PKG="flxmlrpc-0.1.4.tar.gz"
FLRIG_PKG="flrig-1.4.2.tar.gz"
FLDIGI_PKG="fldigi-4.1.20.tar.gz"
WSJTX_PKG="wsjtx_2.4.0_armhf.deb"
QSSTV_PKG="qsstv_9.5.8.tar.gz"
GNURADIO_PKG="gnuradio_3.9"

# Source Directory
SIGPI_SOURCE=$HOME/source

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Desktop Source directories
SIGPI_THEMES=$SIGPI_HOME/themes
SIGPI_BACKGROUNDS=$SIGPI_THEMES/backgrounds
SIGPI_ICONS=$SIGPI_THEMES/icons
SIGPI_LOGO=$SIGPI_THEMES/logo
SIGPI_DESKTOP=$SIGPI_THEMES/desktop

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi

# SigPi Install Support files
SIG_CONFIG=$SIGPI_HOME/sigpi_installer_config.txt
SIG_INSTALL_TXT1=$SIGPI_HOME/updates/SIGpi-installer-1.txt
SIG_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIG_BANNER_RESET="\e[0m"
 
#
# Copy Desktop files not installed via distro
# 
	
#sudo cp $SIGPI_DESKTOP/sigpi_example.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/lime-suite.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/gnuradio/grc/scripts/freedesktop/gnuradio-grc.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/SDRangel/sdrangel/build/sdrangel.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/flrig-1.4.2/data/flrig.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/flarq.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/fldigi.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/qsstv/qsstv.desktop $DESKTOP_FILES
sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo cp $SIGPI_DESKTOP/SigPi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SigPi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
	
#
# Add SigPi Category for each installed application
#

sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/mumble.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigidwiki.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_example.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_home.desktop
	
#
# Add installed applications into SigPi menu
#

xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/lime-suite.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gnuradio-grc.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gqrx.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/CubicSDR.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrangel.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/direwolf.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/linpac.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/xastir.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flarq.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/fldigi.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flrig.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wsjtx.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/message_aggregator.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/qsstv.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/mumble.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gpredict.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wireshark.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigidwiki.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_example.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_home.desktop

# Remove Rogue desktop file to ensure we use the one we provided for direwolf
sudo rm -rf /usr/local/share/applications/direwolf.desktop
