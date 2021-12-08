#!/bin/bash

###
### SIGpi
###
### package_wsjtx
###

###
### 20211208-1200  Currently default to install to keep script backward compatible
###

# REMOVE
if ( $1 == "remove"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Remove WSJT-X"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo dpkg -P wsjtx

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   WSJT-X Removed"
    echo -e "${SIGPI_BANNER_RESET}"
fi

# PURGE
if ( $1 == "purge"); then
    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_COLOR} ##   Purge WSJT-X"
    echo -e "${SIGPI_BANNER_COLOR} ##"
    echo -e "${SIGPI_BANNER_RESET}"

    sudo dpkg -P wsjtx
    rm -rf $HOME/.config/WSJT-X.INI
    sudo rm -rf $SIGPI_DESKTOP/wsjtx.desktop
    sudo rm -rf $DESKTOP_FILES/wsjtx.desktop

    echo -e "${SIGPI_BANNER_COLOR}"
    echo -e "${SIGPI_BANNER_COLOR} ##   WSJT-X Purged"
    echo -e "${SIGPI_BANNER_RESET}"
fi

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install WSJT-X"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES
sudo apt-get install -y gfortran fftw3-dev qtbase5-dev qttools5-dev libqt5serialport5-dev  qtmultimedia5-dev 
sudo apt-get install -y libqt5multimedia5-plugins libqt5sql5-sqlite autoconf automake libtool texinfo
sudo apt-get install -y libusb-1.0-0-dev libudev-dev libboost-all-dev asciidoctor

# INSTALL
cd $SIGPI_SOURCE
if [ "$SIGPI_HWARCH" == "x86" ] 
then

fi

if [ "$SIGPI_HWARCH" == "x86_64"]
	cd $HOME/Downloads
	wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.5.2_amd64.deb -P $HOME/Downloads
	sudo dpkg -i wsjtx_2.5.2_amd64.deb
fi

if [ "$SIGPI_HWARCH" == "armhf"]
	cd $HOME/Downloads
	wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.5.2_armhf.deb -P $HOME/Downloads
	sudo dpkg -i wsjtx_2.5.2_armhf.deb
fi

if [ "$SIGPI_HWARCH" == "aarch64"]
	cd $HOME/Downloads
	wget https://physics.princeton.edu/pulsar/K1JT/wsjtx_2.5.2_amd64.deb -P $HOME/Downloads
	sudo dpkg -i wsjtx_2.5.2_amd64.deb
fi

# Old Install
#cd $SIGPI_SOURCE
#wget https://www.physics.princeton.edu/pulsar/k1jt/wsjtx-2.5.2.tgz -P $HOME/Downloads
#tar -zxvf $HOME/Downloads/wsjtx-2.5.2.tgz -C $SIGPI_SOURCE
#cd $SIGPI_SOURCE/wsjtx-2.5.2
#mkdir build && cd build
#cmake -DWSJT_SKIP_MANPAGES=ON -DWSJT_GENERATE_DOCS=OFF ..
#cmake --build .
#sudo cmake --build . --target install

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   WSJT-X Installed"
echo -e "${SIGPI_BANNER_RESET}"