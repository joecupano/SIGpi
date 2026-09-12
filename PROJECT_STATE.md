# Project State

Working notes on where this branch stands right now. Not user-facing (see
[RELEASE_HISTORY.md](RELEASE_HISTORY.md) for that) - this is a handoff/status
doc for whoever picks up work here next.

**Branch:** `main`. `release/noble-trixie-native-pkg` (the checkinstall ->
dpkg-deb migration, the noble/trixie platform switch, and the two
catalog-accuracy passes described below) merged via PR #66 (`568a87e`).
Since the merge, `main` has picked up: `a906d28` (CUDA driver install),
`e3ba8af` (SDRangel package-install tweaks, superseded by the arm64 policy
change below), `5860b30` (fixed a `libgl1-mesa-glx` compile error), `c47ccfe`
(banner update), and `e8e43dc` (a real arm64 rebuild of 16 packages - see
Known issues). All device-catalog fixes that used to be listed as
"uncommitted" in this doc landed in `f804030`; `evilcrowrf`'s move to
`development/` is likewise committed.

## What this branch has done

- **Native Debian packaging**: every `packages/pkg_*` and `devices/pkg_*`
  script's `package`/`build` case now stages a `DESTDIR` install and builds a
  real `.deb` with `dpkg-deb` via `sigpi_stage_package()` in
  [scripts/SIGpi_pkgbuild](scripts/SIGpi_pkgbuild), replacing `checkinstall`
  everywhere.
- **Platform switch**: certified platforms are now Ubuntu 24.04 "noble" and
  Debian 13 / Raspberry Pi OS "trixie" (amd64 + arm64); 22.04/bookworm are no
  longer certified.
- **Version refresh**: nearly every package/device got bumped to current
  upstream stable and a real git tag/commit pin where one was previously
  missing (see commit `d8b73cb` for the full list).
- **Fail-fast build guard**: every `pkg_*` script's `install|build|package`
  case now opens with
  ```
  if [[ "$1" =~ ^(install|build|package)$ ]]; then
      set -Eeo pipefail
      trap 'sigpi_build_failed "${BASH_SOURCE[0]}" "$1" "$LINENO" "$?"' ERR
  fi
  ```
  so a failed compile/install aborts immediately with a red error banner
  instead of silently staging a broken `.deb` or marking a failed build as
  installed. `remove`/`purge` are deliberately excluded (they need to keep
  running best-effort). Handler lives in `SIGpi_pkgbuild` as
  `sigpi_build_failed()`. **Side effect worth knowing**: this guard turns any
  pre-existing "grep with no match" line into a hard failure instead of a
  silent no-op - see the devices pass below, which found four scripts broken
  this way.
