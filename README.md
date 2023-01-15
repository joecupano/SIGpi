# SIGpi

DEVELOP 6.X


## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install. This (bash) shell script builds SIGINT tools on the following platforms:

- **Raspberry Pi4 4GB RAM** or **Raspberry Pi 400** with 32GB microSD card running **Raspberry Pi OS Full (64-bit)**
- **Ubuntu 22.04 LTS** on arm64 and amd64

A headless server only install (Node Install) can be performed on **Raspberry Pi3 B+** with 32GB microSD card running **Raspberry Pi OS Full (64-bit)**

Be sure to check the [wiki](https://github.com/joecupano/SIGpi/wiki)

## Installation

- Login as pi or sudo user on supported platform
- Update and install pre-requisite packages to install SIGpi

```
sudo apt update && sudo apt upgrade
sudo apt-get install -y build-essential cmake git
```

- From your home directory, create a directory called SIG and switch into it

```
mkdir ~/SIG && cd ~/SIG
```

- Clone the SIGpi repo

```
git clone https://github.com/joecupano/SIGpi.git
```

- Change into the new SIGpi directory and run **SIGpi_installer.sh**  (Node install run **SIGpi_installer.sh node** )


```
cd SIGpi
./SIGpi_installer.sh
```

## Features

### Headless Servers (Node Install)
This is for headless SDR servers requiring no desktop. This will install RTLTCP, SoapySDRServer, and SDRangelsrv

### Upgrade with modules, not fresh images
SIGpi includes it's own package manager to update applications to their latest releases using familiar syntax from package management systems

```
Usage: sigpi [ACTION] [TARGET]
          ACTION  
                 install   install TARGET from current release
                 remove    remove installed TARGET
                 purge     remove installed TARGET and purge configs
                 update    check to see if new TARGET available
                 upgrade   upgrade TARGET to latest release

          TARGET
                 A SIGpi package
```

You can update packages in your existing SIGpi install with the following commands using **SDRangel** and **SDR++** as examples:

```
SIGpi purge sdrangel
SIGpi install sdrangel
SIGpi purge sdrpp
SIGpi install sdrpp
```

### Add/Remove Packages anytime
Perhaps you forgot to add an application during your initial run of SIGpi_installer or there is a new software release available of SDRangel. SIGpi includes its own package management tool for software it supports using similar syntax distro package managers like APT (install, remove, purge, update, upgrade.)

Example
```
SIGpi install gqrx
```

### Package Updates
Best efforts made to update releases when significant releases (X.Y) are made available for component packages with speciall attention to popular SDR packages like SDRangel and SDR++


### Multi-Architecture
Though our first priority of support platforms is the **Raspberry Pi4 4GB RAM** running **Raspberry Pi OS Full (64-bit)**, this build will install and run on **Ubuntu 20.04 LTS** and **Ubuntu 22.04 LTS** (amd64 and aarch64)

### Amateur Radio is nice but we are SIGINT FOCUSED
While tools are included for Amateur Radio, it is not this builds focus. We are focused on the ability to detect and decipher the range of RF signals around us from consumer IoT to critical infrastructure for educational purposes and provide tools to assist those with spectrum planning responsibiity to better visualize spectrum utilization around them.


## Release Notes
* [over here](RELEASE_NOTES.md)


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

## WSJT-X ... well
Since stable arm64 and amd64 packages are available from the WSJTX team, we opted to add WSJTX back in.
Remonder, WSJT-X does not like being installed with JS8CALL given its use of wsjtx-data package.

## Example Hardware Setup
![alt-test](https://github.com/joecupano/SIGpi/blob/main/backgrounds/SIGpi_architecture.png)

### Power
In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are pickya bout getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry RPi4
Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals
Only three USB devices requiring power should be enabled at a time. The range of devices depicted is only to demonstrate what you could potentially connect to it.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the documentation on their respective sites
