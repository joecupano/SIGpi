#!/bin/bash

###
### SIGpi_Installer_Template
###
### 

###
### INIT VARIABLES AND DIRECTORIES
###

# Package Versions
HAMLIB_PKG="hamlib-4.3.tar.gz"
FLXMLRPC_PKG="flxmlrpc-0.1.4.tar.gz"
FLRIG_PKG="flrig-1.4.2.tar.gz"
FLDIGI_PKG="fldigi-4.1.20.tar.gz"
WSJTX_PKG="wsjtx_2.4.0_armhf.deb"
QSSTV_PKG="qsstv_9.5.8.tar.gz"
GNURADIO_PKG="gnuradio_3.9"

# Source Directory
SIGPI_SOURCE=$HOME/source

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Desktop directories
SIGPI_THEMES=$SIGPI_HOME/themes
SIGPI_BACKGROUNDS=$SIGPI_THEMES/backgrounds
SIGPI_ICONS=$SIGPI_THEMES/icons
SIGPI_LOGO=$SIGPI_THEMES/logo
SIGPI_DESKTOP=$SIGPI_THEMES/desktop

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi

# SigPi Install Support files
SIGPI_CONFIG=$SIGPI_HOME/sigpi_installer_config.txt
SIGPI_INSTALL_TXT1=$SIGPI_HOME/updates/SIGpi-installer-1.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"


#
# INSTALL PACKAGE AS FUNCTION HERE
#

install_PACKAGE(){

    echo -e "${SIGPI_BANNER_COLOR}"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install PACKAGE"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
	echo -e "${SIGPI_BANNER_RESET}"

    #
    # CODE
    #
}

install_sigpimenu(){
	echo -e "${SIGPI_BANNER_COLOR}"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Install SIGpi Menu and Desktop Shortcuts"
	echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
	echo -e "${SIGPI_BANNER_RESET}"
    
	# Copy Menu items into relevant directories
	sudo cp $SIGPI_SOURCE/themes/desktop/PACKAGE.desktop $DESKTOP_FILES
	
	# Add SigPi Category for each installed application
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/PACKAGE.desktop
	
	# Add installed applications into SigPi menu
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/PACKAGE.desktop
}

###
###  MAIN
###

install_PACKAGE

install_sigpimenu

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"
exit 0