# SIGpi

## Introduction

SIGpi is a "go-kit" for Signal Intelligence (SIGINT) enthusiasts with capabilities in the HF, VHF, UHF, and SHF spectrum. It includes a framework for simple installation and management of popular SIGINT applications and devices building/installing SIGINT tools on the following platforms:

**Full Install**
- Ubuntu 24.04 LTS (64-bit) on Intel or Raspberry Pi 4/5
- 4GB RAM, 32GB storage

**Server Only**
- Ubuntu 24.04 LTS (64-bit) on Intel or Raspberry Pi 3/4/5

The [wiki](https://github.com/joecupano/SIGpi/wiki) goes deep on all things SIGpi.

## Setup

- Login as pi or sudo user on supported platform
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

Run the following command from **$HOME/SIG/SIGpi** to install 

```
./SIGpi setup standard
```

## Adding Devices

Once started you will be given a menu of devices you can choose to install with RTLSDR and HackRF selected as default. Select the additional devices you would like to install and then click **OK**. For the next 15 to 20 minutes you will see messages scroll by as the SIGpi platform components are installed

After setup the system will reboot.

Don't worry about missing a device. Post install you can add it using **SIGpi device install <DEVICE>**

## Adding Packages

Once setup, you can list the inventory of packages SIGpi includes as well as those already installed with the following

```
SIGpi list library
```

Note that **./** is no longer required for the SIGpi command after setup. An **asterisk** in the INSTALLED column indicates that package is already installed while those without asterisks 
have not been installed. For example, you will see **SDRangel** has not been installed. You can do so with the following

```
SIGpi install sdrangel
```

Go back and list again to install other packages of interest

## Managing Packages

Packages can be installed, removed and purged using the following commands respectively

```
SIGpi install <package>
SIGpi remove <package>
SIGpi purge <package>
```

Periodically new applications will be added to SIGpiand notifications sent to those watching the repo. To add applcations available for install into your SIGpi instance simple run run the following from within your /home/pi/SIG/SIGpi directory

```
git pull
```

You will see the new applications as available running the list library command

```
SIGpi list library
```

You can update packages in your existing SIGpi install. For example, if there is a  **SDRangel** update you can run

```
SIGpi update sdrangel

Update 7.22.123 is available

SIGpi upgrade sdrangel
```

## Server-only Setup

SIGpi includes a headless server option. From a fresh **Ubuntu 24.04 LTS server** install run the following

```
./SIGpi setup server
```

During setup you will have the option to run either **RTL-TCP, SDRangel Server, or SoapySDR server** on startup or choose not to start any of them. After setup system will reboot.

## Example Hardware Setup
![alt-test](https://github.com/joecupano/SIGpi/blob/main/backgrounds/SIGpi_architecture.png)

### Power
In this setup a 12V@17A switching supply powers all the kit. Since RPi4 are picky about getting 5.1V a set-up converter is added to power it. A 12V Rpi4 are picky about getting 5.1V. USB peripherals can be hungry so a powered USB hub is included. While 7 ports are available no more than three devices requiring power should be enabled since hub produces a maximum of 36 Watts ( 3 x 5V x 2.4A = 36 Watts)

### Raspberry RPi4/5
Since this is a SIGINT platform we do not want to be generating any RF so onboard Bluetooth and WiFi should be disabled. If Internet is needed and only available via WiFi then so be it and use your onboard WiFi.

### USB Peripherals
Only three USB devices requiring power should be enabled at a time. The range of devices depicted is only to demonstrate what you could potentially connect to it.

