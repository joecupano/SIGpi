#!/bin/bash

###
### SIGpi
###
### install_docker
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Docker"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# DEPENDENCIES

# INSTALL
cd $SIGPI_SOURCE
mkdir docker && cd docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo bash get-docker.sh
# Set SUDO user to use docker
sudo usermod -aG docker $(whoami)

# Docker Compose
sudo apt install python3-pip -y
sudo pip3 install docker-compose
docker-compose version

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Docker Installed"
echo -e "${SIGPI_BANNER_RESET}"