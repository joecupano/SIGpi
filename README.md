# SIGpi Build Script

Release: 20211016-1300

## Background

This build script is part of a larger project called SIGbox. This script builds SIGbox on a
Raspberry Pi4 runnning Raspberry Pi OS Full (32-bit.) 

NOTE: There is also a build script for Ubuntu 21.04 running on ARM(Pi) amd AMD64 hardware
at the [SIGbox repo](https://github.com/joecupano/SIGbox)

Much how you see Amateur Radio operators build "go-kits" for remote or emergency operations, SIGbox is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install.

![alt-test](https://github.com/joecupano/SIGpi/blob/main/tools/SIGbox_architecture.png)

## SIGpi

SIGpi is the compute component of SIGbox built on a Raspberry Pi4 4GB RAM and 32GB microSD card. The SIGpi Build Script is run on your Raspberry Pi as user **pi** only **<u>AFTER</u>** you followed the [Raspberry Pi Documentation - Getting Started](https://www.raspberrypi.org/documentation/computers/getting-started.html) guide.

Total install time will take over three hours if you choose compile some software versus going with packages available
from the Raspberry Pi OS 32-bit distro. Below is a list of software installed. Asterisk (*) indicate software packages
that are compiled

```

Device Drivers
- rtl-sdr RTL2832U & R820T2-Based *
- hackrf Hack RF One *
- libiio PlutoSDR *
- limesuite LimeSDR *
- soapysdr SoapySDR Library *
- soapyremote Use any Soapy SDR Remotely *
- soapyrtlsdr Soapy SDR Module for RTLSDR *
- soapyhackrf Soapy SDR Module for HackRF One *
- soapyplutosdr Soapy SDR Module for PlutoSD *

Libraries
- aptdec *        NOAA satellite imagery decoder
- cm256cc *
- dab-cmdline *   DABD/DAB+
- mbelib *        P25 Phase 1
- serialDV *      Encode/Decode audio with AMBE3000 based devices (DMR, YSF, D-Star, etc)
- dsdcc *         Encode/Decode Digital Voice modes (DMR, YSF, D-Star, etc)
- sgp4 *          Used for satellite trakcing given TLE data
- libsigmf *      Used for Signal Metadata Format - sharing of signal data
- liquid-dsp *    Digital Signal Processing (DSP) library
- libbtbb *       Bkuetooth Baseband Library
- Hamlib 3.3-5    API for controlling a myriad of radios
- Hamlib 4.3 *    API for controlling a myriad of radios




SDR Applications
- gnuradio 3.7
- gnuradio 3.7 *
- gqrx SDR Receiver
- cubicsdr SDR Receiver

Packet Radio
- libax25
- ax25-apps
- ax25-tools
- direwolf 1.7 *


Amateur Radio
- fldigi 4.1.0
- fldigi 4.1.20 *
- wsjt-x 2.4.0
- wsjt-x 2.4.2 *
- qsstv
- qsstv 9.5.8 *


Satellite and Geo
- gpredict Satellite Tracking
- xastir APRS Station Tracking and Reporting
- linpac Packet Radio Temrinal with mail client


Tools
- kismet Wireless sniffer and monitor
- wireshark Network Traffic Analyzer
- audacity Audio Editor
- pavu PulseAudio Control
- mumble VoIP Server and Client
- splat RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz
- gps GPS client and NTP sync
- tempest Uses your computer monitor to send out AM radio signals *

```

## Dependencies 

Best effort has been made that all software dependencies are satisfied after update/upgrade and
before software installation begins. Dependencies are listed below

```
git cmake g++ pkg-config autoconf automake libtool build-essential
pulseaudio bison flex gettext ffmpeg portaudio19-dev doxygen graphviz gnuplot gnuplot-x11 swig

libfaad-dev zlib1g-dev libboost-all-dev libasound2-dev libfftw3-dev libusb-1.0-0 libusb-1.0-0-dev
libusb-dev libopencv-dev libxml2-dev libaio-dev libnova-dev libwxgtk-media3.0-dev libcairo2-dev
libavcodec-dev libpthread-stubs0-dev libavformat-dev libfltk1.3-dev libfltk1.3 libsndfile1-dev
libopus-dev libavahi-common-dev libavahi-client-dev 

libavdevice-dev libavutil-dev libsdl1.2-dev libgsl-dev liblog4cpp5-dev libzmq3-dev libudev-dev
liborc-0.4-0 liborc-0.4-dev libsamplerate0-dev libgmp-dev libpcap-dev libcppunit-dev libbluetooth-dev
python-pyside python-qt4 qt5-default libpulse-dev libliquid-dev libswscale-dev libswresample-dev 

python3-pip python3-numpy python3-mako python3-sphinx python3-lxml python3-yaml python3-click
python3-click-plugins python3-zmq python3-scipy python3-scapy python3-setuptools python3-pyqt5
python3-gi-cairo python-docutils

qtchooser libqt5multimedia5-plugins qtmultimedia5-dev libqt5websockets5-dev qttools5-dev
qttools5-dev-tools libqt5opengl5-dev qtbase5-dev libqt5quick5 libqt5charts5-dev qml-module-qtlocation
qml-module-qtpositioning qml-module-qtquick-window2 qml-module-qtquick-dialogs qml-module-qtquick-controls
qml-module-qtquick-controls2 qml-module-qtquick-layouts libqt5serialport5-dev qtdeclarative5-dev
qtpositioning5-dev qtlocation5-dev libqt5texttospeech5-dev libqwt-qt5-dev

```

## Release Notes


### Release 2.1: 2021-10-16
- Various fixes as part of merging code with [SIGbox](https://github.com/joecupano/SIGbox)
- SIGpi_update deprecated. This version required to be fresh install

### Release 2.0: 2021-10-02
- Update install script to be TUI-based using Whiptail-based
- Update GNUradio from 3.7 to 3.8
- Add the following digital decoder libraries/tools
-- aptdec, CM265cc, LibDAB, MBElib, SerialDV, DSDcc, SGP4, LibSigMF, Liquid-DSP, Multimon-ng, Bluetooth Baseband Library 
- Option to install latest-compiled versions of Amateur Radio Applications
-- Fldigi 4.1.20 (and suite), WSJT-X 2.4.0, QSSTV 9.5.8
- Install the following software 
-- Ubertooth Tools
-- RTL_433
- Optional install the following software 
-- SPLAT
-- Wireshark
-- Kismet
-- TEMPEST for Eliza

### Release 1.0: 2021-09-15
- Initial Release


## Fresh Install

- Login as Pi
- Create a directory in your home called source and switch into it
- Clone the SIGpi repo
- Run SIGpi_installer.sh
- Follow script instructions.

```
mkdir ~/source && cd ~/source
git clone https://github.com/joecupano/SIGpi.git
cd SIGpi
./SIGpi_installer.sh
```

## Distro versus Compiled Software versions

Go with the distro releases of software packages for classic and common use cases.
If you are a more experience signals investigator you may find your needs may require
the latest versions of software which require compile and alot of patience for the
time they take to compile. The software packages that can take an hour each to
compile include:

- Hamlib 4.3
- Fldigi 4.1.20
- WSJT-X 2.4.2
- QSSTV 9.5.8

SDRangel can take up to 90 minutes to compile. 

## Mumble Server (VoIP)

This server is only necessary if intent to remotely connect to SIGpi and require audio at that remote location. You have the option of running the server on startup or not. Run the following command. 

```
sudo dpkg-reconfigure mumble-server
```

- You will first be asked whether you want to autostart the server or not. Select **No** unless you intent on accessing the SigPI remotely all the time.

- When asked to allow mumble-server to use higher priority select **No**.

- When asked to create a SuperUser password do something strong.

## APRS and Packet using a VHF/UHF Transceiver

SDRangel and other SDR applications have the capability to decode APRS and Packet Radio signals and transmit at very low RF power levels with SDR devices supported. If you have an Amateur Radio license and aspire to operate serious distance including satellites then you will need VHF/UHF transceiver capable of 5 watts for the latter interfacing to the transceiver through audio and radio control via Hamlib.

In the past dedicated hardware known as TNCs (terminal node controllers) was used between a computer and transceiver. But the signals themselves are audio so TNCs were replaced with sofwtare and soundcards connected to the transceiver. For this build DireWolf is the software replacing the TNC and AX.25 software providing the data-link layer above it that provides sockets to it.

If you are planning to operate APRS and Packet Radio with a transceiver then configuring DireWolf and AX.25 is necessary. Otherwise you can skip the subsections. 

### AX.25

You will need to edit a line in the /etc/ax25/axports file as follows:

```
sudo nano /etc/ax25/axports
```

- Change **N0CALL** to your callsign followed by a hyphen and a number 1 to 15. (For Example  N3RDY-3)

```
# /etc/ax25/axports
#
# The format of this file is:
#
# name callsign speed paclen window description
#
ax0     N0CALL-3      1200    255     4       APRS / Packet
#1      OH2BNS-1        1200    255     2       144.675 MHz (1200  bps)
#2      OH2BNS-9        38400   255     7       TNOS/Linux  (38400 bps)
```

- Save and exit

### DireWolf

DireWolf needs to be running for APRS and Packet applications to have use the AX0 interface defined in the previou section. You will need to configure your
callsign, the soundcard device to use, and whether using PTT or VOX in the **$HOME/direwolf.conf** file. The conf file itslef is well documented in how to configure else consult the [DireWolf online docs](https://github.com/wb2osz/direwolf/tree/master/doc).

Because a number of factors go into a successful DireWold setup with your transceiver, configuration discussion is deferred to the [official DireWolf documentation](https://github.com/wb2osz/direwolf/tree/master/doc).

### XASTIR
Xastir is an application that provides geospatial mappng of APRS signals. It needs to configured to use the RF interface provided by DireWolf. You must start Direwolf in a separately terminal window before you start Xastir. Be sure to consult [Xastir online documentation](https://xastir.org/index.php/Main_Page) for more info.

## Gpredict
Some satellites have packet capability. Gpredict is a real-time satellite tracking and orbit prediction application. It needs to be configured with your lcoations latitiude, longitude, altitude, plus online data feeds for accurate tracking. Be sure to consult [Gpredict documentation]( http://gpredict.oz9aec.net/documents.php} for more info

## Post Installation

Though all the software is installed, many apps will require further configuration. Some will require configuration per use if you are using different SDR devices for differenent use cases. This section covers the configurations that only need to be done one time.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the  documentation on their respetive sites


