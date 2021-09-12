#!/bin/bash

###
### SIGpi_install
###
### 

###
###   REVISION: 20210910-0400
###

###
###
### This script is part of the SIGbox Project.
###
### Given a Raspberry Pi 4 4GB RAM 32GB microSD with Raspberry Pi OS Full (32-bit) installed
### This script installs drivers and applications for RF use cases that include hacking and 
### Amateur Radio Digital Modes.
###
### Applications and drivers include
###
### - Pulse Audio Control (PAVU)
### - Audacity
### - AX.25 and utilities
### - VoIP Server/Client (Murmur/Mumble)
### - RTLSDR
### - HackRF
### - LimeSDR
### - PlutoSDR
### - Bluetooth Baseband Library
### - Ubertooth Tools
### - SoapySDR
### - SoapyRTLSDR
### - SoapyHackRF
### - SoapyPlutoSDR
### - SoapyRemote
### - GPSd and Chrony
### - Liquid-DSP
### - GNUradio 3.7X
### - Kismet
###	- Wireshark
### - HackTV
###	- LTE Cell Scanner
###	- IMSI Catcher
### - GQRX
### - CubicSDR
### - Universal Radio Hacker
### - Inspectrum
### - RTL_433
### - SDRangel Dependencies
### - SDRangel
### - SDRangel Wisdom File
### - VOX for SDRangel
### - Gpredict
### - Splat
### - HamLib
### - DireWolf 1.7
### - Linpac
### - Xastir
### - Multimon-NG
### - RadioSonde
### - TEMPEST for Eliza
### - FLdigi Suite (FLxmlrpc, Flrig, Fldigi)
### - WSJT-X
### - QSSTV


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

##
## FUNCTIONS
##

