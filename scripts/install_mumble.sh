#!/bin/bash

###
### SIGpi
###
### installer_mumble
###

sudo apt-get install -y mumble-server mumble

##
## Setting /etc/mumble-server.ini
##
cat <<EOF
autobanAttempts=3
autobanTimeframe=30
autobanTime=60
users=3
channelcountlimit=3
textmessagelength=140
EOF

TERM=ansi whiptail --infobox "When the pop-up window appears, answer NO to the first \
two questions. Last question will ask you to create a password for the SuperUser \
account to manage the VoIP server" 10 100
cd $SIGPI_SOURCE
sleep 9
sudo dpkg-reconfigure mumble-server

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"




