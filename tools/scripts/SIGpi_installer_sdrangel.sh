#!/bin/bash

###
### SIGpi_installer_sdrangel
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
	git clone https://github.com/srcejon/dab-cmdline.git
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
	sudo cp $SIGPI_HOME/tools/SIGpi_sdrangel.sh /usr/local/bin/sdrangel

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


install_sigpimenu(){
	echo -e "${SIG_BANNER_COLOR}"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install SIGpi Menu and Desktop Shortcuts"
	echo -e "${SIG_BANNER_COLOR} #SIGPI#"
	echo -e "${SIG_BANNER_RESET}"
    
	# Copy Menu items into relevant directories
	sudo cp $SIGPI_SOURCE/SDRangel/sdrangel/build/sdrangel.desktop $DESKTOP_FILES
	
	# Add SigPi Category for each installed application
	sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop
	
	# Add installed applications into SigPi menu
	xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrangel.desktop
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

install_dependencies

install_sdrangel

install_sigpimenu

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"
exit 0