# SIGpi

RELEASE 6.2.23

## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with emphasis on capabilities in the VHF, UHF, and SHF spectrum. For completeness, HF spectrum related software is included for optional install. This (bash) shell script builds SIGINT tools on the following platforms:

- **Raspberry Pi4 4GB RAM** or **Raspberry Pi 400** with 32GB microSD card running **Raspberry Pi OS Full (64-bit)**
- **Ubuntu 22.04 LTS** on arm64 and amd64

A headless server aka **Node Install** can be built on a minimum of a **Raspberry Pi3 B+** with 32GB microSD card running **Raspberry Pi OS Lite (64-bit)** or **Ubuntu 22.04 LTS Server**


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

You can update packages in your existing SIGpi install with the following commands using **SDRangel** and **SDR++** as examples:

```
SIGpi upgrade sdrangel
SIGpi upgrade sdrpp
```

### Add/Remove Packages anytime
Perhaps you forgot to add an application during your initial run of SIGpi_installer or there is a new software release available of SDRangel. **SIGpi** includes its own application management system akin to OS package management systems like APT. The difference is sigpi manages
applications whether they are from the distro releases or compiled from other repos such as Github. This enables you to just install the **base** system and go back and add inidividual applications. sigpi can periodically be run to check on availability of new applications and upgrade them.
```
 Usage:    SIGpi [ACTION] [TARGET]

        ACTION  
                 install   install TARGET application from current release
                 remove    remove installed TARGET application
                 purge     remove installed TARGET application and purge configs
                 update    check to see if new TARGET application available
                 upgrade   upgrade TARGET application to latest release
                 shell     wrap SIGpi environment variables around a TARGET script

        TARGET
                 A SIGpi package or script
```
Example
```
SIGpi install kismet
```

### Package Updates
Best efforts made to update releases when significant releases (X.Y) are made available for component packages with speciall attention to popular SDR packages like SDRangel and SDR++

### Multi-Architecture
Though our first priority of support platforms is the **Raspberry Pi4 4GB RAM** running **Raspberry Pi OS Full (64-bit)**, this build will install and run on **Ubuntu 22.04 LTS** (amd64 and aarch64)

### Amateur Radio
While tools are included for Amateur Radio, it is not this builds focus. We are focused on the ability to detect and decipher the range of RF signals around us from consumer IoT to critical infrastructure for educational purposes and provide tools to assist those with spectrum planning responsibiity to better visualize spectrum utilization around them.


## Installation

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

### Full Installation

This is the full desktop installation. Run the following command:

```
./SIGpi_installer.sh
```

### Node Installation

A node is an SDR connected to a headless server running software accessed/managed by command line or a network accessible
API interface. **Node Install** can be performed on **Raspberry Pi3/4 B+** with 32GB microSD card running **Raspberry Pi OS LiteFull (64-bit)**
SIGpi Node install gives the option to run RTL_TCP, SoapySDR, or SDRangel-server on startup. Run the following command to create a node

```
./SIGpi_installer.sh node
```

During installation you will have the option to run either RTL-TCP, SDRangel Server, or SoapySDR server on startup or choose not to start 
any of them. 


## Release Notes
* [over here](RELEASE_NOTES.md)



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
