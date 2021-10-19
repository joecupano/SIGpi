#!/bin/bash

###
### SIGpi
###
### installer_dump1090
###

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Dump1090"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/antirez/dump1090
cd 1090
mkdir build; cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"