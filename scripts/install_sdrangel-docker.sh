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
docker pull f4exb06/sdrangelsrv:v6.17.6
docker image tag f4exb06/sdrangelsrv:v6.17.6
docker run -d -p 8091:8091 --restart unless-stopped --name sigpiserver f4exb06/sdrangelsrv:v6.17.4 sdrangel/server16:latest

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SDRangel-docker Installed"
echo -e "${SIGPI_BANNER_RESET}"