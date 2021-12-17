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
sudo cp $SIGPI_HOME/scripts/SIGpi_pusher.sh /usr/local/bin/SIGpi_pusher
sudo cp $SIGPI_HOME/scripts/SIGpi_popper.sh /usr/local/bin/SIGpi_popper
sudo cp $SIGPI_HOME/scripts/SIGpi.sh /usr/local/bin/SIGpi


# Copy Background images

# What operating system are we?
if [ $SIGPI_OSNAME = "Ubuntu 20.04.3 LTS" ]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    # Change Background image
    gsettings set org.gnome.desktop.background picture-uri /usr/share/backgrounds/SIGpi_wallpaper.png
else
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/rpd-wallpaper
    # Change Background image
    pcmanfm --set-wallpaper /usr/share/rpd-wallpaper/SIGpi_wallpaper.png
fi

# Add Desktop links
sudo cp $SIGPI_DESKTOP/SigPi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SigPi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop
sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS

# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/artemis.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/cubicsdr.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx-sdr.desktop
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
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/cubicsDR.desktop
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


# What operating system are we?
if [ $SIGPI_OSNAME = "Ubuntu 20.04.3 LTS" ]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'sigpi_home.desktop', 'sigidwiki.desktop','org.gnome.Terminal.desktop',\
     'artemis.desktop', 'sdrangel.desktop', 'sdrpp.desktop', 'gnuradio-grc.desktop',\
     'fldigi.desktop', 'xastir.desktop', 'gpredict.desktop', 'org.gnome.Nautilus.desktop']"
fi



echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Items Installed"
echo -e "${SIGPI_BANNER_RESET}"
