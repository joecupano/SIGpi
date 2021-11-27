#!/bin/bash

###
### SIGpi
###
### installer_dependencies
###

# AX.25
echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Install Dependencies"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"

sudo apt-get install -y build-essential pkg-config git cmake g++ gcc autoconf automake libtoollibgl1-mesa-dev 
sudo apt-get install -y libssl-dev libavahi-client-dev libavahi-common-dev libaio-dev
sudo apt-get install -y libtool libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev

# Qt5 Base Packages
sudo apt-get install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools


######

sudo apt-get install -y git cmake g++ gcc autoconf automake libtool build-essential pkg-config 
sudo apt-get install -y bison doxygen dvipng faad ffmpeg flex gettext portaudio19-dev pulseaudio
sudo apt-get install -y mesa-common-dev octave octave-common octave-signal openssl gmp-doc gnuplot gnuplot-x11 swig graphviz

sudo apt-get install -y libtool libudev1 libusb-1.0-0 libusb-1.0-0-dev libusb-dev libsoapysdr-dev libairspyhf-dev libiio-dev libad9361-dev librtaudio-dev libhackrf-dev 

sudo apt-get install -y libssl-dev libavahi-client-dev libavahi-common-dev libaio-dev
sudo apt-get install -y liborc-0.4-0 liborc-0.4-dev liborc-0.4-doc liborc-0.4-0-dbg liborc-0.4-dev-bin liblog4cpp5-dev
sudo apt-get install -y libasound2-dev libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libbluetooth-dev
sudo apt-get install -y libfftw3-3 libfftw3-bin libfftw3-dev libfftw3-doc libfftw3-double3 libfftw3-mpi-dev libfftw3-mpi3 libfftw3-single3
sudo apt-get install -y libvolk1-bin libvolk1-dev libboost-all-dev 

sudo apt-get install -y libcairo2-dev libcanberra-gtk0 libcanberra-gtk-module libcppunit-dev libcppunit-doc libfaad2 libfaad-dev \
libfltk1.3 libfltk1.3-dev libfltk1.3-dev libfreesrp0 libgl1-mesa-dev libgle3 python-pyqtgraph-doc libgles1 libglfw3 \
libgmp10-doc libgmp-dev libgmpxx4ldbl libgsl-dev libhidapi-libusb0 libicu-dev libjs-jquery-ui libjs-jquery-ui-docs libliquid-dev liblog4cpp5-dev liblog4cpp5v5 \
libmpfrc++-dev libmpfr-dev libnova-dev libntl-dev liboctave-dev libopencv-dev libopenjp2-7 libopenjp2-7-dev libopus-dev liborc-0.4 liborc-0.4-0 liborc-0.4-dev \
libosmesa6 libpcap-dev libpng-dev libpthread-stubs0-dev libpulse-dev libsamplerate0-dev libsdl1.2-dev libserialport-dev libsndfile1-dev libsndfile-dev libswresample-dev \
libswscale-dev  libv4l-dev libwxgtk-media3.0-dev libxml2-dev \
libzmq3-dev libglfw3-dev libglew-dev libglfw3-dev libglew-dev libcdk5-dev

sudo apt-get install -y texlive-extra-utils texlive-latex-extra tix ttf-bitstream-vera ttf-staypuft zlib1g zlib1g-dev
sudo apt-get install -y sox tcl8.6 tk8.6 tk8.6-blt2.5 uhd-host valgrind 

sudo apt-get install -y qtchooser qt5-default  libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5 libqt5websockets5-dev qttools5-dev qttools5-dev-tools \
libqt5opengl5-dev qtbase5-dev libqt5quick5 libqt5charts5-dev qml-module-qtlocation  qml-module-qtpositioning qml-module-qtquick-window2 \
qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-layouts libqt5serialport5-dev \
qtdeclarative5-dev qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev libqwt-qt5-dev

sudo apt-get install -y python3-pip python3-cairocffi python3-click python3-click-plugins python3-cycler python3-gdal python3-gi-cairo python3-kiwisolver python3-lxml python3-mako \
python3-matplotlib python3-networkx python3-nose python3-numpy python3-opengl python3-pydot python3-pygraphviz python-qt4 qt5-default python3-pyqt5 python3-pyqt5.qtopengl python-pyside \
python3-pyqtgraph python3-scapy python3-scipy python3-setuptools python3-sphinx python3-tk python3-tk-dbg python3-tornado python3-yaml python3-zmq python-cycler-doc \
python-docutils python-gobject python-matplotlib-data python-matplotlib-doc python-networkx-doc 

sudo apt-get install -y python3-dbg

sudo pip3 install pyinstaller
sudo pip3 install pygccxml
sudo pip3 install qtawesome

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_COLOR} ##   Dependencies Installed"
echo -e "${SIGPI_BANNER_COLOR} ##"
echo -e "${SIGPI_BANNER_RESET}"
