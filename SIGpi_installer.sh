#!/bin/bash

###
### SIGpi_installer
###

###
###  REVISION: 20230831-1900
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
SIGPI_DEBS=$SIGPI_HOME/debs

# SIGpi Install Support files
SIGPI_INSTALLER=$SIGPI_ETC/INSTALL_CONFIG
SIGPI_CONFIG=$SIGPI_ETC/INSTALLED
SIGPI_PKGLIST=$SIGPI_PACKAGES/PACKAGES
SIGPI_INSTALL_TXT=$SIGPI_SCRIPTS/scr_install_welcome.txt
SIGPI_INSTALLSRV_TXT=$SIGPI_SCRIPTS/scr_install-srv_welcome.txt
SIGPI_INSTALLBASE_TXT=$SIGPI_SCRIPTS/scr_install-base_welcome.txt
SIGPI_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIGPI_BANNER_RESET="\e[0m"

# Detect architecture (x86_64, aarch64)
SIGPI_HWARCH=`lscpu|grep Architecture|awk '{print $2}'`
# Detect Operating system "Debian GNU/Linux 11 (bullseye)" or "Ubuntu 22.04.3 LTS"
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

###
### Environment tests
### 

# Are we the right hardware
if [ "$SIGPI_HWARCH" = "x86_64" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_HWARCH" = "aarch64" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_CERTIFIED" = "false" ]; then
    echo "ERROR:"
    echo "ERROR:  Incorrect Hardware"
    echo "ERROR:      Hardware must be x86_64 or aarch64 hardware"
    echo "ERROR:  Aborting"
    echo "ERROR:"
    exit 1;
fi

# Are we the right operating system
if [ "$SIGPI_OSNAME" = "Debian GNU/Linux 11 (bullseye)" ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_OSNAME" = *Ubuntu 22.04* ]; then
    SIGPI_CERTIFIED="true"
fi

if [ "$SIGPI_CERTIFIED" = "false" ]; then
    echo "ERROR:"
    echo "ERROR:  Incorrect Operating System"
    echo "ERROR:      Operating system must be Debian GNU/Linux 11 (bullseye) or Ubuntu 22.04.3 LTS."
    echo "ERROR:  Aborting"
    echo "ERROR:"
    exit 1;
fi

# Are we where we should be
if [ -f /home/$USER/SIG/SIGpi/SIGpi_installer.sh ]; then
    echo
else
    echo "ERROR:"
    echo "ERROR:  Software install setup issue"
    echo "ERROR:  Repo must be cloned from within /home/$USER/SIG directory"
    echo "ERROR:  and SIGpi_installer.sh run from there."
    echo "ERROR:  Aborting"
    echo "ERROR:"
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
    TERM=ansi whiptail --title "SIGpi Installer" --clear --textbox $SIGPI_INSTALL_TXT 34 100 16
}

select_startsrvscreen(){
    TERM=ansi whiptail --title "SIGpi Node Installer" --clear --textbox $SIGPI_INSTALLSRV_TXT 34 100 16
}

select_startbasescreen(){
    TERM=ansi whiptail --title "SIGpi Base Installer" --clear --textbox $SIGPI_INSTALLBASE_TXT 34 100 16
}

