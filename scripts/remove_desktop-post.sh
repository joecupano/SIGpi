#!/bin/bash

###
### SIGpi
###
### remove_desktop-post
###

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Post Remove"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# XDG-USER-DIR
#/.local
#/.local/share
#/.local/share/applications
#/.local/share/desktop-directories

# Remove SIGpi Desktop files to XDG Dirs
#sudo cp $SIGPI_DESKTOP/*.desktop $DESKTOP_FILES
sudo rm -rf $DESKTOP_ICONS/sigpi*
#sudo cp $SIGPI_DESKTOP/SigPi.directory $DESKTOP_DIRECTORY
#sudo cp $SIGPI_DESKTOP/SigPi.menu $DESKTOP_XDG_MENU
sudo rm -rf $HOME/Desktop/SIGpi.desktop
sudo rm -rf $HOME/Desktop/sigidwiki.desktop
sudo rm -rf $HOME/Desktop/sigpi_home.desktop


# Add SigPi Category for installed applications
#sudo rm -rf $DESKTOP_FILES/artemis.desktop
sudo rm -rf $DESKTOP_FILES/CubicSDR.desktop
sudo rm -rf $DESKTOP_FILES/gnuradio-grc.desktop
sudo rm -rf $DESKTOP_FILES/gpredict.desktop
sudo rm -rf $DESKTOP_FILES/gqrx-sdr.desktop
sudo rm -rf $DESKTOP_FILES/lime-suite.desktop
sudo rm -rf $DESKTOP_FILES/sdrangel.desktop
sudo rm -rf $DESKTOP_FILES/sdrpp.desktop
sudo rm -rf $DESKTOP_FILES/wireshark.desktop
sudo rm -rf $DESKTOP_FILES/xastir.desktop
sudo rm -rf $DESKTOP_FILES/direwolf.desktop
sudo rm -rf $DESKTOP_FILES/flarq.desktop
sudo rm -rf $DESKTOP_FILES/fldigi.desktop
sudo rm -rf $DESKTOP_FILES/flrig.desktop
sudo rm -rf $DESKTOP_FILES/linpac.desktop
sudo rm -rf $DESKTOP_FILES/qsstv.desktop
#sudo rm -rf $DESKTOP_FILES/wsjtx.desktop
#sudo rm -rf $DESKTOP_FILES/message_aggregator.desktop
sudo rm -rf $DESKTOP_FILES/xastir.desktop

# Remove installed applications from SigPi menu
sudo rm -rf $DESKTOP_FILES/sigidwiki.desktop
sudo rm -rf $DESKTOP_FILES/sigpi_home.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   Desktop Post Removal Complete"
echo -e "${SIGPI_BANNER_RESET}"
