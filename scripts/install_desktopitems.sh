#!/bin/bash

###
### SIGpi
###
### installer_desktopitems
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Desktop Items"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# Local Settings Extras
#/.local
#/.local/share
#/.local/share/applications
#/.local/share/desktop-directories

# Copy SIGpi commands into /usr/local/bin
#sudo cp $SIGPI_HOME/scripts/SIGpi_pusher.sh /usr/local/bin/SIGpi_pusher
#sudo cp $SIGPI_HOME/scripts/SIGpi_popper.sh /usr/local/bin/SIGpi_popper


# Copy Background images
sudo cp $SIGPI_SOURCE/backgrounds/* /usr/share/rpd-wallpaper
# Change Background image
pcmanfm --set-wallpaper /usr/share/rpd-wallpaper/SigPi_wallpaper.png

# Add Desktop links
sudo cp $SIGPI_SOURCE/desktop/artemis.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/flrig-1.4.2/data/flrig.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/flarq.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/fldigi.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/gnuradio/grc/scripts/freedesktop/gnuradio-grc.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/lime-suite.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/desktop/sdrangel.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/SDRPlusPlus/build/sdrpp.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/qsstv/qsstv.desktop $DESKTOP_FILES
sudo cp $SIGPI_SOURCE/desktop/xastir.desktop $DESKTOP_FILES
sudo cp $SIGPI_DESKTOP/SigPi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SigPi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop
sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS

# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/artemis.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigidwiki.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_example.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_home.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop


# Add installed applications into SigPi menu
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/artemis.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/CubicSDR.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gnuradio-grc.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gpredict.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gqrx.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/lime-suite.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrangel.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrpp.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wireshark.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/xastir.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigidwiki.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_example.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_home.desktop


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Items Installed"
echo -e "${SIGPI_BANNER_RESET}"