stage_1(){

    ##
    ## READ ARGS DIRECTORIES
    ##
    if $1 = "BUILDHAM"; then
		touch $SIGPI_OPTION_BUILDHAM
	fi

	##
    ## CREATE DIRECTORIES
    ##

	if [ ! -d "$SIGPI_OPT" ]; then
    	mkdir $SIGPI_OPT
    fi
    
	if [ ! -d "$SIGPI_EXE" ]; then
    	mkdir $SIGPI_EXE
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

    touch $SIGPI_INSTALL_STAGE1
	cd $SIGPI_SOURCE

	cat <<EOF

###
###
###  SIGpi Install Script"
###	
###	 REVISION:  20200906-0900
###

INTRODUCTION:

Designed for a Raspberry OS Full (32-bit) fresh install with SSH and VNC enabled
from the Raspberry Pi Configuration tool. If not, CTRL-C out of this script.

This script installs relevant drivers and applications as a platform for SIGINT fun. Tools
do include transmit capability so it is YOUR reponsibility for compliance to regulations and
licenses specific to the country you will be operating from.
	
The script runs in stages creating a swapfile and rebooting after the completion of some stages.
After reboot you type the same command as you did to start this script. The script will know where
it left off. Only RTLSDR, HackRF, LimeSDR, and PlutoSDR drivers are included in the build.
	
Below is a list of software installed. The install is in a particular order given dependencies
by other applications.

Total install time will take over three hours with SDRangel and its dependencies take almost
half that time. If Amateur Radio Digital modes do not interest you, you can skip
installing Stage 5.

Stage 1
	- Ensure OS is current (update,upgrade)
    - Pulse Audio Control (PAVU)
	- Audacity
	
Stage 2
	- AX.25 and utilities
	- VoIP Server/Client (Murmur/Mumble)
	- RTLSDR
	- HackRF
	- LimeSDR
	- PlutoSDR
	- Bluetooth Baseband Library"
	- Ubertooth Tools
	- SoapySDR
	- SoapyRTLSDR
	- SoapyHackRF
	- SoapyPlutoSDR
	- SoapyRemote
    - GPSd and Chrony
	- Liquid-DSP
	- GNUradio 3.7X
    - Kismet
	- Wireshark
	- HackTV
	- LTE Cell Scanner
	- IMSI Catcher
	- GQRX
	- CubicSDR
	- Universal Radio Hacker
	- Inspectrum
	- RTL_433

Stage 3
	- SDRangel Dependencies
	- SDRangel
    - SDRangel Wisdom File
    - VOX for SDRangel

Stage 4
	- HamLib
    - Gpredict
	- Splat
    - DireWolf 1.7
	- Linpac
	- Xastir
	- Multimon-NG
	- RadioSonde

Stage 5
	- FLdigi Suite (FLxmlrpc, Flrig, Fldigi)
	- WSJT-X
	- QSSTV
	
EOF

	echo " "
    echo "### "
    echo "### "
	echo "###  SIGpi Install (Stage 1)"
	echo "### "
    echo "### "
	echo " "
	cd $SIGPI_SOURCE

	echo " ## "
	echo " - Create Swap file to improve compile time"
	echo " ## "
    echo " "
	if test -f /swapfile; then
		sudo rm /swapfile
	fi
	sudo fallocate -l 2G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile

        echo " ## "
	echo " - Ensure OS is current (update,upgrade)"
	echo " ## "
    echo " "
	sudo apt-get update
	sudo apt-get upgrade

	echo " "
	echo " ## "
    echo " ## "
	echo " - Install Dependencies"
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
libaio-dev libnova-dev libwxgtk-media3.0-dev gettext libcairo2-dev ffmpeg libavcodec-dev libpcap-dev\
libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev libopus-dev portaudio19-dev doxygen \
libcppunit-dev libbluetooth-dev graphviz gnuplot python-pyside python-qt4 python-docutils
	sudo apt-get install -y qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev \
libavdevice-dev libavutil-dev 
	sudo python3 -m pip install --upgrade pip
    sudo pip3 install pygccxml

	#
	# CREATE SELF-SIGNED SSSL CERT AND KEY
	#
	
	echo " "
	echo "## "
	echo "## "
	echo " -               Generating self-signed SSL certificate  (3 year lifetime)"
	echo " -  /C=US/ST=New York/L=Hudson Valley/O=Hudson Valley Digital Network/OU=SIGpi/CN=hvdn.org"
	echo "## "
	echo "## "
	echo " "
	sudo openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -subj "/C=US/ST=New York/L=Hudson Valley/O=Hudson Valley Digital Network/OU=SIGpi/CN=hvdn.org" -keyout $SIGPI_API_SSL_KEY -out $SIGPI_API_SSL_CRT
	sudo chown pi:pi $SIGPI_API_SSL_KEY >/dev/null 2>&1
	sudo chown pi:pi $SIGPI_API_SSL_CRT >/dev/null 2>&1

	#
    # INSTALL PULSE AUDIO CONTROL
    #
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install Pulse Audio Control (PAVU)"
    echo " ##"
    echo " ##"
    echo " "
    sudo apt-get install -y pavucontrol

	#
	# INSTALL AUDACITY
	#
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install Audacity (Audio Editing)"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get install -y audacity

    rm $SIGPI_INSTALL_STAGE1
    touch $SIGPI_INSTALL_STAGE2
}

