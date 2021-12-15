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

# If we reached this point our hardware and operating system are certified for SIGpi


###
### FUNCTIONS
###

sigpi_update(){

    ## POPPER
    if grep -q $2 $SIGPI_ETC/SIGpi_packages; then
        cd $SIGPI_SOURCE/$1/build
        sudo make uninstall
        sudo rm -rf $SIGPI_SOURCE/$1
    else
        echo "ERROR:  111"
        echo "ERROR:  No such SIGpi package "
        echo "ERROR:  Aborting"
    fi

    ## PUSHER 
    if grep -q $1 $SIGPI_ETC/SIGpi_packages; then
        if -f [$SIGPI_SOURCE/$1]; then
            echo "ERROR:  121"
            echo "ERROR:  You must remove the package first using SIGpi_popper <PACKAGE>"
            echo "ERROR:  Aborting"
            exit 1
        else
            SIGPI_INSTALLER="pkg_"$1
            source $SIGPI_SCRIPTS/$SIGPI_INSTALLER
        fi
    else
        echo "ERROR:  111"
        echo "ERROR:  No such SIGpi package "
        echo "ERROR:  Aborting"
    fi
}

sigpi_upgrade(){
    
}

###
###  MAIN
###

ACTION=$1
SIG_PACKAGE=$2
SIG_PKGSCRIPT="pkg_$2"

### Need to dtermin is this is an upgrade

if $1 = "update"
    sigpi_update
fi

if $1 = "upgrade"
    sigpi_upgrade
fi 

source $SIGPI_SCRIPTS/$SIG_PKGSCRIPT $1

exit 0