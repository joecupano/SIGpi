#!/bin/bash

###
### SIGpi
###
### run_SDRplay.sh
###

###
###  REVISION: 20260110-2300
###

sudo systemctl stop sdrplay
sudo pkill sdrplay_apiService
#sudo rm -f /dev/shm/Glbl\\sdrSrv*
sudo systemctl start sdrplay