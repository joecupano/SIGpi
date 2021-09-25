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
SIG_INSTALL_TXT1=SIGpi-installer-1.txt


##
## FUNCTIONS
##

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

do_startscreen(){
    whiptail --title "SigPi Installer" --textbox $SIG_INSTALL_TXT1 24 120 16
}

do_sdrdevices() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose SDR devices " 20 80 12\
        "rtl-sdr" "RTL2832U & R820T2-Based " ON \
        "hackrf" "Hack RF One " OFF \
        "libiio" "PlutoSDR " OFF \
        "LimeSuite" "LimeSDR " OFF \
        "SoapySDR" "SoapySDR Library " ON \
        "SoapyRemote" "Use any Soapy SDR Remotely " ON \
        "SoapyRTLSDR" "Soapy SDR Module for RTLSDR " ON \
        "SoapyHackRF" "Soapy SDR Module for HackRF One " OFF \
        "SoapyPlutoSDR" "Soapy SDR Module for PlutoSD " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_gnuradio() {
    FUN=$(whiptail --title "SigPi Installer" --radiolist --separate-output \
        "Choose GNUradio version" 20 80 12 \
        "3.7" "GNUradio 3.7 " ON \
        "3.8" "GNUradio 3.8 (required for gr-gsm) " OFF \
        "3.9" "GNUradio 3.9 " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_libraries() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose Libraries " 20 120 12 \
        "dab-cmdline" "DAB library and tool to handle DAB/DAB+ " ON \
        "mbelib" "Library for codecs used in P25 Phase 1, ProVoice, and Half-rate " ON \
        "serialdv" "Library control serial interface to AMBE3000 chip in Packet mode. " ON \
        "dsdcc" "Re-write of Digital Speech Decoder (DSD) project " ON \
        "SGP4" "Library used for Satellite tracking " ON \
        "libsigmf" "header-only C++ library for working with Signal metadata format " ON \
        "liquid-dsp" "Software-Defined Radio Digital Signal Processing Library " ON \
        "libbtbb" "Bluetooth baseband decoding library, forked from the GR-Bluetooth project " ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_decoders() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose Decoders " 20 120 12\
        "aptdec" "Decodes images transmitted by NOAA weather satellites " ON \
        "rtl_433" "Generic data receiver with sensor support mainly for UHF ISM Bands " ON \
        "op25" "P25 digital voice decoder which works with RTL-SDR dongles" ON \
        "multimon-ng" "Decoder for POCSGA, FLEX, X10, DTMF, ZVEi, UFSK, AFSK, etc" ON \
        "ubertooth-tools" "Bluetooth BLE and BR tools for Ubertooth device" ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_sdrapps() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose SDR Applications" 20 80 12 \
        "GQRX" "SDR Receiver " ON \
        "CubicSDR" "SDR Receiver " OFF \
        "SDRangel" "SDRangel " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_hamradio() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose Amateur Radio Applications" 20 80 12 \
        "Fldigi Suite" "Digital Mode suite of applications with Radio control " OFF \
        "DireWolf 1.7" "Soundcard TNC for APRS " OFF \
        "Linpac" "Packet Radio Temrinal with mail client " OFF \
        "Xastir" "APRS Station Tracking and Reporting " OFF \
        "WSJT-X" "Digital Modes for Weak Signal Communicaitons " OFF \
        "QSSTV" "SSTV " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

do_utilities() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose other Useful Applications" 20 120 12 \
        "wireshark" "Network Traffic Analyzer " OFF \
        "Kismet" "Wireless snifferand monitor " OFF \
        "Audacity" "Audio Editor " OFF \
        "PAVU" "PulseAudio Control " OFF \
        "Mumble" "VoIP Server and Client " OFF \
        "GPS and NTP" "GPS client and NTP sync " OFF \
        "Gpredict" "Satellite Tracking " OFF \
        "splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
        "tempest" "Uses your computer monitor to send out AM radio signals" OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN
}

begin_install() {
    echo "Done"
}

###
###
###  MAIN
###
###

touch $CONFIG
calc_wt_size
do_startscreen
do_sdrdevices
do_gnuradio
do_libraries
do_decoders
do_sdrapps
do_hamradio
do_utilities
begin_install
