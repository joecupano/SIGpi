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
### FUNCTIONS
###


###
###  MAIN
###

ACTION=$1
SIG_PACKAGE=$2
SIG_PKGSCRIPT="package_$2"

source $SIGPI_SCRIPTS/$2 $1

exit 0