# Release Notes

## Release 6.X: 2023-02-03
- Rollback aarch64 to GNUradio 3.9.8 given unresolved issue with 3.10.5 compile
- BladeRF support added
- SDRPlay support added
- SDRangel 7.9.0 release 
- Universal Radio Hacker added
- bettercap added
- Beta of srsRAN

## Release 6.0.2: 2023-01-15
- Maintenance Release
- Ensure proper version of SDRangel is reflected (SDRangel 7.8.5)

## Release 6.0.1: 2023-01-12
- Maintenance Release
- Fixes for Ubuntu 22.04 LTS install
- Fix for WSJTX install (all platforms)

## Release 6.0: 2023-01-08
- Deprecating 32-bit OS support
- Deprecating RPi Hardware support to only Raspberry Pi 4B and Raspberry Pi 400
- Support for Ubuntu 22.04 on amd64 and arm64
- Node Install (headless server) support continued for RPi 3B+
- GNUradio 3.8 and 3.9 deprecated for GNUradio 3.10.X
- Created DEB packages for software with long compile times (SDRangel, SDR++, HamLib)
- SDRangel updated to v7.8.5
- SDR++ updated to 1.1.0
- Hamlib updated to 4.5.3
- WSJT-X 2.6.0 added
- Install DOSbox

## Release 5.3: 2022-06-25
- Fix SDRangel package installer
- Fix cm256cc error (related to SDRangel)
- Fix Qt5WebEngine install
- Fix multiple Desktop icons

## Release 5.2.2: 2022-05-30
- SDRangel updated to v7.3.0

## Release 5.2.1: 2022-05-26
- SDRangel updated to v7.2.1

## Release 5.2: 2022-05-20
- Add Virtual Audio Cable (sink) support. PAVUcontrol install is mandatory and not a install menu option
- SDRangel updated to v7.0.1
- GNUradio 3.10 install option added

## Release 5.1.1: 2022-03-30
- Maintenance Release
- SDRangel updated to v6.20.2

## Release 5.1: 2022-03-13
- Fix: Server menu option from checklist to radiolist
- SDR++ updated to v1.0.4
- SDRangel updated to v6.20.1

## Release 5.0: 2022-01-07
- Add **server** install option with choice of SoapySDR, RTLSDR< or SDRangel servers
- Add **Inspectrum** analysis tool

## Release 4.2: 2022-01-01  (Pre 5.0)
- Build installs on RPi Full OS Bullseye 32 and 64 bit)
- Build installs on Ubuntu 20.04 LTS (x86, x86_64, aarch64)
- Add **base** install option which install devices and minimal apps (rtl_433, dump1090, GQRX, CubicSDR)
- Remove **SIG_popper** and **SIG_pusher** and replace with **SIGpi (action) (package)**
- Remove **Artemis** given repeated issues
- Implement SIGpi package management system for install, remove, purge, update, upgrade packages post first time install

## Release 4.1: 2021-12-12
- Fixed RadioSonde install
- Artemis install broken for RPi for now
- Post install can pop (remove) and push (install) SIGpi Packages using SIGpi_popper and SIGPi_pusher scripts

## Release 4.0: 2021-11-27
- Implemente SIGprojects software architecture model
- Updated to SDRangel 6.17.4 and SDR++ 1.0.5
- Added Ettus Research UHD device install script
- Added Artemis, CygnusRFI, JS8CALL, GNuradio 3.8 (repo) and 3.9 (compiled) options
- Added HASviolet (Delaware Release)
- Added ability to **push** and **pop** SIGpi packages post-install

## Release 3.1: 2021-11-25
- Fixes from Bullseye update

## Release 3.0.1: 2021-10-24
- Set SDRangel build from a360ea0a9 due to SDRgui compile issue
- Remmoved Artemis due to build issues
- Moved Amateur Radio apps from SigPI menu to Hamradio menu

## Release 3.0: 2021-10-22
- New install script architecture
- Added SDR++ and Artemis
- Standardize on GNU Radio 3.8
- Add RadioSonde (decoder/encoder used in Balloon telemetry projects)

## Release 2.1: 2021-10-16
- Various fixes as part of merging code with [SIGbox](https://github.com/joecupano/SIGbox)
- SIGpi_update deprecated. This version required to be fresh install

## Release 2.0: 2021-10-02
- Update install script to be TUI-based using Whiptail-based
- Update GNUradio from 3.7 to 3.8
- Add the following digital decoder libraries/tools
-- aptdec, CM265cc, LibDAB, MBElib, SerialDV, DSDcc, SGP4, LibSigMF, Liquid-DSP, Multimon-ng, Bluetooth Baseband Library 
- Option to install latest-compiled versions of Amateur Radio Applications
-- Fldigi 4.1.20 (and suite), WSJT-X 2.4.0, QSSTV 9.5.8
- Install the following software 
-- Ubertooth Tools
-- RTL_433
- Optional install the following software 
-- SPLAT
-- Wireshark
-- Kismet
-- TEMPEST for Eliza

## Release 1.0: 2021-09-15
- Initial Release


