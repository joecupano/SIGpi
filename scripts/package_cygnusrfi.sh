#!/bin/bash

###
### SIGpi
###
### package_cygnusrfi
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if [ $1 = "remove" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove CygnusRFI"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/CygnusRFI
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   CygnusRFI Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if [ $1 = "purge" ]; then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge CygnusRFI"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"
    cd $SIGPI_SOURCE
	rm -rf $SIGPI_SOURCE/CygnusRFI
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   CygnusRFI Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install CygnusRFI"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES

## PACKAGE
cd $SIGPI_SOURCE
git clone https://github.com/0xCoto/CygnusRFI.git

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   CygnusRFI Installed"
echo -e "${SIGPI_BANNER_RESET}"
