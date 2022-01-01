# SIGpi Developer Notes

Release: 20211218-0500

## Introduction

SIGpi is a Signal Intelligence (SIGINT) platform that delivers a range of well known software tools for use with well known software-defined and software-controlled radios. Special emphais is given to complex signals from VHF, UHF, and SHF.

## Focus

2021 saw a number of updates to the Raspberry Pi ecosystem with  the switch to Raspberry Pi OS, 64-bit desktop, and the "Bullseye" release forcing many RF projects to evolve or die.



- [Raspberry Pi 4 4GB Model B ](https://www.amazon.com/CanaKit-Raspberry-4GB-Starter-Kit/dp/B07V5JTMV9) minimum
- [32GB microSDHC card Class 10](https://www.amazon.com/gp/product/B06XWN9Q99)
- [Raspberry Pi OS Full "Bullseye" 32 bit](https://www.raspberrypi.com/software/) or [64 Bit](https://downloads.raspberrypi.org/raspios_arm64/images/raspios_arm64-2021-11-08/)

### How about other architectures?
There is also a build script for Ubuntu 20.04 LTS Desktop at [SIGbox repo](https://github.com/joecupano/SIGbox)

## Hamlib 4.4 Notes

Following library features are enabled with aarch64 build

```
----------------------------------------------------------------------

 Hamlib Version 4.4 configuration:

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
    Enable USRP 		    no
    Enable USB backends 	    yes
    Enable shared libs		    yes
    Enable static libs		    yes

-----------------------------------------------------------------------
```
