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
sudo cp $SIGPI_HOME/scripts/SIGpi_exec-in-shell.sh /usr/local/bin/SIGpi_exec-in-shell 
sudo cp $SIGPI_HOME/scripts/SIGpi.sh /usr/local/bin/SIGpi

# Copy Background images
## What operating system are we?
if [[ "$SIGPI_HWARCH" == "x86_64" ]]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/backgrounds
    # Change Background image
    gsettings set org.gnome.desktop.background picture-uri /usr/share/backgrounds/SIGpi_wallpaper.png
fi

if [[ "$SIGPI_HWARCH" == "aarch64" ]]; then
    sudo cp $SIGPI_HOME/backgrounds/* /usr/share/rpd-wallpaper
    # Change Background image
    pcmanfm --set-wallpaper=/usr/share/rpd-wallpaper/SIGpi_wallpaper.png
fi

# Copy SIGpi Desktop Setup files to XDG Dirs
sudo cp $SIGPI_DESKTOP/SIGpi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SIGpishell.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SIGpi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_DESKTOP/SIGpishell.menu $DESKTOP_XDG_MENU

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Prep Complete"
echo -e "${SIGPI_BANNER_RESET}"
