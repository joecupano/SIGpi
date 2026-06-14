# SIGpi User Guide

This guide describes every package SIGpi can install, grouped by purpose, plus the SDR
hardware SIGpi can drive and any warnings worth knowing before you pick a device.

## Categories

- **SDR** — the signal format is known and published (a broadcast standard, a satellite
  downlink format, a weather balloon protocol, etc.). These apps are aimed at hobbyist
  reception/operation of things that are already documented.
- **SIGINT** — works with raw or unidentified signals. These tools intercept,
  characterize, or reverse-engineer RF and network emissions you don't control — the
  core toolkit for red-team RF/wireless reconnaissance.
- **Amateur Radio** — operating, logging, rig control, and digital-mode software for
  licensed amateur use on ham bands/modes.

Two more sections cover **Supporting Libraries & Codecs** (DSP/codec dependencies the
apps above link against — not standalone tools) and **System & Audio Utilities**
(general-purpose helpers used alongside the above), followed by **Devices & Drivers**.

Use `SIGpi list library` to see this same package list with install status, `SIGpi
install <package>` / `SIGpi remove <package>` to manage packages, and `SIGpi device
install <name>` / `SIGpi device remove <name>` for hardware drivers. Version numbers
below are the versions SIGpi pins/builds, not necessarily the latest upstream release.

Targets: **x86_64** = Ubuntu 24.04 LTS (noble) on Intel or Raspberry Pi 4/5; **aarch64**
= Raspberry Pi OS Bookworm on Raspberry Pi 3/4/5. A few packages/devices are
arch-restricted — these are called out below.

---

## SDR Applications

- **SDRangel** `7.26.1` — Qt5/OpenGL SDR receiver, transmitter, and spectrum analyzer
  with built-in demodulators/decoders for dozens of broadcast, aviation, marine, ADS-B,
  APRS, and digital-voice formats.
- **SDR++** `1.2.1` — Lightweight, cross-platform SDR receiver focused on a fast
  waterfall/spectrum display and broad device support.
- **SatDump** `1.2.2` — Generic multi-mission satellite processor; decodes known
  downlink formats (NOAA APT, Meteor LRPT, GOES/GK-2A LRIT/HRIT, Inmarsat, etc.) into
  imagery and telemetry.
- **aptdec** `1.8.0` — Decodes NOAA APT weather-satellite images, with calibrated
  IR-temperature output and false-color palette options.
- **gpredict** `2.4` — Real-time satellite tracking and pass prediction; used to
  schedule SatDump/aptdec passes and amateur satellite (AMSAT) operating windows.
- **nrsc5** `3.1.0` — Receives and decodes NRSC-5 (HD Radio) digital broadcast stations
  with an RTL-SDR.
- **radiosonde** `1.0` — Decodes weather-balloon radiosonde telemetry (RS41, RS92, M10,
  iMet, etc.) for the radiosonde-hunting hobby.

## SIGINT Applications

- **SigDigger** `0.3.0` — Blind RF signal analyzer: parameter estimation,
  cyclostationary/transition analysis, and adjustable demodulation for *unidentified*
  signals.
- **inspectrum** `0.4.0` — Time-frequency visualization and measurement tool for raw IQ
  recordings; commonly used to reverse-engineer unknown signals.
- **Universal Radio Hacker (urh)** `2.9.5` — End-to-end investigation, demodulation,
  and fuzzing of unknown wireless protocols.
- **Kismet** `2025-09-R1` — Passive Wi-Fi/Bluetooth/Zigbee wireless network sniffer,
  intrusion detection, and recon tool.
- **Bettercap** `2.41.5` — Reconnaissance and attack framework for Wi-Fi, BLE, HID, and
  Ethernet networks.
- **rtl_433** `25.12` — Generic receiver/decoder for ISM-band (433/868/915MHz) traffic;
  surveys and decodes sensors, remotes, and other emitters in range.
- **multimon-ng** `1.4.1` — Decodes POCSAG/FLEX pagers, EAS, DTMF, X10, and other
  narrowband digital signals intercepted off the air.
- **GNU Radio** `3.10.12` — DSP development toolkit and flowgraph builder (GRC); the
  standard tool for building custom decoders for non-standard or unidentified signals,
  and a backend dependency for several apps above.
- **srsRAN 4G** `25.10` — End-to-end 4G LTE stack (RAN + EPC core) for standing up a
  private/test eNodeB — used for cellular protocol research and red-team cellular work.

## Amateur Radio Applications

- **WSJT-X** `3.0.1 (amd64) / 2.7.0 (arm64)` — FT4, FT8, JT4, JT9, JT65, Q65, MSK144,
  and WSPR weak-signal digital modes.
- **JS8Call** `2.3.1` — JS8 keyboard-to-keyboard weak-signal messaging mode
  (FT8-derived).
