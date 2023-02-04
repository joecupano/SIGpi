#!/bin/bash

###
### Restart SDRplay
###
### 

sudo systemctl stop sdrplay
sudo pkill sdrplay_apiService
#sudo rm -f /dev/shm/Glbl\\sdrSrv*
sudo systemctl start sdrplay