#!/bin/bash

###
### SIGpi_Update_RadioSonde
###
### 

###
###   REVISION: v02
###

###
###
### This script is part of the SIGbox Project.
###
### Given a Raspberry Pi 4 4GB RAM 32GB microSD with Raspberry Pi OS Full (32-bit) installed
### This script installs drivers and applications for RF use cases that include hacking and 
### Amateur Radio Digital Modes.
###
### Applications and driver updates include
###
### - RadioSonde


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
LIBBTBB_VERSION="2020-12-R1"
UBERTOOTH_VERSION="2020-12-R1"
GRGSM_VERSION="0.42.2"
URH_VERSION="2.9.2"


# Source Directory
SIGPI_SOURCE=$HOME/source

# Executable Directory (will be created as root)
SIGPI_OPT=/opt/SIGpi
SIGPI_EXE=$SIGPI_OPT/bin

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

# SigPi SSL Cert and Key
SIGPI_API_SSL_KEY=$SIGPI_HOME/SIGpi_api.key
SIGPI_API_SSL_CRT=$SIGPI_HOME/SIGpi_api.crt

##
## FUNCTIONS
##

stage_app(){

	##
    ## CREATE DIRECTORIES
    ##

	if [ ! -d "$SIGPI_OPT" ]; then
    	mkdir $SIGPI_OPT
		sudo mkdir -p $SIGPI_OPT
		sudo chown pi:users $SIGPI_OPT
    fi
    
	if [ ! -d "$SIGPI_EXE" ]; then
    	mkdir $SIGPI_EXE
		sudo mkdir -p $SIGPI_EXE
		sudo chown pi:users $SIGPI_EXE
    fi

    if [ ! -d "$SIGPI_SOURCE" ]; then
    	mkdir $SIGPI_SOURCE
    fi
    
    if [ ! -d "$SIGPI_HOME" ]; then
    	mkdir $SIGPI_HOME
    fi
    
	if [ ! -d "$SIGPI_SDRANGEL" ]; then
    	mkdir $SIGPI_SDRANGEL
    fi

	cd $SIGPI_SOURCE

	echo " "
	echo " ## "
    echo " ## "
	echo " - Check Dependencies"
	echo " ## "
    echo " ## "
	echo " "

    sudo apt-get install -y \
git cmake g++ pkg-config autoconf automake libtool libfftw3-dev libusb-1.0-0-dev libusb-dev \
build-essential qtbase5-dev qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev \
qttools5-dev qttools5-dev-tools libqt5opengl5-dev qtbase5-dev libqt5quick5 libqt5charts5-dev \
qml-module-qtlocation  qml-module-qtlocation qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts \
libqt5serialport5-dev qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev \
libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev pulseaudio libopencv-dev libxml2-dev bison flex \
libaio-dev libnova-dev libwxgtk-media3.0-dev gettext libcairo2-dev ffmpeg libavcodec-dev libpcap-dev \
libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev libopus-dev portaudio19-dev doxygen \
libcppunit-dev libbluetooth-dev graphviz gnuplot python-pyside python-qt4 python-docutils libavahi-common-dev libavahi-client-dev
	sudo apt-get install -y qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev gnuplot-x11
	sudo apt-get install -y libavdevice-dev libavutil-dev 
	sudo python3 -m pip install --upgrade pip
    sudo pip3 install pygccxml

	#
	# INSTALL RADIOSONDE
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - Install RadioSonde (RS)"
	echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/rs1729/RS.git
	cd $SIGPI_SOURCE/RS

	echo "  #"
    echo "  - ECC"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/ecc
	gcc bch_ecc.c -lm -o bch_ecc
	gcc crc_polymod.c -lm -o crc_polymod
	gcc ecc-rs_gf16.c -lm -o ecc-rs_gf16
	gcc ecc-rs_vaisala.c -lm -o ecc-rs_vaisala
	sudo chown root:root bch_ecc crc_polymod ecc-rs_gf16 ecc-rs_vaisala
	sudo cp bch_ecc crc_polymod ecc-rs_gf16 ecc-rs_vaisala $SIGPI_EXE

	echo "  #"
    echo "  - C34"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/c34
	gcc c34dft.c -lm -o c34dft
	gcc c50dft.c -lm -o c50dft
	sudo chown root:root c34dft c50dft
	sudo cp c34dft c50dft $SIGPI_EXE
	
	echo "  #"
    echo "  - M10"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/m10
	gcc m10ptu.c -lm -o m10ptu
	gcc m10gtop.c -lm -o m10gtop
	sudo chown root:root m10ptu m10gtop
	sudo cp m10ptu m10gtop $SIGPI_EXE
	cd $SIGPI_SOURCE/RS/m10/pilotsonde
	gcc m12.c -lm -o m12
	sudo chown root:root m12
	sudo cp m12 $SIGPI_EXE

	echo "  #"
    echo "  - Meisei"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/meisei
	ln -s ../ecc/bch_ecc.c bch_ecc.c
	gcc meisei_ecc.c -lm -o meisei_ecc
	gcc meisei_ims.c -lm -o meisei_ims
	gcc meisei_rs.c -lm -o meisei_rs
	sudo chown root:root meisei_ecc meisei_ims meisei_rs
	sudo cp meisei_ecc meisei_ims meisei_rs $SIGPI_EXE

	echo "  #"
    echo "  - RS92"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/rs92
	gcc rs92gps.c -lm -o rs92gps
	sudo chown root:root rs92gps
	sudo cp rs92gps $SIGPI_EXE
	
	echo "  #"
    echo "  - RS41"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/rs42
	ln -s ../ecc/bch_ecc.c bch_ecc.c
	gcc rs41ptu.c -lm -o rs41ptu
	sudo chown root:root rs41ptu
	sudo cp rs41ptu $SIGPI_EXE

	echo "  #"
    echo "  - LMS6"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/lms6
	ln -s ../ecc/bch_ecc.c bch_ecc.c
	gcc lms6.c -lm -o lms6
	gcc lms6ccsds.c -lm -o lms6ccsds
	gcc lms6ecc.c -lm -o lms6ecc
	gcc lmsX2446.c -lm -o lmsX2446 
	sudo chown root:root lms6 lms6ccsds lms6ecc lmsX2446 
	sudo cp lms6 lms6ccsds lms6ecc lmsX2446 $SIGPI_EXE
	
	echo "  #"
    echo "  - IQ"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/iq
	gcc shift_IQ.c -lm -o shift_IQ
	gcc wavIQ.c -lm -o wavIQ
	sudo chown root:root shift_IQ wavIQ
	sudo cp shift_IQ wavIQ $SIGPI_EXE
	
	echo "  #"
    echo "  - IMET"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/imet
	gcc imet1ab.c -lm -o imet1ab
	gcc imet1ab_cpafsk.c -lm -o imet1ab_cpafsk
	gcc imet1rs_dft.c -lm -o imet1rs_dft
	gcc imet1rs_dft_1.c -lm -o imet1rs_dft_1
	gcc imet1rsb.c -lm -o imet1rsb
	sudo chown root:root imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1
	sudo cp imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1 $SIGPI_EXE
	
	echo "  #"
    echo "  - DFM-06/DFM-09"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/dfm
	gcc dfm06ptu.c -lm -o dfm06ptu
	sudo chown root:root dfm06ptu
	sudo cp dfm06ptu $SIGPI_EXE
	
	echo "  #"
    echo "  - MK2A"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/mk2a
	gcc mk2a.c -lm -o mk2a
	gcc mk2a1680mod.c -lm -o mk2a1680mod
	gcc mk2a_lms1680.c -lm -o mk2a_lms1680
	sudo chown root:root mk2a mk2a1680mod mk2a_lms1680
	sudo cp mk2a mk2a1680mod mk2a_lms1680 $SIGPI_EXE

	echo "  #"
    echo "  - MRZ"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/mrz
	gcc mp3h1.c -lm -o mp3h1
	sudo chown root:root mp3h1
	sudo cp mp3h1 $SIGPI_EXE

	echo "  #"
    echo "  - DropSonde"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/dropsonde
	gcc rd94drop.c -lm -o rd94drop
	sudo chown root:root rd94drop
	sudo cp rd94drop $SIGPI_EXE

	echo "  #"
    echo "  - Decod RS Module"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/rs_module
	gcc -c rs_demod_dft.c
	gcc -c rs_datum.c
	gcc -c rs_demod.c
	gcc -c rs_bch_ecc.c
	gcc -c rs_rs41.c
	gcc -c rs_rs92.c
	gcc -c rs_main41.c
	gcc rs_main41.o rs_rs41.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs41mod
	gcc -c rs_main92.c
	gcc rs_main92.o rs_rs92.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs92mod
	sudo cp rs41mod rs92mode $SIGPI_EXE
	
	echo "  #"
    echo "  - Decoders"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/demod
	ln -s ../ecc/bch_ecc.c bch_ecc.c
	sudo gcc -c demod_dft.c
	gcc rs41dm_dft.c demod_dft.o -lm -o rs41dm_dft
	gcc dfm09dm_dft.c demod_dft.o -lm -o dfm09dm_dft
	gcc m10dm_dft.c demod_dft.o -lm -o m10dm_dft
	gcc lms6dm_dft.c demod_dft.o -lm -o lms6dm_dft
	gcc rs92dm_dft.c demod_dft.o -lm -o rs92dm_dft
	sudo chown root:root rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft
	sudo cp rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft sudo cp rt94drop $SIGPI_EXE

	echo "  #"
    echo "  - Tools"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/tools
	gcc -C pa-stdout.c
	sudo cp pa-stdout $SIGPI_EXE
	sudo cp metno_netcdf_gpx.py pos2aprs.pl pos2gpx.pl pos2kml.pl pos2nmea.pl $SIGPI_EXE

	echo "  #"
    echo "  - Scan"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/scan
	gcc -C dft_detect.c
	gcc -C reset_usb.c
	gcc -C rs_detect.c
	gcc -C scan_fft_pow.c
	gcc -C scan_fft_simple.c
	sudo cp diff_detect reset_usb rs_detect scan_fft_pow scan_fft_simpl $SIGPI_EXE
	sudo cp plot_fft_pow.py plot_fft_simple.py rtlsdr_scan.pl scan_multi.sh scan_multi_rs.pl $SIGPI_EXE

	#
	# Copy Menuitems into relevant directories
	# 
	
	#sudo cp $SIGPI_MENU/sigpi_example.desktop $DESKTOP_FILES
	sudo cp $SIGPI_MENU/SigPi.directory $DESKTOP_DIRECTORY
	sudo cp $SIGPI_MENU/SigPi.menu $DESKTOP_XDG_MENU
	sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
	sudo cp /usr/local/share/Lime/Desktop/lime-suite.desktop $DESKTOP_FILES
	sudo cp $SIGPI_MENU/*.desktop $DESKTOP_FILES
	sudo ln -s $DESKTOP_XDG_MENU/SigPi.menu /etc/xdg/menus/applications-merged/SigPi.menu

	#
	# Add SigPi Category for each installed application
	#

	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/radiosonde.desktop

}

##
## START
##

echo "### "
echo "### "
echo "###  SIGpi Update - Radiosonde Install"
echo "### "
echo "### "
echo " "

##
##  MAIN
##

stage_U1

# Make python scripts executable in /opt/SIGpi/bin
cd $SIGPI_EXE
sudo chmod 755 *py 
cd $SIGPI_HOME

# Shutoff and delete swapfile

echo "*** "
echo "*** "
echo "***   UPDATE COMPLETE"
echo "*** "
echo "*** "
echo " "
exit 0