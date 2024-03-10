# Development Notes

## SoapySDR 
```
#############################################
Begin configuration for Python 3 support...
#############################################
-- Enabling optional Python 3 bindings if possible...
-- Found Python3: /usr/bin/python3 (found version "3.10.12") found components: Interpreter Development 
--  * Interpreter: /usr/bin/python3 (Python)
--  * Include: /usr/include/python3.10
--  * Library: /usr/lib/x86_64-linux-gnu/libpython3.10.so
/home/pi/SIG/source/SoapySDR/swig/python/get_python_lib.py:4: DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12. Use setuptools or check PEP 632 for potential alternatives
  from distutils.sysconfig import get_python_lib
/home/pi/SIG/source/SoapySDR/swig/python/get_python_lib.py:4: DeprecationWarning: The distutils.sysconfig module is deprecated, use sysconfig instead
  from distutils.sysconfig import get_python_lib
-- ######################################################
-- ## SoapySDR enabled features
-- ######################################################
-- 
 * Library, runtime library v0.8.1-gbb33b2d2
 * Apps, command line applications
 * Tests, library unit tests
 * Docs, doxygen documentation
 * Python3, Python3 bindings v3.10.12

-- ######################################################
-- ## SoapySDR disabled features
-- ######################################################
-- 
 * CSharp, C# bindings v4.7.2
 * Python2, Python2 bindings v
 * LuaJIT, LuaJIT bindings

-- SoapySDR version: v0.8.1-gbb33b2d2
-- ABI/so version: v0.8-3
-- Install prefix: /usr/local
-- Configuring done
-- Generating done
-- Build files have been written to: /home/pi/SIG/source/SoapySDR/build

######################################################
Soapy SDR -- the SDR abstraction library     ##
######################################################

Lib Version: v0.8.1-gbb33b2d2
API Version: v0.8.200
ABI Version: v0.8-3
Install root: /usr/local
Search path:  /usr/local/lib/SoapySDR/modules0.8-3 (missing)
No modules found!
Available factories... No factories found!
Available converters...
 -  CF32 -> [CF32, CS16, CS8, CU16, CU8]
 -  CS16 -> [CF32, CS16, CS8, CU16, CU8]
 -  CS32 -> [CS32]
 -   CS8 -> [CF32, CS16, CS8, CU16, CU8]
 -  CU16 -> [CF32, CS16, CS8]
 -   CU8 -> [CF32, CS16, CS8]
 -   F32 -> [F32, S16, S8, U16, U8]
 -   S16 -> [F32, S16, S8, U16, U8]
 -   S32 -> [S32]
 -    S8 -> [F32, S16, S8, U16, U8]
 -   U16 -> [F32, S16, S8]
 -    U8 -> [F32, S16, S8]
```

## Ubertooth Tools
```
fatal: repository 'https://github.com/greatscottgadgets/libbtbb/wireshark/plugins/btbredr.git/' not found
CMake Error at cmake/FindWireshark.cmake:26 (MESSAGE):
Could NOT find the wireshark library and headers
Configuring incomplete, errors occurred!
See also "/home/pi/SIG/source/libbtbb/wireshark/plugins/btbredr/build/CMakeFiles/CMakeOutput.log".
See also "/home/pi/SIG/source/libbtbb/wireshark/plugins/btbredr/build/CMakeFiles/CMakeError.log".
make: *** No targets specified and no makefile found.  Stop.
make: *** No rule to make target 'install'.  Stop.
```

## LimeSDR
```
######################################################
LimeSuite enabled features
######################################################
LimeSuiteHeaders, The lime suite headers
LimeSuiteLibrary, The lime suite library
ConnectionFX3, FX3 Connection support
ConnectionFTDI, FTDI Connection support
ConnectionXillybus, PCIE Xillybus Connection support
LimeSuiteGUI, GUI Application for LimeSuite
LimeSuiteExamples, LimeSuite library API examples
LimeRFE, LimeRFE support
LimeUtilCommand, Command line device discovery utility
LimeQuickTest, LimeSDR-QuickTest Utility
SoapySDRLMS7, SoapySDR bindings for LMS7
LimeSuiteDesktop, LimeSuite freedesktop integration
LimeSuiteOctave, LimeSuite Octave integration

######################################################
LimeSuite disabled features
######################################################
ConnectionEVB7COM, EVB+COM Connection support
ConnectionSTREAM_UNITE, STREAM+UNITE Connection support
ConnectionSPI, Rasp Pi 3 SPI Connection support
LimeSuiteDocAPI, LMS API Doxygen documentation

## Ettus UHD
######################################################
UHD disabled components                             
######################################################
* DPDK

## SDRplay RSPx Device
-- Install configuration: "Release"
-- Installing: /usr/local/lib/pkgconfig/libmirisdr.pc
-- Installing: /usr/local/include/mirisdr.h
-- Installing: /usr/local/include/mirisdr_export.h
-- Installing: /usr/local/lib/libmirisdr.so.4.0git
-- Installing: /usr/local/lib/libmirisdr.so.4
-- Set runtime path of "/usr/local/lib/libmirisdr.so.4.0git" to "/usr/local/lib"
-- Installing: /usr/local/lib/libmirisdr.so
-- Installing: /usr/local/lib/libmirisdr.a
-- Installing: /usr/local/bin/miri_sdr
-- Set runtime path of "/usr/local/bin/miri_sdr" to "/usr/local/lib"
-- Installing: /usr/local/bin/miri_fm
-- Set runtime path of "/usr/local/bin/miri_fm" to "/usr/local/lib"
```