stage_2(){

    echo " "
	echo "### "
    echo "### "
	echo "### SIGpi Install (Stage 2)"
    echo "### "
    echo "### "
	cd $SIGPI_SOURCE

	#
	# INSTALL AX.25
	#

    echo " "
    echo " ## "
    echo " ## "
	echo " - Install AX.25 and utilities"
    echo " ## "
    echo " ## "
	echo " "
	sudo apt-get install -y libax25 ax25-apps ax25-tools
    echo "ax0 N0CALL-3 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports

    #
    # INSTALL VOIP (MURMUR SERVER AND MUMBLE)
    #

	echo " "
    echo " ## "
    echo " ## "
	echo " - VoIP Server (Murmur)"
    echo " ## "
    echo " ## "
	echo " "
    sudo apt-get install -y mumble-server
	
    echo " "
    echo " ## "
    echo " ## "
	echo " - VoIP Client (Mumble)"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt-get install -y mumble

	#
	# INSTALL RTLSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install RTLSDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/osmocom/rtl-sdr.git
	cd rtl-sdr
	mkdir build	
	cd build
	cmake ../
	make
	sudo make install
	sudo ldconfig
	sudo apt-get install -y gr-osmosdr
	
	#
	# INSTALL HACKRF
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Install HackRF"
	echo " ## "
    echo " ## "
	echo " "
	sudo apt-get install -y hackrf libhackrf-dev
	sudo hackrf_info

	#
	# INSTALL LIMESDR SUITE
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Install LimeSDR Suite"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/myriadrf/LimeSuite.git
	cd LimeSuite
	git checkout stable
	mkdir builddir && cd builddir
	cmake ../
	make -j4
	sudo make install
	sudo ldconfig

	#
	# INSTALL PLUTOSDR
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Install PlutoSDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/analogdevicesinc/libiio.git
	cd libiio
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig
	
	#
	# INSTALL BLUETOOTH BASEBAND LIRBARY
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install Bluetooth Baseband Library"
	echo " ## "
    echo " ## "
	echo " "
	cd $SIGPI_SOURCE
	git clone https://github.com/greatscottgadgets/libbtbb.git
	cd libbtbb
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	#
	# INSTALL UBERTOOTH TOOLS
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install Ubertooth Tools"
	echo " ## "
    echo " ## "
	echo " "
	cd $SIGPI_SOURCE
	git clone https://github.com/greatscottgadgets/ubertooth.git
	cd ubertooth/host
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	
	# Wireshark Plug-in
	sudo apt-get install wireshark wireshark-dev libwireshark-dev
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

	#
	# INSTALL SOAPYSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SoapySDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapySDR.git
	cd SoapySDR
	mkdir build && cd build
	cmake ../ -DCMAKE_BUILD_TYPE=Release
	make -j4
	sudo make install
	sudo ldconfig
	SoapySDRUtil --info

	#
	# INSTALL SOAPYRTLSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SoapyRTLSDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyRTLSDR.git
	cd SoapyRTLSDR
	mkdir build && cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make
	sudo make install
	sudo ldconfig
	
	#
	# INSTALL SOAPYHACKRF
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SoapyHackRF"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make
	sudo make install
	sudo ldconfig
	
	#
	# INSTALL SOAPYPLUTOSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SoapyPlutoSDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyPlutoSDR
	cd SoapyPlutoSDR
	mkdir build && cd build
	cmake ..
	make
	sudo make install
	sudo ldconfig
	
	#
	# INSTALL SOAPYREMOTE
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SoapyRemote"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/pothosware/SoapyRemote.git
	cd SoapyRemote
	mkdir build && cd build
	cmake ..
	make
	sudo make install
	sudo ldconfig
	
    #
	# INSTALL GPSD AND CHRONY
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - GPSd and Chrony (Time Synchronization)"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get install -y gpsd gpsd-clients python-gps chrony
	
    #
	# INSTALL LIQUID-DSP
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install Liquid-DSP"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/jgaeddert/liquid-dsp
	cd liquid-dsp
	./bootstrap.sh
	./configure --enable-fftoverride 
	make -j4
	sudo make install
	sudo ldconfig

	#
	# INSTALL GNUradio 3.7.X
	#

	# From GNUradio Wiki
	# https://wiki.gnuradio.org/index.php/InstallingGRFromSource_on_Raspberry_Pi
	echo " "
    echo " ## "
    echo " ## "
	echo " - Install GNUradio 3.7.X"
    echo " ## "
    echo " ## "
	echo " "

	# Pre-requisite files
	sudo apt-get install -y libboost-all-dev libgmp-dev swig python3-numpy \
	python3-scipy python3-scapy python3-mako python3-sphinx python3-lxml \
	libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
	liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
	python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
	libudev-dev python3-setuptools liborc-0.4-0 liborc-0.4-dev liborc-0.4-dev\
	python3-gi-cairo libsamplerate0-dev libosmocore-dev gnuradio-dev
	sudo apt-get install -y gnuradio

    #
    # INSTALL KISMET
    #
    echo " "
    echo " ##"
    echo " ##"
    echo "- Install Kismet"
    echo " ##"
    echo " ##"
    echo " "
    wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | sudo apt-key add -
    echo 'deb https://www.kismetwireless.net/repos/apt/release/buster buster main' | sudo tee /etc/apt/sources.list.d/kismet.list
	sudo apt update
    sudo apt-get install -y kismet
    #
    # Say yes when asked about suid helpers
    #

	#
    # INSTALL WIRESHARK
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install Wireshark"
    echo " ##"
    echo " ##"
    echo " "
    sudo apt install -y wireshark

	#
	# INSTALL HACKTV
	#
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install HackTV"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/fsphil/hacktv.git
	cd hacktv
	make
	sudo make install

    #
    # INSTALL LTE Cell Scanner
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install LTE Cell Scanner"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/Evrytania/LTE-Cell-Scanner.git
	cd LTE-Cell-Scanner
	mkdir build && cd build
	cmake ..
	make
	sudo make install

    #
    # INSTALL IMSI Catcher
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install IMSI Catcher"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/Oros42/IMSI-catcher.git
	cd IMSI-catcher
	#git clone https://git.osmocom.org/gr-gsm
	#cd gr-gsm
	#mkdir build && cd build
	#cmake ..
	#make -j 4
	#sudo make install
	#sudo ldconfig
	#echo 'export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH' >> ~/.bashrc

	#
    # INSTALL GR-GSM
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install GR-GSM"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/ptrkrysik/gr-gsm.git
	cd gr-gsm
	mkdir build && cd build
	cmake ..
	mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/
	make -j4
	sudo make install
	sudo ldconfig

	#
	# INSTALL GQRX-SDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install GQRX"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt-get install -y gqrx-sdr

	#
	# INSTALL CUBICSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Install CubicSDR"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt-get install -y cubicsdr

	#
    # INSTALL UNIVERSAL RADIO HACKER
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo "- Install Universal Radio Hacker"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/jopohl/urh/
	cd urh
	python setup.py install

	#
    # INSTALL INSPECTRUM
    #

	echo " "
    echo " ##"
    echo " ##"
    echo "- Install Inspectrum"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/miek/inspectrum.git
	cd inspectrum
	mkdir build && cd build
	cmake ..
	make
	sudo make install

	#
    # INSTALL RTL_433
    #

	echo " "
    echo " ##"
    echo " ##"
    echo "- Install RTL_433"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/merbanan/rtl_433.git
	cd rtl_433
	mkdir build && cd build
	cmake ..
	make
	sudo make install

	#
    # INSTALL OP25
    #

	echo " "
    echo " ##"
    echo " ##"
    echo "- Install OP25"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://git.osmocom.org/op25
	cd op25
	./install.sh

	rm $SIGPI_INSTALL_STAGE2
	touch $SIGPI_INSTALL_STAGE3
	
	echo " "
    echo "###"
    echo "###"
	echo "###      System needs to reboot for all changes to occur."
	echo "###     Reboot will begin in 15 seconsds unless CTRL-C hit."
    echo "###"
	echo "###     After reboot run the script again to begin Stage 3"
    echo "###"
    echo "###"
	sleep 17
	sudo sync
	sudo reboot
}

