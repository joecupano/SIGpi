# SIGpi

RELEASE 7.0

## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with capabilities in the HF, VHF, UHF, and SHF spectrum. It includes a framework for simple installation and management of popular SIGINT appliucations and devices made mostly from bash scripts building/installing SIGINT tools on the following platforms:

- **Raspberry Pi4 4GB RAM** or **Raspberry Pi 400** with 32GB microSD card running **Raspberry Pi OS "Bullseye" or "Bookworm" Full (64-bit)**
- ARM64 or AMD64 platforms with 4GB RAM and 32GB storage minimum runniing **Ubuntu 22.04 LTS**

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

You can update packages in your existing SIGpi install. For example, Is there a  **SDRangel** update. If so install it:

```
SIGpi update sdrangel

Update 7.17.4 is available

SIGpi upgrade sdrangel
```

You can add/remove Packages anytime

```
SIGpi install audacity
SIGpi remove audacity
```

## Example Hardware Setup
![alt-test](https://github.com/joecupano/SIGpi/blob/main/backgrounds/SIGpi_architecture.png)

### Power
In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are pickya bout getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry RPi4
Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals
Only three USB devices requiring power should be enabled at a time. The range of devices depicted is only to demonstrate what you could potentially connect to it.

## What Else
Check out the [wiki](https://github.com/joecupano/SIGpi/wiki)
