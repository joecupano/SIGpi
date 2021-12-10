#!/bin/bash

###
### SIGPI
###
### package_qsstv
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if [ $1 = "remove" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove QSSTV"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove qsstv
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if [ $1 = "purge" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge QSSTV"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove --purge qsstv
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install QSSTV"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES

## PACKAGE
cd $SIGPI_SOURCE
sudo apt-get install -y qsstv

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   QSSTV Installed"
echo -e "${SIGPI_BANNER_RESET}"