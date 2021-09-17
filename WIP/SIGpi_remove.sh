#!/bin/bash

###
### SIGpi_clean
###
### 

###
###   REVISION: 20210905-0420  (v01)
###

###
###
### This script is part of the SIGbox Project.
###
### This script removes all compiled software installed with SIGpi_build_install.sh
### but leaves the dependencies. Removal of dependencies deferred to package managee as
### part of sudo apt autoremove
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
### - SoapySDR
### - SoapyRTLSDR
### - SoapyHackRF
### - SoapyPlutoSDR
### - SoapyRemote
### - GPSd and Chrony
### - Liquid-DSP
### - GNUradio 3.7X
### - Kismet
### - GQRX
### - CubicSDR
### - SDRangel Dependencies
### - SDRangel
### - SDRangel Wisdom File
### - VOX for SDRangel
### - Gpredict
### - HamLib
### - DireWolf 1.7
### - Linpac
### - Xastir
### - FLdigi Suite (FLxmlrpc, Flrig, Fldigi)
### - WSJT-X
### - QSSTV
### - Ham Radio Menus


##
## INIT VARIABLES AND DIRECTORIES
##

# Source storage
SIGPI_SOURCE=$HOME/source

# getoh source directory
SIGPI_HOME=$HOME/source/SIGbox

SIGPI_INSTALL_STAGE1=$SIGPI_HOME/stage_1
SIGPI_INSTALL_STAGE2=$SIGPI_HOME/stage_2
SIGPI_INSTALL_STAGE3=$SIGPI_HOME/stage_3
SIGPI_INSTALL_STAGE4=$SIGPI_HOME/stage_4
SIGPI_INSTALL_STAGE5=$SIGPI_HOME/stage_5

SIGPI_OPTION_BUILDCLEAN=$SIGPI_HOME/BUILDCLEAN
SIGPI_OPTION_BUILDHAM=$SIGPI_HOME/BUILDHAM
SIGPI_OPTION_BUILDHAMCLEAN=$SIGPI_HOME/BUILDHAMCLEAN


##
## FUNCTIONS
##

stage_1(){
    ##
    ## INIT DIRECTORIES
    ##
    if $1 = "BUILDHAM"; then
		touch $SIGPI_OPTION_BUILDHAM
	fi

    if [ ! -d "$SIGPI_SOURCE" ]; then
    	mkdir $SIGPI_SOURCE
    fi
    
    if [ ! -d "$SIGPI_HOME" ]; then
    	mkdir $SIGPI_HOME
    fi
    
    touch $SIGPI_INSTALL_STAGE1

	echo " "
    echo "### "
    echo "### "
	echo "###  SIGpi Remove (Stage 1)"
	echo "### "
    echo "### "
	echo " "

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

	#
	# REMOVE AX.25
	#

    echo " "
    echo " ## "
    echo " ## "
	echo " - Remove AX.25 and utilities"
    echo " ## "
    echo " ## "
	echo " "
	sudo apt-get install -y libax25 ax25-apps ax25-tools
    ##echo "ax0 N0CALL 1200 255 7 APRS" | sudo tee -a /etc/ax25/axports

    #
    # REMOVE VOIP (MURMUR SERVER AND MUMBLE)
    #

	echo " "
    echo " ## "
    echo " ## "
	echo " - VoIP Server (Murmur)"
    echo " ## "
    echo " ## "
	echo " "
    sudo apt install mumble-server -y 
	
    echo " "
    echo " ## "
    echo " ## "
	echo " - VoIP Client (Mumble)"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt install mumble -y 

	#
	# REMOVE RTLSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove RTLSDR"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	sudo apt install libusb-1.0-0-dev
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
	# REMOVE HACKRF
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove HackRF"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	sudo apt-get install -y hackrf libhackrf-dev
	sudo hackrf_info

	#
	# REMOVE LIMESDR SUITE
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove LimeSDR Suite"
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
	# REMOVE PLUTOSDR
	#
	
	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove PlutoSDR"
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
	# REMOVE SOAPYSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SoapySDR"
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
	# REMOVE SOAPYRTLSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SoapyRTLSDR"
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
	SoapySDRUtil --probe     

	#
	# REMOVE SOAPYHACKRF
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SoapyHackRF"
	echo " ## "
    echo " ## "
	echo " "
    cd $SIGPI_SOURCE
	cmake .. -DCMAKE_BUILD_TYPE=Release
	make
	sudo make install
	sudo ldconfig
	SoapySDRUtil --probe   

	#
	# REMOVE SOAPYPLUTOSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SoapyPlutoSDR"
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
	# REMOVE SOAPYREMOTE
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SoapyRemote"
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
	# REMOVE GPSD AND CHRONY
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - GPSd and Chrony (Time Synchronization)"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get -y install gpsd gpsd-clients python-gps chrony
	
    #
	# REMOVE LIQUID-DSP
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove Liquid-DSP"
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
}


	
}