- **fldigi** `4.2.11` — Soundcard modem covering most ham digital modes (PSK31, RTTY,
  Olivia, MFSK, etc.).
- **flrig** `2.0.10` — Rig (CAT) control companion for fldigi and other apps.
- **Direwolf** `1.8.1` — Software TNC: AX.25 packet radio and APRS encode/decode over a
  soundcard.
- **AX.25 Tools** `1.0.0` — Linux kernel AX.25 packet-radio protocol stack and
  command-line utilities.
- **LinPac** `0.2.0` — AX.25 packet radio terminal.
- **Xastir** `2.2.2` — APRS client with mapping, station tracking, and messaging.
- **QSSTV** `1.0` — Slow-scan television (SSTV) and HamDRM/DSSTV transmit and receive.
- **Hamlib** `4.6.5` — Radio control (CAT) library/daemon used by fldigi, flrig,
  WSJT-X, and gpredict to drive transceivers and rotators.

## Supporting Libraries & Codecs

These aren't standalone applications — they're DSP, codec, and metadata libraries the
apps above link against. Listed here for completeness.

- **codec2** `1.2.0` — Low-bitrate speech codec for HF/VHF digital voice (FreeDV, M17);
  used by SDRangel's digital-voice decoders.
- **ggmorse** `1.0` — Morse code (CW) encode/decode library used by SDRangel's CW mode.
- **dsdcc** `1.9.6` — Digital speech decoder for P25, DMR, D-STAR, NXDN, and YSF
  digital-voice modes.
- **mbelib** `1.0` — P25 Phase 1 / ProVoice vocoder, paired with dsdcc.
- **serialdv** `1.1.5` — Interface to AMBE3000-series hardware vocoders over a serial
  link.
- **libdab** `1.0` — DAB/DAB+ decoding library used by SDRangel's DAB plugin.
- **inmarsatc** `1.0` — Library for receiving Inmarsat-C satellite messaging, used by
  SatDump.
- **libbtbb** `2020-12-R1` — Bluetooth baseband decoding library used with Kismet and
  Ubertooth for BT/BLE sniffing.
- **libsigmf** `1.0` — Header-only C++ library for reading/writing SigMF-format IQ
  recordings and metadata.
- **cm256cc** `1.1.2` — GF(256) Cauchy MDS erasure-coding library used by SDRangel for
  FEC on digital streams.
- **liquid-dsp** `1.7.0` — General-purpose DSP primitives library used across multiple
  SDR apps.
- **VOLK** `3.2.0` — Vector-Optimized Library of Kernels: SIMD-accelerated DSP routines
  underpinning GNU Radio and related tools.
- **VkFFT** `1.3.4` — GPU-accelerated (Vulkan/CUDA/OpenCL) FFT library used for
  accelerated waterfalls and processing.
- **RNNoise** `1.0` — RNN-based real-time audio noise suppression used in digital-voice
  and recording chains.
- **sgp4** `1.0` — SGP4/SDP4 orbital propagation models used by gpredict and SatDump
  for satellite tracking.

## System & Audio Utilities

- **Audacity** `2.4.2` — Multi-track audio editor/recorder; its spectrogram view also
  helps with basic visual inspection of recorded audio.
- **Chrony** `4.8.2` — NTP time synchronization daemon; keeps the system clock accurate
  enough for FT8/WSPR timing and GPS-disciplined SDR work.
- **GPSD** `3.2.2` — GPS receiver interface daemon; provides position/time to APRS,
  gpredict, and frequency-reference tooling.
- **PAVUcontrol** `5.0` — GTK PulseAudio mixer for routing audio between SDR apps and
  digital-mode decoders.
- **DOSBox** `0.74-3` — DOS emulator for running legacy DOS-era radio/decoding software.

---

## Devices & Drivers

SoapySDR and SoapyRemote are installed by default, giving most apps above a common API
across the hardware below.

- **bladeRF** `2023.02` — Nuand bladeRF 2.0 (xA4/xA9): wideband (47MHz–6GHz),
  full-duplex 2x2 MIMO transceiver via SoapyBladeRF.
  > Installed from Nuand's Ubuntu PPA (`ppa:nuandllc/bladerf`). PPAs are an
  > Ubuntu-specific mechanism — on aarch64 (Raspberry Pi OS) this install path may not
  > work as written. Full bandwidth (up to 61.44MHz) requires USB3.

- **Ettus USRP (UHD)** `4.9.0.1` — USRP B-series and other UHD-supported devices.
  > **x86_64 only** — the script explicitly reports "not available for aarch64" and has
  > no Raspberry Pi build path. Needs USB3 and a powered hub for sustained throughput.

