# SIGpi

## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with capabilities in the HF, VHF, UHF, and SHF spectrum. It includes a framework for simple installation and management of popular SIGINT appliucations and devices made mostly from bash scripts building/installing SIGINT tools on the following platforms:

- **Raspberry Pi4 4GB RAM** or **Raspberry Pi 400** with 32GB microSD card running **Raspberry Pi OS "Bullseye" or "Bookworm" Full (64-bit)**
- **Ubuntu 22.04 LTS** on arm64 or amd64 platforms with 4GB RAM and 32GB storage minimum

A headless **Server Install** can be built on a minimum of a **Raspberry Pi3 B+** with 32GB microSD card running **Raspberry Pi OS "Bullseye" or "Bookworm" Lite (64-bit)** or **Ubuntu 22.04 LTS Server**

## Release Notes
* [over here](RELEASE_NOTES.md)

## Quick Setup

- Login as pi or sudo user on supported platform
- Update and install pre-requisite packages to install SIGpi
- From your home directory, create a directory called SIG and switch into it
- Clone the SIGpi repo 
- Change directory into SIGpi

```
sudo apt update && sudo apt upgrade
sudo apt-get install -y build-essential cmake git
cd ~
mkdir ~/SIG && cd ~/SIG
git clone https://github.com/joecupano/SIGpi.git
cd SIGpi
```

Run the following command from $HOME/SIG/SIGpi to install the framework and package management

```
./SIGpi setup standard
```

After setup system will reboot.

### Add a Package

Once setup, you can list the inventory of packages SIGpi includes as well as those already installed
with the following command (note that ./ is no longer required for thr SIGpi command after setup)

```
SIGpi list library
```

An asterisk in the INSTALLED column indicates that package is already installed while those withou asterisks 
have not been installed. For example, you will see SDRangel has not been installed. You can do so with the following command.

```
SIGpi install sdrangel
```

Go back and list again to install other packages of interest

## Overview of Commands

Typing SIGpi by itself will give you the list of commands available.

SIGpi includes it's own package management platform to update applications to their latest releases using familiar syntax from package management systems. Here is an overview of available commands.

```
  Usage:  SIGpi [ACTION] [TARGET]

       ACTION
  
          install                install TARGET from current release
          remove                 remove installed TARGET
          purge                  remove installed TARGET and purge configs
          build                  compile and install TARGET (option may not be available)
          update                 check for update of TARGET
          upgrade                upgrade TARGET to latest release

       TARGET

          A SIGpi package
                 

  Usage:  SIGpi [ACTION]

       ACTION

          SIGpi setup standard   First time setup for desktop
          SIGpi setup server     First time setup for server
          SIGpi list packages    List all packages included with SIGpi
          SIGpi list installed   List installed SIGpi packages
          SIGpi list library     List all packages included with SIGpi with installed ones marked with an *
          SIGpi shell            provide SIGpi env variables around a TARGET
```

You can update packages in your existing SIGpi install with the following commands using **SDRangel** and **SDR++** as examples:

```
SIGpi update sdrangel
SIGpi upgrade sdrangel
```

You can add/remove Packages anytime

```
SIGpi install audacity
SIGpi remove audacity
```

## Packages

