#!/bin/bash

###
### SIGpi
###
### install_devices
###

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install Devices"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# AX.25
echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install AX.25"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

# AX.25 and utilities"
sudo apt-get install -y libncurses5 libax25 ax25-apps ax25-tools
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

if grep soapysdr "$SIG_CONFIG"
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
if grep soapyrtlsdr "$SIG_CONFIG"
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
if grep soapyhackrf "$SIG_CONFIG"
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
if grep soapyplutosdr "$SIG_CONFIG"
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
if grep soapyremote "$SIG_CONFIG"
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

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"