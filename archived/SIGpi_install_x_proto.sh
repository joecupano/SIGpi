#!/bin/bash

###
### SIGpi_install_x (next gen install)
###
### 

###
###   REVISION: 20210912-0900
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

# Source Directory
SIGPI_SOURCE=$HOME/source

# Executable Directory (will be created as root)
SIGPI_OPT=/opt/SIGpi
SIGPI_EXE=$SIGPI_OPT/bin

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGbox

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Install tracking in stages
SIGPI_INSTALL_STAGE1=$SIGPI_HOME/stage_1
SIGPI_INSTALL_STAGE2=$SIGPI_HOME/stage_2
SIGPI_INSTALL_STAGE3=$SIGPI_HOME/stage_3
SIGPI_INSTALL_STAGE4=$SIGPI_HOME/stage_4
SIGPI_INSTALL_STAGE5=$SIGPI_HOME/stage_5

# Install options
SIGPI_OPTION_BUILDHAM=$SIGPI_HOME/BUILDHAM

# SigPi SSL Cert and Key
SIGPI_API_SSL_KEY=$SIGPI_HOME/SIGpi_api.key
SIGPI_API_SSL_CRT=$SIGPI_HOME/SIGpi_api.crt

###


ASK_TO_REBOOT=0
CONFIG=/boot/config.txt

is_pi () {
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = "armhf" ] || [ "$ARCH" = "arm64" ] ; then
    return 0
  else
    return 1
  fi
}

is_live() {
    grep -q "boot=live" $CMDLINE
    return $?
}

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

do_about() {
  whiptail --msgbox "\
This tool allows user to pick and choose whcih applications and
drivers they want installed knowing all dependencies will be
managed.

$(dpkg -s SIGbox-config 2> /dev/null | grep Version)\
" 20 70 1
  return 0
}

is_number() {
  case $1 in
    ''|*[!0-9]*) return 0 ;;
    *) return 1 ;;
  esac
}

do_change_pass() {
  whiptail --msgbox "You will now be asked to enter a new password for the $USER user" 20 60 1
  passwd $USER &&
  whiptail --msgbox "Password changed successfully" 20 60 1
}


get_hostname() {
    cat /etc/hostname | tr -d " \t\n\r"
}

do_hostname() {
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "\
Please note: RFCs mandate that a hostname's labels \
may contain only the ASCII letters 'a' through 'z' (case-insensitive), 
the digits '0' through '9', and the hyphen.
Hostname labels cannot begin or end with a hyphen. 
No other symbols, punctuation characters, or blank spaces are permitted.\
" 20 70 1
  fi
  CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
  if [ "$INTERACTIVE" = True ]; then
    NEW_HOSTNAME=$(whiptail --inputbox "Please enter a hostname" 20 60 "$CURRENT_HOSTNAME" 3>&1 1>&2 2>&3)
  else
    NEW_HOSTNAME=$1
    true
  fi
  if [ $? -eq 0 ]; then
    echo $NEW_HOSTNAME > /etc/hostname
    sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
    ASK_TO_REBOOT=1
  fi
}


get_ssh() {
  if service ssh status | grep -q inactive; then
    echo 1
  else
    echo 0
  fi
}

do_ssh() {
  if [ -e /var/log/regen_ssh_keys.log ] && ! grep -q "^finished" /var/log/regen_ssh_keys.log; then
    whiptail --msgbox "Initial ssh key generation still running. Please wait and try again." 20 60 2
    return 1
  fi
  DEFAULT=--defaultno
  if [ $(get_ssh) -eq 0 ]; then
    DEFAULT=
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --yesno \
      "Would you like the SSH server to be enabled?\n\nCaution: Default and weak passwords are a security risk when SSH is enabled!" \
      $DEFAULT 20 60 2
    RET=$?
  else
    RET=$1
  fi
  if [ $RET -eq 0 ]; then
    ssh-keygen -A &&
    update-rc.d ssh enable &&
    invoke-rc.d ssh start &&
    STATUS=enabled
  elif [ $RET -eq 1 ]; then
    update-rc.d ssh disable &&
    invoke-rc.d ssh stop &&
    STATUS=disabled
  else
    return $RET
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "The SSH server is $STATUS" 20 60 1
  fi
}


