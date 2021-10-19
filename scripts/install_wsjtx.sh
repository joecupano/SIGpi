#!/bin/bash

###
### SIGpi
###
### installer_wsjtx
###

echo -e "${SIGBOX_BANNER_COLOR}"
echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#   Install WSJT-X"
echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
echo -e "${SIGBOX_BANNER_RESET}"

wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.4.0_armhf.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb
# Will get error next command fixes error and downloads dependencies
sudo apt-get --fix-broken install
sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb

# Copy Menu items into relevant directories
sudo cp $SIGPI_SOURCE/themes/desktop/sdrpp.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"