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
###                 nuke      completely remove all of SIGpi
###                 update    check to see if new TARGET available
###                 upgrade   upgrade TARGET to latest release
###                 shell     provide SIGpi env variables around a TARGET
###
###        TARGET
###                 A SIGpi package or script
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
SIGPI_DEBS=$SIGPI_HOME/debs

# SIGpi Install Support files
SIGPI_INSTALLER=$SIGPI_ETC/INSTALL_CONFIG
SIGPI_CONFIG=$SIGPI_ETC/INSTALLED
SIGPI_PKGLIST=$SIGPI_PACKAGES/PACKAGES
SIGPI_INSTALL_TXT1=$SIGPI_SCRIPTS/scr_install_welcome.txt
SIGPI_INSTALLSRC_TXT1=$SIGPI_SCRIPTS/scr_install-srv_welcome.txt
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

# SIGpi Menu category
SIGPI_MENU_CATEGORY=SIGpi
HAMRADIO_MENU_CATEGORY=HamRadio

# If we reached this point our hardware and operating system are certified for SIGpi


###
### FUNCTIONS
###

sigpi_update(){
    # Check for available updates to package
    wget https://raw.githubusercontent.com/joecupano/SIGpi/main/packages/PACKAGES -P $HOME/Downloads
    
    if grep $3 "$HOME/Downloads/PACKAGES"; then
        SIG_PKGSTAMP = 'grep $3 "$SIGPI_HOME/packages/PACKAGES"| cut -d,-f2'
        SIG_PKGNEW = 'grep $3 "$HOME/Downloads/PACKAGES"| cut -d,-f2'
        if $SIG_PKGNEW > $SIG_PKGSTAMP; then
            echo "Update is available"
        else
            echo "No updatess available"
        fi
    fi
}

sigpi_upgrade(){
    # Remove Package, update local clone, install updated package
    cd $SIGPI_HOME
    source $SIGPI_PACKAGES/$SPKGSCRIPT remove
    git pull
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
    nuke )
        Lines=$(cat $SIGPI_PKGLIST)
        for Line in $Lines
        do
            first_part=${Line%,*}   # removes the , and everything after it
            second_part=${Line#*,}  # removes the , and everything before it
            dahpkg="pkg_$first_part"
            source $SIGPI_PACKAGES/$dahpkg purge
        done
        $SIGPI_PACKAGES/remove_desktop-prep.sh
        $SIGPI_PACKAGES/remove_desktop-post.sh
        ;;
    install )
        source $SIGPI_PACKAGES/$SPKGSCRIPT install
        ;;
    build )
        source $SIGPI_PACKAGES/$SPKGSCRIPT build
        ;;
    config )
        source $SIGPI_PACKAGES/$SCFGSCRIPT $3
        ;;
    update )
        sigpi_update $3
        ;;
    upgrade)
        sigpi_upgrade $3
        ;;
    shell )
        source $2
        ;;
    * )
        echo -e "${SIGPI_BANNER_COLOR}"
        echo -e "${SIGPI_BANNER_COLOR} ##  ERROR: Unkown action or package"
        echo -e "${SIGPI_BANNER_RESET}"
        ;;
esac

exit 0
