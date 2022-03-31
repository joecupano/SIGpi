#!/bin/bash

###
### SIGpi_installer
###

###
###  REVISION: 20211228-0700
###

###
###  Usage:    SIGpi_installer
###
###            Fresh install of SIGpi on a fresh OS install
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

if [ "$SIGPI_CERTIFIED" = "false" ]; then
    echo "ERROR:  200 - Incorrect Operating System"
    echo "ERROR:"
    echo "ERROR:  Operating system must be Debian GNU/Linux 11 (bullseye) or Ubuntu 20.04.3 LTS."
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
    TERM=ansi whiptail --title "SigPi Installer" --clear --textbox $SIGPI_INSTALL_TXT1 34 100 16
}

select_devices() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Select additional devices to install " 20 80 12 \
        "ettus" "Ettus Research USRP UHD" OFF \
        "rfm95w" "(RPi only) Adafruit LoRa Radio Bonnet - RFM95W @ 915 MHz " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_INSTALLER
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_gnuradio() {
    FUN=$(whiptail --title "SigPi Installer" --radiolist --clear --separate-output \
        "Select a GNUradio version" 20 80 12 \
		"gnuradio38" "GNU Radio 3.8 " ON \
        "gnuradio39" "GNU Radio 3.9 " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIGPI_INSTALLER
}

select_sdrapps() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Select SDR Applications" 20 80 12 \
        "rtl_433" "RTL_433 " OFF \
        "dump1090" "Dump 1090 " OFF \
        "gqrx" "SDR Receiver " OFF \
        "cubicsdr" "SDR Receiver " OFF \
        "sdrangel" "SDRangel " OFF \
		"sdrpp" "SDR++ " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_INSTALLER
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_amateurradio() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Select Amateur Radio Applications" 24 120 12 \
        "fldigi" "Fldigi 4.1.18 for MFSK, PSK31, CW, RTTY. WEFAX and many others " OFF \
        "js8call" "js8call 2.20 for another digital mode" OFF \
        "qsstv" "QSSTV 9.4.X for SSTV modes " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_INSTALLER
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_usefulapps() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Useful Applications" 20 120 12 \
        "HASviolet" "(RPi only) LoRa and FSK transceiver project " OFF \
        "cygnusrfi" "RFI) analysis tool, based on Python and GNU Radio Companion (GRC)" OFF \
        "gpredict" "Satellite Tracking " OFF \
		"splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
		"wireshark" "Network Traffic Analyzer " OFF \
        "kismet" "Wireless sniffer and monitor " OFF \
        "audacity" "Audio Editor " OFF \
        "pavu" "PulseAudio Control " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_INSTALLER
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}


###
###  MAIN
###

# Setup directories
mkdir $SIGPI_ETC
touch $SIGPI_CONFIG
mkdir $SIGPI_SOURCE
cd $SIGPI_SOURCE

# Node option invoked ?
if [ "$1" = "node" ]; then
    calc_wt_size

    TERM=ansi whiptail --title "SigPi Node Install" --clear --msgbox "Ready to Install" 12 120

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get -y update
    sudo apt-get -y upgrade

    touch $SIGPI_CONFIG
    echo "sigpi_node" >> $SIGPI_CONFIG
    cd $SIGPI_SOURCE

    source $SIGPI_SCRIPTS/install_server_dependencies.sh
    source $SIGPI_SCRIPTS/install_core_devices.sh
    source $SIGPI_PACKAGES/pkg_rtl_433 install
    source $SIGPI_PACKAGES/pkg_dump1090 install
    source $SIGPI_PACKAGES/pkg_multimon-ng install
    source $SIGPI_PACKAGES/pkg_radiosonde install
    source $SIGPI_PACKAGES/pkg_sigpi-node install $2

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   SIGpi Node Installation Complete !!"
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

fi

# Otherwise we are Full install

calc_wt_size
select_startscreen
select_devices
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

touch $SIGPI_CONFIG
echo "sigpi_desktop" >> $SIGPI_CONFIG    
cd $SIGPI_SOURCE

#source $SIGPI_SCRIPTS/install_swapspace.sh
source $SIGPI_SCRIPTS/install_core_dependencies.sh
source $SIGPI_SCRIPTS/install_desktop-prep.sh
source $SIGPI_SCRIPTS/install_core_devices.sh
source $SIGPI_PACKAGES/pkg_limesuite install

# UHD - Ettus
if grep ettus "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_ettus install
fi

# RFM95W  (Adafruit RadioBonnet 900 MHz LoRa-FSK)
if grep rfm95w "$SIGPI_INSTALLER"; then
    source $SIGPI_SCRIPTS/install_devices_rfm95w.sh
fi

source $SIGPI_SCRIPTS/install_libraries.sh
source $SIGPI_PACKAGES/pkg_aptdec install
source $SIGPI_PACKAGES/pkg_nrsc5 install

source $SIGPI_PACKAGES/pkg_cm256cc install
source $SIGPI_PACKAGES/pkg_mbelib install
source $SIGPI_PACKAGES/pkg_serialdv install
source $SIGPI_PACKAGES/pkg_dsdcc install
source $SIGPI_PACKAGES/pkg_codec2 install

source $SIGPI_PACKAGES/pkg_multimon-ng install
source $SIGPI_PACKAGES/pkg_radiosonde install
source $SIGPI_PACKAGES/pkg_ubertooth-tools install
source $SIGPI_PACKAGES/pkg_direwolf install
source $SIGPI_PACKAGES/pkg_linpac install

# RTL_433
if grep rtl_433 "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_rtl_433 install
fi

# Dump1090
if grep gnuradio38 "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_dump1090 install
fi

# GNU Radio
if grep gnuradio38 "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gnuradio38 install
fi

if grep gnuradio39 "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gnuradio39 install
fi

# gqrx
if grep gqrx "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gqrx install
fi

# CubicSDR
if grep cubicsdr "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_cubicsdr install
fi

# SDRangel
if grep sdrangel "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sdrangel install
fi

source $SIGPI_PACKAGES/pkg_fftwf-wisdom install

# SDR++
if grep sdrpp "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sdrpp install
fi

# Fldigi
if grep fldigi "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_fldigi install
fi

# WSJT-X
#if grep wsjtx "$SIGPI_INSTALLER"; then
#    source $SIGPI_PACKAGES/pkg_wsjtx install
#fi

# Xastir
if grep xastir "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_xastir install
fi

# QSSTV
if grep qsstv "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_qsstv install
fi

# QSSTV 9.5.X
#if grep qsstv95 "$SIGPI_INSTALLER"; then
#    source $SIGPI_PACKAGES/pkg_qsstv95 install
#fi

# JS8CALL
if grep js8call "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_js8call install
fi

# Gpredict
if grep gpredict "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gpredict install
fi

# HASviolet
if grep HASviolet "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_hasviolet install
fi

# CygnusRFI
if grep cygnusrfi "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_cygnusrfi install
fi

# Wireshark
if grep wireshark "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_wireshark install
fi

# Kismet
if grep kismet "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_kismet install
fi

# Audacity
if grep audacity "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_audacity install 
fi

# PAVU  - Made Mandatory install in SIGpi 5.2 to support virtual audio cables
source $SIGPI_PACKAGES/pkg_pavucontrol install

# splat
if grep splat "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_splat install
fi

# Artemis
if grep artemis "$SIGPI_INSTALLER"; then
	source $SIGPI_PACKAGES/pkg_artemis install
fi

# SIGpi Menus
source $SIGPI_SCRIPTS/install_desktop-post.sh


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
