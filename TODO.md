# TODO

Open items identified while writing [USER-GUIDE.md](USER-GUIDE.md) and during a
2026-06-15 audit of Raspberry Pi (aarch64) / Ubuntu 24.04 "noble" support. None are
blocking current functionality on x86_64, but several **will break installs on
aarch64 (Raspberry Pi)** or on noble generally. Grouped by priority below.

## Stale arm64 packages (debs/)

Following the amd64 package rebuild (2026-06-14), these `debs/*_current_arm64.deb`
are now behind their amd64 counterparts and upstream. Same rebuild process
(`SIGpi package <name>` on aarch64 hardware) needs to be run for each:

| Package | arm64 (current) | amd64 (current) |
|---|---|---|
| gpredict | 2.4-1 | 2.5.1-1 |
| hamlib | 4.6.5-1 | 4.7.1-1 |
| libsigmf | 1.0-1 | 1.0.2-1 |
| liquid-dsp | 1.7.0-1 | 1.8.0-1 |
| nrsc5 | 3.1.0-1 | 3.2.0-1 |
| sdrangel | 7.22.5-1 | 7.26.1-1 |
| sdrangelsrv | 7.22.5-1 | 7.26.1-1 |
| volk | 3.1.0-1 | 3.3.0-1 |
| wsjtx | 2.7.0 | 3.0.1 |
| xastir | 2.2.3-1 | 2.2.5-1 |
| uhd | *(missing)* | 4.10.0.0-1 |

`uhd` has no arm64 build at all — `devices/pkg_ettus` currently guards aarch64 as
"not available" (TODO: confirm whether UHD now builds on Pi 4/5 under noble before
deciding to build it or keep the guard).

Also: `libbtbb_current_arm64.deb` reports `Version: 20-12-R1-1` vs amd64's
`2020-12-R1-1` — looks like a truncated version string from an old checkinstall run.
Cosmetic, but worth fixing on the next arm64 rebuild pass.

## Broken installs on Ubuntu 24.04 (noble)

- **`devices/pkg_limesuite`** (`install`): adds `ppa:myriadrf/drivers`, which has
  **no `noble` distribution at all** (latest published codename is `jammy`/22.04 —
  confirmed via Launchpad). `apt-get install limesuite ...` will fail on **both**
  x86_64 and aarch64 under Ubuntu 24.04. The script's own `build`/`package` actions
  already compile LimeSuite from source via cmake + checkinstall (a stale
  `deprecated/limesuite_22.09.0-1_arm64.deb` from a prior source build exists).
  Fix: switch `install` to use a prebuilt `limesuite_current_<arch>.deb` (consistent
  with the pattern used by most other device scripts) or build from source directly,
  dropping the PPA.

- **`devices/pkg_bladerf`** (`install`): adds `ppa:nuandllc/bladerf` unconditionally.
  The PPA *does* publish a `noble` dist, but **`main/binary-arm64/Packages` is empty
  (0 bytes)** — only amd64 packages are published for noble. On Raspberry Pi,
  `apt-get install bladerf libbladerf-dev` will fail. The script's `package` action
  already builds bladeRF + SoapyBladeRF from source via checkinstall, and
  `bladerf_current_arm64.deb` (2025.10-1) already exists in `debs/`. Fix: for
  aarch64, install via `dpkg -i $SIGPI_DEBS/bladerf_current_arm64.deb` instead of the
  PPA (matching `devices/pkg_ettus`'s arch-guard pattern, or the prebuilt-deb pattern
  used elsewhere).

- **`devices/pkg_libmirisdr`** (`install`): naming mismatches mean this is broken on
  **both** architectures:
  - x86_64 expects `libmirisdr_current_amd64.deb` but `debs/` has
    `libmirisdr_1.1.2-1_amd64.deb` (non-"current" name).
  - x86_64 and aarch64 both expect `soapymirisdr_current_<arch>.deb`, but the
    `package` action (built from the `SoapyMiri` repo) produces
    `soapymiri_current_amd64.deb` — note `soapymiri` vs `soapymirisdr`. No arm64
    soapymiri build exists at all.
  Fix: align the `package`-produced filenames (checkinstall `--pkgname=`) with what
  `install` expects (or vice versa), and produce/copy a `soapymiri_current_arm64.deb`.

- **`packages/pkg_satdump`** (`install|build|package`, line 67): installs
  `intel-opencl-icd` unconditionally. This is an x86-only Intel GPU OpenCL runtime
  with no arm64 build — `apt-get install` will fail on Raspberry Pi. Gate behind
  `$SIGPI_HWARCH == x86_64` (generic OpenCL is already covered by
  `mesa-opencl-icd`/`ocl-icd-opencl-dev` on the next two lines).

## Missing device scripts

- **HASviolet** (`devices/DEVICES`) has no active installer. Only a deprecated stub
  (`deprecated/device_hasviolet`) and an incomplete `desktop/hasviolet.desktop`
  (`Exec=/usr/bin/lxterminal -e` with nothing after `-e`) exist. Either build
  `devices/pkg_hasviolet` or remove the entry from `devices/DEVICES`.
- **RFM95W** (`devices/DEVICES`) has no installer at all — no script, no desktop file.
  Either build `devices/pkg_rfm95w` (LoRa HAT via SPI/GPIO) or remove the entry.

## Cleanup candidates

- `rtlsdr` (v3) entry in `devices/DEVICES` is redundant — the `rtlsdr-v4` driver
  (rtl-sdr-blog fork) already supports V3 hardware (confirmed). Consider removing the
  `rtlsdr` entry, or keep only as a documentation note.
- `libmirisdr` and `sdrplay` both target the SDRplay RSP1 with no guard against
  installing both. Add a warning in `scripts/SIGpi_setup`'s `select_devices` or in the
  scripts themselves.
- `scripts/SIGpi_env:54` has a stale comment referencing "Debian GNU/Linux 11
  (bullseye) or Ubuntu 22.04.3 LTS" — update to noble (Ubuntu 24.04 LTS) for
  consistency with `SIGpi_setup`'s certification check.

## Unverified interactions

- Kerberos SDR (`devices/pkg_rtl-sdr-kerberos`) and `rtlsdr-v4`
  (`devices/pkg_rtlsdr-v4`) both install librtlsdr-family udev rules
  (`-DINSTALL_UDEV_RULES=ON`). Behavior when both are installed on the same system
  hasn't been tested — verify dongle enumeration doesn't conflict.