stage_remove(){
	echo "###"
    echo "###"
	echo "### SIGpi Remove (Stage 5)"
	echo "###"
    echo "###"
    echo " "

	#
	# REMOVE HAM RADIO MENUS
	#
    echo " "
    echo " ##"
    echo " ##"
	echo " - Ham Radio App Menu"
    echo " ##"
    echo " ##"
	echo " "
    sudo apt remove -y hamradiomenus

    #
	# REMOVE QSSTV
	#
	echo " "
    echo " ##"
    echo " ##"
    echo " - Remove QSSTV"
	echo " ##"
    echo " ##"
    echo " "
    if test -f "$SIGPI_OPTION_BUILDHAM"; then
		cd $SIGPI_SOURCE/qsstv/build
		qmake clean
		sudo make clean
        sudo make uninstall
	else
		sudo apt remove qsstv -y
	fi

	#
	# REMOVE WSJT-X
	#

   	echo " "
    echo " ##"
    echo " ##"
    echo " - Remove WSJT-X"
	echo " ##"
    echo " ##"
    echo " "
	if test -f "$SIGPI_OPTION_BUILDHAM"; then
    	rm -rf cd $HOME/Downloads/wsjtx_2.4.0_armhf.deb
		sudo dpkg -r wsjtx_2.4.0_armhf.deb
	else
		sudo apt remove wsjtx
	fi

    #
	# REMOVE FLRIG, FLXMLRPC, FLDIGI
	#

	if test -f "$SIGPI_OPTION_BUILDHAM"; then
		
        # Remove Fldigi
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Remove FLdigi"
		echo " ##"
    	echo " ##"
    	echo " "
    	sudo apt install -y libudev-dev
		rm -rf $HOME/Downloads/fldigi-4.1.20.tar.gz
		cd $SIGPI_SOURCE/fldigi-4.1.20/build
		sudo make remove
		sudo ldconfig
		cd $HOME

        # Install FLrig
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Remove FLrig"
		echo " ##"
    	echo " ##"
    	echo " "
    	cd $HOME/Downloads/flrig-1.4.2.tar.gz
		cd $SIGPI_SOURCE/flrig-1.4.2/build
		sudo make remove
		cd $HOME


        # Install FLxmlrpc
		echo " "
    	echo " ##"
    	echo " ##"
    	echo " - Remove FLxmlrpc"
		echo " ##"
    	echo " ##"
    	echo " "
    	cd $HOME/Downloads/flxmlrpc-0.1.4.tar.gz
		cd $SIGPI_SOURCE/flxmlrpc-0.1.4/build
		sudo make remove
		sudo ldconfig
	else
		sudo apt remove fldigi flrig -y
	fi

	#
	# REMOVE XASTIR
	#

	echo " "
    echo " ##"
    echo " ##"
    echo " - Remove Xastir"
	echo " ##"
    echo " ##"
    echo " "
    sudo usermod -d -G xastir-ax25 pi
    sudo apt-get remove -y xastir

    #
	# REMOVE LINPAC (PACKET TERMINAL)
	#
    echo " "
    echo " ##"
    echo " ##"
	echo " - Remove Linpac terminal"
	echo " ##"
    echo " ##"
    echo " "
    sudo apt-get remove 
    
    #
	# REMOVE DIREWOLF
	#
    echo " "
    echo " ##"
    echo " ##"
	echo " - Remove DireWolf"
	echo " ##"
    echo " ##"
    echo " "
    cd $SIGPI_SOURCE\direwolf\build
	sudo make remove
	make remove-conf

   	#
	# REMOVE GPREDICT
	#
	echo " "
    echo " ##"
    echo " ##"
    echo " - Remove Gpredict (Satellite Tracking)"
    echo " ##"
    echo " ##"
	echo " "
    sudo apt-get remove -y gpredict

    #
	# REMOVE HAMLIB
	#
	
    echo " "
    echo " ## "
    echo " ## "
	echo " - Remove Hamlib"
	echo " ## "
    echo " ## "
    echo " "
	if test -f "$SIGPI_OPTION_BUILDHAM"; then
		cd $SIGPI_SOURCE/hamlib-4.3/build
		sudo make remove
		sudo ldconfig
	else
		sudo apt remove hamlib -y
	fi

    #
    # REMOVE KISMET
    #
    echo " "
    echo " ##"
    echo " ##"
    echo " - Remove Kismet"
    echo " ##"
    echo " ##"
    echo " "
    ### Remove Source 'deb https://www.kismetwireless.net/repos/apt/release/buster buster main' from /etc/apt/sources.list.d/kismet.list
	sudo apt remove kismet -y
    #
    #

	#
    # REMOVE SDRANGEL
    #
    
    echo " "
    echo " ## "
    echo " ## "
	echo " - Remove SDRangel"
	echo " ## "
    echo " ## "
	echo " "
    rm -rf /opt/build
    rm -rf /opt/install
    rm -rf $SIGPI_SOURCE/sdrangel
    rm -rf $SIGPI_SOURCE/voxangel
    rm -rf $HOME/.config/f4exb

	#
	# REMOVE CUBICSDR
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove CubicSDR"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt remove -y cubicsdr

	#
	# REMOVE GQRX-SDR
	#
	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove GQRX"
	echo " ## "
    echo " ## "
	echo " "
    sudo apt remove -y gqrx-sdr

	#
	# REMOVE GNUradio 3.7.X
	#

	echo " "
    echo " ## "
    echo " ## "
	echo " - Remove GNUradio 3.7.X"
    echo " ## "
    echo " ## "
	echo " "
	sudo apt remove install -y gnuradio






}

  
echo "*** "
echo "*** "
echo "***  SIGpi Removal Complete"
echo "*** "
echo "*** "
echo " "
echo "System needs to reboot for all changes to occur."
echo "Reboot will begin in 15 seconsds unless CTRL-C hit."
sleep 17
sudo sync
sudo reboot
exit 0