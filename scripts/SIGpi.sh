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
### INIT VARIABLES AND DIRECTORIES
###

# SIGpi Directory tree
SIGPI_ROOT=$HOME/SIG
SIGPI_SOURCE=$SIGPI_ROOT/source
SIGPI_HOME=$SIGPI_ROOT/SIGpi
SIGPI_ETC=$SIGPI_ROOT/etc
SIGPI_SCRIPTS=$SIGPI_HOME/scripts
SIGPI_PACKAGES=$SIGPI_HOME/packages

# SigPi Install Support files
SIGPI_CONFIG=$SIGPI_ETC/INSTALL_CONFIG
SIGPI_PKGLIST=$SIGPI_PACKAGES/SIGpi_packages
SIGPI_INSTALL_TXT1=$SIGPI_SCRIPTS/scr_install_welcome.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"

# Detect architecture (x86, x86_64, aarch64, ARMv8, ARMv7)
SIGPI_HWARCH=`lscpu|grep Architecture|awk '{print $2}'`
# Detect Operating system (Debian GNU/Linux 11 (bullseye) or Ubuntu 20.04.3 LTS)
SIGPI_OSNAME=`cat /etc/os-release|grep "PRETTY_NAME"|awk -F'"' '{print $2}'`
# Is Platform good for install- true or false - we start with false
SIGPI_CERTIFIED="false"

# Desktop Source directories
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

# If we reached this point our hardware and operating system are certified for SIGpi


###
### FUNCTIONS
###

sigpi_update(){
    # Update local clone
    cd $SIGPI_HOME
    git pull
}

sigpi_upgrade(){
    # Update local clone
    cd $SIGPI_HOME
    git pull
    source $SIGPI_PACKAGES/$SPKGSCRIPT remove
    source $SIGPI_PACKAGES/$SPKGSCRIPT install
}

###
###  MAIN
###

ACTION=$1
SPACKAGE=$2
SPKGSCRIPT="pkg_$2"
SCFGSCRIPT="cfg_$2"

case "$1" in 
    remove )
        source $SIGPI_PACKAGES/$SPKGSCRIPT remove
        ;;
    purge )
        source $SIGPI_PACKAGES/$SPKGSCRIPT purge
        ;;
    install )
        source $SIGPI_PACKAGES/$SPKGSCRIPT install
        ;;
    config )
        source $SIGPI_PACKAGES/$SCFGSCRIPT $3
        ;;
    update )
        sigpi_update
        ;;
    upgrade)
        sigpi_upgrade
        ;;

    * )
        echo -e "${SIGPI_BANNER_COLOR}"
        echo -e "${SIGPI_BANNER_COLOR} ##  ERROR: Unkown action or package"
        echo -e "${SIGPI_BANNER_RESET}"
        ;;
esac

exit 0
