# SIGpi Build Script

Release: 20210912-1900

## Background

This build script is part of a larger project called SIGbox. 

Much how you see Amateur Radio operators build "go-kits" for remote or emergency operations, SIGbox is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install.

![alt-test](https://github.com/joecupano/SIGbox/blob/main/SIGbox_architecture.png)

## SIGpi

SIGpi is the compute component of SIGbox built on a Raspberry Pi4 4GB RAM and 32GB microSD card. The SIGpi Build Script is run on your Raspberry Pi as user **pi** only **<u>AFTER</u>** you followed the [Raspberry Pi Documentation - Getting Started](https://www.raspberrypi.org/documentation/computers/getting-started.html) guide.

The script runs in stages creating a swapfile and rebooting after the completion of some stages. After reboot you type the same command as you did to start this script. The script will know where it left off. Only RTLSDR, HackRF, LimeSDR, and PlutoSDR drivers are built.

Below is a list of installs per stage. The install are in a particular order given dependencies by other applications. Some are package installs while many require donwloading source and and compiling.

Total install time will take about three hours plus with the SDRangel related packages in Stage 3 taking at least an hour. If Amateur Radio Digital modes do not interest you, you can skip installing Stage 5.

```
Stage 1
	- Ensure OS is current (update,upgrade)
	- Pulse Audio Control (PAVU)
	- Audacity

Stage 2
	- AX.25 and utilities
	- VoIP Server/Client (Murmur/Mumble)
	- RTLSDR
	- HackRF
	- LimeSDR
	- PlutoSDR
	- SoapySDR
	- SoapyRTLSDR
	- SoapyHackRF
	- SoapyPlutoSDR
	- SoapyRemote
	- GPSd and Chrony
	- Liquid-DSP
	- GNUradio 3.7.X
	- Kismet
	- GQRX
	- CubicSDR

Stage 3
	- SDRangel Dependencies
	- SDRangel
	- SDRangel Wisdom File
	- VOX for SDRangel

Stage 4
	- HamLib 4.3
	- Gpredict
	- DireWolf 1.7
	- Linpac
	- Xastir

Stage 5
	- FLdigi Suite (FLxmlrpc 0.1.4, Flrig 1.4.2, Fldigi 4.1.20)
	- WSJT-X 2.4.0
	- QSSTV 9.5.8
	- SigPi Menus

```

## Installation

- Login as Pi
- Create a directory in your home called source and switch into it

```
mkdir ~/source && cd ~/source
```
- Clone the Repo

```
git clone https://github.com/joecupano/SIGbox.git
```

- Change directory into SIGbox

```
cd SIGbox
```

- Make SIGpi_install.sh executable

```
chmod 755 SIGpi_install.sh
```

- Run SIGpi_install.sh

```
./SIGpi_install.sh
```

Follow script instructions. Know Stage 3 will run for well over an hour.

### Amateur Radion Software versions

Installing from repo is the default for the following packages

- Fldigi suite
- QSSTV

If you want the latest stable packages installed for those applications then pass BUILDHAM as argument to the install script the first time you run it.

```
./SIGpi_install.sh BUILDHAM
```
No need to pass the argument again in subsequent stages.

## Post Installation

Though all the software is installed, many apps will require further configuration. Some will require configuration per use if you are using different SDR devices for differenent use cases. This section covers the configurations that only need to be done one time.

### Mumble Server (VoIP)

This server is only necessary if intent to remotely connect to SIGpi and require audio at that remote location. You have the option of running the server on startup or not. Run the following command. 

```
sudo dpkg-reconfigure mumble-server
```

- You will first be asked whether you want to autostart the server or not. Select **No** unless you intent on accessing the SigPI remotely all the time.

- When asked to allow mumble-server to use higher priority select **No**.

- When asked to create a SuperUser password do something strong.

### APRS and Packet using a VHF/UHF Transceiver

SDRangel and other SDR applications have the capability to decode APRS and Packet Radio signals and transmit at very low RF power levels with SDR devices supported. If you have an Amateur Radio license and aspire to operate serious distance including satellites then you will need VHF/UHF transceiver capable of 5 watts for the latter interfacing to the transceiver through audio and radio control via Hamlib.

In the past dedicated hardware known as TNCs (terminal node controllers) was used between a computer and transceiver. But the signals themselves are audio so TNCs were replaced with sofwtare and soundcards connected to the transceiver. For this build DireWolf is the software replacing the TNC and AX.25 software providing the data-link layer above it that provides sockets to it.

If you are planning to operate APRS and Packet Radio with a transceiver then configuring DireWolf and AX.25 is necessary. Otherwise you can skip the subsections. 

#### AX.25

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

#### DireWolf

DireWolf needs to be running for APRS and Packet applications to have use the AX0 interface defined in the previou section. You will need to configure your
callsign, the soundcard device to use, and whether using PTT or VOX in the **$HOME/direwolf.conf** file. The conf file itslef is well documented in how to configure else consult the [DireWolf online docs](https://github.com/wb2osz/direwolf/tree/master/doc).

Because a number of factors go into a successful DireWold setup with your transceiver, configuration discussion is deferred to the [official DireWolf documentation](https://github.com/wb2osz/direwolf/tree/master/doc).

#### XASTIR
Xastir is an application that provides geospatial mappng of APRS signals. It needs to configured to use the RF interface provided by DireWolf. You must start Direwolf in a separately terminal window before you start Xastir. Be sure to consult [Xastir online documentation](https://xastir.org/index.php/Main_Page) for more info.

#### Gpredict
Some satellites have packet capability. Gpredict is a real-time satellite tracking and orbit prediction application. It needs to be configured with your lcoations latitiude, longitude, altitude, plus online data feeds for accurate tracking. Be sure to consult [Gpredict documentation]( http://gpredict.oz9aec.net/documents.php} for more info


## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the  documentation on their respetive sites


