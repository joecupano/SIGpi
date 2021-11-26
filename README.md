# SIGpi Build Script

Release: 20211126-0400

## Introduction

Much how you see Amateur Radio operators build "go-kits" for remote or emergency operations, SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install.

This script builds SIGINT tools on a **Raspberry Pi4 4GB RAM and 32GB microSD card.** The SIGpi Build Script is run on your Raspberry Pi as user **pi** only **<u>AFTER</u>** you followed the [Raspberry Pi Documentation - Getting Started](https://www.raspberrypi.org/documentation/computers/getting-started.html) guide.

### How about other architectures?
There is also a build script for Ubuntu 21.04 running on AMD64 hardware at [SIGbox repo](https://github.com/joecupano/SIGbox)

## Release Notes
* [over here](RELEASE_NOTES.md)

## Install

- Start with a **RPi4 (4GB RAM minium)** with a **fresh install** of **[Raspberry Pi OS Desktop](https://www.raspberrypi.com/software/) on a [32GB microSD card](https://www.amazon.com/dp/B08GY9NYRM/?th=1)**
- Login as Pi on your **fresh install of [Raspberry Pi OS Desktop](https://www.raspberrypi.com/software/) on a [32GB microSD card](https://www.amazon.com/dp/B08GY9NYRM/?th=1)**
- Create a directory in your home called SIG and switch into it
- Clone the SIGpi repo
- Run SIGpi_installer.sh
- Follow script instructions.

```
sudo apt-get install -y build-essential git
mkdir ~/SIG && cd ~/SIG
git clone https://github.com/joecupano/SIGpi.git
cd SIGpi
./SIGpi_installer.sh
```

## Build Details

Total install time will take over three hours because of compile times for vairous components indicates below with an asterisk (*). SDRangel and its dependencies will use half of the time to compile - be patient. Below is a list of software installed.

Device Drivers
* [RTL-SDR](https://www.rtl-sdr.com/about-rtl-sdr/) RTL2832U & R820T2-Based *
* [HackRF One](https://greatscottgadgets.com/hackrf/one/) Hack RF One *
* [PlutoSDR](https://wiki.analog.com/university/tools/pluto) *
* [LimeSuite](https://github.com/myriadrf/LimeSuite) *
* [SoapySDR](https://github.com/pothosware/SoapySDR) SoapySDR Library *
* [SoapyRemote](https://github.com/pothosware/SoapyRemote) Use any Soapy SDR Remotely *
* SoapyRTLSDR Soapy SDR Module for RTLSDR *
* SoapyHackRF Soapy SDR Module for HackRF One *
* SoapyPlutoSDR Soapy SDR Module for PlutoSD *
* GPS client and NTP sync (gpsd gpsd-clients python-gps chrony)

Libraries and Decoders
* [aptdec](https://github.com/Xerbo/aptdec) *        NOAA satellite imagery decoder
* cm256cc *
* [dab-cmdline](https://github.com/JvanKatwijk/dab-cmdline) *   DABD/DAB+
* [mbelib](https://github.com/szechyjs/mbelib) *        P25 Phase 1
* [serialDV](https://github.com/f4exb/serialDV) *      Encode/Decode audio with AMBE3000 based devices (DMR, YSF, D-Star, etc)
* [dsdcc](https://github.com/f4exb/dsdcc) *         Encode/Decode Digital Voice modes (DMR, YSF, D*Star, etc) 
* [sgp4](https://pypi.org/project/sgp4/) *          Used for satellite trakcing given TLE data 
* [rtl_433](https://github.com/merbanan/rtl_433)           Generic data receiver for UHF ISM Bands decoding popular sensors
* [dump1090](https://github.com/antirez/dump1090)           Mode S decoder specifically designed for RTLSDR devices
* [libsigmf](https://github.com/deepsig/libsigmf) *      Used for Signal Metadata Format - sharing of signal data 
* [liquid-dsp](https://github.com/jgaeddert/liquid-dsp) *    Digital Signal Processing (DSP) library 
* [libbtbb](https://github.com/greatscottgadgets/libbtbb) *       Bkuetooth Baseband Library 
* [hamlib 4.3](https://hamlib.github.io/) *    API for controlling a myriad of radios 

SDR Applications
* [GNURadio](https://github.com/gnuradio/gnuradio)
* [GQRX](https://github.com/csete/gqrx)
* [SDRangel](https://github.com/f4exb/sdrangel) *
* [SDR++](https://github.com/AlexandreRouma/SDRPlusPlus)
* [CubicSDR](https://cubicsdr.com/)        SDR Receiver
* [Artemis](https://aresvalley.com/artemis/)         Real-time SIGINT from your SDR

Packet Radio
* libax25         AFSK baseband audio library for AX.25 packet as used by APRS
* ax25-apps       Command line AX.25 spps
* ax25-tools      AX.25 for daemon interfaces
* [direwolf](https://github.com/wb2osz/direwolf) *  Software “soundcard” AX.25 packet modem/TNC and APRS encoder/decoder

Amateur Radio
* [Fldigi](https://sourceforge.net/p/fldigi/wiki/Home/)    GUI app for CW, PSK, MFSK, RTTY, Hell, DominoEX, Olivia, etc 
* [WSJT-X](https://www.physics.princeton.edu/pulsar/k1jt/wsjtx.html) *  GUI app for FST4, FST4W, FT4, FT8, JT4, JT9, JT65, MSK144, and WSPR
* [QSSTV](http://users.telenet.be/on4qz/index.html)     GUI app for SSTV

Satellite and Geo
* [gpredict](https://github.com/csete/gpredict)        Satellite Tracking with Radio and Antenna Rotor Control
* [xastir](http://xastir.org/index.php/Main_Page)          APRS Station Tracking and Reporting
* [linpac](http://linpac.sourceforge.net/doc/manual.html)          Packet Radio Terminal with Mail Client

Tools
* Kismet        Wireless sniffer and monitor
* [Wireshark](https://www.wireshark.org/)     Network Traffic Analyzer
* [Audacity](https://www.audacityteam.org/)      Audio Editor
* [PAVU](https://freedesktop.org/software/pulseaudio/pavucontrol/)          PulseAudio 
Control
* [Mumble](https://www.mumble.info/)        VoIP Server and Client
* [SPLAT](https://www.qsl.net/kd2bd/splat.html)         RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz

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
#1      OH2BNS-1      1200    255     2       144.675 MHz (1200  bps)
#2      OH2BNS-9      38400   255     7       TNOS/Linux  (38400 bps)
```

- Save and exit

### DireWolf

DireWolf needs to be running for APRS and Packet applications to have use the AX0 interface defined in the previou section. You will need to configure your
callsign, the soundcard device to use, and whether using PTT or VOX in the **$HOME/direwolf.conf** file. The conf file itslef is well documented in how to configure else consult the [DireWolf online docs](https://github.com/wb2osz/direwolf/tree/master/doc).

Because a number of factors go into a successful DireWold setup with your transceiver, configuration discussion is deferred to the [official DireWolf documentation](https://github.com/wb2osz/direwolf/tree/master/doc).

### Xastir
Xastir is an application that provides geospatial mappng of APRS signals. It needs to configured to use the RF interface provided by DireWolf. You must start Direwolf in a separately terminal window before you start Xastir. Be sure to consult [Xastir online documentation](https://xastir.org/index.php/Main_Page) for more info.

## Gpredict
Some satellites have packet capability. Gpredict is a real-time satellite tracking and orbit prediction application. It needs to be configured with your lcoations latitiude, longitude, altitude, plus online data feeds for accurate tracking. Be sure to consult [Gpredict documentation]( http://gpredict.oz9aec.net/documents.php} for more info

## Mumble Server (VoIP)

This server is only necessary if intent to remotely connect to SIGpi and require audio at that remote location. You have the option of running the server on startup or not. Run the following command. 

```
sudo dpkg-reconfigure mumble-server
```

- You will first be asked whether you want to autostart the server or not. Select **No** unless you intent on accessing the SigPI remotely all the time.

- When asked to allow mumble-server to use higher priority select **No**.

- When asked to create a SuperUser password do something strong.

## Example Hardware Setup

![alt-test](https://github.com/joecupano/SIGpi/blob/develop_4-0/SIGpi_architecture_v2.png)

### Power

In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are pickya bout getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry Pi4

Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth she be disabled. If Internet is needed and only available via WiFi then use the eonboard WiFi.

### USB Peripherals

Only three USB devices requiring power shoudl be enabled at a time. The range of devices depicted is only to demonstrate what you could potentiall connect to it.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the  documentation on their respetive sites
