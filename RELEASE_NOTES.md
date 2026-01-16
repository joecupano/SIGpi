# Release Notes - SIGpi Changes

## Overview
This document describes the major changes and improvements between the develop and main branches of SIGpi.

## Major Features & Improvements

### Application Management
- **New Applications Management Menu**: Added new menu system for managing applications
- **Applications Management Framework**: Enhanced the installation and management of SIGpi applications

### Device & Package Reorganization
- **Restructured Device Organization**: Moved several device packages to a more organized structure
  - BladeRF, HackRF, and UberTooth devices now available in packages directory
  - LimeSDR and libmirisdr moved to packages for improved accessibility
  
- **Deprecated Device Drivers**: 
  - Moved legacy device packages to deprecated section for cleaner main package list
  - Includes: Splat, ZeroTier, and older device drivers

### Development Package Updates
- **New Development Tools Available**:
  - Evil Crow RF v2 driver
  - SDRangel with qmake6 support
  - Ettus USRP support
  - Fobos SDR support
  - SigDigger updates

### Updated & Enhanced Packages

#### Radio Applications
- **SDR++**: Updated to version 1.2.1
- **SDRangel**: Updated to version 7.22.10 with improved AMD64 support
- **GQRX, QSSTV, JS8Call**: Updated with latest features and bug fixes

#### Utilities
- **Kismet**: Enhanced version with improved wireless monitoring
- **MultiMon-NG**: Updated monitoring capabilities
- **RTL_433**: Enhanced radio frequency signal monitoring
- **Direwolf**: AX.25 packet radio improvements

#### Development Tools
- **Go Language**: Updated to version 1.23 (required for bettercap)
- **URH (Universal Radio Hacker)**: Updated with latest analysis capabilities
- **Wireshark**: Enhanced packet analysis features
- **SigUtils**: Improved signal processing utilities

#### Audio & Modulation
- **DSDCC**: Updated to version 1.9.6
- **SerialDV**: Enhanced digital voice support
- **Codec2**: Latest version for digital voice coding

### Setup Infrastructure

#### New Setup Scripts
- **setup_apps**: New comprehensive application management setup
- **setup_core_desktop**: Streamlined desktop environment setup
- **setup_devices**: Reorganized device setup process
- **setup_swapspace**: New swap space management configuration

#### Improvements to Existing Scripts
- **Enhanced Core Package Setup**: Optimized package installation process
- **Improved Server Setup**: Better server configuration handling
- **Better Error Handling**: Improved shell script reliability with case error checking
- **Installation Options**: Added `-y` flag to automate package installation

#### Removed Legacy Setup
- Legacy SIGpi installer script removed
- Deprecated Docker setup files removed for cleaner repository

### Package Management
- **New Package Template**: Added standardized package template for easier development
- **Package Format Updates**: Modernized package configuration across all applications
- **Dependency Management**: Improved Python package version handling
- **Zero Copy Support**: Enabled for better performance in supported applications

### Optional Packages
- Several core packages moved to optional list to reduce default installation footprint
- Better modular installation experience

### Additional Scripts
- **exec-in-shell**: Enhanced shell execution capabilities
- **SDRplay Runtime**: Updated SDRplay device runner
- **DirectWolf Runner**: Enhanced AX.25 packet radio runner
- **URH Runner**: Improved Universal Radio Hacker execution
- **Xastir Runner**: Enhanced APRS application runner

## Developer Notes

### Package Organization
- Moved from device-centric to functionality-based organization
- Better separation between stable, development, and deprecated packages
- Simplified package discovery and management

### Code Quality
- Fixed Python version compatibility issues
- Improved error checking in installation scripts
- Cleaner code organization in setup utilities

## Deprecations

The following packages have been moved to deprecated status:
- Dump1090 ADS-B decoder (legacy)
- CubicSDR (see SDR++ or GQRX instead)
- BetterCapUI (use bettercap direct)
- Legacy device drivers in deprecated directory

## Recommendations for Users

1. **Fresh Installations**: Use the new setup scripts for optimal results
2. **Updating Applications**: Review the new applications management menu
3. **Device Support**: Check if your device is now in the packages directory (may need reinstallation)
4. **Legacy Systems**: Contact developers if running legacy hardware no longer in main packages

---

**Note**: For detailed technical changes, refer to the git commit history between develop and main branches.
