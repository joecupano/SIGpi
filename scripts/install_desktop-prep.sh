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

# Local Settings Extras XDG-USER-DIR
#/.local
#/.local/share
#/.local/share/applications
#/.local/share/desktop-directories

# Copy SIGpi commands into /usr/local/bin
sudo cp $SIGPI_HOME/scripts/SIGpi_exec-in-shell.sh /usr/local/bin/SIGpi_exec-in-shell 
sudo cp $SIGPI_HOME/scripts/SIGpi.sh /usr/local/bin/SIGpi

# Copy icons
sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS

# Copy Background images
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

# Copy SIGpi Menu and Directory files to XDG Dirs
sudo cp $SIGPI_DESKTOP/SIGpi.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SIGpishell.directory $DESKTOP_DIRECTORY
sudo cp $SIGPI_DESKTOP/SIGpi.menu $DESKTOP_XDG_MENU
sudo cp $SIGPI_DESKTOP/SIGpishell.menu $DESKTOP_XDG_MENU


# Copy SIGpi Desktop files to XDG Dirs
#sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop
sudo chmod 755 $HOME/Desktop/SIGpi.desktop
sudo chown $USER $HOME/Desktop/SIGpi.desktop
sudo cp $SIGPI_DESKTOP/sigidwiki.desktop $HOME/Desktop/sigidwiki.desktop
sudo chmod 755 $HOME/Desktop/sigidwiki.desktop
sudo chown $USER $HOME/Desktop/sigidwiki.desktop

# Add installed applications into SIGpi menu
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SIGpi.directory $DESKTOP_FILES/sigidwiki.desktop
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SIGpi.directory $DESKTOP_FILES/sigpi_home.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Prep Complete"
echo -e "${SIGPI_BANNER_RESET}"