select_devices() {
    FUN=$(whiptail --title "SIGpi Installer" --clear --checklist --separate-output \
        "Choose additional SDR devices " 20 80 12 \
        "bladerf" "bladeRF " OFF \
        "ettus" "Ettus Research USRP UHD " OFF \
        "limesuite" "LimeSDR " OFF \
        "plutosdr" "PlutoSDR " OFF \
        "sdrplay" "SDRPlay " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi

    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_sdrapps() {
    FUN=$(whiptail --title "SIGpi Installer" --clear --checklist --separate-output \
        "Choose general purpose SDR Applications" 20 80 12 \
        "cubicsdr" "SDR Receiver " OFF \
        "gnuradio" "GNU Radio " OFF \
        "sdrangel" "SDRangel " OFF \
		"sdrpp" "SDR++ 1.1.0" OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi

    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_amateurradio() {
    FUN=$(whiptail --title "SIGpi Installer" --clear --checklist --separate-output \
        "Choose Amateur Radio Applications" 24 120 12 \
        "hamlib" "Ham Radio Control Libraries 4.5.3 " OFF \
        "fldigi" "Fldigi for MFSK, PSK31, CW, RTTY, and many others " OFF \
        "flrig" "Optional Rig Control program for Fldigi " OFF \
        "gpredict" "Satellite Tracking " OFF \
        "js8call" "js8call JS8 for weak signal kbd-to-kbd messaging " OFF \
        "qsstv" "QSSTV for SSTV modes " OFF \
        "wsjtx" "WSJT-X for FT4, FT8, JT4, JT9, JT65, Q65, MSK144 " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi

    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_usefulapps() {
    FUN=$(whiptail --title "SIGpi Installer" --clear --checklist --separate-output \
        "Choose Additional and Advanced Applications" 20 120 12 \
        "bettercap" "Swiss Army knife for 802.11, BLE, IPv4 and IPv6 reconnaissance" OFF \
        "cygnusrfi" "RFI analysis tool, based on Python and GNU Radio Companion (GRC)" OFF \
		"splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
        "sigdigger" "SigDigger, free digital signal analyzer " OFF \
        "srsran" "srsRAN, Open-source 4G/5G software radio suite (amd64 only)" OFF \
        "uniradhack" "Universal Radio Hacker. Offline wireless protocol investigation" OFF \
        "wireshark" "Network protocol analyzer" OFF \
        "kismet" "Wireless sniffer and monitor " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi

    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_INSTALLER
    done
}

select_nodeserver() {
    FUN=$(whiptail --title "SIGpi Node Installer" --clear --checklist --separate-output \
        "Choose which SDR server to run as a service" 20 120 12 \
        "rtltcpsrv" "RTL-TCP Server " OFF \
        "sdrangelsrv" "SDRangel Server" OFF \
        "soapysdrsrv" "SoapySDR Server " OFF \
		3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi

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


##
## Node Install 
##

if [ "$1" = "node" ]; then
    calc_wt_size
    select_startsrvscreen
    select_devices
    select_nodeserver
    TERM=ansi whiptail --title "SIGpi Node Install" --clear --msgbox "Ready to Install" 12 120

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get -y update
    sudo apt-get -y upgrade

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade Complete"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    touch $SIGPI_CONFIG
    echo "sigpi_node" >> $SIGPI_CONFIG
    cd $SIGPI_SOURCE

    source $SIGPI_SCRIPTS/install_server_dependencies.sh
    source $SIGPI_SCRIPTS/install_core_devices.sh

    # Copy SIGpi commands into /usr/local/bin
    sudo cp $SIGPI_HOME/scripts/SIGpi_exec-in-shell.sh /usr/local/bin/SIGpi_exec-in-shell 
    cdsudo cp $SIGPI_HOME/scripts/SIGpi.sh /usr/local/bin/SIGpi

    # Install bladeRF
    if grep bladerf "$SIGPI_INSTALLER"; then
        source $SIGPI_PACKAGES/pkg_bladerf install
    fi
    # Install LimeSDR
    if grep limesuite "$SIGPI_INSTALLER"; then
        source $SIGPI_PACKAGES/pkg_limesuite install
    fi
    # Install Ettus UHD
    if grep ettus "$SIGPI_INSTALLER"; then
        source $SIGPI_PACKAGES/pkg_ettus install
    fi
    # Install PlutoSDR
    if grep plutosdr "$SIGPI_INSTALLER"; then
        source $SIGPI_PACKAGES/pkg_plutosdr install
    fi
    # Install SDRPlay
    if grep sdrplay "$SIGPI_INSTALLER"; then
        source $SIGPI_PACKAGES/pkg_sdrplay install
    fi
    # Install RFM95W (Adafruit RadioBonnet 900 MHz LoRa-FSK)
    if grep rfm95w "$SIGPI_INSTALLER"; then
        source $SIGPI_SCRIPTS/install_devices_rfm95w.sh
    fi

    # Install APTdec (NOAA APT)
    source $SIGPI_PACKAGES/pkg_aptdec install
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
    # Install Radiosonde (Atmospheric Telemetry)
    source $SIGPI_PACKAGES/pkg_radiosonde install
    # Install Ubertooth Tools
    source $SIGPI_PACKAGES/pkg_ubertooth-tools install
    # Install Direwolf (AFSK APRS)
    source $SIGPI_PACKAGES/pkg_direwolf install
    # Install RTL_433
    source $SIGPI_PACKAGES/pkg_rtl_433 install
    # Install Dump1090
    source $SIGPI_PACKAGES/pkg_dump1090 install
    # Generate FFT Wisdom file
    source $SIGPI_PACKAGES/pkg_fftw install
    
    if [ "$2" = "rtltcpsrv" ]; then
        sudo cp $SIGPI_SOURCE/scripts/sigpi_node_rtltcp.service /etc/systemd/system/sigpi-node.service
        echo "sigpi-node_rtltcp" >> $SIGPI_CONFIG
    elif [ "$2" = "sdrangelsrv" ]; then
        source $SIGPI_PACKAGES/pkg_sdrangelsrv
        sudo cp $SIGPI_SOURCE/scripts/sigpi_node_sdrangelsrv.service /etc/systemd/system/sigpi-node.service
        echo "sigpi-node_sdrangelsrv" >> $SIGPI_CONFIG
    elif [ "$2" = "soapysdrsrv" ]; then
        sudo cp $SIGPI_SOURCE/scripts/sigpi_node_soapysdrsrv.service /etc/systemd/system/sigpi-node.service
        echo "sigpi-node_soapysdrsrv" >> $SIGPI_CONFIG
    else
        echo -e "${SIGPI_BANNER_COLOR}"
        echo -e "${SIGPI_BANNER_COLOR} ##  "
        echo -e "${SIGPI_BANNER_COLOR} ##  ERROR: Unkown Server Type"
        echo -e "${SIGPI_BANNER_COLOR} ##  "
        echo -e "${SIGPI_BANNER_COLOR} ##  Your choices are rtltcp, sdrangelsrv, or soapysdrsrv"
        echo -e "${SIGPI_BANNER_COLOR} ##  "
        echo -e "${SIGPI_BANNER_RESET}"
        exit 0
    fi

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   SIGpi Node Installation Complete !!"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System needs to reboot for all changes to occur"
    echo -e "${SIGPI_BANNER_COLOR} ##   Reboot will begin in 15 seconsds unless CTRL-C hit"
    echo -e "${SIGPI_BANNER_RESET}"
    sleep 15
    sudo sync
    sudo reboot
    exit 0
fi


##
## Base Install
##

if [ "$1" = "base" ]; then
    calc_wt_size
    select_startbasescreen

    TERM=ansi whiptail --title "SIGpi Base Install" --clear --msgbox "Ready to Install" 12 120

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get -y update
    sudo apt-get -y upgrade

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade Complete"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    touch $SIGPI_CONFIG
    echo "sigpi_desktop" >> $SIGPI_CONFIG
    cd $SIGPI_SOURCE

    source $SIGPI_SCRIPTS/install_core_dependencies.sh
    source $SIGPI_SCRIPTS/install_desktop-prep.sh

    # Install Core Devices
    source $SIGPI_SCRIPTS/install_core_devices.sh
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
    # Install Radiosonde (Atmospheric Telemetry)
    source $SIGPI_PACKAGES/pkg_radiosonde install
    # Install Ubertooth Tools
    source $SIGPI_PACKAGES/pkg_ubertooth-tools install
    # Install Direwolf (AFSK APRS)
    source $SIGPI_PACKAGES/pkg_direwolf install
    # Install Linpac (AX.25 Terminal
    source $SIGPI_PACKAGES/pkg_linpac install
    # Install Multimon-NG (POCSAG, FSK, AFSK, DTMF, X10)
    source $SIGPI_PACKAGES/pkg_multimon-ng install
    # Install RTL_433
    source $SIGPI_PACKAGES/pkg_rtl_433 install
    # Install Dump1090
    source $SIGPI_PACKAGES/pkg_dump1090 install
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   SIGpi Base Installation Complete !!"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System needs to reboot for all changes to occur"
    echo -e "${SIGPI_BANNER_COLOR} ##   Reboot will begin in 15 seconds unless CTRL-C hit"
    echo -e "${SIGPI_BANNER_RESET}"
    sleep 15
    sudo sync
    sudo reboot
    exit 0

fi


##
## Full Install (Default)
##

calc_wt_size
select_startscreen
select_devices
# select_gnuradio
select_sdrapps
select_amateurradio
select_usefulapps
TERM=ansi whiptail --title "SIGpi Installer" --clear --msgbox "Ready to Install" 12 120

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

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade Complete"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

touch $SIGPI_CONFIG
echo "sigpi_desktop" >> $SIGPI_CONFIG    
cd $SIGPI_SOURCE

source $SIGPI_SCRIPTS/install_core_dependencies.sh
source $SIGPI_SCRIPTS/install_desktop-prep.sh

# Install Core Devices
source $SIGPI_SCRIPTS/install_core_devices.sh
# Install bladeRF
if grep bladerf "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_bladerf install
fi
# Install LimeSDR
if grep limesuite "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_limesuite install
fi
# Install Ettus UHD
if grep ettus "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_ettus install
fi
# Install PlutoSDR
if grep plutosdr "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_plutosdr install
fi
# Install SDRPlay
if grep sdrplay "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sdrplay install
fi
# Install RFM95W (Adafruit RadioBonnet 900 MHz LoRa-FSK)
if grep rfm95w "$SIGPI_INSTALLER"; then
    source $SIGPI_SCRIPTS/install_devices_rfm95w.sh
fi

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
# Install Radiosonde (Atmospheric Telemetry)
source $SIGPI_PACKAGES/pkg_radiosonde install
# Install Ubertooth Tools
source $SIGPI_PACKAGES/pkg_ubertooth-tools install
# Install Direwolf (AFSK APRS)
source $SIGPI_PACKAGES/pkg_direwolf install
# Install Linpac (AX.25 Terminal
source $SIGPI_PACKAGES/pkg_linpac install
# Install Multimon-NG (POCSAG, FSK, AFSK, DTMF, X10)
source $SIGPI_PACKAGES/pkg_multimon-ng install
# Install RTL_433
source $SIGPI_PACKAGES/pkg_rtl_433 install
# Install Dump1090
source $SIGPI_PACKAGES/pkg_dump1090 install
# Generate FFT Wisdom file
source $SIGPI_PACKAGES/pkg_fftw install

# GNU Radio
if grep gnuradio "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gnuradio install
fi

# CubicSDR
if grep cubicsdr "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_cubicsdr install
fi

# SDRangel
if grep sdrangel "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sdrangel install
fi

# SDR++
if grep sdrpp "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sdrpp install
fi

# srsRAN
if grep srsran "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_srsran install
fi

# HamLib
if grep hamlib "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_hamlib install
fi

# Fldigi
if grep fldigi "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_fldigi install
fi

# Flrig
if grep flrig "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_flrig install
fi

# WSJT-X
if grep wsjtx "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_wsjtx install
fi

# Xastir
if grep xastir "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_xastir install
fi

# QSSTV
if grep qsstv "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_qsstv install
fi

# JS8CALL
if grep js8call "$SIGPI_INSTALLER"; then
    if grep wsjtx "$SIGPI_INSTALLER"; then
        echo -e "${SIGPI_BANNER_COLOR}"
        echo -e "${SIGPI_BANNER_COLOR} ##"
        echo -e "${SIGPI_BANNER_COLOR} ## ERROR: JS8CALL cannot be installed while WSJT-X is installed due to library conflicts"
        echo -e "${SIGPI_BANNER_COLOR} ##"
        echo -e "${SIGPI_BANNER_COLOR}"
    else
        source $SIGPI_PACKAGES/pkg_js8call install
    fi
fi

# Gpredict
if grep gpredict "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_gpredict install
fi

# HASviolet
if grep HASviolet "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_hasviolet install
fi

# Universal Radio Hacker
if grep uniradhack "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_urh install
fi

# bettercap
if grep bettercap "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_bettercap install
fi

# bettercapui
#if grep bettercapui "$SIGPI_INSTALLER"; then
#    source $SIGPI_PACKAGES/pkg_bettercapui install
#fi

# CygnusRFI
if grep cygnusrfi "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_cygnusrfi install
fi

# SigDigger
if grep sigdigger "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_sigdigger install
fi

# Install Wireshark
if grep wireshark "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_wireshark install
fi

# Install Kismet
if grep kismet "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_kismet install
fi

# Install Audacity
source $SIGPI_PACKAGES/pkg_audacity install 

# Install PAVU 
source $SIGPI_PACKAGES/pkg_pavucontrol install

# Install SPLAT
if grep splat "$SIGPI_INSTALLER"; then
    source $SIGPI_PACKAGES/pkg_splat install
fi

# Install DOSbox
source $SIGPI_PACKAGES/pkg_dosbox install

# Install SIGpi Menus
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
