#!/bin/bash

###
### SIGPI
###
### remove_core_devices
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Remove Core Devices"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

cd $SIGPI_SOURCE/rtl-sdr/build
sudo make uninstall
cd $SIGPI_SOURCE/hackrf/host/build
sudo make uninstall
cd $SIGPI_SOURCE/libiio/build
sudo make uninstall
cd $SIGPI_SOURCE/LimeSuite/build-dir
sudo make uninstall
cd $SIGPI_SOURCE/SoapySDR/build
sudo make uninstall
cd $SIGPI_SOURCE/SoapyRTLSDR/buil
sudo make uninstall
cd $SIGPI_SOURCE/SoapyHackRF/build
sudo make uninstall
cd $SIGPI_SOURCE/SoapyPlutoSDR/build
sudo make uninstall
cd $SIGPI_SOURCE/SoapyRemote/build
sudo make uninstall
sudo ldconfig
cd $SIGPI_SOURCE
rm -rf rtl-sdr
rm -rf hackrf
rm -rf libiio
rm -rf LimeSuite
rm -rf SoapySDR
rm -rf SoapyRTLSDR
rm -rf SoapyHackRF
rm -rf SoapyPlutoSDR
rm -rf SoapyRemote

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Core Devices Removed"
echo -e "${SIGPI_BANNER_RESET}"