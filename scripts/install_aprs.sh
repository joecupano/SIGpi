#!/bin/bash

###
### SIGpi
###
### installer_aprs
###

# DireWolf
if grep direwolf "$SIG_CONFIG"
then
   	cd $SIGPI_SOURCE
	git clone https://www.github.com/wb2osz/direwolf
	cd direwolf
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	make install-conf
fi

# Linpac
if grep linpac "$SIG_CONFIG"
then
   	sudo apt-get install -y linpac
fi

# Xastir
if grep xastir "$SIG_CONFIG"
then
   	sudo apt-get install -y xastir
fi

# Copy Menu items into relevant directories
sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"