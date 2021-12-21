#!/bin/bash

###
### SIGpi_installer
###

###
###   REVISION: 202112170500
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
SIGPI_DESKTOP_DIRECTORY=/usr/share/SIGpi/desktop-directories
SIGPI_DESKTOP_FILES=/usr/share/SIGpi/applications
SIGPI_DESKTOP_ICONS=/usr/share/SIGpi/icons
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
#DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

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
# LimeSDR
    if grep limesdr "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/install_devices_limesdr
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
        "Devices" 20 80 12 \
        "plutosdr" "PlutoSDR " OFF \
        "limesdr" "LimeSDR " OFF \
        "ettus" "Ettus Research USRP UHD" OFF \
        "rfm95w" "Adafruit LoRa Radio Bonnet - RFM95W @ 915 MHz " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_CONFIG
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_CONFIG
    done
}

select_gnuradio() {
    FUN=$(whiptail --title "SigPi Installer" --radiolist --clear --separate-output \
        "GNUradio version" 20 80 12 \
		"gnuradio38" "GNU Radio 3.8 " ON \
        "gnuradio39" "GNU Radio 3.9 " OFF \
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
        "rtl433" "RTL_433 " OFF \
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
    ##echo $FUN >> $SIGPI_CONFIG
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_CONFIG
    done
}

select_amateurradio() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Amateur Radio Applications" 24 120 12 \
        "fldigi" "Fldigi 4.1.18 for MFSK, PSK31, CW, RTTY. WEFAX and many others " OFF \
        "js8call" "js8call 2.20 for another digital mode" OFF \
        "qsstv" "QSSTV 9.4.X for SSTV modes " OFF \
        "wsjtx" "WSJT-X 2.5.1 for FT8, JT4, JT9, JT65, QRA64, ISCAT, MSK144, and WSPR " OFF \
        "xastir" "Xastir provides mapping, tracking, messaging, weather, weather alerts" OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    ##echo $FUN >> $SIGPI_CONFIG
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_CONFIG
    done
}