stage_3(){
	
	echo " "
    echo "###"
    echo "###"
	echo "### SIGpi Install (Stage 3)"
	echo "###"
	echo "###"
	echo " "
	cd $SIGPI_SOURCE


	#
	# INSTALL SDRANGEL
	#
	echo " "
    echo " ## "
    echo " ## "
	echo " - Install SDRangel Dependencies"
	echo " ## "
    echo " ## "
	echo " "
    sudo mkdir -p /opt/build
	sudo chown pi:users /opt/build
	sudo mkdir -p /opt/install
	sudo chown pi:users /opt/install

	# APT
	# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- APTdec"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/srcejon/aptdec.git
	cd aptdec
	git checkout libaptdec
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/aptdec ..
	make -j $(nproc) install

	# CM265cc
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- CM265cc"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/cm256cc.git
	cd cm256cc
	git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/cm256cc ..
	make -j $(nproc) install

	# LibDAB
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- LibDAB"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/srcejon/dab-cmdline
	cd dab-cmdline/library
	git checkout msvc
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libdab ..
	make -j $(nproc) install

	# MBElib
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- MBElib"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/szechyjs/mbelib.git
	cd mbelib
	git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/mbelib ..
	make -j $(nproc) install

	# SerialDV
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SerialDV"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/serialDV.git
	cd serialDV
	git reset --hard "v1.1.4"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/serialdv ..
	make -j $(nproc) install

	# DSDcc
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- DSDcc"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/dsdcc.git
	cd dsdcc
	git reset --hard "v1.9.3"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=/opt/install/mbelib/include -DLIBMBE_LIBRARY=/opt/install/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=/opt/install/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=/opt/install/serialdv/lib/libserialdv.so ..
	make -j $(nproc) install

	# Codec2/FreeDV
	# Codec2 is already installed from the packager, but this version is required for SDRangel.
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- Codec2/FreeDV"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/drowe67/codec2.git
	cd codec2
	git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2
	mkdir build_linux; cd build_linux
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/codec2 ..
	make -j $(nproc) install

	# SGP4
	# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SGP4"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/dnwrnr/sgp4.git
	cd sgp4
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/sgp4 ..
	make -j $(nproc) install

	# LibSigMF
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- LibSigMF"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/f4exb/libsigmf.git
	cd libsigmf
	git checkout "new-namespaces"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libsigmf .. 
	make -j $(nproc) install
	sudo ldconfig

	# RTLSDR
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- RTLSDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/osmocom/rtl-sdr.git librtlsdr
	cd librtlsdr
	git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7
	mkdir build; cd build
	cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=/opt/install/librtlsdr ..
	make -j4 install

	# PlutoSDR
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- PlutoSDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/analogdevicesinc/libiio.git
	cd libiio
	git reset --hard v0.21
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libiio -DINSTALL_UDEV_RULE=OFF ..
	make -j4 install

	# HackRF
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- HackRF for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/mossmann/hackrf.git
	cd hackrf/host
	git reset --hard "v2018.01.1"
	mkdir build; cd build
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libhackrf -DINSTALL_UDEV_RULES=OFF ..
	make -j4 install

	# LimeSDR
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- LimeSDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/myriadrf/LimeSuite.git
	cd LimeSuite
	git reset --hard "v20.01.0"
	mkdir builddir; cd builddir
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite ..
	make -j4 install

	#SoapySDR
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SoapySDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapySDR.git
	cd SoapySDR
	git reset --hard "soapy-sdr-0.7.1"
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR ..
	make -j4 install
	
	#SoapyRTLSDR
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SoapyRTLSDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyRTLSDR.git
	cd SoapyRTLSDR
	mkdir build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR  -DRTLSDR_INCLUDE_DIR=/opt/install/librtlsdr/include -DRTLSDR_LIBRARY=/opt/install/librtlsdr/lib/librtlsdr.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SoapyHackRF
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SoapyHackRF for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyHackRF.git
	cd SoapyHackRF
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DLIBHACKRF_INCLUDE_DIR=/opt/install/libhackrf/include/libhackrf -DLIBHACKRF_LIBRARY=/opt/install/libhackrf/lib/libhackrf.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SoapyLimeRF
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SoapyLimeSDR for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SDRANGEL
	cd LimeSuite/builddir
	cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite -DCMAKE_PREFIX_PATH=/opt/install/SoapySDR ..
	make -j4 install
	cp /opt/install/LimeSuite/lib/SoapySDR/modules0.7/libLMS7Support.so /opt/install/SoapySDR/lib/SoapySDR/modules0.7

	#SoapyRemote
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SoapyRemote for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
    sudo apt-get -y install libavahi-client-dev
	cd $SIGPI_SDRANGEL
	git clone https://github.com/pothosware/SoapyRemote.git
	cd SoapyRemote
	git reset --hard "soapy-remote-0.5.1"
	mkdir build; cd build
	cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
	make -j4 install

	#SDRangel
    echo " "
    echo " ## "
    echo " ## "
	echo " - Install SDRangel"
	echo " ## "
    echo " ## "
	echo " "
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

	echo " "
    echo "  # "
    echo "  # "
	echo "  -- Generating SDRangel Wisdom File"
	echo "  # "
    echo "  # "
	echo " "
    cd $HOME/.config/
	mkdir f4exb
	cd f4exb
	# Generate a new wisdom file for FFT sizes : 128, 256, 512, 1024, 2048, 4096, 8192, 16384 and 32768.
	# This will take a very long time.
	fftwf-wisdom -n -o fftw-wisdom 128 256 512 1024 2048 4096 8192 16384 32768

	echo " "
    echo "  # "
    echo "  # "
	echo "  -- VOX for SDRangel"
	echo "  # "
    echo "  # "
	echo " "
    # Add VOX for Transimtting with SDRangel
	cd $SIGPI_SOURCE
	git clone https://gitlab.wibisono.or.id/published/voxangel.git

	rm $SIGPI_INSTALL_STAGE3
	touch $SIGPI_INSTALL_STAGE4
	
	echo " "
    echo "###"
    echo "###"
	echo "###      System needs to reboot for all changes to occur."
	echo "###     Reboot will begin in 15 seconsds unless CTRL-C hit."
    echo "###"
	echo "###     After reboot run the script again to begin Stage 4"
    echo "###"
    echo "###"
	sleep 17
	sudo sync
	sudo reboot
}

