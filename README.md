# SIGpi

RELEASE 5.1.1

## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install. This (bash) shell script builds SIGINT tools on the following:

- **Raspberry Pi4 4GB RAM** with 32GB microSD card running **Raspberry Pi OS Full (32 or 64-bit)**
- **Ubuntu 20.04 LTS** on amd64 and aarch64

Be sure to check the [wiki](https://github.com/joecupano/SIGpi/wiki)

## Release Notes
* [over here](RELEASE_NOTES.md)

## Installation

### Fresh Full Install

- Login as Pi on your **fresh install of Raspberry Pi OS Full**
- Create a directory in your home directory called SIG and switch into it
- Clone the SIGpi repo
- Run **SIGpi_installer.sh**
- Follow script instructions.

```
sudo apt-get install -y build-essential cmake git
mkdir ~/SIG && cd ~/SIG
git clone https://github.com/joecupano/SIGpi.git
cd SIGpi
./SIGpi_installer.sh
```

### Fresh Bare Install

Follow the same instructions as for the impatient but add **base* as an option

```
./SIGpi_installer.sh base
```
This will install bare minimum software to enjoy receiving signals

- RTLSDR
- HackRF
- LimeSDR
- rtl_433
- dump1090
- GQRX
- CubicSDR

### Update an Existing 5.0 Install

This is a maintenance release. You can update your existing 5.0 install with the following commands:

```
SIGpi purge sdrangel
SIGpi install sdrangel
SIGpi purge sdrpp
SIGpi install sdrpp
```

## Features

### Current or -1 Releases
We make best effort to include the most recent releases of popular packages and include tools to update your install

### Installs and Updates
Perhaps you forgot to add an application during your initial run of SIGpi_installer or there is a new software release available of SDRangel. SIGpi includes its own package management tool for software it supports using similar syntax distro package managers like APT (install, remove, purge, update, upgrade.)

Example
```
SIGpi install gqrx
```

### Multi-Architecture
Though our first priority of support platforms is the **Raspberry Pi4 4GB RAM** running **Raspberry Pi OS Full (64-bit)**, this build will install and run on the following:

- Raspberry Pi4 4GB RAM running Raspberry Pi OS Full (32-bit)
- Ubuntu 20.04 LTS (x86, x86_64, aarch64)

### Amateur Radio is nice but we are SIGINT FOCUSED

While tools are included for Amateur Radio, it is not this builds focus. We are focused on the ability to detect and decipher the range of RF signals around us from consumer IoT to critical infrastructure for educational purposes and provide tools to assist those with spectrum planning responsibiity to better visualize spectrum utilization around them.

## Build Details

Total install time will take over three hours because of compile times for vairous components indicates below with an asterisk (*). SDRangel and its dependencies will use half of the time to compile - be patient.

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

## WSJT-X ... not
As quoted from the [WSJT-site](https://www.physics.princeton.edu/pulsar/k1jt/wsjtx.html) 

"Note: these packages are unlikely to install properly on Linux distributions with required dependencies at lower versions than those on the named distributions. In such cases building from source is the correct way to install WSJT-X."

So we go ahead an build from source and notice it wants to be a snowflake and compile and install its own Hamlib build because of two patches not accepted by Hamlib maintainers. Nevermind how long WSJT-X takes to compile. Since we are SIGINT first we decided to drop WSJT-X this release and let JS8CALL perform said duties. BTW, WSJT-X does not like being installed with JS8CALL given its use of wsjtx-data package.

## Example Hardware Setup

![alt-test](https://github.com/joecupano/SIGpi/blob/main/backgrounds/SIGpi_architecture.png)

### Power

In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are pickya bout getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry Pi4

Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals

Only three USB devices requiring power should be enabled at a time. The range of devices depicted is only to demonstrate what you could potentially connect to it.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the documentation on their respective sites
