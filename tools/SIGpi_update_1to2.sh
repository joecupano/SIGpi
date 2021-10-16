#!/bin/bash

###
### SIGpi_Update 1 to 2
###

###
###   REVISION: 20211001-2300
###

###
### This script is part of the SIGbox Project.
###
### Given a Raspberry Pi 4 4GB RAM 32GB microSD with Raspberry Pi OS Full (32-bit) installed
### This script installs drivers and applications for RF use cases that include hacking and 
### Amateur Radio Digital Modes.
###
### Updates Release 1.0 to 2.0
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
SIG_UPDATE_TXT1=$SIGPI_HOME/updates/SIGpi-update-1.txt
SIG_UPDATE_TXT2=$SIGPI_HOME/updates/SIGpi-update-2.txt
SIG_UPDATE_TXT3=$SIGPI_HOME/updates/SIGpi-update-3.txt
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
    TERM=ansi whiptail --title "SigPi Update" --textbox $SIG_UPDATE_TXT1 24 120 16
}

select_decoders() {
    TERM=ansi whiptail --title "Digital Decoders" --textboxput $SIG_UPDATE_TXT2 20 120 12
}

select_hamradio() {
    if (whiptail --title "Fldigi Suite" --yesno "Fldigi - Update from 4.1.01 Distro to 4.1.20 compiled version ?" 8 80 ); then
        echo "fldigi-4.1.20" >> $SIG_CONFIG
    fi

    if (whiptail --title "WSJT-X" --yesno "WSJT-X - Update from 2.0.0 distro to 2.4.2 compiled version ?" 8 80 ); then
        echo "wsjtx-2.4.0" >> $SIG_CONFIG
    fi

    if (whiptail --title "QSSTV" --yesno "QSSTV - Update from 9.2.6 distro to 9.5.8 compiled version ?" 8 80 ); then
        echo "qsstv-9.5.8" >> $SIG_CONFIG
    fi
}

select_utilities() {
    TERM=ansi whiptail --title "Useful Applications" --textboxput $SIG_UPDATE_TXT3 20 120 12
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
select_decoders
select_sdrapps
select_hamradio
select_utilities
TERM=ansi whiptail --title "SigPi Update" --msgbox "Ready to Install" 12 120

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
## INSTALL GNURADIO 3.8
##

sudo apt-get remove -y gnuradio gnuradio-dev
install_gnuradio38

##
## INSTALL RTL_433
##

cd $SIGPI_SOURCE
git clone https://github.com/merbanan/rtl_433.git
cd rtl_433
mkdir build && cd build
cmake ..
make
sudo make install

##
## INSTALL DECODERS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Decoders"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"
 
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

##
## INSTALL AMATEUR RADIO APPLICATIONS
##

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Amateur Radio Applications"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# Fldigi
if grep fldigi-4.1.20 "$SIG_CONFIG"
then
    sudo apt-get -y remove install fldigi flrig flxmlrpc
    install_fldigi
fi

# WSJT-X
if grep wsjtx-2.4.0 "$SIG_CONFIG"
then
    sudo apt-get remove -y wsjtx
    install_wsjtx
fi

# QSSTV
if grep qsstv-9.5.8 "$SIG_CONFIG"
then
    sudo apt-get remove -y qsstv
	install_qsstv
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

# splat
if grep splat "$SIG_CONFIG"
then
    sudo apt-get install -y splat
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