stage_4(){
	echo " "
    echo "###"
    echo "###"
	echo "### SIGpi Install (Stage 4)"
	echo "###"
    echo "###"
    echo " "
	cd $SIGPI_SOURCE

	#
	# INSTALL HAMLIB
	#
	
    echo " "
    echo " ## "
    echo " ## "
	echo " - Install Hamlib"
	echo " ## "
    echo " ## "
    echo " "
	wget https://github.com/Hamlib/Hamlib/releases/download/4.3/hamlib-4.3.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/hamlib-4.3.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/hamlib-4.3
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig

	#
	# INSTALL GPREDICT
	#
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install Gpredict (Satellite Tracking)"
    echo " ##"
    echo " ##"
	echo " "
    sudo apt-get install -y gpredict

	#
	# INSTALL SPLAT
	#
    echo " "
    echo " ##"
    echo " ##"
	echo " - Install Splat"
	echo " ##"
    echo " ##"
	echo " "
	sudo apt-get install -y splat

	#
	# INSTALL DIREWOLF
	#

    echo " "
    echo " ##"
    echo " ##"
	echo " - Install DireWolf"
	echo " ##"
    echo " ##"
	echo " "
    cd $SIGPI_SOURCE
	git clone https://www.github.com/wb2osz/direwolf
	cd direwolf
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
	make install-conf

	#
	# INSTALL LINPAC (PACKET TERMINAL)
	#

    echo " "
    echo " ##"
    echo " ##"
	echo " - Install Linpac terminal"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get install -y linpac

	#
	# INSTALL XASTIR
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - Install Xastir"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get install -y xastir
	sudo usermod -a -G xastir-ax25 pi

	#
	# INSTALL MULTIMON-NG
	#

    echo " "
    echo " ##"
    echo " ##"
	echo " - Install Multimon-NG"
	echo " ##"
    echo " ##"
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/EliasOenal/multimon-ng.git
	cd multimon-ng
	mkdir build && cd build
	qmake ../multimon-ng.pro
	make
	sudo make install


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
	gcc m12.c -lm -o m12
	sudo chown root:root m10ptu m10gtop m12
	sudo cp m10ptu m10gtop m12 $SIGPI_EXE

	echo "  #"
    echo "  - Meisei"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/meisei
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
	gcc rs41ptu.c -lm -o rs41ptu
	sudo chown root:root rs41ptu
	sudo cp rs41ptu $SIGPI_EXE

	echo "  #"
    echo "  - RS41"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/lms6
	gcc lms6.c -lm -o lms6
	gcc lms6ccsds.c -lm -o lms6ccsds
	gcc lms6ecc.c -lm -o lms6ecc
	gcc lmsX2446.c -lm -o lmsX2446 
	sudo chown root:root lms6 lms6ccsds lms6ecc lmsX2446 
	sudo cp lms6 lms6ccsds lms6ecc lmsX2446 $SIGPI_EXE
	
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
	gcc mk2a1680mode.c -lm -o mk2a1680mod
	gcc mk2alms1680.c -lm -o mk2alms1680
	sudo chown root:root mk2a mk2a1680mod mk2alms1680
	sudo cp mk2a mk2a1680mod mk2alms1680 $SIGPI_EXE

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
	gcc rt94drop.c -lm -o rt94drop
	sudo chown root:root rt94drop
	sudo cp rt94drop $SIGPI_EXE

	echo "  #"
    echo "  - Decod RS Module"
	echo "  #"
	echo " "
	cd $SIGPI_SOURCE/RS/rs_module
	sudo gcc -c demod_dft.c
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
	# INSTALL TEMPEST FOR ELIZA
	#
	
    echo " "
    echo " ## "
    echo " ## "
	echo " - Install TEMPEST for ELiza"
	echo " ## "
    echo " ## "
    echo " "
	wget http://www.erikyyy.de/tempest/tempest_for_eliza-1.0.5.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/tempest_for_eliza-1.0.5.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/tempest_for_eliza-1.0.5
	./configure
	make
	sudo make install
	sudo ldconfig

	rm $SIGPI_INSTALL_STAGE4
	touch $SIGPI_INSTALL_STAGE5

    echo " "
    echo "###"
    echo "###"
	echo "###      System needs to reboot for all changes to occur."
	echo "###     Reboot will begin in 15 seconsds unless CTRL-C hit."
    echo "###"
	echo "###     After reboot run the script again to begin Stage 5"
    echo "###"
    echo "###  NOTE: If Amateur Radio Digital modes do not interest you"
    echo "###  then after reboot you can skip installing Stage 5 and"
    echo "###  consider yourself done with the software install. Then"
    echo "###  consult the README on repo for post configuration info."
    echo "###"
    echo "###  https://github.com/joecupano/SIGbox/blob/main/README.md"
	echo "###"
    echo "###"
    sleep 17
	sudo sync
	sudo reboot
}

