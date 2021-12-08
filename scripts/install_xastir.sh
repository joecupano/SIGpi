#!/bin/bash

###
### SIGPI
###
### package_xastir
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 == "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove Xastir"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
    cd $SIGPI_SOURCE
    sudo apt-get remove xastir
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   Xastir Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 == "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge Xastir"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
    cd $SIGPI_SOURCE
    sudo apt-get remove --purge xastir
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   Xastir Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Xastir"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
sudo apt-get install xastir

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Xastir Installed"
echo -e "${SIGPI_BANNER_RESET}"


