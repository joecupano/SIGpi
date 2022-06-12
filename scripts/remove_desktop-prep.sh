#!/bin/bash

###
### SIGpi
###
### remove_desktop-prep
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Remove Desktop "
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# Local Settings Extras
#/.local
#/.local/share
#/.local/share/applications
#/.local/share/desktop-directories

# Remove SIGpi commands from /usr/local/bin
sudo rm -rf /usr/local/bin/SIGpi_exec-in-shell 
sudo rm -rf /usr/local/bin/SIGpi

# Remove SIGpi Background images
## What operating system are we?
if [ "$SIGPI_OSNAME" = "Ubuntu 20.04.3 LTS" ]; then
    sudo rm -rf /usr/share/backgrounds/SIGpi*
    sudo rm -rf /usr/share/backgrounds/SigPi*
    # Change Background image
    gsettings set org.gnome.desktop.background picture-uri /usr/share/backgrounds/wallpaper.png
else
    sudo rm -rf /usr/share/rpd-wallpaper/SIGpi*
    sudo rm -rf /usr/share/rpd-wallpaper/SigPi*
    # Change Background image
    pcmanfm --set-wallpaper=/usr/share/rpd-wallpaper/wallpaper.png
fi

# Remove SIGpi Desktop files from XDG Dirs
sudo rm -rf $DESKTOP_DIRECTORY/SigPi.directory
sudo rm -rf $DESKTOP_DIRECTORY/SigPishell.directory
sudo rm -rf $DESKTOP_XDG_DIR/SigPi.menu
sudo rm -rf $DESKTOP_XDG_DIR/SigPishell.menu

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Removal"
echo -e "${SIGPI_BANNER_RESET}"
