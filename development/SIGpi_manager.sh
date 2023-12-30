#!/bin/bash

###
### SIGpi_manager
###

###
###  REVISION: 20231113-1900
###

###
###  Usage:    SIGpi_manager
###
###            Manages installed SIGpi apps
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
SIGPI_CONFIG=$SIGPI_ETC/INSTALLED# Function to list installed applications
list_applications() {
    INSTALLED_APPS=$(cat $SIGPI_CONFIG | awk '{print $1}')
    whiptail --msgbox "Installed Applications:\n$INSTALLED_APPS" 20 60
}

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


###
### FUNCTIONS
###

# Function to display the ncurses menu
display_menu() {
    local selected_option

    while true; do
        selected_option=$(whiptail --title "SIGpi Manager" --menu "Choose an option:" 15 60 4 "${lines[@]}" 3>&1 1>&2 2>&3)

        case $selected_option in
            "")
                # User pressed Cancel or Esc
                break
                ;;
            *)
                # User selected an option
                whiptail --msgbox "Selected option: $selected_option" 8 40
                ;;
        esac
    done
}

# Function to display the main menu
main_menu() {
    while true; do
        CHOICE=$(whiptail --title "Application Management" --menu "Choose an option:" 15 60 4 \
            "1" "Add Application" \
            "2" "Remove Application" \
            "3" "List Installed Applications" \
            "4" "List Available Applications" \
            "5" "Exit" 3>&1 1>&2 2>&3)

        case $CHOICE in
            1)
                add_application
                ;;
            2)
                remove_application
                ;;
            3)
                list_installed_applications
                ;;
            4)
                list_available_applications
                ;;
            5)
                exit 0
                ;;
            *)
                whiptail --msgbox "Invalid choice. Please try again." 8 40
                ;;
        esac
    done
}

# Function to add an application
add_application() {
    APP_NAME=$(whiptail --inputbox "Enter the name of the application to add:" 8 60 3>&1 1>&2 2>&3)
    
    if [ -n "$APP_NAME" ]; then
        SIGpi install "$APP_NAME"
        whiptail --msgbox "Application '$APP_NAME' installed successfully." 8 40
    else
        whiptail --msgbox "Invalid application name. Please try again." 8 40
    fi
}

# Function to remove an application
remove_application() {
    APP_NAME=$(whiptail --inputbox "Enter the name of the application to remove:" 8 60 3>&1 1>&2 2>&3)
    
    if [ -n "$APP_NAME" ]; then
        SIGpi remove "$APP_NAME"
        whiptail --msgbox "Application '$APP_NAME' removed successfully." 8 40
    else
        whiptail --msgbox "Invalid application name. Please try again." 8 40
    fi
}

# Function to list installed applications
list__installed_applications() {
    INSTALLED_APPS=$(cat $SIGPI_CONFIG | awk '{print $1}')
    whiptail --msgbox "Installed Applications:\n$INSTALLED_APPS" 20 60
}

# Function to list available applications
list_available_applications() {
    AVAILABLE_APPS=$(cat $SIGPI_PKGS | awk '{print $1}')
    whiptail --msgbox "Available Applications:\n$AVAILABLE_APPS" 20 60
}


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
    TERM=ansi whiptail --title "SIGpi Manager" --clear --textbox $SIGPI_MANAGER_TXT 34 100 16
}


select_devices() {
    FUN=$(whiptail --title "SIGpi Manager" --clear --checklist --separate-output \
        "SDR devices " 20 80 12 \
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
    FUN=$(whiptail --title "SIGpi Manager" --clear --checklist --separate-output \
        "SDR Applications" 20 80 12 \
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

select_variousapps() {
    FUN=$(whiptail --title "SIGpi Manager" --clear --checklist --separate-output \
        "Applications" 24 120 12 \
        "hamlib" "Ham Radio Control Libraries 4.5.3 " OFF \
        "fldigi" "Fldigi for MFSK, PSK31, CW, RTTY, and many others " OFF \
        "flrig" "Optional Rig Control program for Fldigi " OFF \
        "gpredict" "Satellite Tracking " OFF \
        "js8call" "js8call JS8 for weak signal kbd-to-kbd messaging " OFF \
        "qsstv" "QSSTV for SSTV modes " OFF \
        "wsjtx" "WSJT-X for FT4, FT8, JT4, JT9, JT65, Q65, MSK144 " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
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
        "openwebrx" "OpenWebRX " OFF \
        "rtltcpsrv" "RTL-TCP Server " OFF \
        "sdrangelsrv" "SDRangel Server " OFF \
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


# Read the SIGPI_INSTALLED file line by line and put each line into an array

while IFS= read -r line; do
    lines+=("$line")
done < "$SIGPI_CONFIG"
main_menu


##
## Base Install
##

calc_wt_size
select_startscreen

TERM=ansi whiptail --title "SIGpi Manager" --clear --msgbox "Ready to Install" 12 120

touch $SIGPI_CONFIG
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