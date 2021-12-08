#!/bin/bash

###
### SIGPI
###
### package_RTL_433
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 == "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove RTL_433"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/rtl_433/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/rtl_433
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   RTL_433 Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 == "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge RTL_433"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    cd $SIGPI_SOURCE/rtl_433/build
    sudo make uninstall
    sudo ldconfig
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/rtl_433

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   RTL_433 Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES
sudo apt-get install -y libtool libssl-dev

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install RTL_433"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/merbanan/rtl_433.git
cd rtl_433
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   RTL_433 Installed"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"