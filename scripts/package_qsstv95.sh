#!/bin/bash

###
### SIGpi
###
### package_qsstv95
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 = "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove QSSTV 9.5.X"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/qsstv/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/qsstv
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV 9.5.X Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 = "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge QSSTV 9.5.X"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/qsstv/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/qsstv
    rm -rf $HOME/qsstv
    sudo rm -rf $SIGPI_DESKTOP/qsstv.desktop
    sudo rm -rf $DESKTOP_FILES/qsstv.desktop
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV 9.5.X Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES
sudo apt-get install -y g++ 
sudo apt-get install -y libfftw3-dev 
sudo apt-get install -y qtbase5-dev 
sudo apt-get install -y qtchooser
sudo apt-get install -y qt5-qmake 
sudo apt-get install -y qtbase5-dev-tools
sudo apt-get install -y libpulse-dev
sudo apt-get install -y libhamlib-dev
sudo apt-get install -y libasound2-dev 
sudo apt-get install -y libv4l-dev
sudo apt-get install -y libopenjp2-7
sudo apt-get install -y libopenjp2-7-dev

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install QSSTV 9.5.X"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
cd $SIGPI_SOURCE/qsstv
qmake
make
sudo make install

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV 9.5.X Installed !!"
echo -e "${SIGPI_BANNER_RESET}"