#!/bin/bash

###
### SIGpi
###
### installer_sigpimenu
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install SIGpi Menu and Desktop Shortcuts"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"


# GNUradio
sudo cp $SIGPI_SOURCE/gnuradio/grc/scripts/gnuradio-grc.desktop $DESKTOP_FILES
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop

# SDRangel
sudo cp $SIGPI_SOURCE/desktop/sdrangel.desktop $DESKTOP_FILES
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop

# SDR++
sudo cp $SIGPI_SOURCE/SDRPlusPlus/build/sdrpp.desktop $DESKTOP_FILES
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop

# WSJT-X
#sudo cp $SIGPI_SOURCE/themes/desktop/wsjtx.desktop $DESKTOP_FILES
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop

# Xastir
sudo cp $SIGPI_SOURCE/desktop/xastir.desktop $DESKTOP_FILES
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop



######## OLD    
#
# Copy Menu items into relevant directories
# 
	
# Copy Desktop files
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
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/mumble.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop
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
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrpp.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/direwolf.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/linpac.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/xastir.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flarq.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/fldigi.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flrig.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wsjtx.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/message_aggregator.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/qsstv.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrpp.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/mumble.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gpredict.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wireshark.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigidwiki.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_example.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_home.desktop

# Add Desktop links
sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop

# Remove Rogue desktop file to ensure we use the one we provided for direwolf
sudo rm -rf /usr/local/share/applications/direwolf.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"