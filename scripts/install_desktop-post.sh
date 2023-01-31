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
