#!/bin/bash

###
### SIGpi_installer
###

###
###   REVISION: 2021017-0100
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

# Package Versions
HAMLIB_PKG="hamlib-4.3.tar.gz"
FLXMLRPC_PKG="flxmlrpc-0.1.4.tar.gz"
FLRIG_PKG="flrig-1.4.2.tar.gz"
FLDIGI_PKG="fldigi-4.1.20.tar.gz"
WSJTX_PKG="wsjtx_2.4.0_armhf.deb"
QSSTV_PKG="qsstv_9.5.8.tar.gz"

# Source Directory
SIGPI_SOURCE=$HOME/source

# SIGpi Home directory
SIGPI_HOME=$SIGPI_SOURCE/SIGpi

# SDRangel Source directory
SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel

# Desktop directories
SIGPI_THEMES=$SIGPI_HOME/themes
SIGPI_BACKGROUNDS=$SIGPI_THEMES/backgrounds
SIGPI_ICONS=$SIGPI_THEMES/icons
SIGPI_LOGO=$SIGPI_THEMES/logo
SIGPI_DESKTOP=$SIGPI_THEMES/desktop

# Desktop Destination Directories
DESKTOP_DIRECTORY=/usr/share/desktop-directories
DESKTOP_FILES=/usr/share/applications
DESKTOP_ICONS=/usr/share/icons
DESKTOP_XDG_MENU=/usr/share/extra-xdg-menus

# SigPi Menu category
SIGPI_MENU_CATEGORY=SigPi

# SigPi Install Support files
SIG_CONFIG=$SIGPI_HOME/sigpi_installer_config.txt
SIG_INSTALL_TXT1=$SIGPI_HOME/updates/SIGpi-installer-1.txt
SIG_BANNER_COLOR="\e[0;104m\e[K"   # blue
SIG_BANNER_RESET="\e[0m"


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
    TERM=ansi whiptail --title "SigPi Installer" --textbox $SIG_INSTALL_TXT1 24 120 16
}