select_usefulapps() {
    FUN=$(whiptail --title "SigPi Installer" --clear --checklist --separate-output \
        "Useful Applications" 20 120 12 \
        "HASviolet" "LoRa and FSK transceiver project " OFF \
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
    ##echo $FUN >> $SIGPI_CONFIG
    IFS=' '     # space is set as delimiter
    read -ra ADDR <<< "$FUN"   # str is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do   # access each element of array
        echo $FUN >> $SIGPI_CONFIG
    done
}

server_install(){
    
    FUN=$(whiptail --title "SigPi Server Installer" --clear --checklist --separate-output \
        "SDR Server Startup" 20 80 12 \
        "rtltcp_on" "RTL_TCP on start " OFF \
        "soapy_on" "SoapySDR on start " OFF \
        "none" "No server on startup " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN

    TERM=ansi whiptail --title "SigPi Server Installer" --clear --msgbox "Ready to Install" 12 120
    
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   System Update & Upgrade"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo apt-get -y update
    sudo apt-get -y upgrade

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Create $SIGPI_CONFIG "
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    touch $SIGPI_CONFIG
    echo "sigpi_server" >> $SIGPI_CONFIG
    cd $SIGPI_SOURCE

    #source $SIGPI_SCRIPTS/install_swapspace.sh
    source $SIGPI_SCRIPTS/install_server_dependencies.sh
    source $SIGPI_SCRIPTS/install_core_devices.sh
    source $SIGPI_SCRIPTS/install_libraries.sh
    source $SIGPI_SCRIPTS/install_radiosonde.sh
    source $SIGPI_PACKAGES/pkg_rtl_433 install
    source $SIGPI_PACKAGES/pkg_dump1090 install
    source $SIGPI_PACKAGES/pkg_ubertooth install
    source $SIGPI_PACKAGES/pkg_direwolf install
    
}

full_install(){
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

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Create SIGPI Directories and config"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    touch $SIGPI_CONFIG
    echo "sigpi_desktop" >> $SIGPI_CONFIG    
    sudo mkdir /usr/share/SIGpi
    sudo mkdir $SIGPI_DESKTOP_DIRECTORY
    sudo mkdir $SIGPI_DESKTOP_FILES
    sudo mkdir $SIGPI_DESKTOP_ICONS
    cd $SIGPI_SOURCE

    #source $SIGPI_SCRIPTS/install_swapspace.sh
    source $SIGPI_SCRIPTS/install_core_dependencies.sh
    source $SIGPI_SCRIPTS/install_core_devices.sh

    source $SIGPI_SCRIPTS/install_desktop-prep.sh

    # PlutoSDR
    if grep plutosdr "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_plutosdr install
        echo "plutosdr" >> $SIGPI_CONFIG  
    fi

    # LimeSDR
    if grep limesdr "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_limesdr install
        echo "limesdr" >> $SIGPI_CONFIG  
    fi

    # UHD - Ettus
    if grep ettus "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_ettus install
    fi

    # RFM95W  (Adafruit RadioBonnet 900 MHz LoRa-FSK)
    if grep rfm95w "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/install_devices_rfm95w
    fi

    source $SIGPI_SCRIPTS/install_libraries.sh
    source $SIGPI_SCRIPTS/install_radiosonde.sh
    echo "radiosonde" >> $SIGPI_CONFIG  
    source $SIGPI_PACKAGES/pkg_ubertooth-tools install
    echo "ubertooth" >> $SIGPI_CONFIG  
    source $SIGPI_PACKAGES/pkg_direwolf install
    echo "direwolf" >> $SIGPI_CONFIG  
    source $SIGPI_PACKAGES/pkg_linpac install
    echo "linpac" >> $SIGPI_CONFIG  

    # RTL_433
    if grep rtl433 "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_rtl433 install
    fi

    # Dump1090
    if grep gnuradio38 "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_dump1090 install
    fi

    # GNU Radio
    if grep gnuradio38 "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_gnuradio38 install
    fi

    if grep gnuradio39 "$SIGPI_CONFIG"; then
	source $SIGPI_PACKAGES/pkg_gnuradio39 install
    fi

    # gqrx
    if grep gqrx "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_gqrx install
    fi

    # CubicSDR
    if grep cubicsdr "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_cubicsdr install
    fi

    # SDRangel
    if grep sdrangel "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_sdrangel install
    fi

    # SDR++
    if grep sdrpp "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_sdrpp install
    fi

    # Fldigi
    if grep fldigi "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_fldigi install
    fi

    # Fldigi 4.1.20
    #if grep fldigi4120 "$SIGPI_CONFIG"; then
    #    source $SIGPI_PACKAGES/pkg_fldigi-latest install
    #fi

    # WSJT-X
    if grep wsjtx "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_wsjtx install
    fi

    # Xastir
    if grep xastir "$SIGPI_CONFIG"; then
	source $SIGPI_PACKAGES/pkg_xastir install
    fi

    # QSSTV
    if grep qsstv "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_qsstv install
    fi

    # QSSTV 9.5.X
    #if grep qsstv95 "$SIGPI_CONFIG"; then
    #    source $SIGPI_PACKAGES/pkg_qsstv95 install
    #fi

    # JS8CALL
    if grep js8call "$SIGPI_CONFIG"; then
	source $SIGPI_PACKAGES/pkg_js8call install
    fi

    # Gpredict
    if grep gpredict "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_gpredict install
    fi

    # HASviolet
    if grep HASviolet "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_hasviolet install
    fi

    # CygnusRFI
    if grep cygnusrfi "$SIGPI_CONFIG"; then
	source $SIGPI_PACKAGES/pkg_cygnusrfi install
    fi

    # Wireshark
    if grep wireshark "$SIGPI_CONFIG"; then
	source $SIGPI_PACKAGES/pkg_wireshark install
    fi

    # Kismet
    if grep kismet "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_kismet install
    fi

    # Audacity
    if grep audacity "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_audacity install 
    fi

    # PAVU
    if grep pavu "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_pavucontrol install
    fi

    # splat
    if grep splat "$SIGPI_CONFIG"; then
        source $SIGPI_PACKAGES/pkg_splat install
    fi

    # SIGpi Menus
    source $SIGPI_SCRIPTS/install_desktop-post.sh

}


###
###  MAIN
###

# Server option invoked ?
if [ "$1" = "server" ]; then 
    server_install
else
    full_install
fi

# Turn off Swapfile
if [ -f /swapfile ]; then
    echo "Removing swapfile"
    sudo swapoff /swapfile
    sleep 5
    sudo rm -rf /swapfile
fi


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
