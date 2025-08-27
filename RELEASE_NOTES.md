# Release Notes

## Release 8.0: 2025-08-30
- Major Release
- Bullseye and Ubuntu 22.04 LTS amd64 deprecated, rebuild on bookworm and Ubuntu 24.04 LTS amd64

## Release 7.0: 2024-01-15
- Major Release. See [wiki](https://github.com/joecupano/SIGpi/wiki)

## Release 6.7: 2023-12-30
- Maintenance Release
- SDRangel 7.17.2 update

## Release 6.6: 2023-11-1
- SDRangel 7.17.0 update
- DireWolf 1.7 update

## Release 6.5.1: 2023-10-22
- Fix release
- Install script bug
- Fix SDRangel 7.16.0 packages (Desktop and Server)

## Release 6.5: 2023-09-24
- Updates to SIGpi package management
- SIGpi build option puts create Debian packages in /home/pi/SIG/SIGpi/debs
- SIGpi_installer updated to include Ubuntu 22.04 on RPi4 (Pre-Release)
- SDRangel 7.16.0 Update (Desktop and Server)

## Release 6.4: 2023-09-04
- Enable Swapspace for faster install
- Python2 reference removal cleanup
- RTLSDR v4 support
- Moved PlutoSDR from core device install to optional
- GNUradio cleamnup (3.9.80 for RPi, 3.10.7 for x86-64)
- Block JS8 install if WSJTX installed due to library conflicts
- SDRangel 7.15.4 Update (Desktop and Server)
- FLdigi 4.1.27 update
- FLrig 2.0.03 update
- Add ZeroTier network package as CMDline install

## Release 6.3: 2023-08-28
- Add tools for FFT GPU tools for experimentation (VkFFT GPU FFT library)
- Add Vulkan drivers to core dependencies
- FFTW-Wisdom now its own package and not bundled under SDRangel
- Publish SIGpi Base install option (SDR device drivers, CMDline tools, DireWolf for APRS)
- SDRangel 7.15.3 Release

## Release 6.2.6: 2023-08-07
- Maintenance Release
- SDRangel 7.15.2 Release

## Release 6.2.5: 2023-06-19
- Maintenance Release
- SDRangel 7.15.0 Release
- WSJT-X 2.6.1 Release

## Release 6.2.4: 2023-05-26
- Maintenance Release
- SDRangel 7.14.1 Release

## Release 6.2.3: 2023-04-29
- Maintenance Release
- SDRangel 7.13.0 Release

## Release 6.2.2: 2023-04-07
- Maintenance Release
- SDRangel 7.12.0 Release
- Hamlib 4.5.5 Release

## Release 6.2.1: 2023-03-20
- Feature Release
- SDRangel 7.11.0 release
- Adding SIGpi **build** option to various packages (see [wiki](https://github.com/joecupano/SIGpi/wiki))

## Release 6.2: 2023-03-02
- Maintenance Release
- Syntax errors SIGpi.sh
- Add comments within pkg scripts
- SIGpi Node SDRangel server config fix
- Add SigDigger digtal signal analyzer

## Release 6.1.1: 2023-02-08
- Maintenance Release
- Syntax errors in install menu
- SDRPlay. Fix library install script
- Fix SDRangel 7.9.0 version install on amd64
- Fix GNUradio 3.9.8 (arm64) compile issue dependency change
- Fix Hamlib 4.5.4 install
- Add reminder in install menu that srsRAN is for amd64 only

## Release 6.1: 2023-02-03
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


