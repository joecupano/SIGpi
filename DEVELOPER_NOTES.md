# Developer Notes

The following are notes, tweaks to be addressed, etc. (My notepad of sorts.)
Most notorius to sort is differences in menu settings for the different OS Desktop
environments.

## Raspbeery Pi OS

### Desktop Prep

```
xdg-desktop-menu: file '/usr/share/applications/sigidwiki.desktop' does not exist
xdg-desktop-menu: file '/usr/share/applications/sigpi_home.desktop' does not exist
```

### SoapySDR

```
-- ######################################################
-- ## SoapySDR enabled features
-- ######################################################
-- 
 * Library, runtime library v0.8.1-gbb33b2d2
 * Apps, command line applications
 * Tests, library unit tests
 * Docs, doxygen documentation
 * Python2, Python2 bindings v2.7.18
 * Python3, Python3 bindings v3.9.2
 * LuaJIT, LuaJIT bindings

-- ######################################################
-- ## SoapySDR disabled features
-- ######################################################
-- 
 * CSharp, C# bindings v4.7.2
 * LDoc, LuaJIT API documentation
 * LuaJIT tests, LuaJIT unit tests

-- SoapySDR version: v0.8.1-gbb33b2d2
-- ABI/so version: v0.8-3
-- Install prefix: /usr/local
-- Configuring done
-- Generating done
-- Build files have been written to: /home/pi/SIG/source/SoapySDR/build

/home/pi/SIG/source/SoapySDR/include/SoapySDR/Device.hpp:261: Warning 560: Unknown Doxygen command: parblock.
/home/pi/SIG/source/SoapySDR/include/SoapySDR/Device.hpp:265: Warning 560: Unknown Doxygen command: endparblock.
```

### LimeSuite

```
-- ######################################################
-- ## LimeSuite enabled features
-- ######################################################
-- 
 * LimeSuiteHeaders, The lime suite headers
 * LimeSuiteLibrary, The lime suite library
 * ConnectionFX3, FX3 Connection support
 * ConnectionFTDI, FTDI Connection support
 * ConnectionXillybus, PCIE Xillybus Connection support
 * LimeSuiteGUI, GUI Application for LimeSuite
 * LimeSuiteExamples, LimeSuite library API examples
 * LimeRFE, LimeRFE support
 * LimeUtilCommand, Command line device discovery utility
 * LimeQuickTest, LimeSDR-QuickTest Utility
 * SoapySDRLMS7, SoapySDR bindings for LMS7
 * LimeSuiteDesktop, LimeSuite freedesktop integration
 * LimeSuiteOctave, LimeSuite Octave integration

-- ######################################################
-- ## LimeSuite disabled features
-- ######################################################
-- 
 * ConnectionEVB7COM, EVB+COM Connection support
 * ConnectionSTREAM_UNITE, STREAM+UNITE Connection support
 * ConnectionSPI, Rasp Pi 3 SPI Connection support
 * LimeSuiteDocAPI, LMS API Doxygen documentation

-- Install prefix: /usr/local
-- Build timestamp: 2023-08-31
-- Lime Suite version: 22.09.0-ge829d3ed
-- ABI/so version: 22.09-1
-- Configuring done
-- Generating done
-- Build files have been written to: /home/pi/SIG/source/LimeSuite/build-dir
```

### Multimon-NG

```
  By not providing "FindPulseAudio.cmake" in CMAKE_MODULE_PATH this project
  has asked CMake to find a package configuration file provided by
  "PulseAudio", but CMake did not find one.

  Could not find a package configuration file provided by "PulseAudio" with
  any of the following names:

    PulseAudioConfig.cmake
    pulseaudio-config.cmake

  Add the installation prefix of "PulseAudio" to CMAKE_PREFIX_PATH or set
  "PulseAudio_DIR" to a directory containing one of the above files.  If
  "PulseAudio" provides a separate development package or SDK, be sure it has
  been installed.


-- Install configuration: ""
-- Installing: /usr/local/share/man/man1/multimon-ng.1
-- Installing: /usr/local/bin/multimon-ng
```

### GNURadio

```
-- Installing: /usr/local/share/gnuradio/grc/blocks/soapy_custom_sink.block.yml
sed: can't read /usr/share/applications/gnuradio-grc.desktop: No such file or directory
xdg-desktop-menu: file '/usr/share/applications/gnuradio-grc.desktop' does not exist
```

### FLdigi

```
sed: can't read /usr/share/applications/fldigi.desktop: No such file or directory
sed: can't read /usr/share/applications/flarq.desktop: No such file or directory
xdg-desktop-menu: file '/usr/share/desktop-directories/HamRadio.directory' does not exist
xdg-desktop-menu: file '/usr/share/desktop-directories/HamRadio.directory' does not exist
```

### Kismet

```
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 kismet-capture-bladerf-wiphy : Depends: libwebsockets17 but it is not installable
 kismet-capture-hak5-wifi-coconut : Depends: libwebsockets17 but it is not installable
 kismet-capture-linux-bluetooth : Depends: libwebsockets17 but it is not installable
 kismet-capture-linux-wifi : Depends: libwebsockets17 but it is not installable
 kismet-capture-nrf-51822 : Depends: libwebsockets17 but it is not installable
 kismet-capture-nrf-52840 : Depends: libwebsockets17 but it is not installable
 kismet-capture-nrf-mousejack : Depends: libwebsockets17 but it is not installable
 kismet-capture-nxp-kw41z : Depends: libwebsockets17 but it is not installable
 kismet-capture-rz-killerbee : Depends: libwebsockets17 but it is not installable
 kismet-capture-ti-cc-2531 : 
 kismet-capture-ubertooth-one : Depends: libwebsockets17 but it is not installable
 kismet-core : Depends: libssl3 but it is not installable
               Recommends: kismet-capture-ti-cc-2540 but it is not going to be installed
```