disable_raspi_config_at_boot() {
  if [ -e /etc/profile.d/SIGbox-config.sh ]; then
    rm -f /etc/profile.d/SIGbox-config.sh
    if [ -e /etc/systemd/system/getty@tty1.service.d/SIGbox-config-override.conf ]; then
      rm /etc/systemd/system/getty@tty1.service.d/SIGbox-config-override.conf
    fi
    telinit q
  fi
}

get_boot_cli() {
  if systemctl get-default | grep -q multi-user ; then
    echo 0
  else
    echo 1
  fi
}

get_autologin() {
  if [ $(get_boot_cli) -eq 0 ]; then
    # booting to CLI
    # stretch or buster - is there an autologin conf file?
    if [ -e /etc/systemd/system/getty@tty1.service.d/autologin.conf ] ; then
      echo 0
    else
      # stretch or earlier - check the getty service symlink for autologin
      if [ $(deb_ver) -le 9 ] && grep -q autologin /etc/systemd/system/getty.target.wants/getty@tty1.service ; then
        echo 0
      else
        echo 1
      fi
    fi
  else
    # booting to desktop - check the autologin for lightdm
    if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
      echo 0
    else
      echo 1
    fi
  fi
}

get_boot_wait() {
  if test -e /etc/systemd/system/dhcpcd.service.d/wait.conf; then
    echo 0
  else
    echo 1
  fi
}

do_boot_wait() {
  DEFAULT=--defaultno
  if [ $(get_boot_wait) -eq 0 ]; then
    DEFAULT=
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --yesno "Would you like boot to wait until a network connection is established?" $DEFAULT 20 60 2
    RET=$?
  else
    RET=$1
  fi
  if [ $RET -eq 0 ]; then
    mkdir -p /etc/systemd/system/dhcpcd.service.d/
    cat > /etc/systemd/system/dhcpcd.service.d/wait.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/lib/dhcpcd5/dhcpcd -q -w
EOF
    STATUS=enabled
  elif [ $RET -eq 1 ]; then
    rm -f /etc/systemd/system/dhcpcd.service.d/wait.conf
    STATUS=disabled
  else
    return $RET
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "Waiting for network on boot is $STATUS" 20 60 1
  fi
}

get_boot_splash() {
  if is_pi ; then
    if grep -q "splash" $CMDLINE ; then
      echo 0
    else
      echo 1
    fi
  else
    if grep -q "GRUB_CMDLINE_LINUX_DEFAULT.*splash" /etc/default/grub ; then
      echo 0
    else
      echo 1
    fi
  fi
}

do_boot_splash() {
  if [ ! -e /usr/share/plymouth/themes/pix/pix.script ]; then
    if [ "$INTERACTIVE" = True ]; then
      whiptail --msgbox "The splash screen is not installed so cannot be activated" 20 60 2
    fi
    return 1
  fi
  DEFAULT=--defaultno
  if [ $(get_boot_splash) -eq 0 ]; then
    DEFAULT=
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --yesno "Would you like to show the splash screen at boot?" $DEFAULT 20 60 2
    RET=$?
  else
    RET=$1
  fi
  if [ $RET -eq 0 ]; then
    if is_pi ; then
      if ! grep -q "splash" $CMDLINE ; then
        sed -i $CMDLINE -e "s/$/ quiet splash plymouth.ignore-serial-consoles/"
      fi
    else
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 quiet splash plymouth.ignore-serial-consoles\"/"
      sed -i /etc/default/grub -e "s/  \+/ /g"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\" /GRUB_CMDLINE_LINUX_DEFAULT=\"/"
      update-grub
    fi
    STATUS=enabled
  elif [ $RET -eq 1 ]; then
    if is_pi ; then
      if grep -q "splash" $CMDLINE ; then
        sed -i $CMDLINE -e "s/ quiet//"
        sed -i $CMDLINE -e "s/ splash//"
        sed -i $CMDLINE -e "s/ plymouth.ignore-serial-consoles//"
      fi
    else
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)quiet\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)splash\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)plymouth.ignore-serial-consoles\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1\2\"/"
      sed -i /etc/default/grub -e "s/  \+/ /g"
      sed -i /etc/default/grub -e "s/GRUB_CMDLINE_LINUX_DEFAULT=\" /GRUB_CMDLINE_LINUX_DEFAULT=\"/"
      update-grub
    fi
    STATUS=disabled
  else
    return $RET
  fi
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "Splash screen at boot is $STATUS" 20 60 1
  fi
}

