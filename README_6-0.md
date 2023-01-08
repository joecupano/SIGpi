# SIGpi

RELEASE 6.0


## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included.

SIGpi is available as a distro image for the **Raspberry Pi4 (4GB or 8GB RAM** and **Raspberry Pi RPi 400** platforms running **Raspberry Pi OS (64-bit)** 
with 32GB microSD card recommended. It is also available as (Bash) scripted install on same platforms plus the following

- **Ubuntu 20.04 LTS or 22.04** on aarch64
- **Ubuntu 20.04 LTS or 22.04** on amd64

A headless SDR server option is available. It can be installed on the same platforms or the **Raspberry Pi3 B+** with 16GB microSD card running **Raspberry Pi OS Lite (64-bit)**

Be sure to check the [wiki](https://github.com/joecupano/SIGpi/wiki) for further information

## Scripted Installation
- Login as pi or sudo user on supported platform
- Create a directory in your home directory called SIG and switch into it
- Clone the SIGpi repo
- Run **SIGpi_installer.sh**
- Run following commands then follow script instructions

```
sudo apt-get install -y build-essential cmake git
mkdir ~/SIG && cd ~/SIG
git clone https://github.com/joecupano/SIGpi.git
cd SIGpi
./SIGpi_installer.sh
```

### Headless SDR Server
Follow the same instructions as for Full Install but add **node* as an option to last command

```
./SIGpi_installer.sh node
```
This will install RTLTCP, SoapySDRServer, and SDRangelsrv

### Update Packages on existing 5.X Install
You can update packages in your existing 5.X install with the following commands using **SDRangel** and **SDR++** as examples:

```
SIGpi purge sdrangel
SIGpi install sdrangel
SIGpi purge sdrpp
SIGpi install sdrpp
```

### Scripted Installation Details

Total install time for full install will take over three hours because of compile times for SDRangel and its components using
half of that - be patient. Of course you can go with the disSDRangel-7.3.0-SIGpi_RPi4.tar.gztro instead.

## Features

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
### Package Updates
Best efforts made to update releases when significant releases are made availabel for component packages, Especiallly for popular SDR packages such as SDRangel and SDR++

### Add/Remove Packages anytime
Perhaps you forgot to add an application during your initial run of SIGpi_installer or there is a new software release available of SDRangel. SIGpi includes its own package management tool for software it supports using similar syntax distro package managers like APT (install, remove, purge, update, upgrade.)

Example
```
SIGpi install gqrx
```
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

## WSJT-X ... not
As quoted from the [WSJT-site](https://www.physics.princeton.edu/pulsar/k1jt/wsjtx.html) 

"Note: these packages are unlikely to install properly on Linux distributions with required dependencies at lower versions than those on the named distributions. In such cases building from source is the correct way to install WSJT-X."

So we go ahead and build from source and notice it wants to be a snowflake and compile and install its own Hamlib build because of two patches not accepted by Hamlib maintainers. Nevermind how long WSJT-X takes to compile. Since we are SIGINT first we decided to drop WSJT-X this release and let JS8CALL perform said duties. BTW, WSJT-X does not like being installed with JS8CALL given its use of wsjtx-data package.

## Example Hardware Setup
![alt-test](https://github.com/joecupano/SIGpi/blob/main/backgrounds/SIGpi_architecture.png)

### Power
In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are pickya bout getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry Pi
Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals
Only three USB devices requiring power should be enabled at a time. The range of devices depicted is only to demonstrate what you could potentially connect to it.

## What Else
Yes, I know there are more apps installed. There is no short-cut and must defer you to the documentation on their respective sites
