#!/bin/bash

###
### SIGpi_menus
### 

###
###   REVISION: 20210912-1020 
###

##
## INIT VARIABLES AND DIRECTORIES
##

# Source Directory
SIGPI_SOURCE=$HOME/source

# Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

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

#
# Copy Compiled app Menuitems into relevant directories
# 
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/fldigi.desktop $SIGPI_MENU
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/flarq.desktop $SIGPI_MENU
sudo cp $SIGPI_SOURCE/flrig-1.4.2/data/flrig.desktop $SIGPI_MENU

#sudo cp $SIGPI_MENU/sigpi_example.desktop $DESKTOP_FILES
sudo cp $SIGPI_MENU/SigPi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_MENU/SigPi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
sudo cp /usr/local/share/applications/direwolf.desktop $DESKTOP_FILES
sudo cp /usr/local/share/Lime/Desktop/lime-suite.desktop $DESKTOP_FILES
sudo cp $SIGPI_MENU/*.desktop $DESKTOP_FILES

#
# Add SigPi Category for each installed application
#

sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/mumble.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop

#
# Add installed applications into SigPi menu
#

xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/CubicSDR.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/flarq.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/fldigi.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/flrig.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/gnuradio-grc.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/gpredict.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/gqrx.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/message_aggregator.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/mumble.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/qsstv.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/wsjtx.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/xastir.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/direwolf.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/lime-suite.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/sdrangel.desktop
xdg-desktop-menu install --novendor $DESKTOP_DIRECTORY/SigPi.directory   $DESKTOP_FILES/linpac.desktop

##
## NOTES:
##
: '

 The following are installed with package installs

 CubicSDR.desktop
 flarq.desktop
 fldigi.desktop
 flrig.desktop
 gnuradio-grc.desktop
 gpredict.desktop
 gqrx.desktop
 mumble.desktop
 qsstv.desktop
 wsjtx.desktop
 xastir.desktop

 Need to create desktop files for

 AX.25 and utilities
 axlisten (which needs direwolf running first)
 axcall (which needs direwolf running first)
 Murmur Server
 GPSd and Chrony
 Kismet
 VOX for SDRangel
 DireWolf 1.7
 Linpac


 DESKTOP FILES

 /usr/share/applications/audacity.desktop
 /usr/share/applications/CubicSDR.desktop
 /usr/share/applications/flarq.desktop
 /usr/share/applications/fldigi.desktop
 /usr/share/applications/flrig.desktop
 /usr/share/applications/gnuradio-grc.desktop
 /usr/share/applications/gpredict.desktop
 /usr/share/applications/gqrx.desktop
 /usr/share/applications/mumble.desktop
 /usr/share/applications/pavucontrol.desktop
 /usr/share/applications/qsstv.desktop
 /usr/share/applications/xastir.desktop
 /usr/share/applications/wsjtx.desktop
 /usr/local/share/applications/direwolf.desktop
 /usr/local/share/Lime/Desktop/lime-suite.desktop
 /opt/install/sdrangel/share/applications/sdrangel.desktop

 ICONS

 /usr/share/pixmaps/CQ.png   (Ham Radio menu icon)
 /usr/share/pixmaps/direwolf_icon.png
 /usr/share/icons/hicolor/64x64/apps/fldigi.png
 /usr/share/icons/hicolor/48x48/apps/flarq.png
 /usr/share/qsstv/qsstv.png
 
 DESKTOP-DIRECTORIES

 /usr/share/desktop-directories/HamRadio.directory
'






