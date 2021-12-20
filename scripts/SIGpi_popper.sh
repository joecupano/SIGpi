#!/bin/bash

###
### SIGpi_popper
###

###
###   REVISION: 2021126-0500
###

###
### INIT VARIABLES AND DIRECTORIES
###

# SIGpi Root Directory
SIGPI_SOURCE=$HOME/SIG

# SIGpi directories
SIGPI_HOME=$SIGPI_SOURCE/SIGpi
SIGPI_ETC=$SIGPI_HOME/etc
SIGPI_SCRIPTS=$SIGPI_HOME/scripts
SIGPI_PACKAGES=$SIGPI_HOME/packages

# SigPi Install Support files
SIGPI_CONFIG=$SIGPI_ETC/INSTALL_CONFIG
SIGPI_INSTALL_TXT1=$SIGPI_ETC/SIGpi-installer-1.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"

# Detect architecture (x86, x86_64, aarch64, ARMv8, ARMv7)
SIGPI_HWARCH=`lscpu|grep Architecture|awk '{print $2}'`
# Detect Operating system (Debian GNU/Linux 11 (bullseye) or Ubuntu 20.04.3 LTS)
SIGPI_OSNAME=`cat /etc/os-release|grep "PRETTY_NAME"|awk -F'"' '{print $2}'`
# Is Platform good for install- true or false - we start with false
SIGPI_CERTIFIED="false"

# Desktop Destination Directories
SIGPI_DESKTOP_DIRECTORY=/usr/share/SIGpi/desktop-directories
SIGPI_DESKTOP_FILES=/usr/share/SIGpi/applications
SIGPI_DESKTOP_ICONS=/usr/share/SIGpi/icons
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi
HAMRADIO_MENU_CATEGORY=HamRadio

if grep -q $1 $SIGPI_CONFIG; then
    if [ -d $SIGPI_SOURCE/$1 ]; then
        cd $SIGPI_SOURCE/$1/build
        sudo make uninstall
        sudo rm -rf $SIGPI_SOURCE/$1
    else
        sudo apt-get remove $1
    fi
else
    echo "+++++++++"
    echo "ERROR 200: SIGpi Package not installed"
    echo "+++++++++"
    exit 1
fi
exit 0