select_sdrdevices() {
    FUN=$(whiptail --title "SDR Devices" --checklist --separate-output \
        "Choose SDR devices " 20 80 12\
        "rtl-sdr" "RTL2832U & R820T2-Based " ON \
        "hackrf" "Hack RF One " OFF \
        "libiio" "PlutoSDR " OFF \
        "limesuite" "LimeSDR " OFF \
        "soapysdr" "SoapySDR Library " ON \
        "soapyremote" "Use any Soapy SDR Remotely " ON \
        "soapyrtlsdr" "Soapy SDR Module for RTLSDR " ON \
        "soapyhackrf" "Soapy SDR Module for HackRF One " OFF \
        "soapyplutosdr" "Soapy SDR Module for PlutoSD " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_gnuradio() {
    FUN=$(whiptail --title "GNUradio" --radiolist --separate-output \
        "Choose GNUradio version" 20 80 12 \
        "gnuradio-3.7" "Installed from Distro " OFF \
		"gnuradio-3.8" "Compiled from Repo " ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_decoders() {
    FUN=$(whiptail --title "Digital Decoders" --checklist --separate-output \
        "Choose Decoders " 20 120 12\
        "aptdec" "Decodes images transmitted by NOAA weather satellites " ON \
        "rtl_433" "Generic data receiver with sensor support mainly for UHF ISM Bands " ON \
		"radiosonde" "Decoders used in Balloon flights" ON \
        "op25" "P25 digital voice decoder which works with RTL-SDR dongles" ON \
        "multimon-ng" "Decoder for POCSGA, FLEX, X10, DTMF, ZVEi, UFSK, AFSK, etc" ON \
        "ubertooth-tools" "Bluetooth BLE and BR tools for Ubertooth device" ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_sdrapps() {
    FUN=$(whiptail --title "SDR Applications" --checklist --separate-output \
        "Choose SDR Applications" 20 80 12 \
        "gqrx" "SDR Receiver " ON \
        "cubicsdr" "SDR Receiver " OFF \
        "sdrangel" "SDRangel " OFF \
		"sdrplusplus" "SDR++ " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_amateurradio() {
	FUN=$(whiptail --title "Ham Control Library" --radiolist --separate-output \
        "Used for external control of Amateur Radio and some SDR transceivers as \
		well as antenna rotors. Choose HAMlib version" 20 80 12 \
        "hamlib-3.3" "Installed from distro " OFF \
        "hamlib-4.3" "Compiled from Repo (~20 minutes compile time) " ON \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG

    FUN=$(whiptail --title "Fldigi Suite" --radiolist --separate-output \
        "Used for MFSK, PSK31, CW, RTTY. WEFAX and many others \
		Choose Fldigi version" 20 80 12 \
        "fldigi-4.1.01" "Installed from distro " ON \
        "fldigi-4.1.20" "Compiled from Repo (~40 minutes compile time) " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG

	FUN=$(whiptail --title "Weak Signal Amateur Radio" --radiolist --separate-output \
        "Used for FT8, JT4, JT9, JT65, QRA64, ISCAT, MSK144, and WSPR \
		digital modes. Choose WSJT-X version" 20 80 12 \
        "wsjtx-2.0" "Installed from distro " ON \
        "wsjtx-2.4.0" "Compiled from Repo (~20 minutes compile time) " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG

	FUN=$(whiptail --title "SigPi Installer" --radiolist --separate-output \
        "Choose QSSTV version" 20 80 12 \
        "qsstv-9.2.6" "Installed from distro " ON \
        "qsstv-9.5.8" "Compiled from Repo (~20 minutes compile time) " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG

    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose Packet Radio Applications" 20 80 12 \
        "direWolf" "DireWolf 1.7 Soundcard TNC for APRS " OFF \
        "linpac" "Packet Radio Temrinal with mail client " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_usefulapps() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose other Useful Applications" 20 120 12 \
		"artemis" "Real-tim RF Signal Recognition to a large database of signals " OFF \
        "gps" "GPS client and NTP sync " OFF \
        "gpredict" "Satellite Tracking " OFF \
		"splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
		"wireshark" "Network Traffic Analyzer " OFF \
        "kismet" "Wireless snifferand monitor " OFF \
        "audacity" "Audio Editor " OFF \
        "pavu" "PulseAudio Control " OFF \
        "mumble" "VoIP Server and Client " OFF \
        "tempest" "Uses your computer monitor to send out AM radio signals" OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

install_dependencies(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Dependencies"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
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

	sudo fallocate -l 2G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile

    sudo apt-get install -y git cmake g++ pkg-config autoconf automake libtool build-essential pulseaudio bison flex gettext ffmpeg
	sudo apt-get install -y portaudio19-dev doxygen graphviz gnuplot gnuplot-x11 swig  icu-doc libjs-jquery-ui-docs tcl8.6 tk8.6 libvolk2-doc python-cycler-doc
	sudo apt-get install -y tk8.6-blt2.5 ttf-bitstream-vera uhd-host dvipng texlive-latex-extra ttf-staypuft tix openssl
	
	sudo apt-get install -y libusb-1.0-0 libusb-1.0-0-dev libusb-dev libudev1
	sudo apt-get install -y libaio-dev libusb-1.0-0-dev libserialport-dev libxml2-dev libavahi-client-dev doxygen graphviz
	sudo apt-get install -y libfltk1.3 libfltk1.3-dev 
	sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev libv4l-dev
	sudo apt-get install -y libsdl1.2-dev libfaad2 libfftw3-dev libfftw3-doc libfftw3-bin libfftw3-dev libfftw3-long3 libfftw3-quad3

	sudo apt-get install -y libvolk2-bin libvolk2-dev libvolk2.2 libfaad-dev zlib1g zlib1g-dev libasound2-dev 
	sudo apt-get install -y libopencv-dev libxml2-dev libaio-dev libnova-dev libwxgtk-media3.0-dev libcairo2-dev libavcodec-dev libpthread-stubs0-dev
	sudo apt-get install -y libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev libopus-dev libavahi-common-dev libavahi-client-dev libavdevice-dev libavutil-dev
	sudo apt-get install -y libsdl1.2-dev libgsl-dev liblog4cpp5-dev libzmq3-dev liborc-0.4 liborc-0.4-0 liborc-0.4-dev libsamplerate0-dev libgmp-dev
	sudo apt-get install -y libpcap-dev libcppunit-dev libbluetooth-dev qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev
	sudo apt-get install -y libgles1 libosmesa6 gmp-doc libgmp10-doc libmpfr-dev libmpfrc++-dev libntl-dev libcppunit-doc zlib-dev libpng-dev
	
	sudo apt-get install -y libcanberra-gtk-module libcanberra-gtk0 libcppunit-1.15-0 libcppunit-dev  
	sudo apt-get install -y libfreesrp0 libglfw3 libgmp-dev libgmpxx4ldbl libhidapi-libusb0 libicu-dev libjs-jquery-ui 
	sudo apt-get install -y liblog4cpp5-dev liblog4cpp5v5 faad libfaad2 libfaad-dev

	sudo apt-get install -y python3-pip python3-numpy python3-mako python3-sphinx python3-lxml python3-yaml python3-click python3-click-plugins 
	sudo apt-get install -y python3-zmq python3-scipy python3-scapy python3-setuptools python3-pyqt5 python3-gi-cairo python-docutils python-gobject python3-nose

	sudo apt-get install -y python3-tornado texlive-extra-utils python-networkx-doc python3-gdal python3-pygraphviz python3-pydot libgle3 python-pyqtgraph-doc 
	sudo apt-get install -y python-matplotlib-doc python3-cairocffi python3-tk-dbg python-matplotlib-data python3-cycler python3-kiwisolver python3-matplotlib python3-networkx 
	sudo apt-get install -y python3-opengl python3-pyqt5.qtopengl python3-pyqtgraph python3-tk

	sudo python3 -m pip install --upgrade pip
	sudo pip3 install pyinstaller
	sudo pip3 install pygccxml
	sudo pip3 install qtawesome
	sudo pip3 install PyQt5
	sudo pip3 install PyQt4
	sudo pip3 install PySide

	# RTL-SDR Dependencies
	sudo apt-get install -y libusb-1.0-0-dev

	# APTdec dependencies
	sudo apt-get install -y libsndfile-dev libpng-dev

	# LibDAB dab-cmdline dependencies
	sudo apt-get install -y pkg-config libsndfile1-dev libfftw3-dev portaudio19-dev libfaad-dev zlib1g-dev libusb-1.0-0-dev mesa-common-dev libgl1-mesa-dev libsamplerate0-dev

	# MBElib, SerialDV, SGP4, LibTBB- no dependencies specified
	
	# DSDcc - requires MBElib installed prior

	# Liquid-DSP - prefers FFTW installed prior

	# Codec2
	sudo apt-get install -y octave octave-common octave-signal liboctave-dev gnuplot python3-numpy sox valgrind

install_radiosonde(){
	#
	# INSTALL RADIOSONDE
	#
	echo -e "${SIGBOX_BANNER_COLOR}"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#   Install RadioSonde"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
	echo -e "${SIGBOX_BANNER_RESET}"

	cd $SIGBOX_SOURCE
	git clone https://github.com/rs1729/RS.git

	echo "  "
	echo "  ## RS92"
	cd $SIGBOX_SOURCE/RS/rs92
	gcc rs92gps.c -lm -o rs92gps
	sudo chown root:root rs92gps
	sudo cp rs92gps /usr/local/bin

	echo "  "
	echo "  ## RS41"
	cd $SIGBOX_SOURCE/RS/rs41
	cp $SIGBOX_SOURCE/RS/ecc/bch_ecc.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.h .
	gcc rs41ptu.c -lm -o rs41ptu
	sudo chown root:root rs41ptu
	sudo cp rs41ptu /usr/local/bin

	echo "  "
	echo "  ## DropSonde"
	cd $SIGBOX_SOURCE/RS/dropsonde
	gcc rd94drop.c -lm -o rd94drop
	sudo chown root:root rd94drop
	sudo cp rd94drop /usr/local/bin

	echo "  "
	echo "  ## M10"
	cd $SIGBOX_SOURCE/RS/m10
	gcc m10ptu.c -lm -o m10ptu
	gcc m10gtop.c -lm -o m10gtop
	sudo chown root:root m10ptu m10gtop
	sudo cp m10ptu m10gtop /usr/local/bin
	cd $SIGBOX_SOURCE/RS/m10/pilotsonde
	gcc m12.c -lm -o m12
	sudo chown root:root m12
	sudo cp m12 /usr/local/bin

	echo "  "
	echo "  ## dfm (06 and 09)"
	cd $SIGBOX_SOURCE/RS/dfm
	gcc dfm06ptu.c -lm -o dfm06ptu
	sudo chown root:root dfm06ptu
	sudo cp dfm06ptu /usr/local/bin

	echo "  "
	echo "  ## imet"
	cd $SIGBOX_SOURCE/RS/imet
	gcc imet1ab.c -lm -o imet1ab
	gcc imet1ab_cpafsk.c -lm -o imet1ab_cpafsk
	gcc imet1rs_dft.c -lm -o imet1rs_dft
	gcc imet1rs_dft_1.c -lm -o imet1rs_dft_1
	gcc imet1rsb.c -lm -o imet1rsb
	sudo chown root:root imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1
	sudo cp imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1 /usr/local/bin

	echo "  "
	echo "  ## c34"
	cd $SIGBOX_SOURCE/RS/c34
	gcc c34dft.c -lm -o c34dft
	gcc c50dft.c -lm -o c50dft
	sudo chown root:root c34dft c50dft
	sudo cp c34dft c50dft /usr/local/bin

	echo "  "
	echo "  ## lms6"
	cd $SIGBOX_SOURCE/RS/lms6
	cp $SIGBOX_SOURCE/RS/ecc/bch_ecc.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.h .
	gcc lms6.c -lm -o lms6
	gcc lms6ccsds.c -lm -o lms6ccsds
	gcc lms6ecc.c -lm -o lms6ecc
	gcc lmsX2446.c -lm -o lmsX2446 
	sudo chown root:root lms6 lms6ccsds lms6ecc lmsX2446 
	sudo cp lms6 lms6ccsds lms6ecc lmsX2446 /usr/local/bin

	echo "  "
	echo "  ## mk2A"
	cd $SIGBOX_SOURCE/RS/mk2a
	gcc mk2a.c -lm -o mk2a
	gcc mk2a1680mod.c -lm -o mk2a1680mod
	gcc mk2a_lms1680.c -lm -o mk2a_lms1680
	sudo chown root:root mk2a mk2a1680mod mk2a_lms1680
	sudo cp mk2a mk2a1680mod mk2a_lms1680 /usr/local/bin

	echo "  "
	echo "  ## Meisei"
	cd $SIGBOX_SOURCE/RS/meisei
	cp $SIGBOX_SOURCE/RS/ecc/bch_ecc.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.h .
	gcc meisei_ecc.c -lm -o meisei_ecc
	gcc meisei_ims.c -lm -o meisei_ims
	gcc meisei_rs.c -lm -o meisei_rs
	sudo chown root:root meisei_ecc meisei_ims meisei_rs
	sudo cp meisei_ecc meisei_ims meisei_rs /usr/local/bin

	echo "  "
	echo "  ## MRZ"
	cd $SIGBOX_SOURCE/RS/mrz
	gcc mp3h1.c -lm -o mp3h1
	sudo chown root:root mp3h1

	echo "  "
	echo "  ## Decoders"
	cd $SIGBOX_SOURCE/RS/demod
	cp $SIGBOX_SOURCE/RS/ecc/bch_ecc.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.c .
	cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.h .
	cp $SIGBOX_SOURCE/RS/rs92/nav_gps_vel.c .
	sudo gcc -c demod_dft.c
	gcc rs41dm_dft.c demod_dft.o -lm -o rs41dm_dft
	gcc dfm09dm_dft.c demod_dft.o -lm -o dfm09dm_dft
	gcc m10dm_dft.c demod_dft.o -lm -o m10dm_dft
	gcc lms6dm_dft.c demod_dft.o -lm -o lms6dm_dft
	gcc rs92dm_dft.c demod_dft.o -lm -o rs92dm_dft
	sudo chown root:root rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft
	sudo cp rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft /usr/local/bin

	echo "  "
	echo "  ## IQ"
	cd $SIGBOX_SOURCE/RS/iq
	gcc shift_IQ.c -lm -o shift_IQ
	gcc wavIQ.c -lm -o wavIQ
	sudo chown root:root shift_IQ wavIQ
	sudo cp shift_IQ wavIQ /usr/local/bin

	echo "  "
	echo "  ## Scan"
	cd $SIGBOX_SOURCE/RS/scan
	#gcc -C dft_detect.c -lm -o dft_detect # Compile issues with line 88 and 93
	gcc -C dft_detect.c -lm -o dft_detect
	gcc -C reset_usb.c -lm -o reset_usb
	gcc -C rs_detect.c -lm -o rs_detect
	gcc -C scan_fft_pow.c -lm -o scan_fft_pow
	gcc -C scan_fft_simple.c -lm -o scan_fft_simple
	sudo chown root:root reset_usb rs_detect scan_fft_pow scan_fft_simple
	sudo cp dft_detect reset_usb rs_detect scan_fft_pow scan_fft_simple /usr/local/bin

	#echo "  #"
	#echo "  - Decod RS Module"
	#echo "  #"
	#echo " "
	#cd $SIGBOX_SOURCE/RS/rs_module
	#cp $SIGBOX_SOURCE/RS/ecc/bch_ecc.c .
	#cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.c .
	#cp $SIGBOX_SOURCE/RS/demod/mod/bch_ecc_mod.h .
	#gcc -c rs_datum.c
	#gcc -c rs_demod.c
	#gcc -c rs_bch_ecc.c
	#gcc -c rs_rs41.c
	#gcc -c rs_rs92.c
	#gcc -c rs_main41.c
	#gcc rs_main41.o rs_rs41.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs41mod
	#gcc -c rs_main92.c
	#gcc rs_main92.o rs_rs92.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs92mod
	#sudo chown root:root rs41mod rs92mod
	#sudo cp rs41mod rs92mod /usr/local/bin
	
	echo "  "
	echo "  ## Tools"
	cd $SIGBOX_SOURCE/RS/tools
	#pa-stdout.c  compile issued with undfined references so skipping
	#chown root:root metno_netcdf_gpx.py pos2pars.py pos2gpx.pl pos2kml.pl
	sudo cp metno_netcdf_gpx.py pos2pars.py pos2gpx.pl pos2kml.pl postnmea.p1 /usr/local/bin
}

install_libraries(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Libraries   (ETA: +30 Minutes)"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	cd $SIGPI_SOURCE

	# APT
	# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
    cd $SIGPI_SOURCE
	git clone https://github.com/srcejon/aptdec.git
	cd aptdec
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# CM265cc
    cd $SIGPI_SOURCE
	git clone https://github.com/f4exb/cm256cc.git
	cd cm256cc
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# LibDAB
    cd $SIGPI_SOURCE
	git clone https://github.com/srcejon/dab-cmdline
	cd dab-cmdline/library
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# MBElib
    cd $SIGPI_SOURCE
	git clone https://github.com/szechyjs/mbelib.git
	cd mbelib
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# SerialDV
    cd $SIGPI_SOURCE
	git clone https://github.com/f4exb/serialDV.git
	cd serialDV
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# DSDcc
    cd $SIGPI_SOURCE
	git clone https://github.com/f4exb/dsdcc.git
	cd dsdcc
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# SGP4
	# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
    cd $SIGPI_SOURCE
	git clone https://github.com/dnwrnr/sgp4.git
	cd sgp4
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# LibSigMF
    cd $SIGPI_SOURCE
	git clone https://github.com/deepsig/libsigmf.git
	cd libsigmf
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig
	
    # Liquid-DSP
	cd $SIGPI_SOURCE
	git clone https://github.com/jgaeddert/liquid-dsp
	cd liquid-dsp
	./bootstrap.sh
	./configure --enable-fftoverride 
	make -j4
	sudo make install
	sudo ldconfig

    # Bluetooth Baseband Library
	cd $SIGPI_SOURCE
	git clone https://github.com/greatscottgadgets/libbtbb.git
	cd libbtbb
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# Hamlib
	wget https://github.com/Hamlib/Hamlib/releases/download/4.3/hamlib-4.3.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/hamlib-4.3.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/hamlib-4.3
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig
}

install_gnuradio38(){
	cd $SIGPI_SOURCE
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install GNUradio 3.8    (ETA: +60 Minutes)"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	git clone https://github.com/gnuradio/gnuradio.git
	cd gnuradio
	git checkout maint-3.8
	git submodule update --init --recursive
	mkdir build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ../
	make -j4
	sudo make install
	sudo ldconfig
	cd ~
	echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.6/dist-packages:$PYTHONPATH" >> .profile
	echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> .profile
}

install_sdrangel(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install SDRangel (ETA: +80 Minutes)"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	cd $SIGPI_SOURCE
    sudo mkdir -p /opt/build
	sudo chown pi:users /opt/build
	sudo mkdir -p /opt/install
	sudo chown pi:users /opt/install

	# APT
	# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
    cd $SIGPI_SDRANGEL
	git clone https://github.com/srcejon/aptdec.git
	cd aptdec
	git checkout libaptdec
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/aptdec ..
	make -j $(nproc) install

	# CM265cc
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/cm256cc.git
	cd cm256cc
	git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/cm256cc ..
	make -j $(nproc) install

	# LibDAB
    cd $SIGPI_SDRANGEL
	git clone https://github.com/srcejon/dab-cmdline
	cd dab-cmdline/library
	git checkout msvc
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libdab ..
	make -j $(nproc) install

	# MBElib
    cd $SIGPI_SDRANGEL
	git clone https://github.com/szechyjs/mbelib.git
	cd mbelib
	git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/mbelib ..
	make -j $(nproc) install

	# SerialDV
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/serialDV.git
	cd serialDV
	git reset --hard "v1.1.4"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/serialdv ..
	make -j $(nproc) install

	# DSDcc
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/dsdcc.git
	cd dsdcc
	git reset --hard "v1.9.3"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=/opt/install/mbelib/include -DLIBMBE_LIBRARY=/opt/install/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=/opt/install/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=/opt/install/serialdv/lib/libserialdv.so ..
	make -j $(nproc) install

	# Codec2/FreeDV
	# Codec2 is already installed from the packager, but this version is required for SDRangel.
    cd $SIGPI_SDRANGEL
	git clone https://github.com/drowe67/codec2.git
	cd codec2
	git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2
	mkdir build_linux; cd build_linux
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/codec2 ..
	make -j $(nproc) install

	# SGP4
	# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
    cd $SIGPI_SDRANGEL
	git clone https://github.com/dnwrnr/sgp4.git
	cd sgp4
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/sgp4 ..
	make -j $(nproc) install

	# LibSigMF
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/libsigmf.git
	cd libsigmf
	git checkout "new-namespaces"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libsigmf .. 
	make -j $(nproc) install
	sudo ldconfig

	# RTLSDR
	cd $SIGPI_SDRANGEL
	git clone https://github.com/osmocom/rtl-sdr.git librtlsdr
	cd librtlsdr
	git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7
	mkdir build; cd build
	cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=/opt/install/librtlsdr ..
	make -j4 install

	# PlutoSDR
	cd $SIGPI_SDRANGEL
	git clone https://github.com/analogdevicesinc/libiio.git
	cd libiio
	git reset --hard v0.21
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libiio -DINSTALL_UDEV_RULE=OFF ..
	make -j4 install

	# HackRF
	cd $SIGPI_SDRANGEL
	git clone https://github.com/mossmann/hackrf.git
	cd hackrf/host
	git reset --hard "v2018.01.1"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libhackrf -DINSTALL_UDEV_RULES=OFF ..
	make -j4 install

	# LimeSDR
	cd $SIGPI_SDRANGEL
	git clone https://github.com/myriadrf/LimeSuite.git
	cd LimeSuite
	git reset --hard "v20.01.0"
	mkdir builddir; cd builddir
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite ..
	make -j4 install

	#SoapySDR
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapySDR.git
	cd SoapySDR
	git reset --hard "soapy-sdr-0.7.1"
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR ..
	make -j4 install
	
	#SoapyRTLSDR
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyRTLSDR.git
	cd SoapyRTLSDR
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR  -DRTLSDR_INCLUDE_DIR=/opt/install/librtlsdr/include -DRTLSDR_LIBRARY=/opt/install/librtlsdr/lib/librtlsdr.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SoapyHackRF
    cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyHackRF.git
	cd SoapyHackRF
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DLIBHACKRF_INCLUDE_DIR=/opt/install/libhackrf/include/libhackrf -DLIBHACKRF_LIBRARY=/opt/install/libhackrf/lib/libhackrf.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SoapyLimeRF
    cd $SIGPI_SDRANGEL
	cd LimeSuite/builddir
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite -DCMAKE_PREFIX_PATH=/opt/install/SoapySDR ..
	make -j4 install
	cp /opt/install/LimeSuite/lib/SoapySDR/modules0.7/libLMS7Support.so /opt/install/SoapySDR/lib/SoapySDR/modules0.7

	#SoapyRemote
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyRemote.git
	cd SoapyRemote
	git reset --hard "soapy-remote-0.5.1"
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SDRangel
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/sdrangel.git
	cd sdrangel
	mkdir build; cd build
	cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DHACKRF_DIR=/opt/install/libhackrf \
	-DRTLSDR_DIR=/opt/install/librtlsdr \
	-DLIMESUITE_DIR=/opt/install/LimeSuite \
	-DIIO_DIR=/opt/install/libiio \
	-DSOAPYSDR_DIR=/opt/install/SoapySDR \
	-DAPT_DIR=/opt/install/aptdec \
	-DCM256CC_DIR=/opt/install/cm256cc \
	-DDSDCC_DIR=/opt/install/dsdcc \
	-DSERIALDV_DIR=/opt/install/serialdv \
	-DMBE_DIR=/opt/install/mbelib \
	-DCODEC2_DIR=/opt/install/codec2 \
	-DSGP4_DIR=/opt/install/sgp4 \
	-DLIBSIGMF_DIR=/opt/install/libsigmf \
	-DDAB_DIR=/opt/install/libdab \
	-DCMAKE_INSTALL_PREFIX=/opt/install/sdrangel ..
	make -j4 install
	# Copy special startup script for this snowflake
	sudo cp $SIGPI_HOME/snowflakes/SIGpi_sdrangel.sh /usr/local/bin

    cd $HOME/.config/
	mkdir f4exb
	cd f4exb
	# Generate a new wisdom file for FFT sizes : 128, 256, 512, 1024, 2048, 4096, 8192, 16384 and 32768.
	# This will take a very long time.
	fftwf-wisdom -n -o fftw-wisdom 128 256 512 1024 2048 4096 8192 16384 32768

    # Add VOX for Transimtting with SDRangel
	cd $SIGPI_SOURCE
	git clone https://gitlab.wibisono.or.id/published/voxangel.git
	
}

install_sdrplusplus(){
	echo -e "${SIGBOX_BANNER_COLOR}"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#   Install SDRplusplus"
	echo -e "${SIGBOX_BANNER_COLOR} #SIGBOX#"
	echo -e "${SIGBOX_BANNER_RESET}"

	sudo apt-get install -y libfftw3-dev libglfw3-dev libglew-dev libvolk2-dev libsoapysdr-dev libad9361-dev libairspyhf-dev 

	cd $SIGBOX_SOURCE
	git clone https://github.com/AlexandreRouma/SDRPlusPlus
	cd SDRPlusPlus
	mkdir build && cd build
	cmake ../ -DOPT_BUILD_AUDIO_SINK=OFF \
	-DOPT_BUILD_BLADERF_SOURCE=OFF \
	-DOPT_BUILD_M17_DECODER=ON \
	-DOPT_BUILD_NEW_PORTAUDIO_SINK=ON \
	-DOPT_BUILD_PLUTOSDR_SOURCE=ON \
	-DOPT_BUILD_PORTAUDIO_SINK=ON \
	-DOPT_BUILD_SOAPY_SOURCE=ON \
	-DOPT_BUILD_AIRSPY_SOURCE=OFF
	make -j4
	sudo make install
	sudo ldconfig

	# SDRplusplus dependencies
	#sudo apt-get install -y libfftw3-dev libglfw3-dev libglew-dev libvolk2-dev libsoapysdr-dev libairspyhf-dev libiio-dev libad9361-dev librtaudio-dev libhackrf-dev
	#
	#wget https://github.com/AlexandreRouma/SDRPlusPlus/releases/download/1.0.3/sdrpp_ubuntu_focal_amd64.deb -D $HOME/Downloads
	#sudo dpkg -i $HOME/Downloads/sdrpp_ubuntu_focal_amd64.deb
}

install_kismet(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Kismet"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	TERM=ansi whiptail --infobox "Installing Kismet" 10 100
    wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | sudo apt-key add -
    echo 'deb https://www.kismetwireless.net/repos/apt/release/buster buster main' | sudo tee /etc/apt/sources.list.d/kismet.list
	sudo apt update
    sudo apt-get install -y kismet
    #
    # Say yes when asked about suid helpers
    #
}

install_fldigi(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Fldigi Suite"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
    # Install FLxmlrpc
	wget http://www.w1hkj.com/files/flxmlrpc/flxmlrpc-0.1.4.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/flxmlrpc-0.1.4.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/flxmlrpc-0.1.4
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig
	
	# Install FLrig
	wget http://www.w1hkj.com/files/flrig/flrig-1.4.2.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/flrig-1.4.2.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/flrig-1.4.2
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig
	sudo cp $SIGPI_SOURCE/flrig-1.4.2/data/flrig.desktop $SIGPI_DESKTOP

	#Install Fldigi
	wget http://www.w1hkj.com/files/fldigi/fldigi-4.1.20.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/fldigi-4.1.20.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/fldigi-4.1.20
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig
	sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/fldigi.desktop $SIGPI_DESKTOP
	sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/flarq.desktop $SIGPI_DESKTOP
}

install_wsjtx(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install WSJT-Xt"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
    wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.4.0_armhf.deb -P $HOME/Downloads
	sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb
	# Will get error next command fixes error and downloads dependencies
	sudo apt-get --fix-broken install
	sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb
}

install_qsstv(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install QSSTV"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
    sudo apt-get install -y libhamlib-dev libv4l-dev
	sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev
	wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
	tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/qsstv
	qmake
	make
	sudo make install
}

install_tempest-eliza(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install TEMPEST for Eliza"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	wget http://www.erikyyy.de/tempest/tempest_for_eliza-1.0.5.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/tempest_for_eliza-1.0.5.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/tempest_for_eliza-1.0.5
	./configure
	make
	sudo make install
	sudo ldconfig
}

install_sigpimenu(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install SIGpi Menu and Desktop Shortcuts"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
    
	#
	# Copy Menu items into relevant directories
	# 
	
	#sudo cp $SIGPI_DESKTOP/sigpi_example.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/lime-suite.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/gnuradio/grc/scripts/freedesktop/gnuradio-grc.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/SDRangel/sdrangel/build/sdrangel.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/flrig-1.4.2/data/flrig.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/flarq.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/fldigi-4.1.20/data/fldigi.desktop $DESKTOP_FILES
	sudo cp $SIGPI_SOURCE/qsstv/qsstv.desktop $DESKTOP_FILES
	sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
	sudo cp $SIGPI_DESKTOP/SigPi.directory $DESKTOP_DIRECTORY
	sudo cp $SIGPI_DESKTOP/SigPi.menu $DESKTOP_XDG_MENU
	sudo cp $SIGPI_ICONS/* $DESKTOP_ICONS
	
	#
	# Add SigPi Category for each installed application
	#

	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/mumble.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrpp.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigidwiki.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_example.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sigpi_home.desktop
	
	#
	# Add installed applications into SigPi menu
	#

	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/lime-suite.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gnuradio-grc.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gqrx.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/CubicSDR.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrangel.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/direwolf.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/linpac.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/xastir.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flarq.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/fldigi.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/flrig.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wsjtx.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/message_aggregator.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/qsstv.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrpp.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/mumble.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/gpredict.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/wireshark.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigidwiki.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_example.desktop
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sigpi_home.desktop

	# Add Desktop links
	sudo cp $SIGPI_DESKTOP/sigpi_home.desktop $HOME/Desktop/SIGpi.desktop


	# Remove Rogue desktop file to ensure we use the one we provided for direwolf
	sudo rm -rf /usr/local/share/applications/direwolf.desktop
}

config_stuff(){
	TERM=ansi whiptail --infobox "When the pop-up window appears, answer NO to the first \
	two questions. Last question will ask you to create a password for the SuperUser \
	account to manage the VoIP server" 10 100
	cd $SIGPI_SOURCE
    sleep 9
	sudo dpkg-reconfigure mumble-server
}


###
###  MAIN
###

touch $SIG_CONFIG
calc_wt_size
select_startscreen
select_sdrdevices
select_gnuradio
select_decoders
select_sdrapps
select_amateurradio
select_usefulapps
TERM=ansi whiptail --title "SigPi Installer" --msgbox "Ready to Install" 12 120

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   System Update & Upgrade"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

sudo apt-get -y update
sudo apt-get -y upgrade
install_dependencies
install_libraries

##
##  INSTALL DRIVERS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Drivers"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# AX.25 and utilities"
sudo apt-get install -y libax25 ax25-apps ax25-tools
echo "ax0 N0CALL-3 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports

# RTL-SDR
if grep rtl-sdr "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/osmocom/rtl-sdr.git
	cd rtl-sdr
	mkdir build	
	cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig
fi

# HackRF
if grep hackrf "$SIG_CONFIG"
then
    sudo apt-get install -y hackrf libhackrf-dev
	sudo hackrf_info
fi

# PlutoSDR
if grep libiio "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/analogdevicesinc/libiio.git
	cd libiio
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig
fi

# LimeSDR
if grep limesuite "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/myriadrf/LimeSuite.git
	cd LimeSuite
	git checkout stable
	mkdir builddir && cd builddir
	cmake ../
	make -j4
	sudo make install
	sudo ldconfig
fi

# SoapySDR
#
if grep SoapySDR "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapySDR.git
	cd SoapySDR
	mkdir build && cd build
	cmake ../ -DCMAKE_BUILD_TYPE=Release
	make -j4
	sudo make install
	sudo ldconfig
	SoapySDRUtil --info
fi

# SoapyRTLSDR
if grep SoapyRTLSDR "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyRTLSDR.git
	cd SoapyRTLSDR
	mkdir build && cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make
	sudo make install
	sudo ldconfig
fi

# SoapyHackRF
if grep SoapyHackRF "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyHackRF.git
	cd SoapyHackRF
	mkdir build && cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make
	sudo make install
	sudo ldconfig
fi

# SoapyPlutoSDR
if grep SoapyPlutoSDR "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyPlutoSDR
	cd SoapyPlutoSDR
	mkdir build && cd build
	cmake ..
	make
	sudo make install
	sudo ldconfig
fi

# SoapyRemote
if grep SoapyRemote "$SIG_CONFIG"
then
     cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyRemote.git
	cd SoapyRemote
	mkdir build && cd build
	cmake ..
	make
	sudo make install
	sudo ldconfig
fi

##
## INSTALL GNURADIO
##

# GNUradio
if grep gnuradio-3.8 "$SIG_CONFIG"
then
	install_gnuradio38
else
	sudo apt-get install -y gnuradio gnuradio-dev
fi

##
## INSTALL DECODERS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Decoders"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"
 
# OP25 ---- script crashes at next line and goes to and with EOF error
#if grep op25 "$SIG_CONFIG"
#then
#    cd $SIGPI_SOURCE
#	 git clone https://github.com/osmocom/op25.git
#	 cd op25
#	 if grep gnuradio-3.8 "$SIG_CONFIG"
#	 then
#	     cat gr3.8.patch | patch -p1
#		 ./install_sh
#	 else
#		 ./install.sh
#fi

# Multimon-NG
if grep multimon-ng "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/EliasOenal/multimon-ng.git
	cd multimon-ng
	mkdir build && cd build
	qmake ../multimon-ng.pro
	make
	sudo make install
fi

# Ubertooth Tools
if grep ubertooth-tools "$SIG_CONFIG"
then
	cd $SIGPI_SOURCE
	git clone https://github.com/greatscottgadgets/ubertooth.git
	cd ubertooth/host
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
fi


##
## INSTALL SDRAPPS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install SDR Applications"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# rtl_433
if grep rtl_433 "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/merbanan/rtl_433.git
	cd rtl_433
	mkdir build && cd build
	cmake ..
	make
	sudo make install
fi

# gqrx
if grep gqrx "$SIG_CONFIG"
then
    sudo apt-get install -y gqrx-sdr
fi

# CubicSDR
if grep cubicsdr "$SIG_CONFIG"
then
    sudo apt-get install -y cubicsdr
fi

# SDRangel
if grep sdrangel "$SIG_CONFIG"
then
    install_sdrangel
fi

##
## INSTALL AMATEUR RADIO APPLICATIONS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Amateur Radio Applications"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# Fldigi
if grep fldigi "$SIG_CONFIG"
then
    install_fldigi
fi

# DireWolf
if grep direwolf "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://www.github.com/wb2osz/direwolf
	cd direwolf
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	make install-conf
fi

# Linpac
if grep linpac "$SIG_CONFIG"
then
    sudo apt-get install -y linpac
fi

# Xastir
if grep xastir "$SIG_CONFIG"
then
    sudo apt-get install -y xastir
fi

# WSJT-X
if grep wsjtx-2.4.0 "$SIG_CONFIG"
then
    install_wsjtx
else
	sudo apt-get install -y wsjtx
fi

#SIGPKGCHK=$(cat $SIG_CONFIG |grep "WSJT-Xc")
#if $SIGPKGCHK="WSJT-Xc" ;then
#    install_wsjtx
#fi

# QSSTV
if grep qsstv-9.5.8 "$SIG_CONFIG"
then
	install_qsstv
else
    sudo apt-get install -y qsstv
fi

#SIGPKGCHK=$(cat $SIG_CONFIG |grep "QSSTVc")
#if $SIGPKGCHK="QSSTVc" ;then
#    install_qsstv
#fi

# Gpredict
if grep gpredict "$SIG_CONFIG"
then
    sudo apt-get install -y gpredict
fi

##
## INSTALL OTHERAPPS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Other Applications/Tools"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# Wireshark
if grep wireshark "$SIG_CONFIG"
then
    sudo apt-get install -y wireshark wireshark-dev libwireshark-dev
	cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbb
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
	make -j4
	sudo make install
	
	# BTBR Plugin
	cd $SIGPI_SOURCE/libbtbb/wireshark/plugins/btbredr
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu/wireshark/libwireshark3/plugins ..
	make -j4
	sudo make install
fi

# Kismet
if grep kismet "$SIG_CONFIG"
then
    install_kismet
fi

# Audcacity
if grep audacity "$SIG_CONFIG"
then
    sudo apt-get install -y audcacity
fi

# PAVU
if grep pavu "$SIG_CONFIG"
then
    sudo apt-get install -y pavucontrol
fi

# GPS
if grep gps "$SIG_CONFIG"
then
    sudo apt-get install -y gpsd gpsd-clients python-gps chrony
fi

# splat
if grep splat "$SIG_CONFIG"
then
    sudo apt-get install -y splat
fi

# mumble
if grep mumble "$SIG_CONFIG"
then
    sudo apt-get install -y mumble-server mumble
fi

# Tempest for Eliza
if grep tempest "$SIG_CONFIG"
then
    wget http://www.erikyyy.de/tempest/tempest_for_eliza-1.0.5.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/tempest_for_eliza-1.0.5.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/tempest_for_eliza-1.0.5
	./configure
	make
	sudo make install
	sudo ldconfig
fi

install_sigpimenu

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   System needs to reboot for all changes to occur"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Reboot will begin in 15 seconsds unless CTRL-C hit"
echo -e "${SIG_BANNER_RESET}"
sleep 17
sudo sync
sudo reboot
exit 0