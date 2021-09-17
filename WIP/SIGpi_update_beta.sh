#!/bin/bash

###
### SIGpi_Update
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
### - Bluetooth Baseband Library
### - Ubertooth Tools
###	- Wireshark
### - HackTV
###	- LTE Cell Scanner
###	- IMSI Catcher
### - Universal Radio Hacker
### - Inspectrum
### - RTL_433
### - Splat
### - Multimon-NG
### - TEMPEST for Eliza


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

# SigPi Install Change Tracking through touched files
SIGPI_INSTALL_STAGE1=$SIGPI_HOME/stage_1
SIGPI_INSTALL_STAGE2=$SIGPI_HOME/stage_2
SIGPI_INSTALL_STAGE3=$SIGPI_HOME/stage_3
SIGPI_INSTALL_STAGE4=$SIGPI_HOME/stage_4
SIGPI_INSTALL_STAGE5=$SIGPI_HOME/stage_5
SIGPI_INSTALL_COMPLETE=$SIGPI_HOME/INSTALLED
SIGPI_UPDATE_STAGEU1=$SIGPI_HOME/stage_U1
SIGPI_UPDATE_STAGEU2=$SIGPI_HOME/stage_U2
SIGPI_UPDATE_COMPLETE=$SIGPI_HOME/UPDATED

# Install options
SIGPI_OPTION_BUILDHAM=$SIGPI_HOME/BUILDHAM

# SigPi SSL Cert and Key
SIGPI_API_SSL_KEY=$SIGPI_HOME/SIGpi_api.key
SIGPI_API_SSL_CRT=$SIGPI_HOME/SIGpi_api.crt

##
## FUNCTIONS
##

