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

if [[ "$SIGPI_HWARCH" == "x86_64" ]]; then
    sudo rm -rf /usr/share/backgrounds/SIGpi*
    sudo rm -rf /usr/share/backgrounds/SIGpi*
    # Change Background image
    gsettings set org.gnome.desktop.background picture-uri /usr/share/backgrounds/wallpaper.png
fi

if [[ "$SIGPI_HWARCH" == "aarch64" ]]; then
    sudo rm -rf /usr/share/rpd-wallpaper/SIGpi*
    sudo rm -rf /usr/share/rpd-wallpaper/SIGpi*
    # Change Background image
    pcmanfm --set-wallpaper=/usr/share/rpd-wallpaper/wallpaper.png
fi

# Remove SIGpi Desktop files from XDG Dirs
sudo rm -rf $DESKTOP_DIRECTORY/SIGpi.directory
sudo rm -rf $DESKTOP_DIRECTORY/SIGpishell.directory
sudo rm -rf $DESKTOP_XDG_DIR/SIGpi.menu
sudo rm -rf $DESKTOP_XDG_DIR/SIGpishell.menu

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Removal"
echo -e "${SIGPI_BANNER_RESET}"
