#!/bin/bash

###
### SIGpi
###
### install_sdrangel
###

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Install SDRangel (ETA: +80 Minutes)"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"

SIGPI_SDRANGEL=$SIGPI_SOURCE/SDRangel
cd $SIGPI_SOURCE

sudo mkdir -p /opt/build
sudo chown pi:users /opt/build
sudo mkdir -p /opt/install
sudo chown pi:users /opt/install

# APT
# Aptdec is a FOSS program that decodes images transmitted by NOAA weather satellites.
cd $SIGPI_SDRANGEL
git clone https://github.com/srcejon/aptdec.git
cd aptdec
git checkout libaptdec
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/aptdec ..
make -j $(nproc) install

# CM265cc
cd $SIGPI_SDRANGEL
git clone https://github.com/f4exb/cm256cc.git
cd cm256cc
git reset --hard c0e92b92aca3d1d36c990b642b937c64d363c559
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/cm256cc ..
make -j $(nproc) install

# LibDAB
cd $SIGPI_SDRANGEL
git clone https://github.com/srcejon/dab-cmdline.git
cd dab-cmdline/library
git checkout msvc
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libdab ..
make -j $(nproc) install

# MBElib
cd $SIGPI_SDRANGEL
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
git reset --hard 9a04ed5c78176a9965f3d43f7aa1b1f5330e771f
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/mbelib ..
make -j $(nproc) install

# SerialDV
cd $SIGPI_SDRANGEL
git clone https://github.com/f4exb/serialDV.git
cd serialDV
git reset --hard "v1.1.4"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/serialdv ..
make -j $(nproc) install

# DSDcc
cd $SIGPI_SDRANGEL
git clone https://github.com/f4exb/dsdcc.git
cd dsdcc
git reset --hard "v1.9.3"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/dsdcc -DUSE_MBELIB=ON -DLIBMBE_INCLUDE_DIR=/opt/install/mbelib/include -DLIBMBE_LIBRARY=/opt/install/mbelib/lib/libmbe.so -DLIBSERIALDV_INCLUDE_DIR=/opt/install/serialdv/include/serialdv -DLIBSERIALDV_LIBRARY=/opt/install/serialdv/lib/libserialdv.so ..
make -j $(nproc) install

# Codec2/FreeDV
# Codec2 is already installed from the packager, but this version is required for SDRangel.
cd $SIGPI_SDRANGEL
git clone https://github.com/drowe67/codec2.git
cd codec2
git reset --hard 76a20416d715ee06f8b36a9953506876689a3bd2
mkdir build_linux; cd build_linux
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/codec2 ..
make -j $(nproc) install

# SGP4
# python-sgp4 1.4-1 is available in the packager, installing this version just to be sure.
cd $SIGPI_SDRANGEL
git clone https://github.com/dnwrnr/sgp4.git
cd sgp4
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/sgp4 ..
make -j $(nproc) install

# LibSigMF
cd $SIGPI_SDRANGEL
git clone https://github.com/f4exb/libsigmf.git
cd libsigmf
git checkout "new-namespaces"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libsigmf .. 
make -j $(nproc) install
sudo ldconfig

# RTLSDR
cd $SIGPI_SDRANGEL
git clone https://github.com/osmocom/rtl-sdr.git librtlsdr
cd librtlsdr
git reset --hard be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7
mkdir build; cd build
cmake -Wno-dev -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX=/opt/install/librtlsdr ..
make -j4 install

# PlutoSDR
cd $SIGPI_SDRANGEL
git clone https://github.com/analogdevicesinc/libiio.git
cd libiio
git reset --hard v0.21
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libiio -DINSTALL_UDEV_RULE=OFF ..
make -j4 install

# HackRF
cd $SIGPI_SDRANGEL
git clone https://github.com/mossmann/hackrf.git
cd hackrf/host
git reset --hard "v2018.01.1"
mkdir build; cd build
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/libhackrf -DINSTALL_UDEV_RULES=OFF ..
make -j4 install

# LimeSDR
cd $SIGPI_SDRANGEL
git clone https://github.com/myriadrf/LimeSuite.git
cd LimeSuite
git reset --hard "v20.01.0"
mkdir builddir; cd builddir
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite ..
make -j4 install

