#!/bin/bash

###
### SIGPI
###
### package_dump1090
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 == "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove dump1090"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
	rm -rf $SIGPI_SOURCE/dump1090
    sudo rm /usr/local/bin/dump1090
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   dump1090 Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 == "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge dump1090"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
	rm -rf $SIGPI_SOURCE/dump1090
    sudo rm /usr/local/bin/dump1090
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   dump1090 Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Dump1090"
echo -e "${SIGPI_BANNER_COLOR} #"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/antirez/dump1090.git
cd dump1090
make -j4
sudo cp dump1090 /usr/local/bin/dump1090

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Dump1090 Installed"
echo -e "${SIGPI_BANNER_RESET}"