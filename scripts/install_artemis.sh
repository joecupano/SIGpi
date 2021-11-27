#!/bin/bash

###
### SIGpi
###
### installer_artemis
###

# Artemis
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Artemis"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
cd $SIGPI_SOURCE
if grep artemis "$SIGPI_CONFIG"
then
   	cd $HOME/Downloads
	# Note; this link specific to this arch 1045 for armfh, 193 for amd64
	wget https://aresvalley.com/download/1045/ 
	mv index.html artemis.tar.gz
	tar -zxvf artemis.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/artemis
	sudo cp artemis3.svg /usr/share/icons/
fi


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Artemis Installed"
echo -e "${SIGPI_BANNER_RESET}"