stage_U1(){

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

	# APT
	# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- APTdec"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/srcejon/aptdec.git
	cd aptdec
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# CM265cc
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- CM256cc"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/f4exb/cm256cc.git
	cd cm256cc
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# LibDAB
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- LibDAB"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/srcejon/dab-cmdline
	cd dab-cmdline/library
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# MBElib
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- MBElib"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/szechyjs/mbelib.git
	cd mbelib
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# SerialDV
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SerialDV"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/f4exb/serialDV.git
	cd serialDV
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# DSDcc
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- DSDcc"
	echo "  # "
    echo "  # "
	echo " "
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
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- SGP4"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/dnwrnr/sgp4.git
	cd sgp4
	mkdir build; cd build
	cmake ..
	make -j4
	sudo make install
	sudo ldconfig

	# LibSigMF
	echo " "
    echo "  # "
    echo "  # "
	echo "  -- LibSigMF"
	echo "  # "
    echo "  # "
	echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/deepsig/libsigmf.git
	cd libsigmf
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
	
	# Pre-requisite files
	sudo apt-get install -y libboost-all-dev libgmp-dev swig python3-numpy \
	python3-scipy python3-scapy python3-mako python3-sphinx python3-lxml \
	libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
	liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
	python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 libusb-1.0-0-dev \
	libudev-dev python3-setuptools liborc-0.4-0 liborc-0.4-dev \
	python3-gi-cairo libsamplerate0-dev libosmocore-dev gnuradio-dev
	sudo apt-get install -y gnuradio
	sudo apt-get install -y gr-osmosdr

	#
    # INSTALL WIRESHARK
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install Wireshark"
    echo " ##"
    echo " ##"
    echo " "
    sudo apt install -y wireshark

	#
	# INSTALL HACKTV  soapysdr.c:135:5: error: too many arguments to function ‘SoapySDRDevice_setupStream’
	#
	#
	#echo " "
    #echo " ##"
    #echo " ##"
    #echo " - Install HackTV  (KNown issue with SoapySDR)"
    #echo " ##"
    #echo " ##"
    #echo " "
    #cd $SIGPI_SOURCE
	#git clone https://github.com/fsphil/hacktv.git
	#cd hacktv
	#make
	#sudo make install

    #
    # INSTALL LTE Cell Scanner (Could not fine ITPP library)
    #
    #
	#echo " "
    #echo " ##"
    #echo " ##"
    #echo " - Install LTE Cell Scanner"
    #echo " ##"
    #echo " ##"
    #echo " "
    #cd $SIGPI_SOURCE
	#git clone https://github.com/Evrytania/LTE-Cell-Scanner.git
	#cd LTE-Cell-Scanner
	#mkdir build && cd build
	#cmake ..
	#make
	#sudo make install

    #
    # INSTALL IMSI Catcher
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install IMSI Catcher"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://github.com/Oros42/IMSI-catcher.git
	cd IMSI-catcher
	
	#
    # INSTALL GR-GSM
    #
    
	echo " "
    echo " ##"
    echo " ##"
    echo " - Install GR-GSM"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone git clone https://git.osmocom.org/gr-gsm
	cd gr-gsm
	mkdir build && cd build
	cmake ..
	make -j 4
	sudo make install
	sudo ldconfig
	echo 'export PYTHONPATH=/usr/local/lib/python3/dist-packages/:$PYTHONPATH' >> ~/.bashrc

	#
    # INSTALL UNIVERSAL RADIO HACKER
    #
    
	#echo " "
    #echo " ##"
    #echo " ##"
    #echo "- Install Universal Radio Hacker"
    #echo " ##"
    #echo " ##"
    #echo " "
    #cd $SIGPI_SOURCE
	#git clone https://github.com/jopohl/urh/
	#cd urh
	#python setup.py install  # Issue with Line 44

	#
    # INSTALL INSPECTRUM
    #

	#echo " "
    #echo " ##"
    #echo " ##"
    #echo "- Install Inspectrum "
    #echo " ##"
    #echo " ##"
    #echo " "
    #cd $SIGPI_SOURCE
	#git clone https://github.com/miek/inspectrum.git
	#cd inspectrum
	#mkdir build && cd build
	#cmake ..
	#make
	#sudo make install

	#
    # INSTALL RTL_433
    #

	echo " "
    echo " ##"
    echo " ##"
    echo " - Install RTL_433"
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
    echo " - Install OP25"
    echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE
	git clone https://git.osmocom.org/op25
	cd op25
	./install.sh
	
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

	#
	# INSTALL SIGPI MENU
	#
    
	echo " "
    echo " ##"
    echo " ##"
	echo " - SigPi Menu"
    echo " ##"
    echo " ##"
	echo " "
	
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

	# Remove Rogue desktop file to ensure we use the one we provided for direwolf
	sudo rm -rf /usr/local/share/applications/direwolf.desktop


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


	cat <<EOF
For configurations for the remainder of the software consult 
the README on the SIGbox Repo.

https://github.com/joecupano/SIGbox/blob/main/README.md

EOF

}


##
## START
##

echo "### "
echo "### "
echo "###  SIGpi Update "
echo "### "
echo "### "
echo " "

##
##  MAIN
##

if test ! -f "$SIGPI_INSTALL_COMPLETE"; then
	echo "*** "
	echo "*** "
	echo "***   UPDATE FAIL - Does not appear this is a complete install"
	echo "*** "
	echo "*** "
	echo " "
	exit 1
fi

stage_U1

# Make python scripts executable in /opt/SIGpi/bin
cd $SIGPI_EXE
sudo chmod 755 *py 
cd $SIGPI_HOME

# Shutoff and delete swapfile
if test -f /swapfile; then
	sudo swapoff /swapfile
	sudo rm /swapfile
fi

touch $SIGPI_UPDATE_COMPLETE

echo "*** "
echo "*** "
echo "***   UPDATE COMPLETE"
echo "*** "
echo "*** "
echo " "
echo "System needs to reboot for all changes to occur."
echo "Reboot will begin in 15 seconds unless CTRL-C hit."
sleep 17
sudo sync
sudo reboot
exit 0