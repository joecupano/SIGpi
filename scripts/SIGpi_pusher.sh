#!/bin/bash

###
### SIGpi_pusher
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
SIGPI_DEP=$SIGPI_HOME/dependencies
SIGPI_SCRIPTS=$SIGPI_HOME/scripts

# SigPi Install Support files
SIGPI_CONFIG=$SIGPI_HOME/INSTALL_CONFIG
SIGPI_INSTALL_TXT1=$SIGPI_DEP/SIGpi-installer-1.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"

# Detect architecture (x86, x86_64, amd64, armv7l etc)
SIGPI_MACHINE_TYPE=`uname -m`
#SIGPI_OSID='cat /etc/os-release|grep ID=ubuntu|sed "s/"ID="//"'
#SIGPI_VERID='cat /etc/os-release|grep VERSION_ID|sed "s/"VERSION_ID="//"'

# Desktop directories
SIGPI_BACKGROUNDS=$SIGPI_HOME/backgrounds
SIGPI_ICONS=$SIGPI_HOME/icons
SIGPI_LOGO=$SIGPI_HOME/logo
SIGPI_DESKTOP=$SIGPI_HOME/desktop

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi
HAMRADIO_MENU_CATEGORY=HamRadio

if grep -q $1 $SIGPI_DEP/SIGpi_packages; then
    if -f [$SIGPI_SOURCE/$1]; then
        echo "ERROR:  121"
        echo "ERROR:  You must remove the package first using SIGpi_popper <PACKAGE>"
        echo "ERROR:  Aborting"
        exit 1
    fi
    SIGPI_INSTALLER="package_"$1".sh"
    source $SIGPI_SCRIPTS/$SIGPI_INSTALLER
else
    echo "ERROR:  111"
    echo "ERROR:  No such SIGpi package "
    echo "ERROR:  Aborting"
fi
exit 0