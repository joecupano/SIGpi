#!/bin/bash

###
### SIGpi_install_whiptail
###

###
###   REVISION: 20210925-0900
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
GNURADIO_PKG="gnuradio_3.9"

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
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
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
    FUN=$(whiptail --title "SigPi Installer" --radiolist --separate-output \
        "Choose GNUradio version" 20 80 12 \
        "gnuradio-3.7" "Installed from distro (Raspberry Pi OS) " ON \
        "gnuradio-3.8" "Compiled from Repo (required for gr-gsm) " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_decoders() {
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
    echo $FUN >> $SIG_CONFIG
}

select_sdrapps() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose SDR Applications" 20 80 12 \
        "gqrx" "SDR Receiver " ON \
        "cubicsdr" "SDR Receiver " OFF \
        "sdrangel" "SDRangel " OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_hamradio() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose Amateur Radio Applications" 20 80 12 \
        "fldigi" "Digital Mode suite of applications with Radio control " OFF \
        "direWolf" "DireWolf 1.7 Soundcard TNC for APRS " OFF \
        "linpac" "Packet Radio Temrinal with mail client " OFF \
        "xastir" "APRS Station Tracking and Reporting " OFF \
        "wsjt-x" "Digital Modes for Weak Signal Communicaitons " OFF \
        "qsstv" "SSTV " OFF \
        "QSSTV-9.2.4" "Lates stable" OFF \
        3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
        $FUN = "NONE"
    fi
    echo $FUN >> $SIG_CONFIG
}

select_utilities() {
    FUN=$(whiptail --title "SigPi Installer" --checklist --separate-output \
        "Choose other Useful Applications" 20 120 12 \
        "wireshark" "Network Traffic Analyzer " OFF \
        "kismet" "Wireless snifferand monitor " OFF \
        "audacity" "Audio Editor " OFF \
        "pavu" "PulseAudio Control " OFF \
        "mumble" "VoIP Server and Client " OFF \
        "gpsPS" "GPS client and NTP sync " OFF \
        "gpredict" "Satellite Tracking " OFF \
        "splat" "RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz " OFF \
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

    sudo apt-get install -y git cmake g++ pkg-config autoconf automake libtool build-essential \
	pulseaudio bison flex gettext ffmpeg portaudio19-dev doxygen graphviz gnuplot gnuplot-x11 swig

	sudo apt-get install -y libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev libfftw3-dev libusb-1.0-0 libusb-1.0-0-dev libusb-dev \
	libopencv-dev libxml2-dev libaio-dev libnova-dev libwxgtk-media3.0-dev libcairo2-dev libavcodec-dev libpthread-stubs0-dev \
	libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev libopus-dev libavahi-common-dev libavahi-client-dev libavdevice-dev libavutil-dev \
	libsdl1.2-dev libgsl-dev liblog4cpp5-dev libzmq3-dev libudev-dev liborc-0.4-0 liborc-0.4-dev libsamplerate0-dev libgmp-dev \
	libpcap-dev libcppunit-dev libbluetooth-dev python-pyside python-qt4 qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev 

	sudo apt-get install -y python3-pip python3-numpy python3-mako python3-sphinx python3-lxml python3-yaml python3-click python3-click-plugins \
	python3-zmq python3-scipy python3-scapy python3-setuptools python3-pyqt5 python3-gi-cairo python-docutils

	sudo apt-get install -y qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qttools5-dev qttools5-dev-tools \
	libqt5opengl5-dev qtbase5-dev libqt5quick5 libqt5charts5-dev qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
	qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts libqt5serialport5-dev \
	qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev libqwt-qt5-dev

	sudo python3 -m pip install --upgrade pip
	sudo pip3 install pygccxml
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

	#Install Fldigi
	wget http://www.w1hkj.com/files/fldigi/fldigi-4.1.20.tar.gz -P $HOME/Downloads
	tar -zxvf $HOME/Downloads/fldigi-4.1.20.tar.gz -C $SIGPI_SOURCE
	cd $SIGPI_SOURCE/fldigi-4.1.20
	./configure --prefix=/usr/local --enable-static
	make
	sudo make install
	sudo ldconfig	
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

	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/CubicSDR.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flarq.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/fldigi.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/flrig.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gnuradio-grc.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gpredict.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/gqrx.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/message_aggregator.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/mumble.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/qsstv.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wsjtx.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/direwolf.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/linpac.desktop
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/wireshark.desktop

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
select_hamradio
select_utilities
TERM=ansi whiptail --title "SigPi Installer" --msgbox "Ready to Install" 12 120

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   System Update & Upgrade"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

sudo apt-get update
sudo apt-get upgrade
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

# GNUradio 3.7
if grep gnuradio-3.7 "$SIG_CONFIG"
then
    echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install GNUradio 3.7"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
	sudo apt-get install -y gnuradio gnuradio-dev
fi

# GNUradio 3.8
if grep gnuradio-3.8 "$SIG_CONFIG"
then
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
fi

##
## INSTALL DECODERS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Decoders"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# OP25
if grep op25 "$SIG_CONFIG"
then
    cd $SIGPI_SOURCE
	git clone https://github.com/osmocom/op25.git
	cd op25
	if grep gnuradio-3.8 "$SIG_CONFIG"
	then
		cat gr3.8.patch | patch -p1
		./install_sh
	else
		./install.sh
fi

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
if grep wsjt-x "$SIG_CONFIG"
then
    sudo apt-get install -y wsjtx
fi

#SIGPKGCHK=$(cat $SIG_CONFIG |grep "WSJT-Xc")
#if $SIGPKGCHK="WSJT-Xc" ;then
#    install_wsjtx
#fi

# QSSTV
if grep qsstv "$SIG_CONFIG"
then
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