- **PACKAGES accuracy pass** (committed in `d603fb1`): audited every
  `packages/pkg_*` script's embedded version against `packages/PACKAGES` and
  against the actual `Package:`/`Version:` fields inside the committed
  `.deb`s in `debs/` (`dpkg-deb -f`, not just script comments). Fixes:
  - Added the missing `fftw` row (the script installs and self-registers
    against it via `grep "fftw" $SIGPI_PKGLIST` - with no row that silently
    never marked itself installed).
  - `wsjtx` -> `2.7.0`, `sdrpp` -> `1.2.1`: PACKAGES had been bumped (3.0.2,
    1.3.0) ahead of the actual staged `.deb`s (neither script has a build
    path - the `.deb` is staged manually). Rolled PACKAGES back to match.
  - `linpac`: `0.2.0` -> `0.28` (matches the current noble/trixie repo
    version; the old value predated this pass and didn't match any real
    linpac release).
  - `pkg_wsjtx` `remove`/`purge` were running `dpkg -r/-P wsjtx_3.0.2` -
    `dpkg -r/-P` take the installed package name, not `name_version`, so
    this always failed regardless of version. Fixed to `wsjtx`.
  - `pkg_openwebrx`: dropped a stale leftover comment embedding an old
    PACKAGES row that no longer matched the script.
  - `pkg_js8call` recreated (it existed under `development/` pre-checkinstall
    -removal but was never migrated to `packages/`, leaving a PACKAGES row
    with no installer). Rebuilt on the current template: fail-fast guard,
    `dpkg -r/-P` (matching how it's installed), the same WSJT-X/JS8Call
    mutual-exclusion check `pkg_wsjtx` has, no arm64 path (no arm64 `.deb`
    exists yet - exits cleanly with a message instead of failing).
  - `pkg_rtl_433`: `build`/`package` removed (they called
    `sigpi_stage_package "rtl_433" ...` - **`dpkg-deb --build` hard-rejects
    underscores in a `Package:` name**, verified directly; that call would
    fail every time). Now just print "option not available" like the other
    apt/prebuilt-only scripts (`kismet`, `gpsd`, etc.); `remove`/`purge`/
    `install` are untouched.
  - `pkg_sdrangel`: `build`/`package` on arm64 now reject immediately (moved
    the aarch64 check ahead of the ~70-package apt dependency list, instead of
    installing all of it first and only then bailing); `install` on arm64
    prints the version it's about to install, read live from
    `sdrangel_current_arm64.deb` via `dpkg-deb -f` rather than a hardcoded
    string, so the banner can't drift from what's actually staged.
- **DEVICES accuracy pass** (same method, applied to `devices/`): compared
  every `devices/pkg_*` script's version pin against `devices/DEVICES`, then
  cross-checked which scripts actually depend on a pre-staged `.deb` for
  `install` (only `ettus`, `evilcrowrf`, `libfobos`, `libmirisdr`,
  `rtl-sdr-kerberos` - the rest build from source or an apt/PPA at install
  time, so a missing/stale `.deb` for them doesn't matter). Fixes:
  - `devices/DEVICES`: `rtlsdrv4` -> `rtlsdr-v4` (the catalog key didn't
    match the script filename `pkg_rtlsdr-v4` or the identifier used
    everywhere else - `scripts/setup_devices`, `SIGpi_setup`'s checklist tag.
    `SIGpi device install rtlsdrv4` would have failed to find its script).
  - `ettus`: DEVICES corrected to `4.9.0.1` to match what's actually staged
    in `debs/uhd_current_amd64.deb` (no arm64 `.deb` exists at all, despite
    this branch's commit message claiming the aarch64 exclusion was lifted).
    `pkg_ettus` still targets `v4.11.0.0` in its build/package path - a
    comment now flags that DEVICES needs bumping once that's actually built
    and staged for both arches.
  - `rtl-sdr-kerberos`: version left as-is (per direction) - `1.0` in
    DEVICES matches the currently-staged `.deb` even though the script's own
    build convention would tag a fresh rebuild `0+git<date>` (unpinned
    upstream HEAD). Separately, its `install` case was found grepping the
    **wrong catalog file** (`$SIGPI_PKGLIST` instead of `$SIGPI_DEVLIST`) to
    mark itself installed - "rtl-sdr-kerberos" only exists in DEVICES, so
    this always found nothing and (with the fail-fast guard) hard-failed
    `install` outright. Fixed to `$SIGPI_DEVLIST`.
  - `evilcrowrf`: moved `devices/pkg_evilcrowrf` -> `development/pkg_evilcrowrf`
    (`git mv`, history preserved) - `install` depends on
    `evilcrowrf_current_<arch>.deb`, and neither the amd64 nor arm64 file has
    ever been staged, so it failed on every platform. Header comment
    explains what's needed to bring it back (stage the `.deb`s via
    `SIGpi device package evilcrowrf` on each arch, verify `install`, move
    back, re-add its DEVICES row). Its now-orphaned DEVICES row was removed
    too, to avoid recreating the exact "catalog lists it, nothing can
    install it" gap found with `js8call`.
  - `libmirisdr`: was manually repaired outside this session (renamed the
    misnamed `.deb`s in `debs/` to the `libmirisdr_current_amd64.deb` /
    `soapymirisdr_current_amd64.deb` names the script expects) - rechecked
    and found the renamed sub-component file's *internal* package name was
    still the old `soapymiri`, not `soapymirisdr`, which would have broken
    `remove`/`purge` (`dpkg -r/-P soapymirisdr` would never match what's
    actually registered). Rather than rebuild, renamed every
    `soapymirisdr` reference back to `soapymiri` throughout `pkg_libmirisdr`
    (dpkg calls, sed cleanup, `sigpi_stage_package` call) and renamed
    `debs/soapymirisdr_current_amd64.deb` -> `debs/soapymiri_current_amd64.deb`
    to match - now internally consistent end to end. No arm64 `.deb`s exist
    for either component (both were deleted during the manual fix and never
    replaced) - `install` on aarch64 will fail until those are staged.
  - **Discovered a class of bug via functional testing, not just reading**:
    `pkg_libmirisdr`, `pkg_libfobos`, `pkg_rtl-sdr-kerberos`, and
    `pkg_ubertooth` each had a `cat $SIGPI_DEVLIST|grep "<name>" >>
    $SIGPI_INSTALLED_DEVICES` line that could never match anything (grepping
    for a sub-component with no DEVICES row of its own, the wrong catalog
    file, or a copy-pasted wrong search term). Before the fail-fast guard
    these were silent no-ops; after it, they turned `install`/`build` into
    guaranteed hard failures for `libmirisdr`, `libfobos`, and (on `build`)
    `ubertooth`, despite every real compile/install step succeeding first.
    Fixed by dropping the two dead sub-component lines (`libmirisdr`'s
    `soapymiri`, `libfobos`'s `soapyfobos` x2 - matching the existing
    convention where `bladerf`/`hackrf`/`plutosdr` etc. never tracked their
    soapy sub-components in DEVICES either) and correcting `ubertooth`'s
    copy-pasted `grep "libbtbb"` to `grep "ubertooth"`. All four verified
    end-to-end with mocked `sudo`/`git`/`cmake`/`make`/`pip3` - each now
    exits 0 and correctly appends its row to `$SIGPI_INSTALLED_DEVICES`.

## Uncommitted right now

```
 M PROJECT_STATE.md
 M packages/pkg_sdrangel
```

`pkg_sdrangel`: `build`/`package` now reject arm64 immediately (before the
apt dependency list runs, not after), and `install` on arm64 prints the
version it's about to install, read live via `dpkg-deb -f` from
`sdrangel_current_arm64.deb` (currently `7.22.5-1`) instead of a hardcoded
string. See "What this branch has done" above for the full rationale.

## Known issues / not yet acted on

- **arm64 `.deb`s were largely refreshed in `e8e43dc` ("arm64 package
  updates"), but a few stragglers remain.** Confirmed via `dpkg-deb -f`:
  aptdec, cm256cc, direwolf, dsdcc, fldigi (4.2.13), flrig (2.0.12), ggmorse,
  gpredict (2.6), hamlib (4.7.2), inmarsatc, libdab (2026.06), liquid-dsp
  (1.8.2), mbelib (1.3.0), multimon-ng, nrsc5 (3.2.0), and rnnoise all got
  real arm64 rebuilds and now match their amd64/PACKAGES versions. Still
  lagging: **volk** (3.1.0), **xastir** (2.2.3), **libsigmf** (1.0). Still
  **no arm64 `.deb` at all**: `uhd` (ettus), both `libmirisdr` sub-components
  (only `libmirisdr_current_amd64.deb` exists in `debs/` now - the arm64 file
  and its `soapymiri` sub-file are both still missing), and `js8call`.
  `sdrpp` **now has** an arm64 `.deb` (`sdrpp_current_arm64.deb` exists,
  correcting an earlier note here that it didn't).
- **`sdrangel`/`sdrangelsrv` arm64 are deliberately frozen at `7.22.5-1`, not
  stale.** `pkg_sdrangel`'s `build`/`package` now hard-reject arm64 (GUI build
  hits an unresolved upstream `libunwind` aarch64-unwinder link failure, see
  f4exb/sdrangel issue #2741) rather than attempting a rebuild; `install`
  installs the pre-built `7.22.5-1` `.deb` and prints its version so this
  doesn't look like silent staleness. `pkg_sdrangelsrv` (headless,
  `BUILD_GUI=off`) is the recommended arm64/Pi path, deliberately *does*
  build on aarch64 (per its own header comment), and wasn't touched by this
  change.
- **One corrupted arm64 artifact remains**: `debs/libbtbb_current_arm64.deb`'s
  internal version is still truncated to `20-12-R1-1` (should be
  `2020-12-R1-1`) - needs a rebuild, not a text fix. (The
  `multimon-ng_current_arm64.deb` misspelled-package-name issue noted here
  previously is fixed - its `Package:` field now correctly reads
  `multimon-ng`, apparently as a side effect of the `e8e43dc` rebuild.)
- **`js8call` has no arm64 `.deb` at all** - the script exits cleanly on
  aarch64 rather than failing, but it isn't actually installable on Raspberry
  Pi yet.
- **`evilcrowrf` is parked in `development/`**, not installable on any
  platform until its `.deb`s are actually built and staged (see its header
  comment for the exact steps to bring it back).
- **`devices/pkg_ubertooth`** still has the corrupted error string on its
  unknown-action path (`"ERROR: Unknown case "$1" in wn action or
  package"`) - cosmetic, flagged but not fixed. (`devices/pkg_sdrplay`'s
  matching issue noted here previously is fixed - it now reads the normal
  `"ERROR: Unknown action or package"`.)
- **`rtl-sdr-kerberos`'s DEVICES version (`1.0`) will drift on the next
  rebuild** - the script tags fresh unpinned-HEAD builds `0+git<date>`, so a
  future `SIGpi device package rtl-sdr-kerberos` will stage something DEVICES
  no longer matches. Left as-is per direction; worth aligning the two
  conventions (either give DEVICES a `0+git<date>`-style value, or make the
  script emit a plain version like `ggmorse`/`rnnoise`/`inmarsatc` do in
  `packages/`) whenever this gets touched again.
- **Six apt-only packages intentionally track upstream, not distro repo**:
  audacity, chrony, gpsd, pavucontrol, bettercap, gqrx have no version pin in
  their scripts and PACKAGES documents current upstream stable rather than
  whatever noble/trixie's repo actually ships (e.g. audacity 4.0.0 in
  PACKAGES vs ~3.4 in noble's repo). This is a deliberate, pre-existing
  choice reaffirmed in `d8b73cb`'s commit message, not a bug - noted here so
  it isn't "rediscovered" as one.
- **Worth a periodic audit**: the fail-fast guard means any future
  `grep ... >> $SIGPI_INSTALLED[_DEVICES]` line that can't match its catalog
  will now hard-fail instead of silently doing nothing. Four instances of
  exactly that were just found and fixed (see above) - worth a quick sweep
  for the same pattern next time a `pkg_*` script is touched.
- **Partially verified on real hardware now.** `e8e43dc` shows 16 packages
  actually got rebuilt arm64 `.deb`s (real binary changes, not text edits),
  so at least those had a genuine arm64 build. `volk`, `xastir`, `libsigmf`,
  `uhd`, `libmirisdr`, `js8call`, `libbtbb`, and any heavier package not in
  that list (GNU Radio, WSJT-X, etc.) are still unconfirmed on real arm64
  hardware. Everything in this doc not covered by that rebuild was still only
  checked by reading scripts, `bash -n`/functional dry-runs with mocked
  `sudo`/`git`/`cmake`/`make`/`pip3`/`dpkg`, and inspecting committed `.deb`
  metadata.

## Suggested next steps

1. Commit this pass's `packages/pkg_sdrangel` change.
2. Get access to arm64/RPi hardware (or cross-build tooling) to refresh the
   remaining stale/missing/corrupted arm64 `.deb`s: `volk`, `xastir`,
   `libsigmf` (stale); `uhd`, `libmirisdr`'s two components (missing
   entirely); `libbtbb` (corrupted version string).
3. Build/stage `evilcrowrf`'s `.deb`s (amd64 + arm64) and move it back to
   `devices/`.
4. Decide whether `wsjtx` should stay a manually-staged `.deb` forever or gain
   a real `build`/`package` path so PACKAGES version bumps and the staged
   artifact can't drift apart again (`sdrpp` now has an arm64 `.deb` staged,
   same open question still applies to it too).
5. Build/stage an arm64 `js8call` `.deb` if Raspberry Pi support is wanted
   for it.
6. Fix `devices/pkg_ubertooth`'s corrupted "Unknown case" error string
   (cosmetic, low priority).
7. No action needed on `pkg_sdrangelsrv`: its header comment already
   explains it deliberately does *not* exclude aarch64 like `pkg_sdrangel`
   now does - the headless (`BUILD_GUI=off`) build is the recommended
   arm64/Pi path, so it keeps its normal build/package logic on that arch.
