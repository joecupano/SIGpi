# TODO

Open items identified while writing [USER-GUIDE.md](USER-GUIDE.md). None are blocking
current functionality, but worth tracking.

## Missing device scripts

- **HASviolet** (`devices/DEVICES`) has no active installer. Only a deprecated stub
  (`deprecated/device_hasviolet`) and an incomplete `desktop/hasviolet.desktop`
  (`Exec=/usr/bin/lxterminal -e` with nothing after `-e`) exist. Either build
  `devices/pkg_hasviolet` or remove the entry from `devices/DEVICES`.
- **RFM95W** (`devices/DEVICES`) has no installer at all — no script, no desktop file.
  Either build `devices/pkg_rfm95w` (LoRa HAT via SPI/GPIO) or remove the entry.

## Untested cross-arch paths

- `devices/pkg_bladerf` and `devices/pkg_limesuite` install via Ubuntu PPAs
  (`ppa:nuandllc/bladerf`, `ppa:myriadrf/drivers`) with no `$SIGPI_HWARCH` branch.
  `add-apt-repository ppa:...` is Ubuntu-specific and likely fails on aarch64
  (Raspberry Pi OS / Debian). Needs an aarch64 install path or an explicit
  "not available for aarch64" guard like `devices/pkg_ettus` already has.

## Cleanup candidates

- `rtlsdr` (v3) entry in `devices/DEVICES` is redundant — the `rtlsdr-v4` driver
  (rtl-sdr-blog fork) already supports V3 hardware (confirmed). Consider removing the
  `rtlsdr` entry, or keep only as a documentation note.
- `libmirisdr` and `sdrplay` both target the SDRplay RSP1 with no guard against
  installing both. Add a warning in `scripts/SIGpi_setup`'s `select_devices` or in the
  scripts themselves.

## Unverified interactions

- Kerberos SDR (`devices/pkg_rtl-sdr-kerberos`) and `rtlsdr-v4`
  (`devices/pkg_rtlsdr-v4`) both install librtlsdr-family udev rules
  (`-DINSTALL_UDEV_RULES=ON`). Behavior when both are installed on the same system
  hasn't been tested — verify dongle enumeration doesn't conflict.
