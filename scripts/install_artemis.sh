#!/bin/bash

###
### SIGpi
###
### installer_artemis
###

# Artemis
echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Artemis"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

if grep artemis "$SIGBOX_CONFIG"
then
   	cd $HOME/Downloads
	wget https://aresvalley.com/download/193/ 
	mv index.html artemis.tar.gz
	tar -zxvf artemis.tar.gz -C $SIGBOX_SOURCE
	cd $SIGBOX_SOURCE/artemis
	sudo cp artemis3.svg /usr/share/icons/
fi

# Copy Menu items into relevant directories
sudo cp $SIGPI_SOURCE/themes/desktop/artemis.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/artemis.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"
