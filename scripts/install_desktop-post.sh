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

if [[ "$SIGPI_OSNAME" == "Debian GNU/Linux 11 (bullseye)" ]]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/rpd-wallpaper
    # Change Background image
    pcmanfm --set-wallpaper /usr/share/rpd-wallpaper/SIGpi_wallpaper.png
else
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop',\
     'sdrangel.desktop', 'sdrpp.desktop', 'gnuradio-grc.desktop',\
     'rtl_433.desktop', 'sigidwiki.desktop', 'sigpi_home.desktop']"
fi

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Post Complete"
echo -e "${SIGPI_BANNER_RESET}"
