#!/bin/bash

###
### SIGpi
###
### package_wireshark
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 = "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove Wireshark"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove --purge wireshark wireshark-dev libwireshark-dev
    cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbb/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbredr
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
    rm -rf $SIGPI_SOURCE/libbtb
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   Wireshark Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 = "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge Wireshark"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove --purge wireshark wireshark-dev libwireshark-dev
    cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbb/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbredr
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
    rm -rf $SIGPI_SOURCE/libbtb
    rm -rf $HOME/.config/wireshark

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   Wireshark Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES


# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Wireshark"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y wireshark wireshark-dev libwireshark-dev
cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbb
mkdir build && cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make -j4
sudo make install
	
# BTBR Plugin
cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbredr
mkdir build && cd build
cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
make -j4
sudo make install

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Wireshark Installed"
echo -e "${SIGPI_BANNER_RESET}"