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

## Various support scripts

**SIGpi_env**
**SIGpi_exec-in-shell**
**run_SDRplay.sh**
**run_direwolf.sh**
**run_sdrangel.sh**
**run_urh.sh**
**run_xastir.sh**
