#!/bin/bash

###
### SIGpi
###
### installer_qsstv
###

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install QSSTV"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

sudo apt-get install -y libhamlib-dev libv4l-dev
sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev
wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/qsstv
qmake
make
sudo make install

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"