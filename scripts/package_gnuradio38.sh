#!/bin/bash

###
### SIGpi
###
### package_gnuradio
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 = "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove GNUradio"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove gnuradio gnuradio-dev
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   GNUradio Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 = "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge GNUradio"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get remove --purge gnuradio gnuradio-dev
    rm -rf $HOME/.gnuradio
    sudo rm -rf $SIGPI_DESKTOP/gnuradio-grc.desktop
    sudo rm -rf $DESKTOP_FILES/gnuradio-grc.desktop
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   GNUradio Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# DEPENDENCIES

# INSTALL
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install GNUradio 3.8"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y gnuradio gnuradio-dev

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   GnuRadio INstalled"
echo -e "${SIGPI_BANNER_RESET}"