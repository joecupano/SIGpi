# Scripts

These scripts are called during SIGpi installation. SOme of them in turn call the scripts in **devices** and **package**


## SIGpi_setup##
called by **SIGpi** Depending on options passed either **setup_core_standard** or **setup_core_server** are run next


## setup_core_standard
Installs devices selected, core packages, and desktop settings running  
**setup_devices**, **setup_core_packages** and **setup_core_desktop** respectively


## setup_core_server
Used for server-only installs. Installs devices selected and core packages running **setup_devices** and **setup_core_packages** respectively

## SIGpi_pkg_menu.py
This is a Gtk menu called by the **SIGpi menu** commnand used for **install**, **remove**, and **purge** of SIGpi applications

## SIGpi_pkgbuild
Debian-native packaging helper functions (`sigpi_stage_package`, `sigpi_deb_arch`), sourced
by the root **SIGpi** script so every `packages/pkg_*` and `devices/pkg_*` script can build a
`.deb` with `dpkg-deb` instead of `checkinstall`.

Also defines `sigpi_build_failed`, the handler behind the guard every `pkg_*` script's
`install`/`build`/`package` case opens with:

```
if [[ "$1" =~ ^(install|build|package)$ ]]; then
    set -Eeo pipefail
    trap 'sigpi_build_failed "${BASH_SOURCE[0]}" "$1" "$LINENO" "$?"' ERR
fi
```

This makes the script abort immediately - with a red error banner instead of a silent
continue - the moment any compile/install command fails, so a failed build is never staged
as a `.deb` or marked installed in `$SIGPI_INSTALLED`/`$SIGPI_INSTALLED_DEVICES`. `remove`
and `purge` are intentionally left out of the guard since they must keep running best-effort
(e.g. cleaning up a package that was only partly installed).

## Various support scripts

**SIGpi_exec-in-shell**
**run_SDRplay.sh**
**run_direwolf.sh**
**run_sdrangel.sh**
**run_urh.sh**
**run_xastir.sh**