stage_5(){
	echo "###"
    echo "###"
	echo "### SIGpi Install (Stage 5)"
	echo "###"
    echo "###"
    echo " "
	cd $SIGPI_SOURCE

	#
	# INSTALL FLRIG, FLXMLRPC, FLDIGI
	#

	if test -f "$SIGPI_OPTION_BUILDHAM"; then
		# Install FLxmlrpc
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Install FLxmlrpc"
		echo " ##"
    	echo " ##"
    	echo " "
		wget http://www.w1hkj.com/files/flxmlrpc/flxmlrpc-0.1.4.tar.gz -P $HOME/Downloads
		tar -zxvf $HOME/Downloads/flxmlrpc-0.1.4.tar.gz -C $SIGPI_SOURCE
		cd $SIGPI_SOURCE/flxmlrpc-0.1.4
		./configure --prefix=/usr/local --enable-static
		make
		sudo make install
		sudo ldconfig

		# Install FLrig
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Install FLrig"
		echo " ##"
    	echo " ##"
    	echo " "
		wget http://www.w1hkj.com/files/flrig/flrig-1.4.2.tar.gz -P $HOME/Downloads
		tar -zxvf $HOME/Downloads/flrig-1.4.2.tar.gz -C $SIGPI_SOURCE
		cd $SIGPI_SOURCE/flrig-1.4.2
		./configure --prefix=/usr/local --enable-static
		make
		sudo make install

		#Install Fldigi
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Install FLdigi"
		echo " ##"
    	echo " ##"
    	echo " "
    	sudo apt install -y libudev-dev
		wget http://www.w1hkj.com/files/fldigi/fldigi-4.1.20.tar.gz -P $HOME/Downloads
		tar -zxvf $HOME/Downloads/fldigi-4.1.20.tar.gz -C $SIGPI_SOURCE
		cd $SIGPI_SOURCE/fldigi-4.1.20
		./configure --prefix=/usr/local --enable-static
		make
		sudo make install
		sudo ldconfig
	else
		sudo apt-get -y install flrig fldigi
	fi

	#
	# INSTALL WSJT-X
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - Install WSJT-X"
	echo " ##"
    echo " ##"
    echo " "
	if test -f "$SIGPI_OPTION_BUILDHAM"; then
		wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.4.0_armhf.deb -P $HOME/Downloads
		sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb
		# Will get error next command fixes error and downloads dependencies
		sudo apt-get --fix-broken install
		sudo dpkg -i $HOME/Downloads/wsjtx_2.4.0_armhf.deb
	else
		sudo apt-get install -y wsjtx
	fi

	#
	# INSTALL QSSTV
	#
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install QSSTV"
	echo " ##"
    echo " ##"
    echo " "
    if test -f "$SIGPI_OPTION_BUILDHAM"; then
		sudo apt-get install -y qt5-default libpulse-dev
		sudo apt-get install -y libhamlib-dev libv4l-dev
		sudo apt-get install -y libopenjp2-7 libopenjp2-7-dev
		wget http://users.telenet.be/on4qz/qsstv/downloads/qsstv_9.5.8.tar.gz -P $HOME/Downloads
		tar -xvzf $HOME/Downloads/qsstv_9.5.8.tar.gz -C $SIGPI_SOURCE
		cd $SIGPI_SOURCE/qsstv
		qmake
		make
		sudo make install
	else
		sudo apt-get install -y qsstv
	fi

	#
	# CONFIGURATIONS
	#

    echo " "
    echo " ##"
    echo " ##"
	echo " - Application Configurations"
    echo " ##"
    echo " ##"
	echo " "
	cd $SIGPI_SOURCE

    echo " "
    echo "  #"
    echo "  #"
	echo "  - VoIP Server Config"
    echo "  #"
    echo "  #"
	echo " "
	echo "  When the pop-up window appears, anser NO to the first two questions."
	echo "  Last question will ask you to create a password for the SuperUser"
	echo "  account to manage the VoIP server"
	echo " "
	sleep 9
	sudo dpkg-reconfigure mumble-server

	cat <<EOF
For configurations for the remainder of the software consult 
the README on the SIGbox Repo.

https://github.com/joecupano/SIGbox/blob/main/README.md

EOF
	rm $SIGPI_INSTALL_STAGE5
    touch $SIGPI_HOME/INSTALLED
}


##
## START
##

echo "### "
echo "### "
echo "###  SIGpi Install "
echo "### "
echo "### REVISION:  20200906-0900"
echo "### "
echo " "

##
##  MAIN
##

if test -f "$SIGPI_INSTALL_STAGE1"; then
	stage_1
fi

if test -f "$SIGPI_INSTALL_STAGE2"; then
	stage_2
fi

if test -f "$SIGPI_INSTALL_STAGE3"; then
	stage_3
fi

if test -f "$SIGPI_INSTALL_STAGE4"; then
	stage_4
fi

if test -f "$SIGPI_INSTALL_STAGE5"; then
	stage_5
fi

# Get to here means were done. Shutoff and delete swapfile

if test -f /swapfile; then
	sudo swapoff /swapfile
	sudo rm /swapfile
fi

echo "*** "
echo "*** "
echo "***  SIGpi Installation Complete"
echo "*** "
echo "*** "
echo " "
echo "System needs to reboot for all changes to occur."
echo "Reboot will begin in 15 seconsds unless CTRL-C hit."
sleep 17
sudo sync
sudo reboot
exit 0