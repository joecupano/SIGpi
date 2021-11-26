#!/bin/bash

###
### SIGpi_installer
###

###
###   REVISION: 2021126-0500
###

###
### This script is part of the SIGbox Project.
###
### Given a Raspberry Pi 4 4GB RAM 32GB microSD with Raspberry Pi OS Full (32-bit) installed
### This script installs drivers and applications for RF use cases that include hacking and 
### Amateur Radio Digital Modes.
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
    TERM=ansi whiptail --title "SigPi Installer" --clear --textbox $SIGPI_INSTALL_TXT1 34 100 16
}

select_gnuradio() {
    FUN=$(whiptail --title "SigPi Installer" --radiolist --clear --separate-output \
        "GNUradio version" 20 80 12 \
		"gnuradio38" "GNU Radio 3.8 " ON \
        "gnuradio37" "GNU Radio 3.9 " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_sdrapps() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "General Purpose SDR Applications" 20 80 12 \
        "gqrx" "SDR Receiver " OFF \
        "cubicsdr" "SDR Receiver " OFF \
        "sdrangel" "SDRangel " OFF \
		"sdrpp" "SDR++ " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_amateurradio() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Amateur Radio Applications" 24 120 12 \
        "fldigi" "Fldigi 4.1.01 for MFSK, PSK31, CW, RTTY. WEFAX and many others " OFF \
        "qsstv" "QSSTV 9.2.6 for SSTV modes " OFF \
        "wsjtx" "WSJT-X 2.5.1 for FT8, JT4, JT9, JT65, QRA64, ISCAT, MSK144, and WSPR " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_usefulapps() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Useful Applications" 20 120 12 \
        "artemis" "Real-time SIGINT from your SDR " OFF \
        "gpredict" "Satellite Tracking " OFF \
		"splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
		"wireshark" "Network Traffic Analyzer " OFF \
        "kismet" "Wireless sniffer and monitor " OFF \
        "audacity" "Audio Editor " OFF \
        "pavu" "PulseAudio Control " OFF \
        "mumble" "VoIP Server and Client " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

###
###  MAIN
###

touch $SIGPI_CONFIG
calc_wt_size
select_startscreen
select_gnuradio
select_sdrapps
select_amateurradio
select_usefulapps
TERM=ansi whiptail --title "SigPi Installer" --clear --msgbox "Ready to Install" 12 120

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get -y update
sudo apt-get -y upgrade

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Create Directories"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

if [ ! -d "$SIGPI_SOURCE" ]; then
  	mkdir $SIGPI_SOURCE
fi
    
if [ ! -d "$SIGPI_HOME" ]; then
  	mkdir $SIGPI_HOME
fi
    
cd $SIGPI_SOURCE

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Create Temporary Swap"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

source $SIGPI_SCRIPTS/install_dependencies.sh
source $SIGPI_SCRIPTS/install_devices.sh
source $SIGPI_SCRIPTS/install_libraries.sh
source $SIGPI_SCRIPTS/install_rtl_433.sh
source $SIGPI_SCRIPTS/install_radiosonde.sh
source $SIGPI_SCRIPTS/install_direwolf.sh

# GNU Radio
if grep gnuradio38 "$SIGPI_CONFIG"; then
    sudo apt-get install -y gnuradio gnuradio-dev
fi

if grep gnuradio39 "$SIGPI_CONFIG"; then
	source $SIGPI_SCRIPTS/install_gnuradio39.sh
fi

# gqrx
if grep gqrx "$SIGPI_CONFIG"; then
    sudo apt-get install -y gqrx-sdr
fi

# CubicSDR
if grep cubicsdr "$SIGPI_CONFIG"; then
    sudo apt-get install -y cubicsdr
fi

# SDRangel
if grep sdrangel "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_sdrangel.sh
fi

# SDR++
if grep sdrpp "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_sdrpp.sh
fi

# Fldigi
if grep fldigi "$SIGPI_CONFIG"; then
    sudo apt-get install -y fldigi
fi

#if grep fldigi4120 "$SIGPI_CONFIG"; then
#    source $SIGPI_SCRIPTS/install_fldigi.sh
#fi

# WSJT-X
if grep wsjtx "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_wsjtx.sh
fi

# QSSTV
if grep qsstv "$SIGPI_CONFIG"; then
	sudo apt-get install -y qsstv
fi

#if grep qsstv958 "$SIGPI_CONFIG"; then
#    source $SIGPI_SCRIPTS/install_qsstv.sh
#fi

# Gpredict
if grep gpredict "$SIGPI_CONFIG"; then
    sudo apt-get install -y gpredict
fi

# Artemis
#if grep artemis "$SIGPI_CONFIG"; then
#	source $SIGPI_SCRIPTS/install_artemis.sh
#fi

# Wireshark
if grep wireshark "$SIGPI_CONFIG"; then
	source $SIGPI_SCRIPTS/install_wireshark.sh
fi

# Kismet
if grep kismet "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_kismet.sh
fi

# Audacity
if grep audacity "$SIGPI_CONFIG"; then
    sudo apt-get install -y audacity
fi

# PAVU
if grep pavu "$SIGPI_CONFIG"; then
    sudo apt-get install -y pavucontrol
fi

# splat
if grep splat "$SIGPI_CONFIG"; then
    sudo apt-get install -y splat
fi

# mumble
if grep mumble "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_mumble.sh
fi

# SIGpi Menu
#source $SIGPI_SCRIPTS/install_sigpimenu.sh

# Turn of Swapfile
sudo swapoff /swapfile
sleep 5
sudo rm -rf /swapfile

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   System needs to reboot for all changes to occur"
echo -e "${SIGPI_BANNER_COLOR} ##   Reboot will begin in 15 seconsds unless CTRL-C hit"
echo -e "${SIGPI_BANNER_RESET}"
sleep 17
sudo sync
sudo reboot
exit 0