Device Drivers
* [bladeRF](https://github.com/Nuand/bladeRF)
* [HackRF One](https://greatscottgadgets.com/hackrf/one/)
* [LimeSuite](https://github.com/myriadrf/LimeSuite) 
* [PlutoSDR](https://wiki.analog.com/university/tools/pluto)
* [RTL-SDR](https://www.rtl-sdr.com/about-rtl-sdr/) - RTL2832U & R820T2-Based
* [SDRPlay](https://www.sdrplay.com/products/)
* [SoapySDR](https://github.com/pothosware/SoapySDR)
* [SoapyRemote](https://github.com/pothosware/SoapyRemote)
* SoapyBladeRF
* SoapyHackRF
* SoapyPlutoSDR
* SoapyRTLSDR
* SoapySDRPlay
* [Ubertooth](https://github.com/greatscottgadgets/ubertooth) - Ubertooth support

Libraries and Decoders
* [aptdec](https://github.com/Xerbo/aptdec) - NOAA satellite imagery decoder
* cm256cc
* [dab-cmdline](https://github.com/JvanKatwijk/dab-cmdline) - DABD/DAB+
* [dsdcc](https://github.com/f4exb/dsdcc) - Encode/Decode Digital Voice modes (DMR, YSF, D*Star, etc) 
* [hamlib](https://hamlib.github.io/) - API for controlling a myriad of radios 
* libax25 - AFSK baseband audio library for AX.25 packet as used by APRS
* [libbtbb](https://github.com/greatscottgadgets/libbtbb) - Bluetooth Baseband Library 
* [libsigmf](https://github.com/deepsig/libsigmf) - Used for Signal Metadata Format - sharing of signal data 
* [liquid-dsp](https://github.com/jgaeddert/liquid-dsp) - Digital Signal Processing (DSP) library 
* [mbelib](https://github.com/szechyjs/mbelib) - P25 Phase 1
* [RadioSonde](https://github.com/rs1729/RS) - Various tools for Weather balloon telemetry
* [serialDV](https://github.com/f4exb/serialDV) - Encode/Decode audio with AMBE3000 based devices (DMR, YSF, D-Star, etc)
* [sgp4](https://pypi.org/project/sgp4/) - Used for satellite tracking given TLE data 

SDR Applications
* [Audacity](https://www.audacityteam.org/) - Audio Editor
* [CubicSDR](https://cubicsdr.com/)
* [CygnusRFI](https://github.com/0xCoto/CygnusRFI) - Radio Frequency Interference (RFI) analysis tool
* [dump1090](https://github.com/antirez/dump1090) - Mode S decoder specifically designed for RTLSDR devices
* [GNURadio](https://github.com/gnuradio/gnuradio)
* [SDRangel](https://github.com/f4exb/sdrangel)
* [SDR++](https://github.com/AlexandreRouma/SDRPlusPlus)
* [SigDigger](https://github.com/BatchDrake/SigDigger)
* [rtl_433](https://github.com/merbanan/rtl_433)- Generic data receiver for UHF ISM Bands decoding popular sensors

Amateur Radio Applications
* ax25-apps - Command line AX.25 apps
* ax25-tools - AX.25 for daemon interfaces
* [direwolf](https://github.com/wb2osz/direwolf) - Software “soundcard” AX.25 packet modem/TNC and APRS encoder/decoder
* [Fldigi](https://sourceforge.net/p/fldigi/wiki/Home/) - GUI app for CW, PSK, MFSK, RTTY, Hell, DominoEX, Olivia, etc 
* [js8call](http://js8call.com/) - JS8 mode
* [QSSTV](http://users.telenet.be/on4qz/index.html) - GUI app for SSTV
* [WSJT-X](https://wsjt.sourceforge.io/wsjtx.html) - FT4, FT8, JT4, JT9, JT65, Q65, MSK144

Satellite and Geo
* [gpredict](https://github.com/csete/gpredict) - Satellite Tracking with Radio and Antenna Rotor Control
* [xastir](http://xastir.org/index.php/Main_Page) - APRS Station Tracking and Reporting
* [linpac](http://linpac.sourceforge.net/doc/manual.html) - Packet Radio Terminal with Mail Client

Other SIGINT tools
* [bettercap](https://www.bettercap.org/) wireless signal reconnaissance
* Chrony - NTP sync
* [HASviolet](https://github.com/hudsonvalleydigitalnetwork/hasviolet/wiki/HASviolet) (RPi only) LoRa communications on 33cm band (902-928 MHz)
* [Kismet](https://www.kismetwireless.net/) - wireless reconnaissance and intrusion detection
* [Multimon-NG](https://github.com/EliasOenal/multimon-ng) - decodes POCSAG, etc
* [NRSC5](https://github.com/theori-io/nrsc5) - HD Radio decoder
* [SPLAT](https://www.qsl.net/kd2bd/splat.html) - RF Signal Propagation, Loss, And Terrain analysis tool for 20 MHz to 20 GHz
* [srsRAN](https://www.srsran.com/) beta
* [Universal Radio Hacker](https://github.com/jopohl/urh)
* [Wireshark](https://www.wireshark.org/) - Network Traffic Analyzer

For Raspberry Pi OS, most of the GUI applications you will find via the **SIGpi**,**Hamradio** or other menus. Many of the command line applications are accessible via the **SIGpi shell** menu. Each menu option opens up a terminal window for that application and invokes its included help info. If a command line tool does not appear in the SIGpi shell menu, not it is in located in /usr/local/bin and in PATH.
For Ubuntu, all apps will be available via Applications icon


## Package Notes

### [CubicSDR](https://github.com/cjcliffe/CubicSDR)
Cross-Platform Software-Defined Radio Application. Used with SoapySDR capable devices such as RTLSDR and HackRF. 
The RPi OS repo package is installed which is the latest version 0.2.5.More information available from the [online documentation](https://cubicsdr.readthedocs.io/en/latest/) 

### [CygnusRFI](https://github.com/0xCoto/CygnusRFI)
CygnusRFI is an easy-to-use open-source Radio Frequency Interference (RFI) analysis tool, based on Python and GNU Radio Companion (GRC) that is conveniently applicable to any ground station/radio telescope working with a GRC-supported software-defined radio (SDR). In addition to data acquisition, CygnusRFI also carries out automated analysis of the recorded data, producing a series of averaged spectra covering a wide range of frequencies of interest. CygnusRFI is built for ground station operators, radio astronomers, amateur radio operators and anyone who wishes to get an idea of how "radio-quiet" their environment is, using inexpensive instruments like SDRs.

Menu launches you into a terminal session in the CygnusRFI directory

### [DireWolf](https://github.com/wb2osz/direwolf)
DireWolf needs to be running for APRS and Packet applications to have use the AX0 interface defined in the previou section. You will need to configure your callsign, the soundcard device to use, and whether using PTT or VOX in the **/usr/local/etc/direwolf/direwolf.conf** file. The conf file itself is well documented in how to configure else consult the [DireWolf online docs](https://github.com/wb2osz/direwolf/tree/master/doc).

Because a number of factors go into a successful DireWolf setup with your transceiver, configuration discussion is deferred to the [official DireWolf documentation](https://github.com/wb2osz/direwolf/tree/master/doc).

### [Dump1090](https://github.com/antirez/dump1090)
During install you will be flashed with a message that **dump1090 can be started automatically via an init-script. Otherwise, the init-script does nothing; you must run dump1090 by hand.** Answer **no** when asked to **Start dump1090 automatically?** unless you are install the **SIGpi node** and that is your intent. Dump1090 runs a light HTTP server which could conflict with some SDR gui apps with APIs.

### [Flarq](http://www.w1hkj.com/FlarqHelpFiles/)
Fast Light Automatic Repeat reQuest is a file transfer application that is based on the ARQ specification capable capable of transmitting and receiving frames of ARQ data via FLDIGI. Program data exchange between FLARQ and FLDIGI is accomplished using a localhost socket interface. The socket interface requires that one program act as the server and the other the client. FLARQ is a client program and FLDIGI is a server program. FLARQ will not execute unless FLDIGI is already running. See the [online documentation](http://www.w1hkj.com/FlarqHelpFiles/) for more info.

### [Fldigi](http://www.w1hkj.com/FldigiHelp/index.html)
Fldigi is a modem program which supports many classic digital modes used by Amateur Radio operators today (CW, RTTY, MFSK, PSK31, and many others). It is used with a USB sound dongle as a simple two-way data modem connected to the microphone and headphone connections of an amateur radio SSB transceiver or an FM two way radio.

The RPi OS repo package is installed which is version 4.1.18 for RPi and 4.1.20 for Ubuntu 22.04. More information available from the [online documentation](http://www.w1hkj.com/FldigiHelp/index.html) For advanced RPi OS users, a build script is included to download and compile
the most recent version 4.1.20. Remove the old package then install new

```
SIGpi remove fldigi
SIGpi install fldigi4120
```

### [GNUradio ](https://github.com/gnuradio/gnuradio)
For amd64, GNUradio 3.10.5 is installed from the GNUradio repo. For arm64, GNUradio 3.9.8 is compiled from source during installation.
Have yet to identify issues in building GNUradio 3.10.X for arm64. Consult the [online documentation](https://wiki.gnuradio.org/index.php/Main_Page) for usage details.

### [JS8CALL](http://js8call.com/)
JS8Call is a derivative of the WSJT-X application, restructured and redesigned for message passing using a custom FT8 modulation called JS8. It is not supported by nor endorsed by the WSJT-X development group. Note that WSJT-X conflicts with JS8CALL given both use wsjtx-data package. It's installation will conflict with the WSJT-X application.

### [LinPAC](http://linpac.sourceforge.net/overview.php)
Packet radio terminal used for AX.25 commuications.

### [Kismet](https://www.kismetwireless.net)
When asked **Should Kismet be installed with suid-root helpers?** respond with default **yes**

### [SDRangel](https://github.com/f4exb/sdrangel)
While we have built packages from source to make the install quicker, the install script also generates the [FFTW Wisdom](http://www.fftw.org/fftw-wisdom.1.html) file. This file is invoked as a startup option in the desktop icon/file for SDRangel to make the start much quicker. The cost of this is the time it takes to generate this file during install. At least 20 minutes for RPi4 it under 2 minutes for amd64 systems.

### Xastir
Xastir is an application that provides geospatial mappng of APRS signals. It needs to configured to use the RF interface provided by DireWolf. You must start Direwolf in a separately terminal window before you start Xastir. Be sure to consult [Xastir online documentation](https://xastir.org/index.php/Main_Page) for more info.

### [Wireshark](https://www.wireshark.org)
When asked **Should non-superusers be able to capture packets?**, respond with the default **no**

### WSJT-X
Since stable arm64 and amd64 packages are available from the WSJTX team, we opted to add WSJTX back in. Reminder, WSJT-X does not like being installed with JS8CALL given their common use of wsjtx-data package.

### LimeSDR Suite
Features enabled/disabled on RPi4 install
```
-- ######################################################
-- ## LimeSuite enabled features
-- ######################################################
-- 
 * LimeSuiteHeaders, The lime suite headers
 * LimeSuiteLibrary, The lime suite library
 * ConnectionFX3, FX3 Connection support
 * ConnectionFTDI, FTDI Connection support
 * ConnectionXillybus, PCIE Xillybus Connection support
 * LimeSuiteGUI, GUI Application for LimeSuite
 * LimeSuiteExamples, LimeSuite library API examples
 * LimeRFE, LimeRFE support
 * LimeUtilCommand, Command line device discovery utility
 * LimeQuickTest, LimeSDR-QuickTest Utility
 * LimeSuiteDesktop, LimeSuite freedesktop integration
 * LimeSuiteOctave, LimeSuite Octave integration

-- ######################################################
-- ## LimeSuite disabled features
-- ######################################################
-- 
 * ConnectionEVB7COM, EVB+COM Connection support
 * ConnectionSTREAM_UNITE, STREAM+UNITE Connection support
 * ConnectionRemote, Remote Connection support for testing
 * ConnectionSPI, Rasp Pi 3 SPI Connection support10
 * SoapySDRLMS7, SoapySDR bindings for LMS7
 * LimeSuiteDocAPI, LMS API Doxygen documentation

-- Install prefix: /usr/local
-- Build timestamp: 2021-12-31
-- Lime Suite version: 20.10.0-g1480bfea
-- ABI/so version: 20.10-1
-- Configuring done
-- Generating done
-- Build files have been written to: /home/pi/SIG/source/LimeSuite/build-dir
```

### SoapySDR
Features enabled/disabled on RPi4 install
```
-- ######################################################
-- ## SoapySDR enabled features
-- ######################################################
-- 
 * Library, runtime library v0.8.1-g6f97389b
 * Apps, command line applications
 * Tests, library unit tests
 * Docs, doxygen documentation
 * Python, python bindings v2.7.18
 * Python3, python3 bindings

-- ######################################################
-- ## SoapySDR disabled features
-- ######################################################
-- 

-- SoapySDR version: v0.8.1-g6f97389b
-- ABI/so version: v0.8
-- Install prefix: /usr/local
-- Configuring done
-- Generating done
-- Build files have been written to: /home/pi/SIG/source/SoapySDR/build

######################################################
##     Soapy SDR -- the SDR abstraction library     ##
######################################################

Lib Version: v0.8.1-g6f97389b
API Version: v0.8.0
ABI Version: v0.8
Install root: /usr/local
Search path:  /usr/local/lib/SoapySDR/modules0.8 (missing)
No modules found!
Available factories... No factories found!
Available converters...
 -  CF32 -> [CF32, CS16, CS8, CU16, CU8]
 -  CS16 -> [CF32, CS16, CS8, CU16, CU8]
 -  CS32 -> [CS32]
 -   CS8 -> [CF32, CS16, CS8, CU16, CU8]
 -  CU16 -> [CF32, CS16, CS8]
 -   CU8 -> [CF32, CS16, CS8]
 -   F32 -> [F32, S16, S8, U16, U8]
 -   S16 -> [F32, S16, S8, U16, U8]
 -   S32 -> [S32]
 -    S8 -> [F32, S16, S8, U16, U8]
 -   U16 -> [F32, S16, S8]
 -    U8 -> [F32, S16, S8]
```

### HamLib 4.5.X
Features enabled in RPi4 build
```
----------------------------------------------------------------------

 Hamlib Version 4.5.4 configuration:

 Prefix 	/usr/local
 Preprocessor	gcc -E 
 C Compiler	gcc -g -O2 
 C++ Compiler	g++ -std=c++11 -g -O2

 Package features:
    With C++ binding		    yes
    With Perl binding		    no
    With Python binding 	    no
    With TCL binding		    no
    With Lua binding		    no
    With rigmem XML support	    no
    With Readline support	    yes
    With INDI support		    no

    Enable HTML rig feature matrix  no
    Enable WinRadio		    yes
    Enable Parallel		    yes
    Enable USRP 		    no
    Enable USB backends 	    yes
    Enable shared libs		    yes
    Enable static libs		    yes

-----------------------------------------------------------------------

```


## APRS and Packet using a VHF/UHF Transceiver
SDRangel and other SDR applications have the capability to decode APRS and Packet Radio signals and transmit at given TX capable supported and attached devices. If you have an Amateur Radio license and aspire to operate serious distance including satellites then you will need VHF/UHF transceiver capable of 5 watts for the latter interfacing to the transceiver through audio and radio control via Hamlib.

In the past dedicated hardware known as TNCs (terminal node controllers) was used between a computer and transceiver. But the signals themselves are audio so TNCs were replaced with software and soundcards connected to the transceiver. For this build DireWolf is the software replacing the TNC and AX.25 software providing the data-link layer above it that provides sockets to it.

If you are planning to operate APRS and Packet Radio with a transceiver then configuring DireWolf and AX.25 is necessary. Otherwise you can skip the subsections. 


### AX.25
If you intend to transmit, you will need to edit **axports** and change to your licensed Amateur Radio callsign

```
sudo nano /etc/ax25/axports
```

- Change **N0CALL** to your callsign followed by a hyphen and a number 1 to 15. (For Example  N0CALL-3)

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

## Advanced Topics

### Server Setup

An SDR connected to a headless server running software accessed/managed by command line or a network accessible
API interface. **Server Install** can be performed on **Raspberry Pi3/4 B+** with 32GB microSD card running **Raspberry Pi OS Lite (Bullseye or Bookworm) (64-bit)**. Server install gives the option to run RTL_TCP, SoapySDR, or SDRangel-server on startup. Run the following command to create a server

```
./SIGpi setup server
```

During setup you will have the option to run either RTL-TCP, SDRangel Server, or SoapySDR server on startup or choose not to start any of them. After setup system will reboot.

### SIGpi Build

Users skilled at compiling applications have the option of building and installing some packages from source. If you already
installed the application you need to remove it first. For example:

```
SIGpi purge [PACKAGE]
SIGpi build [PACKAGE]
```
The build option will clone the source code into a new directory under /home/pi/SIG/source and build a Debian package (.deb) in the build directory within that cloned directory. From there you can install the Debian pacakge

```
sudo dpkg -i <PACKAGE>
```

## Developer Notes

### Debian Packages
To speed up installation, beginning in SIGpi 6.X we started building our own aarch64 and amd64 Debian packages for select software when the latest packages are not available from Ubuntu or Raspberry Pi OS.

We began with SDRangel for aarch64 (RPi) and slowly adding packages alopng the was. The debian packages we install can be found in **~/SIG/SIGpi/debs**. They are built to be SIGpi independent so as long as your particualr build has the dependencies installed, these packages should install normally with **sudo dpkg -i <package-name>**. 

For SDR software we only compile the packages to support RTL-SDR, HackRF, PlutoSDR, LimeSuite and SDRplay. For other SDR you can recompile - see next section.

### Building and/or Installing Packeges
If our packages do not support your SDR device, you can install SDR drivers per your device's instructions and comile a new version. Using SDRangel as an example you would first remove SDRangel if already installed and then compile and install a new SDRangel build as follows:

```
SIGpi remove sdrangel
SIGpi build sdrangel
```

For **build** what happens is SDRangel git repo is cloned into **~/SIG/source** then compiled into **~/SIG/source/<package>/build**. The debian package is created there using [checkinstall ](https://help.ubuntu.com/community/CheckInstall) and installed. A copy of the Debian package is then made available in **~/SIG/SIGpi/debs**. 

If you just wanted to create a Debian package of SDRangel and not install it, the second command would instead be:

```
SIGpi package sdrangel
```

For **package** git repo is cloned into **~/SIG/source** then compiled into **~/SIG/source/<package>/build**. The debian package is created there using [checkinstall ](https://help.ubuntu.com/community/CheckInstall) copied to **~/SIG/SIGpi/debs**. 


### Desktop Environments
For the Raspberry Pi OS desktop environment, we have tried to curate the GUI and command line applications into menus and submenus. Where an application
appears missing you should be able to run from the terminal windows as pi user. For Ubuntu 22.04 som apps have been added as favorites yet all will be available via the Applications icon on the lower left. Also for Ubuntu 22.04 desktop, the SIGIwiki and SIGpi icons will show red circled X on them. This is Ubuntu being secure with the desktop. Just right-click each icon and set them for **Allow Launching**

### Streaming Audio

Perhaps you want to remotely connect to your SIGpi box and listen from a more comfortable location. VNC which is included will let you remotely see and touch but not hear audio. For audio we configure via **Preferences > PulseAudio Preferences** in the Network Access and Network Server tabs. In Network Access check the first box and in Network Server check the first four boxes.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the documentation on their respective sites

