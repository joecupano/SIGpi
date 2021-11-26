#!/bin/bash

###
### SIGpi
###
### installer_mumble
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Mumble"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

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


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Installation Complete !!"
echo -e "${SIGPI_BANNER_RESET}"




