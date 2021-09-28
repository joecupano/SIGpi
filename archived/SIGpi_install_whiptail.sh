#!/bin/bash

###
### SIGpi_install_whiptail
###
### 

###
###   REVISION: 20210925-0900
###

###
###
### This script is part of the SIGbox Project.
###
### Given a Raspberry Pi 4 4GB RAM 32GB microSD with Raspberry Pi OS Full (32-bit) installed
### This script installs drivers and applications for RF use cases that include hacking and 
### Amateur Radio Digital Modes.
###


##
## INIT VARIABLES AND DIRECTORIES
##

# Package Versions
HAMLIB_PKG="hamlib-4.3.tar.gz"
FLXMLRPC_PKG="flxmlrpc-0.1.4.tar.gz"
FLRIG_PKG="flrig-1.4.2.tar.gz"
FLDIGI_PKG="fldigi-4.1.20.tar.gz"
WSJTX_PKG="wsjtx_2.4.0_armhf.deb"
QSSTV_PKG="qsstv_9.5.8.tar.gz"
GNURADIO_PKG="gnuradio_3.8"

# Source Directory
SIGPI_SOURCE=$HOME/source

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Desktop directories
SIGPI_DESKTOP=$SIGPI_HOME/desktop
SIGPI_BACKGROUNDS=$SIGPI_DESKTOP/backgrounds
SIGPI_ICONS=$SIGPI_DESKTOP/icons
SIGPI_LOGO=$SIGPI_DESKTOP/logo
SIGPI_MENU=$SIGPI_DESKTOP/menu

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi

# SigPi Install Change Tracking through touched files
SIGPI_INSTALL_STAGE1=$SIGPI_HOME/sigpi_dependencies
SIGPI_INSTALL_STAGE2=$SIGPI_HOME/sigpi_libsdrivers
SIGPI_INSTALL_STAGE3=$SIGPI_HOME/sigpi_gnuradio
SIGPI_INSTALL_STAGE4=$SIGPI_HOME/sigpi_sdrapps
SIGPI_INSTALL_STAGE5=$SIGPI_HOME/sigpi_sdrangel
SIGPI_INSTALL_STAGE6=$SIGPI_HOME/sigpi_packet
SIGPI_INSTALL_STAGE7=$SIGPI_HOME/sigpi_ham
SIGPI_INSTALL_STAGE8=$SIGPI_HOME/sigpi_wrapping
SIGPI_OPTION_BUILDHAM=$SIGPI_HOME/BUILDHAM

# Tool Variables
CONFIG=$SIGPI_HOME/sigpi_config


##
## FUNCTIONS
##

calc_wt_size() {

  # NOTE: it's tempting to redirect stderr to /dev/null, so supress error 
  # output from tput. However in this case, tput detects neither stdout or 
  # stderr is a tty and so only gives default 80, 24 values
  WT_HEIGHT=18
  WT_WIDTH=$(tput cols)

  if [ -z "$WT_WIDTH" ] || [ "$WT_WIDTH" -lt 60 ]; then
    WT_WIDTH=80
  fi
  if [ "$WT_WIDTH" -gt 178 ]; then
    WT_WIDTH=120
  fi
  WT_MENU_HEIGHT=$(($WT_HEIGHT-7))

}

do_sdrdevices_menu() {
    FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --checklist \
        "Choose SDR devices and libraries" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT \
        "RTLSDR" "RTL2832U & R820T2-Based " ON \
        "HackRF" "Hack RF One " OFF \
        "PlutoSDR" "PlutoSDR " OFF \
        "LimeSDR" "LimeSDR " OFF \
        "SoapySDR" "SoapySDR Library " ON \
        "SoapyRemote" "Use any Soapy SDR Remotely " ON \
        "SoapyRTLSDR" "Soapy SDR Module for RTLSDR " ON \
        "SoapyHackRF" "Soapy SDR Module for HackRF One " OFF \
        "SoapyPlutoSDR" "Soapy SDR Module for PlutoSDR " OFF \
        "SoapyLimeSDR" "Soapy SDR Module for LimeSDR " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return 0
    elif [ $RET -eq 0 ]; then
        echo "Your SDR device and Library choices are:" $FUN
    fi
}

do_gnuradio_menu() {
    FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --checklist \
        "Choose GNUradio version" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT \
        "3.7" "GNUradio 3.7 " ON \
        "3.8" "GNUradio 3.8 " OFF \
        "3.9" "GNUradio 3.9 " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return 0
    elif [ $RET -eq 0 ]; then
        echo "Your GNuradio choice is:" $FUN
    fi
}

do_sdrapps_menu() {
    FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --checklist \
        "Choose SDR Applications" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT \
        "GQRX" "GQRX " ON \
        "CubicSDR" "CubicSDR " OFF \
        "SDRangel" "SDRangel " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return 0
    elif [ $RET -eq 0 ]; then
        echo "Your SDR apps are:" $FUN
    fi
}

do_hamradio_menu() {
    FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --checklist \
        "Choose Amateur Radio Applications" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT \
        "Fldigi" "Fldigi Suite (fldigi, flrig, flxmlrpc, etc " OFF \
        "DireWolf" "Direwolf 1.7 " OFF \
        "Linpac" "Linpac Packet Terminal " OFF \
        "Xastir" "APRS Map " OFF \
        "WSJT-X" "WSJT-X " OFF \
        "QSSTV" "SSTV " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return 0
    elif [ $RET -eq 0 ]; then
        echo "Your Amateur Radio apps are:" $FUN
    fi
}

do_utilities_menu() {
    FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --checklist \
        "Choose other Useful Applications" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT \
        "wireshark" "Wireshark " OFF \
        "Kismet" "Kismet " OFF \
        "Audacity" "Audacity " OFF \
        "PAVU" "PulseAudio Control " OFF \
        "Mumble" "VoIP Server and Client " OFF \
        "GPSD" "GPS client " OFF \
        "Gpredict" "Satellite Tracking " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        return 0
    elif [ $RET -eq 0 ]; then
        echo "Your Additional apps are:" $FUN
    fi
}

do_about() {
  whiptail --msgbox "\
This tool provides a straightforward way of installing
SigPi selecting only the packages you desire.\
" 20 70 1
  return 0
}

#
# Interactive use loop
#
touch $CONFIG
calc_wt_size
while true; do
  FUN=$(whiptail --title "SigPi Software Configuration Tool (SIGpi-installer)" --menu "Setup Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Finish --ok-button Select \
      "1 SDR Devices" "Choose SDR devices and libraries" \
      "2 GNUradio" "Choose GNUradio version and blocks" \
      "3 SDR Applications" "Choose SDR applications" \
      "4 Amateur Radio" "Choose Amatuer Radio applications" \
      "5 Utilities" "Choose various useful applications" \
      "6 Begin Install" "Begin Install" \
      "9 About SIGpi-installer" "Information about this configuration tool" \
       3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
      exit 0
    elif [ $RET -eq 0 ]; then
      case "$FUN" in
        1\ *) do_sdrdevices_menu ;;
        2\ *) do_gnuradio_menu ;;
        3\ *) do_sdrapps_menu ;;
        4\ *) do_hamradio_menu ;;
        5\ *) do_utilities_menu ;;
        6\ *) do_installation ;;
        9\ *) do_about ;;
        *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
      esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
    else
      exit 1
    fi
  done 