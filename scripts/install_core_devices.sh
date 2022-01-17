#!/bin/bash

###
### SIGPI
###
### install_core_devices
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Core Devices"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# AX.25 and utilities"
echo -e "${SIGPI_BANNER_COLOR} ###   - AX.25 "
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libncurses5 libax25 ax25-apps ax25-tools
echo "ax0 N0CALL-3 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports

# RTL-SDR
echo -e "${SIGPI_BANNER_COLOR} ###   - RTLSDR "
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES
sudo apt-get install -y libusb-1.0-0-dev
sudo pip3 install pyrtlsdr

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/osmocom/rtl-sdr.git
cd rtl-sdr
mkdir build	&& cd build
cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
make
sudo make install
sudo cp ../rtl-sdr.rules /etc/udev/rules.d/
sudo ldconfig


# HackRF
echo -e "${SIGPI_BANNER_COLOR} ###   - HackRF "
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES
sudo apt-get install -y libusb-1.0-0-dev libfftw3-dev

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/mossmann/hackrf.git
cd hackrf/host
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig


# PlutoSDR
echo -e "${SIGPI_BANNER_COLOR} ###   - PlutoSDR "
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES
sudo apt-get install -y libaio-dev libusb-1.0-0-dev 
sudo apt-get install -y libserialport-dev libavahi-client-dev 
sudo apt-get install -y libxml2-dev bison flex libcdk5-dev 
sudo apt-get install -y python3 python3-pip python3-setuptools

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/analogdevicesinc/libiio.git
cd libiio
mkdir build && cd build
cmake ..
make -j4
sudo make install
sudo ldconfig

# SoapySDR
echo -e "${SIGPI_BANNER_COLOR} ###   - SoapySDR "
echo -e "${SIGPI_BANNER_RESET}"

## DEPENDENCIES
sudo apt-get install -y swig
sudo apt-get install -y avahi-daemon
sudo apt-get install -y libavahi-client-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y python-dev python3-dev

## INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
mkdir build && cd build
cmake ../ -Wno-dev -DCMAKE_BUILD_TYPE=Release
make -j4
sudo make install
sudo ldconfig
SoapySDRUtil --info

if grep sigpi_desktop "$SIGPI_INSTALLER"; then
    # LimeSDR
    echo -e "${SIGPI_BANNER_COLOR} ##$   - LimeSDR"
    echo -e "${SIGPI_BANNER_RESET}"

    ## DEPENDENCIES
    sudo apt-get install -y swig
    sudo apt-get install -y libsqlite3-dev
    sudo apt-get install -y libi2c-dev
    sudo apt-get install -y libusb-1.0-0-dev
    sudo apt-get install -y liboctave-dev
    sudo apt-get install -y libfltk1.3-dev
    # sudo apt-get install -y libwxgtk3.0-dev
    # Following is rpelacement fot libwxgtk3.0-dev
    sudo apt-get install -y libwxbase3.0-0v5
    sudo apt-get install -y freeglut3-dev

    ## INSTALL
    cd $SIGPI_SOURCE
    git clone https://github.com/myriadrf/LimeSuite.git
    cd LimeSuite
    git checkout stable
    mkdir build-dir && cd build-dir
    cmake ../
    make -j4
    sudo make install
    sudo ldconfig

    ## DESKTOP
    # Add Icon
    sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/*png $DESKTOP_ICONS
    sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/lime-suite-32.png $DESKTOP_ICONS/lime-suite.png
    # Add Desktop
    sudo cp $SIGPI_SOURCE/LimeSuite/Desktop/lime-suite.desktop $DESKTOP_FILES
    # Change Category
    sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/lime-suite.desktop
    # Add to Menu
    xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/lime-suite.desktop
fi

# SoapyRTLSDR
echo -e "${SIGPI_BANNER_COLOR} ###   - SoapyRTLSDR "
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyRTLSDR.git
cd SoapyRTLSDR
mkdir build && cd build
cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release
make
sudo make install
sudo ldconfig

# SoapyHackRF
echo -e "${SIGPI_BANNER_COLOR} ###   - SoapyHackRF "
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyHackRF.git
cd SoapyHackRF
mkdir build && cd build
cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release
make
sudo make install
sudo ldconfig

# SoapyPlutoSDR
echo -e "${SIGPI_BANNER_COLOR} ###   - SoapyPlutoSDR "
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y libserialport-dev libavahi-client-dev 
cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyPlutoSDR.git
cd SoapyPlutoSDR
mkdir build && cd build
cmake .. -Wno-dev
make
sudo make install
sudo ldconfig

# SoapyRemote
echo -e "${SIGPI_BANNER_COLOR} ###   - SoapyRemote "
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE
git clone https://github.com/pothosware/SoapyRemote.git
cd SoapyRemote
mkdir build && cd build
cmake .. -Wno-dev
make
sudo make install
sudo ldconfig

# GPS
echo -e "${SIGPI_BANNER_COLOR} ###   - GPS (Chrony) "
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y gpsd chrony

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Core Devices Installed"
echo -e "${SIGPI_BANNER_RESET}"