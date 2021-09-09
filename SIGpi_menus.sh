#!/bin/bash

###
### SIGpi_menus
### 

###
###   REVISION: 20210909-0420 
###

##
## INIT VARIABLES AND DIRECTORIES
##

# Source Directory
SIGPI_SOURCE=$HOME/source
# SIGpi Home directory
SIGPI_HOME=$HOME/source/SIGbox
# SIGpi Menuitems directory
SIGPI_MENUITEMS=$HOME/source/SIGbox/menuitems

DTOP_CATEGORY=SigPi
DTOP_DIRECTORY=/usr/share/desktop-directories
DTOP_FILE=/usr/share/applications
DTOP_ICONS=/usr/share/icons
#DTOP_XDG_MENU=/usr/local/share/extra-xdg-menus

sudo cp $SIGPI_MENUITEMS/sigpi_example.desktop $DTOP_FILE
sudo cp $SIGPI_MENUITEMS/SigPi.directory $DTOP_DIRECTORY
sudo cp $SIGPI_MENUITEMS/*.png $DTOP_ICONS

#
# Add SigPi Category for each installed application
#

#sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/audacity.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/CubicSDR.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/gqrx.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/mumble.desktop
#sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/pavucontrol.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/qsstv.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" $DTOP_FILE/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" /usr/local/share/applications/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" /usr/local/share/Lime/Desktop/lime-suite.desktop
sudo sed -i "s/Categories.*/Categories=$DTOP_CATEGORY/" /opt/install/sdrangel/share/applications/sdrangel.desktop

## NOTES:

#
# DESKTOP FILES
#
# /usr/share/applications/audacity.desktop
# /usr/share/applications/CubicSDR.desktop
# /usr/share/applications/flarq.desktop
# /usr/share/applications/fldigi.desktop
# /usr/share/applications/flrig.desktop
# /usr/share/applications/gnuradio-grc.desktop
# /usr/share/applications/gpredict.desktop
# /usr/share/applications/gqrx.desktop
# /usr/share/applications/mumble.desktop
# /usr/share/applications/pavucontrol.desktop
# /usr/share/applications/qsstv.desktop
# /usr/share/applications/xastir.desktop
# /usr/share/applications/wsjtx.desktop
# /usr/local/share/applications/direwolf.desktop
# /usr/local/share/Lime/Desktop/lime-suite.desktop
# /opt/install/sdrangel/share/applications/sdrangel.desktop

#
# ICONS
#
# /usr/share/pixmaps/CQ.png   (Ham Radio menu icon)
# /usr/share/pixmaps/direwolf_icon.png
# /usr/share/icons/hicolor/64x64/apps/fldigi.png
# /usr/share/icons/hicolor/48x48/apps/flarq.png
# /usr/share/qsstv/qsstv.png
# 

#
# DESKTOP-DIRECTORIES
#
# /usr/share/desktop-directories/HamRadio.directory








