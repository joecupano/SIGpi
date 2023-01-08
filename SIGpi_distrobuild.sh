#!/bin/bash

###
### SIGpi_distrobuild
###

###
###  REVISION: 20230107-0500
###

###
###  Usage:    SIGpi_distrobuild
###
###            Fresh build of SIGpi on a fresh OS install to be imaged for distro
###
###
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

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi
HAMRADIO_MENU_CATEGORY=HamRadio

###
### Environment tests
### 

# Are we the right hardware
if [ "$SIGPI_HWARCH" = "x86" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_HWARCH" = "x86_64" ]; then
    SIGPI_CERTIFIED="true"
fi

# Raspberry Pi 3B+ 
if [ "$SIGPI_HWARCH" = "armv7l" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_HWARCH" = "armhf" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_HWARCH" = "aarch64" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_CERTIFIED" = "false" ]; then
    echo "ERROR:  100 - Incorrect Hardware"
    echo "ERROR:"
    echo "ERROR:  Hardware must be x86, x86_64, armhf, or aarch64 hardware"
    echo "ERROR:"
    echo "ERROR:  Aborting"
    exit 1;
fi

# Are we the right operating system
if [ "$SIGPI_OSNAME" = "Debian GNU/Linux 11 (bullseye)" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_OSNAME" = "Ubuntu 20.04.3 LTS" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_OSNAME" = "Ubuntu 22.04.1 LTS" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_CERTIFIED" = "false" ]; then
    echo "ERROR:  200 - Incorrect Operating System"
    echo "ERROR:"
    echo "ERROR:  Operating system must be Debian GNU/Linux 11 (bullseye), Ubuntu 20.04.3 LTS, or Ubuntu 22.04.1 LTS."
    echo "ERROR:"
    echo "ERROR:  Aborting"
    exit 1;
fi

# Are we where we should be
if [ -f /home/$USER/SIG/SIGpi/SIGpi_installer.sh ]; then
    echo
else
    echo "ERROR:  300 - Software install setup issue"
    echo "ERROR:"
    echo "ERROR:  Repo must be cloned from within /home/$USER/SIG directory"
    echo "ERROR:  and SIGpi_installer.sh run from there."
    echo "ERROR:"
    echo "ERROR:  Aborting"
    exit 1;
fi


###
### FUNCTIONS
###

calc_wt_size() {

  # NOTE: it's tempting to redirect stderr to /dev/null, so supress error 
  # output from tput. However in this case, tput detects neither stdout or 
  # stderr is a tty and so only gives default 80, 24 values
  WT_HEIGHT=26
  WT_WIDTH=$(tput cols)

  if [ -z "$WT_WIDTH" ] || [ "$WT_WIDTH" -lt 60 ]; then
    WT_WIDTH=60
  fi
  if [ "$WT_WIDTH" -gt 178 ]; then
    WT_WIDTH=80
  fi
  WT_MENU_HEIGHT=$(($WT_HEIGHT-7))
}

select_startscreen(){
    TERM=ansi whiptail --title "SigPi DistroBuild" --clear --textbox $SIGPI_INSTALL_TXT1 34 100 16
}


###
###  MAIN
###

# Setup directories
mkdir $SIGPI_ETC
touch $SIGPI_CONFIG
mkdir $SIGPI_SOURCE
cd $SIGPI_SOURCE

# Flash a message/screen 
calc_wt_size
select_startscreen
TERM=ansi whiptail --title "SigPi DistroBuild" --clear --msgbox "Ready to Build" 12 120

# System Update & Upgrade
# Core Dependencies
# Desktop Prep
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get -y update
sudo apt-get -y upgrade

touch $SIGPI_CONFIG
echo "sigpi_desktop" >> $SIGPI_CONFIG    
cd $SIGPI_SOURCE

#source $SIGPI_SCRIPTS/install_swapspace.sh
source $SIGPI_SCRIPTS/install_core_dependencies.sh
source $SIGPI_SCRIPTS/install_desktop-prep.sh

# Install Core Devices
source $SIGPI_SCRIPTS/install_core_devices.sh
# Install LimeSDR
source $SIGPI_PACKAGES/pkg_limesuite install
# Install Ettus UHD
source $SIGPI_PACKAGES/pkg_ettus install
# Install RFM95W (Adafruit RadioBonnet 900 MHz LoRa-FSK)
source $SIGPI_SCRIPTS/install_devices_rfm95w.sh
# Install Libraries
source $SIGPI_SCRIPTS/install_libraries.sh
# Install APTdec (NOAA APT)
source $SIGPI_PACKAGES/pkg_aptdec install
# Install NRSC5 (HD Radio)
source $SIGPI_PACKAGES/pkg_nrsc5 install
# Install cm256cc
source $SIGPI_PACKAGES/pkg_cm256cc install
# Install mbelib (P25 Phase)
source $SIGPI_PACKAGES/pkg_mbelib install
# Install SeriaDV (AMBE3000 chip serial control)
source $SIGPI_PACKAGES/pkg_serialdv install
# Install DSDcc (Digital Speech Decoder)
source $SIGPI_PACKAGES/pkg_dsdcc install
# Install Codec 2
source $SIGPI_PACKAGES/pkg_codec2 install
# Install Multimon-NG (POCSAG, FSK, AFSK, DTMF, X10)
source $SIGPI_PACKAGES/pkg_multimon-ng install
# Install Radiosonde (Atmospheric Telemetry)
source $SIGPI_PACKAGES/pkg_radiosonde install
# Install Ubertooth Tools
source $SIGPI_PACKAGES/pkg_ubertooth-tools install
# Install Direwolf (AFSK APRS)
source $SIGPI_PACKAGES/pkg_direwolf install
# Install Linpac (AX.25 Terminal
source $SIGPI_PACKAGES/pkg_linpac install
# Install RTL_433
source $SIGPI_PACKAGES/pkg_rtl_433 install
# Install Dump1090
source $SIGPI_PACKAGES/pkg_dump1090 install
# Install GNUradio (3.10)
source $SIGPI_PACKAGES/pkg_gnuradio install
# gqrx
source $SIGPI_PACKAGES/pkg_gqrx install
# CubicSDR
source $SIGPI_PACKAGES/pkg_cubicsdr install
# SDRangel
source $SIGPI_PACKAGES/pkg_sdrangel install
source $SIGPI_PACKAGES/pkg_fftwf-wisdom install
# SDR++
source $SIGPI_PACKAGES/pkg_sdrpp install
# Fldigi
source $SIGPI_PACKAGES/pkg_fldigi install
# WSJT-X
# source $SIGPI_PACKAGES/pkg_wsjtx install
# Xastir
source $SIGPI_PACKAGES/pkg_xastir install
# QSSTV
source $SIGPI_PACKAGES/pkg_qsstv install
# JS8CALL
source $SIGPI_PACKAGES/pkg_js8call install
# Gpredict
source $SIGPI_PACKAGES/pkg_gpredict install
# CygnusRFI
source $SIGPI_PACKAGES/pkg_cygnusrfi install
# Wireshark
source $SIGPI_PACKAGES/pkg_wireshark install
# Kismet
source $SIGPI_PACKAGES/pkg_kismet install
# Audacity
source $SIGPI_PACKAGES/pkg_audacity install 
# PAVU 
source $SIGPI_PACKAGES/pkg_pavucontrol install
# splat
source $SIGPI_PACKAGES/pkg_splat install
# DOSbox
source $SIGPI_PACKAGES/pkg_dosbox install
# SIGpi Menus
source $SIGPI_SCRIPTS/install_desktop-post.sh

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Build Complete !!"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_RESET}"
sleep 7
sudo sync
exit 0
