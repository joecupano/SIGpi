#!/bin/bash

###
### SIGpi
###
### installer_hamlib
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install Hamlib 4.3 "
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

wget https://github.com/Hamlib/Hamlib/releases/download/4.3/hamlib-4.3.tar.gz -P $HOME/Downloads
tar -zxvf $HOME/Downloads/hamlib-4.3.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/hamlib-4.3
./configure --prefix=/usr/local --enable-static
make
sudo make install
sudo ldconfig

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"