do_update() {
  apt-get update &&
  apt-get install SIGbox-config &&
  printf "Sleeping 5 seconds before reloading SIGbox-config\n" &&
  sleep 5 &&
  exec SIGbox-config
}

list_wlan_interfaces() {
  for dir in /sys/class/net/*/wireless; do
    if [ -d "$dir" ]; then
      basename "$(dirname "$dir")"
    fi
  done
}

do_wifi_ssid_passphrase() {
  RET=0
  IFACE_LIST="$(list_wlan_interfaces)"
  IFACE="$(echo "$IFACE_LIST" | head -n 1)"

  if [ -z "$IFACE" ]; then
    if [ "$INTERACTIVE" = True ]; then
      whiptail --msgbox "No wireless interface found" 20 60
    fi
    return 1
  fi

  if ! wpa_cli -i "$IFACE" status > /dev/null 2>&1; then
    if [ "$INTERACTIVE" = True ]; then
      whiptail --msgbox "Could not communicate with wpa_supplicant" 20 60
    fi
    return 1
  fi

  if [ "$INTERACTIVE" = True ] && [ -z "$(get_wifi_country)" ]; then
    do_wifi_country
  fi

  SSID="$1"
  while [ -z "$SSID" ] && [ "$INTERACTIVE" = True ]; do
    SSID=$(whiptail --inputbox "Please enter SSID" 20 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
      return 0
    elif [ -z "$SSID" ]; then
      whiptail --msgbox "SSID cannot be empty. Please try again." 20 60
    fi
  done

  PASSPHRASE="$2"
  while [ "$INTERACTIVE" = True ]; do
    PASSPHRASE=$(whiptail --passwordbox "Please enter passphrase. Leave it empty if none." 20 60 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
      return 0
    else
      break
    fi
  done

  # Escape special characters for embedding in regex below
  local ssid="$(echo "$SSID" \
   | sed 's;\\;\\\\;g' \
   | sed -e 's;\.;\\\.;g' \
         -e 's;\*;\\\*;g' \
         -e 's;\+;\\\+;g' \
         -e 's;\?;\\\?;g' \
         -e 's;\^;\\\^;g' \
         -e 's;\$;\\\$;g' \
         -e 's;\/;\\\/;g' \
         -e 's;\[;\\\[;g' \
         -e 's;\];\\\];g' \
         -e 's;{;\\{;g'   \
         -e 's;};\\};g'   \
         -e 's;(;\\(;g'   \
         -e 's;);\\);g'   \
         -e 's;";\\\\\";g')"

  wpa_cli -i "$IFACE" list_networks \
   | tail -n +2 | cut -f -2 | grep -P "\t$ssid$" | cut -f1 \
   | while read ID; do
    wpa_cli -i "$IFACE" remove_network "$ID" > /dev/null 2>&1
  done

  ID="$(wpa_cli -i "$IFACE" add_network)"
  wpa_cli -i "$IFACE" set_network "$ID" ssid "\"$SSID\"" 2>&1 | grep -q "OK"
  RET=$((RET + $?))

  if [ -z "$PASSPHRASE" ]; then
    wpa_cli -i "$IFACE" set_network "$ID" key_mgmt NONE 2>&1 | grep -q "OK"
    RET=$((RET + $?))
  else
    wpa_cli -i "$IFACE" set_network "$ID" psk "\"$PASSPHRASE\"" 2>&1 | grep -q "OK"
    RET=$((RET + $?))
  fi

  if [ $RET -eq 0 ]; then
    wpa_cli -i "$IFACE" enable_network "$ID" > /dev/null 2>&1
  else
    wpa_cli -i "$IFACE" remove_network "$ID" > /dev/null 2>&1
    if [ "$INTERACTIVE" = True ]; then
      whiptail --msgbox "Failed to set SSID or passphrase" 20 60
    fi
  fi
  wpa_cli -i "$IFACE" save_config > /dev/null 2>&1

  echo "$IFACE_LIST" | while read IFACE; do
    wpa_cli -i "$IFACE" reconfigure > /dev/null 2>&1
  done

  return $RET
}

do_finish() {
  disable_raspi_config_at_boot
  if [ $ASK_TO_REBOOT -eq 1 ]; then
    whiptail --yesno "Would you like to reboot now?" 20 60 2
    if [ $? -eq 0 ]; then # yes
      sync
      reboot
    fi
  fi
  exit 0
}

# $1 = filename, $2 = key name
get_json_string_val() {
  sed -n -e "s/^[[:space:]]*\"$2\"[[:space:]]*:[[:space:]]*\"\(.*\)\"[[:space:]]*,$/\1/p" $1
}

# TODO: This is probably broken
do_apply_os_config() {
  [ -e /boot/os_config.json ] || return 0
  NOOBSFLAVOUR=$(get_json_string_val /boot/os_config.json flavour)
  NOOBSLANGUAGE=$(get_json_string_val /boot/os_config.json language)
  NOOBSKEYBOARD=$(get_json_string_val /boot/os_config.json keyboard)

  if [ -n "$NOOBSFLAVOUR" ]; then
    printf "Setting flavour to %s based on os_config.json from NOOBS. May take a while\n" "$NOOBSFLAVOUR"

    printf "Unrecognised flavour. Ignoring\n"
  fi

  # TODO: currently ignores en_gb settings as we assume we are running in a 
  # first boot context, where UK English settings are default
  case "$NOOBSLANGUAGE" in
    "en")
      if [ "$NOOBSKEYBOARD" = "gb" ]; then
        DEBLANGUAGE="" # UK english is the default, so ignore
      else
        DEBLANGUAGE="en_US.UTF-8"
      fi
      ;;
    "de")
      DEBLANGUAGE="de_DE.UTF-8"
      ;;
    "fi")
      DEBLANGUAGE="fi_FI.UTF-8"
      ;;
    "fr")
      DEBLANGUAGE="fr_FR.UTF-8"
      ;;
    "hu")
      DEBLANGUAGE="hu_HU.UTF-8"
      ;;
    "ja")
      DEBLANGUAGE="ja_JP.UTF-8"
      ;;
    "nl")
      DEBLANGUAGE="nl_NL.UTF-8"
      ;;
    "pt")
      DEBLANGUAGE="pt_PT.UTF-8"
      ;;
    "ru")
      DEBLANGUAGE="ru_RU.UTF-8"
      ;;
    "zh_CN")
      DEBLANGUAGE="zh_CN.UTF-8"
      ;;
    *)
      printf "Language '%s' not handled currently. Run sudo SIGbox-config to set up" "$NOOBSLANGUAGE"
      ;;
  esac

  if [ -n "$DEBLANGUAGE" ]; then
    printf "Setting language to %s based on os_config.json from NOOBS. May take a while\n" "$DEBLANGUAGE"
    do_change_locale "$DEBLANGUAGE"
  fi

  if [ -n "$NOOBSKEYBOARD" -a "$NOOBSKEYBOARD" != "gb" ]; then
    printf "Setting keyboard layout to %s based on os_config.json from NOOBS. May take a while\n" "$NOOBSKEYBOARD"
    do_configure_keyboard "$NOOBSKEYBOARD"
  fi
  return 0
}

is_uname_current() {
  test -d "/lib/modules/$(uname -r)"
  return $?
}

nonint() {
  "$@"
}

#
# Command line options for non-interactive use
#
for i in $*
do
  case $i in
  --memory-split)
    OPT_MEMORY_SPLIT=GET
    printf "Not currently supported\n"
    exit 1
    ;;
  --memory-split=*)
    OPT_MEMORY_SPLIT=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    printf "Not currently supported\n"
    exit 1
    ;;
  --expand-rootfs)
    INTERACTIVE=False
    do_expand_rootfs
    printf "Please reboot\n"
    exit 0
    ;;
  --apply-os-config)
    INTERACTIVE=False
    do_apply_os_config
    exit $?
    ;;
  nonint)
    INTERACTIVE=False
    "$@"
    exit $?
    ;;
  *)
    # unknown option
    ;;
  esac
done

#if [ "GET" = "${OPT_MEMORY_SPLIT:-}" ]; then
#  set -u # Fail on unset variables
#  get_current_memory_split
#  echo $CURRENT_MEMSPLIT
#  exit 0
#fi

# Everything else needs to be run as root
if [ $(id -u) -ne 0 ]; then
  printf "Script must be run as root. Try 'sudo SIGbox-config'\n"
  exit 1
fi

if [ -n "${OPT_MEMORY_SPLIT:-}" ]; then
  set -e # Fail when a command errors
  set_memory_split "${OPT_MEMORY_SPLIT}"
  exit 0
fi

do_system_menu() {
  if is_pi ; then
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "System Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "S1 Wireless LAN" "Enter SSID and passphrase" \
      "S2 Audio" "Select audio out through HDMI or 3.5mm jack" \
      "S3 Password" "Change password for the '$USER' user" \
      "S4 Hostname" "Set name for this computer on a network" \
      "S5 Boot / Auto Login" "Select boot into desktop or to command line" \
      "S6 Network at Boot" "Select wait for network connection on boot" \
      "S7 Splash Screen" "Choose graphical splash screen or text boot" \
      "S8 Power LED" "Set behaviour of power LED" \
      3>&1 1>&2 2>&3)
  elif is_live ; then 
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "System Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "S1 Wireless LAN" "Enter SSID and passphrase" \
      "S3 Password" "Change password for the '$USER' user" \
      "S4 Hostname" "Set name for this computer on a network" \
      "S5 Boot / Auto Login" "Select boot into desktop or to command line" \
      "S6 Network at Boot" "Select wait for network connection on boot" \
      3>&1 1>&2 2>&3)
  else
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "System Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "S1 Wireless LAN" "Enter SSID and passphrase" \
      "S3 Password" "Change password for the '$USER' user" \
      "S4 Hostname" "Set name for this computer on a network" \
      "S5 Boot / Auto Login" "Select boot into desktop or to command line" \
      "S6 Network at Boot" "Select wait for network connection on boot" \
      "S7 Splash Screen" "Choose graphical splash screen or text boot" \
      3>&1 1>&2 2>&3)
  fi
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      S1\ *) do_wifi_ssid_passphrase ;;
      S2\ *) do_audio ;;
      S3\ *) do_change_pass ;;
      S4\ *) do_hostname ;;
      S5\ *) do_boot_behaviour ;;
      S6\ *) do_boot_wait ;;
      S7\ *) do_boot_splash ;;
      S8\ *) do_leds ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_display_menu() {
  if is_pi ; then
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Display Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "D1 Resolution" "Set a specific screen resolution" \
      "D2 Underscan" "Remove black border around screen" \
      "D3 Pixel Doubling" "Enable/disable 2x2 pixel mapping" \
      "D4 Screen Blanking" "Enable/disable screen blanking" \
      3>&1 1>&2 2>&3)
  else
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Display Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "D3 Pixel Doubling" "Enable/disable 2x2 pixel mapping" \
      "D4 Screen Blanking" "Enable/disable screen blanking" \
      3>&1 1>&2 2>&3)
  fi
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      D1\ *) do_resolution ;;
      D2\ *) do_overscan ;;
      D3\ *) do_pixdub ;;
      D4\ *) do_blanking ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_interface_menu() {
  if is_pi ; then
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Interfacing Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "P1 Camera" "Enable/disable connection to the Raspberry Pi Camera" \
      "P2 SSH" "Enable/disable remote command line access using SSH" \
      "P3 VNC" "Enable/disable graphical remote access using RealVNC" \
      "P4 SPI" "Enable/disable automatic loading of SPI kernel module" \
      "P5 I2C" "Enable/disable automatic loading of I2C kernel module" \
      "P6 Serial Port" "Enable/disable shell messages on the serial connection" \
      "P7 1-Wire" "Enable/disable one-wire interface" \
      "P8 Remote GPIO" "Enable/disable remote access to GPIO pins" \
      3>&1 1>&2 2>&3)
  else
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Interfacing Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "P2 SSH" "Enable/disable remote command line access using SSH" \
      3>&1 1>&2 2>&3)
  fi
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      P1\ *) do_camera ;;
      P2\ *) do_ssh ;;
      P3\ *) do_vnc ;;
      P4\ *) do_spi ;;
      P5\ *) do_i2c ;;
      P6\ *) do_serial ;;
      P7\ *) do_onewire ;;
      P8\ *) do_rgpio ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_performance_menu() {
  FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Performance Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
    "P1 Overclock" "Configure CPU overclocking" \
    "P2 GPU Memory" "Change the amount of memory made available to the GPU" \
    "P3 Overlay File System" "Enable/disable read-only file system" \
    "P4 Fan" "Set behaviour of GPIO fan" \
    3>&1 1>&2 2>&3)
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      P1\ *) do_overclock ;;
      P2\ *) do_memory_split ;;
      P3\ *) do_overlayfs ;;
      P4\ *) do_fan ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_internationalisation_menu() {
  FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Localisation Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
    "L1 Locale" "Configure language and regional settings" \
    "L2 Timezone" "Configure time zone" \
    "L3 Keyboard" "Set keyboard layout to match your keyboard" \
    "L4 WLAN Country" "Set legal wireless channels for your country" \
    3>&1 1>&2 2>&3)
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      L1\ *) do_change_locale ;;
      L2\ *) do_change_timezone ;;
      L3\ *) do_configure_keyboard ;;
      L4\ *) do_wifi_country ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_advanced_menu() {
  if is_pifour ; then
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Advanced Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "A1 Expand Filesystem" "Ensures that all of the SD card is available" \
      "A2 GL Driver" "Enable/disable experimental desktop GL driver" \
      "A3 Compositor" "Enable/disable xcompmgr composition manager" \
      "A4 Network Interface Names" "Enable/disable predictable network i/f names" \
      "A5 Network Proxy Settings" "Configure network proxy settings" \
      "A6 Boot Order" "Choose network or USB device boot" \
      "A7 Bootloader Version" "Select latest or default boot ROM software" \
      "A8 HDMI / Composite" "Raspberry Pi 4 video output options" \
      3>&1 1>&2 2>&3)
  elif is_pi ; then
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Advanced Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "A1 Expand Filesystem" "Ensures that all of the SD card is available" \
      "A2 GL Driver" "Enable/disable experimental desktop GL driver" \
      "A3 Compositor" "Enable/disable xcompmgr composition manager" \
      "A4 Network Interface Names" "Enable/disable predictable network i/f names" \
      "A5 Network Proxy Settings" "Configure network proxy settings" \
      3>&1 1>&2 2>&3)
  else
    FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Advanced Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
      "A4 Network Interface Names" "Enable/disable predictable network i/f names" \
      "A5 Network Proxy Settings" "Configure network proxy settings" \
      3>&1 1>&2 2>&3)
  fi
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      A1\ *) do_expand_rootfs ;;
      A2\ *) do_gldriver ;;
      A3\ *) do_xcompmgr ;;
      A4\ *) do_net_names ;;
      A5\ *) do_proxy_menu ;;
      A6\ *) do_boot_order ;;
      A7\ *) do_boot_rom ;;
      A8\ *) do_pi4video ;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

do_proxy_menu() {
  FUN=$(whiptail --title "Raspberry Pi Software Configuration Tool (SIGbox-config)" --menu "Network Proxy Settings" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Back --ok-button Select \
    "P1 All" "Set the same proxy for all schemes" \
    "P2 HTTP" "Set the HTTP proxy" \
    "P3 HTTPS" "Set the HTTPS/SSL proxy" \
    "P4 FTP" "Set the FTP proxy" \
    "P5 RSYNC" "Set the RSYNC proxy" \
    "P6 Exceptions" "Set addresses for which a proxy server should not be used" \
    3>&1 1>&2 2>&3)
  RET=$?
  if [ $RET -eq 1 ]; then
    return 0
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      P1\ *) do_proxy all ;;
      P2\ *) do_proxy http ;;
      P3\ *) do_proxy https ;;
      P4\ *) do_proxy ftp ;;
      P5\ *) do_proxy rsync ;;
      P6\ *) do_proxy no;;
      *) whiptail --msgbox "Programmer error: unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  fi
}

#
# Interactive use loop
#
calc_wt_size
while [ "$USER" = "pi" ]; do
  if ! USER=$(whiptail --inputbox "SIG_config can only be run as Pi.\\n" 20 60 pi 3>&1 1>&2 2>&3); then
    return 0
  fi
done
while true; do
  if is_pi ; then
    FUN=$(whiptail --title "SIGpi Configuration Tool (SIGbox-config)" --backtitle "$(cat /proc/device-tree/model)" --menu "Setup Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Finish --ok-button Select \
      "1 Drivers" "SDR and AX.25 drivers" \
      "2 SDR Applications" "General SDR applications" \
      "3 Signal Intel" "Signal encoder/decoder/analysis" \
      "4 GeoSpatial Intel" "Location sate from signals" \
      "5 Amateur Radio" "Amateur Radio specific applications" \
      "6 Utilities" "Useful Utilities" \
      "9 About SIGbox-config" "Information about this configuration tool" \
      3>&1 1>&2 2>&3)
  else
    FUN=$(whiptail --title "SIGbox Configuration Tool (SIGbox-config)" --menu "Setup Options" $WT_HEIGHT $WT_WIDTH $WT_MENU_HEIGHT --cancel-button Finish --ok-button Select \
      "1 Drivers" "SDR and AX.25 drivers" \
      "2 SDR Applications" "General SDR applications" \
      "3 Signal Intel" "Signal encoder/decoder/analysis" \
      "4 GeoSpatial Intel" "Location sate from signals" \
      "5 Amateur Radio" "Amateur Radio specific applications" \
      "6 Utilities" "Useful Utilities" \
      "9 About SIGbox-config" "Information about this configuration tool" \
      3>&1 1>&2 2>&3)
  fi
  RET=$?
  if [ $RET -eq 1 ]; then
    do_finish
  elif [ $RET -eq 0 ]; then
    case "$FUN" in
      1\ *) do_sdrdrivers_menu ;;
      2\ *) do_sdrapps_menu ;;
      3\ *) do_sigint_menu ;;
      4\ *) do_geospatial_menu ;;
      5\ *) do_amateurradio_menu ;;
      6\ *) do_utilities_menu ;;
      9\ *) do_about ;;
      *) whiptail --msgbox "Unrecognized option" 20 60 1 ;;
    esac || whiptail --msgbox "There was an error running option $FUN" 20 60 1
  else
    exit 1
  fi
done
