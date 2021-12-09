#!/bin/bash

###
### SIGpi_shell
###

###
###  Usage:    sigpi [ACTION] [TARGET]
###
###        ACTION  
###                 install   install TARGET from current release
###                 remove    remove installed TARGET
###                 purge     remove installed TARGET and purge configs
###                 upgrade   upgrade TARGET to latest release
###
###        TARGET
###                 A SIGpi package 
###

###
###   REVISION: 20211209-0500
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

# Detect architecture (x86, x86_64, aarch64, ARMv8, ARMv7)
SIGPI_HWARCH=`lscpu|grep Architecture|awk '{print $2}'`
# Detect Operating system (Debian GNU/Linux 11 (bullseye) or Ubuntu 20.04.3 LTS)
SIGPI_OSNAME=`cat /etc/os-release|grep "PRETTY_NAME"|awk -F'"' '{print $2}'`

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

###
### Environment tests
### 

# Are we a sudoer
if ![ 'id | grep sudo' ]; then
    echo "ERROR:  007"
    echo "ERROR:  Must be run as user with sudo privileges"
    echo "ERROR:  Aborting"
fi

# Are we the right hardware
if [ "$SIGPI_HWARCH" != "x86"] || [ "$SIGPI_HWARCH" != "x86_64"] || [ "$SIGPI_HWARCH" != "aarch64" ] || [ "$SIGPI_HWARCH" != "armhf" ]; then
    echo "ERROR:  010"
    echo "ERROR:  Hardware must be x86, x86_64, armhf (Raspberry Pi 3/4), or aarch64 (Raspberry Pi 4)"
    echo "ERROR:  Aborting"
    exit 1;
fi

# Are we the right operating system
if [ "$SIGPI_OSNAME" != "Debian GNU/Linux 11 (bullseye)" ] || [ "$SIGPI_OSNAME" != "Ubuntu 20.04.3 LTS" ]; then
    echo "ERROR:  020"
    echo "ERROR:  Operating System must be Debian GNU/Linux 11 (bullseye) or Ubuntu 20.04.3 LTS"
    echo "ERROR:  Aborting"
    exit 1;
fi

# Are we where we should be
if [ -f /home/$USER/SIG/SIGpi/SIGpi_installer.sh ]; then
    echo
else
    echo "ERROR:  030"
    echo "ERROR:  Repo must be cloned from within /home/$USER/SIG directory"
    echo "ERROR:  and SIGpi_installer.sh run from there."
    echo "ERROR:  Aborting"
    exit 1;
fi


###
### FUNCTIONS
###


###
###  MAIN
###

ACTION = $1
SIG_PACKAGE = $2
SIG_PKGSCRIPT = "package_$2"

source $SIGPI_SCRIPTS/$2 $1

exit 0