- **Evil Crow RF V2** `1.0` — ESP32 + CC1101/SX127x sub-1GHz (300–928MHz) transceiver
  for RF replay, jamming, and protocol research.
  > Transmit-capable — confirm local RF regulations before transmitting. Installs from
  > a prebuilt `.deb` and adds a terminal-based control launcher to the SIGpi shell
  > menu.

- **RigExpert Fobos** `2.4.0` — Wideband SDR receiver; builds libfobos + SoapyFobos
  from source and installs udev rules for non-root USB access.

- **HackRF One** `2026.01.02` — 1MHz–6GHz, up to 20MHz bandwidth, half-duplex, 8-bit
  ADC.
  > Cannot transmit and receive simultaneously, and has less dynamic range than
  > LimeSDR/USRP/bladeRF — fine for general RX/TX experimentation, not for full-duplex
  > work.

- **HASviolet** `1.0` — LoRa SDR companion app intended for use with the RFM95W LoRa
  bonnet (below).
  > Currently a placeholder: only a deprecated stub (`deprecated/device_hasviolet`) and
  > an incomplete desktop launcher exist; there is no active `devices/pkg_hasviolet`
  > installer yet.

- **Kerberos SDR** `1.0` — 4x coherent RTL-SDR array for direction-finding (DOA) and
  passive coherent radar.
  > Requires four matched RTL-SDR dongles on a powered USB hub sharing a common clock,
  > plus a Python DOA/PR GUI installed via pip. Builds its own librtlsdr with udev
  > rules — installing alongside the default RTL-SDR v4 driver (below) may cause
  > udev/driver overlap; verify dongle enumeration after installing both.

- **Legacy SDRplay RSP1 driver (libmirisdr)** `1.0` — Open-source driver for the
  original SDRplay RSP1 and Mirics MSi001+MSi2500-based clones (MSI-SDR/"M3", certain
  Hauppauge/AverMedia DVB-T dongles).
  > Not for RSP1A/RSP2/RSPduo/RSPdx. Blacklists the `msi2500`/`msi001` kernel modules.
  > Mutually exclusive with the SDRplay driver below for an RSP1 — its modern unified
  > API also covers RSP1, so installing both for the same device is redundant.

- **LimeSDR (LimeSuite)** `23.11.0` — LimeSDR USB/Mini/Mini 2.0: full-duplex 2x2 MIMO,
  up to ~61.44MHz bandwidth.
  > Installed from MyriadRF's Ubuntu PPA (`ppa:myriadrf/drivers`) — same aarch64/PPA
  > caveat as bladeRF above. Full bandwidth requires USB3, shared with the rest of the
  > Pi's USB3 bus.

- **PlutoSDR** `0.25` — ADALM-PLUTO: full-duplex, single-channel (1x1), ~20MHz
  bandwidth.
  > Enumerates as a USB network device (default `192.168.2.1`) rather than a
  > conventional USB SDR — host firewall/network configuration can affect discovery.

- **Adafruit RFM95W LoRa Bonnet** `1.0` — 868/915MHz LoRa radio HAT, connected via the
  Pi's GPIO header (SPI) rather than USB.
  > No dedicated install script exists yet in `devices/` — its companion app HASviolet
  > (above) is also a placeholder. When wired up, it occupies the full 40-pin GPIO
  > header; check for conflicts with other GPIO-based HATs.

- **RTL-SDR v3** `1.0` — Generic RTL2832U-based dongles (e.g., RTL-SDR Blog V3).
  > Superseded in the active install flow by RTL-SDR v4 below — its rtl-sdr-blog driver
  > fork supports both V3 and V4 hardware, so no separate V3-only driver is installed.

- **RTL-SDR v4** `1.0` — RTL-SDR Blog V4 dongle (R828D tuner); installed by default
  (checked on in setup) and also covers V3 dongles.
  > Installing this purges the stock `librtlsdr` package and any existing librtlsdr
  > files before building the rtl-sdr-blog fork — anything else on the system that
  > depends on the distro's stock librtlsdr will be relinked against this driver. Also
  > blacklists the kernel's `dvb_usb_rtl28xxu` module so the dongle isn't grabbed as a
  > TV tuner.

- **SDRplay** `3.15.2` — Current SDRplay API (v3.15) covering RSP1, RSP1A, RSP2,
  RSPduo, and RSPdx.
  > Proprietary binary driver/service (`SDRplay_RSP_API`), installed from a
  > vendor-provided zip — not open source. Installs a `run_SDRplay.sh` launcher that
  > must start the API service before any app can use the device. See the libmirisdr
  > note above for RSP1 overlap.

- **Ubertooth One** `2020-12-R1` — 2.4GHz Bluetooth Classic/BLE sniffing and
  development platform.
  > Pairs with libbtbb for baseband decoding and with Kismet for combined
  > Wi-Fi/Bluetooth recon.
