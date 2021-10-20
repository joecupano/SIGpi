#!/bin/bash

###
### SIGpi_installer
###

###
###   REVISION: 2021021-2300
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

# Source Directory
SIGPI_SOURCE=$HOME/source

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGpi
SIGPI_DEP=$SIGPI_HOME/dependencies
SIGPI_SCRIPTS=$SIGPI_HOME/scripts

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

# SigPi Install Support files
SIGPI_CONFIG=$SIGPI_HOME/INSTALL_CONFIG
SIGPI_INSTALL_TXT1=$SIGPI_DEP/SIGpi-installer-1.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"


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
    TERM=ansi whiptail --title "SigPi Installer" --textbox $SIGPI_INSTALL_TXT1 24 120 16
}

select_sdrdevices() {
    FUN=$(whiptail --title "SDR Devices" --checklist --separate-output \
        "Choose SDR devices " 20 80 12\
        "rtl-sdr" "RTL2832U & R820T2-Based " ON \
        "hackrf" "Hack RF One " ON \
        "libiio" "PlutoSDR " OFF \
        "limesuite" "LimeSDR " OFF \
        "soapysdr" "SoapySDR Library " ON \
        "soapyremote" "Use any Soapy SDR Remotely " ON \
        "soapyrtlsdr" "Soapy SDR Module for RTLSDR " ON \
        "soapyhackrf" "Soapy SDR Module for HackRF One " ON \
        "soapyplutosdr" "Soapy SDR Module for PlutoSD " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_gnuradio() {
    FUN=$(whiptail --title "GNUradio" --radiolist --separate-output \
        "Choose GNUradio version" 20 80 12 \
        "gnuradio37" "GNU Radio 3.7 " OFF \
		"gnuradio38" "GNU Radio 3.8 " ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_sdrapps() {
    FUN=$(whiptail --title "SDR Applications" --checklist --separate-output \
        "SDR Applications" 20 80 12 \
        "gqrx" "SDR Receiver " OFF \
        "cubicsdr" "SDR Receiver " OFF \
        "sdrangel" "SDRangel " ON \
		"sdrplusplus" "SDR++ " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_amateurradio() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Amateur Radio Applications" 20 80 12 \
        "fldigi4101" "Fldigi 4.1.01 for MFSK, PSK31, CW, RTTY. WEFAX and many others " ON \
        "fldigi4120" "Fldigi 4.1.20 Compiled (~40 minutes compile time) " OFF \
        "wsjtx" "WSJT-X 2.5.0 for FT8, JT4, JT9, JT65, QRA64, ISCAT, MSK144, and WSPR" ON \
        "qsstv926" "QSSTV 9.2.6 for SSTV modes " OFF \
        "qsstv958" "QSSTV 9.5.8 Compiled (~30 minutes compile time) " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG

    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Packet Radio Applications" 20 80 12 \
        "direwolf" "DireWolf 1.7 Soundcard TNC for APRS " OFF \
        "linpac" "Packet Radio Temrinal with mail client " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_CONFIG
}

select_usefulapps() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Useful Applications" 20 120 12 \
		"artemis" "Real-time RF Signal Recognition to a large database of signals " OFF \
        "gps" "GPS client and NTP sync " OFF \
        "gpredict" "Satellite Tracking " OFF \
		"splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
		"wireshark" "Network Traffic Analyzer " OFF \
        "kismet" "Wireless sniffer and monitor " OFF \
        "audacity" "Audio Editor " OFF \
        "pavu" "PulseAudio Control " OFF \
        "mumble" "VoIP Server and Client " OFF \
        "tempest" "Uses your computer monitor to send out AM radio signals" OFF \
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
select_sdrdevices
select_gnuradio
select_decoders
select_sdrapps
select_amateurradio
select_usefulapps
TERM=ansi whiptail --title "SigPi Installer" --msgbox "Ready to Install" 12 120

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   System Update & Upgrade"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get -y update
sudo apt-get -y upgrade

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Create Directories"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

if [ ! -d "$SIGPI_SOURCE" ]; then
  	mkdir $SIGPI_SOURCE
fi
    
if [ ! -d "$SIGPI_HOME" ]; then
  	mkdir $SIGPI_HOME
fi
    
cd $SIGPI_SOURCE

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Create Temporary Swap"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

source $SIGPI_SCRIPTS/install_dependencies.sh
source $SIGPI_SCRIPTS/install_devices.sh
source $SIGPI_SCRIPTS/install_libraries.sh
source $SIGPI_SCRIPTS/install_decoders.sh
source $SIGPI_SCRIPTS/install_rtl_433.sh
source $SIGPI_SCRIPTS/install_radiosonde.sh

# GNU Radio
if grep gnuradio37 "$SIGPI_CONFIG"; then
    sudo apt-get install -y gnuradio gnuradio-dev
fi

if grep gnuradio38 "$SIGPI_CONFIG"; then
	source $SIGPI_SCRIPTS/install_gnuradio38.sh
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

# APRS
source $SIGPI_SCRIPTS/install_aprs.sh

# Fldigi
if grep fldigi4101 "$SIGPI_CONFIG"; then
    sudo apt-get install -y fldigi
fi

if grep fldigi4120 "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_fldigi.sh
fi

# WSJT-X
if grep wsjtx "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_wsjtx.sh
fi

# QSSTV
if grep qsstv926 "$SIGPI_CONFIG"; then
	sudo apt-get install -y qsstv
fi

if grep qsstv958 "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_qsstv.sh
fi

# Gpredict
if grep gpredict "$SIGPI_CONFIG"; then
    sudo apt-get install -y gpredict
fi

# Artemis
if grep artemis "$SIGBOX_CONFIG"; then
	source $SIGPI_SCRIPTS/install_artemis.sh
fi

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

# GPS
if grep gps "$SIGPI_CONFIG"; then
    sudo apt-get install -y gpsd gpsd-clients python-gps chrony
fi

# splat
if grep splat "$SIGPI_CONFIG"; then
    sudo apt-get install -y splat
fi

# mumble
if grep mumble "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_mumble.sh
fi

# Tempest for Eliza
if grep tempest "$SIGPI_CONFIG"; then
    source $SIGPI_SCRIPTS/install_tempest-eliza.sh
fi

# SIGpi Menu
source $SIGPI_SCRIPTS/install_sigpimenu.sh

# Turn of Swapfile
sudo swapoff /swapfile

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   System needs to reboot for all changes to occur"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Reboot will begin in 15 seconsds unless CTRL-C hit"
echo -e "${SIGPI_BANNER_RESET}"
sleep 17
sudo sync
sudo reboot
exit 0