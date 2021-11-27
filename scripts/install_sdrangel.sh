#!/bin/bash

###
### SIGpi
###
### install_sdrangel
###

# DEPENDENCIES
sudo apt-get install -y libfftw3-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y libusb-dev
sudo apt-get install -y qt5-default
sudo apt-get install -y qtbase5-dev
sudo apt-get install -y qtchooser
sudo apt-get install -y libqt5multimedia5-plugins
sudo apt-get install -y qtmultimedia5-dev
sudo apt-get install -y libqt5websockets5-dev
sudo apt-get install -y qttools5-dev
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y libqt5opengl5-dev
sudo apt-get install -y qtbase5-dev
sudo apt-get install -y libqt5quick5
sudo apt-get install -y libqt5charts5-dev
sudo apt-get install -y qml-module-qtlocation
sudo apt-get install -y qml-module-qtpositioning
sudo apt-get install -y qml-module-qtquick-window2
sudo apt-get install -y qml-module-qtquick-dialogs
sudo apt-get install -y qml-module-qtquick-controls
sudo apt-get install -y qml-module-qtquick-layouts
sudo apt-get install -y libqt5serialport5-dev
sudo apt-get install -y libqt5texttospeech5-dev
sudo apt-get install -y qtdeclarative5-dev
sudo apt-get install -y qtpositioning5-dev
sudo apt-get install -y qtlocation5-dev
sudo apt-get install -y libboost-all-dev
sudo apt-get install -y libasound2-dev
sudo apt-get install -y pulseaudio
sudo apt-get install -y libopencv-dev
sudo apt-get install -y libxml2-dev
sudo apt-get install -y bison
sudo apt-get install -y flex
sudo apt-get install -y ffmpeg
sudo apt-get install -y libavcodec-dev
sudo apt-get install -y libavformat-dev
sudo apt-get install -y libopus-dev
sudo apt-get install -y graphviz


# INSTALL

# Application Specific Install variables

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install SDRangel (ETA: +80 Minutes)"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

# CM256cc
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/cm256cc.git
cd cm256cc
git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
mkdir build; cd build
cmake -Wno-dev ''
make -j4
sudo make install
sudo ldconfig

# MBElib
cd $SIGPI_SOURCE
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
mkdir build; cd build
cmake -Wno-dev ..
make -j4
sudo make install
sudo ldconfigsudo apt-get install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tool
sudo apt-get install -y libqt5websockets5-dev qtmultimedia5-dev qtpositioning5-dev
sudo apt-get install -y libqt5charts5-dev
sudo apt-get install -y libgl1-mesa-dev graphviz doxygen gettext \
  qtscript5-dev libqt5svg5-dev qttools5-dev-tools qttools5-dev \
  libqt5opengl5-dev qtmultimedia5-dev libqt5multimedia5-plugins \
  libqt5serialport5 libqt5serialport5-dev qtpositioning5-dev libgps-dev \
  libqt5positioning5 libqt5positioning5-plugins
sudo apt-get install -y qtlocation5-dev libqt5texttospeech5-dev libboost-all-dev
sudo apt-get install -y opus-tools libopus-dev

# SerialDV
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/serialDV.git
cd serialDV
git reset --hard "v1.1.4"
mkdir build; cd build
cmake -Wno-dev ..
make -j4
sudo make install
sudo ldconfig

# DSDcc
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/dsdcc.git
cd dsdcc
git reset --hard "v1.9.3"
mkdir build; cd build
cmake -Wno-dev -DUSE_MBELIB=ON ..
make -j4
sudo make install
sudo ldconfig

# Codec2/FreeDV
# Codec2 is already installed from the packager, but this version is required for SDRangel.
cd $SIGPI_SOURCE
git clone https://github.com/drowe67/codec2.git
cd codec2
git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2
mkdir build_linux; cd build_linux
cmake -Wno-dev ..
make -j4
sudo make install
sudo ldconfig

#SDRangel
cd $SIGPI_SOURCE
git clone https://github.com/f4exb/sdrangel.git
cd sdrangel
#git reset --hard 3e6fe8afefb7e0040af68f906962a03a360ea0a9  ## Added due to SDRgui compile issue for Pi from later committ
git reset --hard bb99edddc14a472c5986bf859fa36307f8e59334  #v6.17.4
mkdir build; cd build
cmake -Wno-dev ..
make -j4
sudo make install
sudo ldconfig

# Copy special startup script for this snowflake
sudo cp $SIGPI_SCRIPTS/run_sdrangel.sh /usr/local/bin/run_sdrangel.sh

# Add VOX for Transimtting with SDRangel
cd $SIGPI_SOURCE
git clone https://gitlab.wibisono.or.id/published/voxangel.git


echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##   SDRangel Installed"
echo -e "${SIGPI_BANNER_RESET}"
