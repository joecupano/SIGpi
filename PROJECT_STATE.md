# Project State

Working notes on where this branch stands right now. Not user-facing (see
[RELEASE_HISTORY.md](RELEASE_HISTORY.md) for that) - this is a handoff/status
doc for whoever picks up work here next.

**Branch:** `release/noble-trixie-native-pkg` (pushed to `origin`, not yet
merged to `main`). `main` is still at the pre-native-packaging state
(`5c772c6`); this branch is ~9 commits ahead with the checkinstall -> dpkg-deb
migration, the noble/trixie platform switch, and a full package version
refresh.

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
  `sigpi_build_failed()`.
- **PACKAGES accuracy pass**: audited every `packages/pkg_*` script's
  embedded version against `packages/PACKAGES` and against the actual
  `Package:`/`Version:` fields inside the committed `.deb`s in `debs/`
  (`dpkg-deb -f`, not just script comments). Fixes applied:
  - Added the missing `fftw` row (the script installs and self-registers
    against it via `grep "fftw" $SIGPI_PKGLIST` - with no row that silently
    never marked itself installed).
  - `wsjtx`/`sdrpp`: PACKAGES had been bumped (3.0.2, 1.3.0) ahead of the
    actual staged `.deb`s, which are still 2.7.0 and 1.2.1-1487 respectively
    (neither script has a build path - the `.deb` is staged manually).
    Rolled PACKAGES back to match what's actually installed.
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

## Uncommitted right now

All of the PACKAGES-accuracy fixes above are still in the working tree, not
committed:

```
 M packages/PACKAGES
 M packages/pkg_openwebrx
 M packages/pkg_rtl_433
 M packages/pkg_sdrpp
 M packages/pkg_wsjtx
?? packages/pkg_js8call
```

## Known issues / not yet acted on

- **arm64 `.deb`s are broadly stale.** The amd64 side was rebuilt to match
  the version-refresh pass; arm64 wasn't (no ARM/RPi hardware was available
  to the person/session doing that pass - see `d8b73cb`'s commit message).
  Confirmed via `dpkg-deb -f` against every `debs/*_current_arm64.deb`:
  hamlib (4.6.5, not 4.7.2), sdrangel/sdrangelsrv (7.22.5, not 7.27.2),
  gpredict (2.4), liquid-dsp (1.7.0), mbelib (1.0), nrsc5 (3.1.0), volk
  (3.1.0), xastir (2.2.3), fldigi (4.2.11), flrig (2.0.10), libdab (1.0),
  libsigmf (1.0) all lag their amd64/PACKAGES counterparts. Needs a real
  rebuild on arm64/RPi hardware, not something fixable by editing text.
- **Two corrupted arm64 artifacts** (found incidentally, not yet fixed):
  `debs/libbtbb_current_arm64.deb`'s internal version is truncated to
  `20-12-R1-1` (should be `2020-12-R1-1`), and
  `debs/multimon-ng_current_arm64.deb`'s internal package name is misspelled
  `multimon-g` (should be `multimon-ng`). Both need a rebuild, not a text fix.
- **`js8call`/`sdrpp` have no arm64 `.deb` at all** - both scripts exit
  cleanly on aarch64 rather than failing, but neither is actually installable
  on Raspberry Pi yet.
- **`devices/pkg_sdrplay`** has a corrupted error string on its unknown-action
  path (`"ERROR: Unknown case "$1" in wn action or package"`) - cosmetic,
  flagged but not fixed (out of scope of the work requested so far).
- **Six apt-only packages intentionally track upstream, not distro repo**:
  audacity, chrony, gpsd, pavucontrol, bettercap, gqrx have no version pin in
  their scripts and PACKAGES documents current upstream stable rather than
  whatever noble/trixie's repo actually ships (e.g. audacity 4.0.0 in
  PACKAGES vs ~3.4 in noble's repo). This is a deliberate, pre-existing
  choice reaffirmed in `d8b73cb`'s commit message, not a bug - noted here so
  it isn't "rediscovered" as one.
- **Not verified on real hardware** (per `d8b73cb`): actual arm64 compiles,
  and full builds of the heavier packages (SDRangel, GNU Radio, WSJT-X, etc.)
  on either architecture. Everything above was checked by reading scripts,
  running `bash -n`/functional dry-runs with mocked `sudo`/`dpkg`, and
  inspecting committed `.deb` metadata - not by running a real install on
  target hardware.

## Suggested next steps

1. Commit the uncommitted PACKAGES-accuracy fixes (or fold them into the next
   `package updates` commit).
2. Get access to arm64/RPi hardware (or cross-build tooling) to refresh the
   stale/corrupted arm64 `.deb`s.
3. Decide whether `wsjtx`/`sdrpp` should stay manually-staged `.deb`s forever
   or gain a real `build`/`package` path so PACKAGES version bumps and the
   staged artifact can't drift apart again.
4. Build/stage an arm64 `js8call` `.deb` if Raspberry Pi support is wanted
   for it.
