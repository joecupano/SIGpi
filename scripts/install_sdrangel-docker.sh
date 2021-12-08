#!/bin/bash

###
### SIGpi
###
### _install_sdrangel-docker
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SDRangel-docker"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/sdrangel-docker.git
cd sdrangel-docker/sdrangel

#sdrserver
#./build_server.sh -f armv8.ubuntu.Dockerfile -T bb99edddc14a472c5986bf859fa36307f8e59334  #v6.17.4
docker pull f4exb06/sdrangelsrv:v6.17.4

#sdrangel
#build_vanilla.sh -T bb99edddc14a472c5986bf859fa36307f8e59334  #v6.17.4


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SDRangel-docker Installed"
echo -e "${SIGPI_BANNER_RESET}"