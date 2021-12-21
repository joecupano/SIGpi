#!/bin/bash

###
### SIGpi
###
### installer_desktop-prep
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Prep"
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
## What operating system are we?
if [ "$SIGPI_OSNAME" = "Ubuntu 20.04.3 LTS" ]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    # Change Background image
    gsettings set org.gnome.desktop.background picture-uri /usr/share/backgrounds/SIGpi_wallpaper.png
else
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/rpd-wallpaper
    # Change Background image
    pcmanfm --set-wallpaper=/usr/share/rpd-wallpaper/SIGpi_wallpaper.png
fi

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Prep Complete"
echo -e "${SIGPI_BANNER_RESET}"