#SoapySDR
cd $SIGPI_SDRANGEL
git clone https://github.com/pothosware/SoapySDR.git
cd SoapySDR
git reset --hard "soapy-sdr-0.7.1"
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR ..
make -j4 install
	
#SoapyRTLSDR
cd $SIGPI_SDRANGEL
git clone https://github.com/pothosware/SoapyRTLSDR.git
cd SoapyRTLSDR
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR  -DRTLSDR_INCLUDE_DIR=/opt/install/librtlsdr/include -DRTLSDR_LIBRARY=/opt/install/librtlsdr/lib/librtlsdr.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
make -j4 install

#SoapyHackRF
cd $SIGPI_SDRANGEL
git clone https://github.com/pothosware/SoapyHackRF.git
cd SoapyHackRF
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DLIBHACKRF_INCLUDE_DIR=/opt/install/libhackrf/include/libhackrf -DLIBHACKRF_LIBRARY=/opt/install/libhackrf/lib/libhackrf.so -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
make -j4 install

#SoapyLimeRF
cd $SIGPI_SDRANGEL
cd LimeSuite/builddir
cmake -Wno-dev -DCMAKE_INSTALL_PREFIX=/opt/install/LimeSuite -DCMAKE_PREFIX_PATH=/opt/install/SoapySDR ..
make -j4 install
cp /opt/install/LimeSuite/lib/SoapySDR/modules0.7/libLMS7Support.so /opt/install/SoapySDR/lib/SoapySDR/modules0.7

#SoapyRemote
cd $SIGPI_SDRANGEL
git clone https://github.com/pothosware/SoapyRemote.git
cd SoapyRemote
git reset --hard "soapy-remote-0.5.1"
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/install/SoapySDR -DSOAPY_SDR_INCLUDE_DIR=/opt/install/SoapySDR/include -DSOAPY_SDR_LIBRARY=/opt/install/SoapySDR/lib/libSoapySDR.so ..
make -j4 install

#SDRangel
cd $SIGPI_SDRANGEL
git clone https://github.com/f4exb/sdrangel.git
cd sdrangel
mkdir build; cd build
cmake -Wno-dev -DDEBUG_OUTPUT=ON -DRX_SAMPLE_24BIT=ON \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DHACKRF_DIR=/opt/install/libhackrf \
-DRTLSDR_DIR=/opt/install/librtlsdr \
-DLIMESUITE_DIR=/opt/install/LimeSuite \
-DIIO_DIR=/opt/install/libiio \
-DSOAPYSDR_DIR=/opt/install/SoapySDR \
-DAPT_DIR=/opt/install/aptdec \
-DCM256CC_DIR=/opt/install/cm256cc \
-DDSDCC_DIR=/opt/install/dsdcc \
-DSERIALDV_DIR=/opt/install/serialdv \
-DMBE_DIR=/opt/install/mbelib \
-DCODEC2_DIR=/opt/install/codec2 \
-DSGP4_DIR=/opt/install/sgp4 \
-DLIBSIGMF_DIR=/opt/install/libsigmf \
-DDAB_DIR=/opt/install/libdab \
-DCMAKE_INSTALL_PREFIX=/opt/install/sdrangel ..
make -j4 install
# Copy special startup script for this snowflake
sudo cp $SIGPI_SCRIPTS/run_sdrangel.sh /usr/local/bin/sdrangel

cd $HOME/.config/
mkdir f4exb
cd f4exb
# Generate a new wisdom file for FFT sizes : 128, 256, 512, 1024, 2048, 4096, 8192, 16384 and 32768.
# This will take a very long time.
fftwf-wisdom -n -o fftw-wisdom 128 256 512 1024 2048 4096 8192 16384 32768

# Add VOX for Transimtting with SDRangel
cd $SIGPI_SOURCE
git clone https://gitlab.wibisono.or.id/published/voxangel.git

# Copy Menu items into relevant directories
sudo cp $SIGPI_SOURCE/SDRangel/sdrangel/build/sdrangel.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/sdrangel.desktop

# Add installed applications into SigPi menu
xdg-desktop-menu install --novendor --noupdate $DESKTOP_DIRECTORY/SigPi.directory $DESKTOP_FILES/sdrangel.desktop

echo -e "${SIG_BANNER_COLOR}"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIG_BANNER_COLOR} #SIGPI#"
echo -e "${SIG_BANNER_RESET}"