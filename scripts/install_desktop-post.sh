#!/bin/bash

###
### SIGpi
###
### installer_desktop-post
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Post"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# XDG-USER-DIR
#/.local
#/.local/share
#/.local/share/applications
#/.local/share/desktop-directories

# Copy SIGpi Desktop files to XDG Dirs
#sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
#sudo cp $SIGPI_DESKTOP/SIGpi.directory $DESKTOP_DIRECTORY
#sudo cp $SIGPI_DESKTOP/SIGpi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop
sudo chmod 755 $HOME/Desktop/SIGpi.desktop
sudo chown $USER $HOME/Desktop/SIGpi.desktop
sudo cp $SIGPI_DESKTOP/sigidwiki.desktop $HOME/Desktop/sigidwiki.desktop
sudo chmod 755 $HOME/Desktop/sigidwiki.desktop
sudo chown $USER $HOME/Desktop/sigidwiki.desktop

# Add SIGpi Category for installed applications
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/artemis.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx-sdr.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
#sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
#sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
sudo sed -i "s/Categories.*/Categories=$HAMRADIO_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

# Add installed applications into SIGpi menu
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SIGpi.directory $DESKTOP_FILES/sigidwiki.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SIGpi.directory $DESKTOP_FILES/sigpi_home.desktop

if [[ "$SIGPI_HWARCH" == "x86_64" ]]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop',\
     'sdrangel.desktop', 'sdrpp.desktop', 'gnuradio-grc.desktop',\
     'rtl_433.desktop', 'sigidwiki.desktop', 'sigpi_home.desktop']"
fi

if [[ "$SIGPI_HWARCH" == "aarch64" ]]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/rpd-wallpaper
    # Change Background image
    pcmanfm --set-wallpaper /usr/share/rpd-wallpaper/SIGpi_wallpaper.png
fi

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Post Complete"
echo -e "${SIGPI_BANNER_RESET}"
