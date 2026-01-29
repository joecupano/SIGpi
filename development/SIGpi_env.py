#!/usr/bin/env python3
"""
Python version of SIGpi_env bash script
"""
import os
import subprocess

# SIGpi Directory tree
SIGPI_ROOT = os.path.expanduser('~/SIG')
SIGPI_SOURCE = os.path.join(SIGPI_ROOT, 'source')
SIGPI_HOME = os.path.join(SIGPI_ROOT, 'SIGpi')
SIGPI_ETC = os.path.join(SIGPI_ROOT, 'etc')
SIGPI_DEVICES = os.path.join(SIGPI_HOME, 'devices')
SIGPI_SCRIPTS = os.path.join(SIGPI_HOME, 'scripts')
SIGPI_PACKAGES = os.path.join(SIGPI_HOME, 'packages')
SIGPI_DEBS = os.path.join(SIGPI_HOME, 'debs')

# SIGpi Install Support files
SIGPI_INSTALLED = os.path.join(SIGPI_ETC, 'INSTALLED_PKGS')
SIGPI_PKGLIST = os.path.join(SIGPI_PACKAGES, 'PACKAGES')
SIGPI_INSTALLED_DEVICES = os.path.join(SIGPI_ETC, 'INSTALLED_DEVICES')
SIGPI_DEVLIST = os.path.join(SIGPI_DEVICES, 'DEVICES')
SIGPI_SCREEN_STANDARD = os.path.join(SIGPI_SCRIPTS, 'screen_standard_setup')
SIGPI_SCREEN_SERVER = os.path.join(SIGPI_SCRIPTS, 'screen_server_setup')
SIGPI_BANNER_COLOR = "\033[0;104m\033[K"  # blue
SIGPI_BANNER_RESET = "\033[0m"

# Desktop Source directories
SIGPI_BACKGROUNDS = os.path.join(SIGPI_HOME, 'backgrounds')
SIGPI_ICONS = os.path.join(SIGPI_HOME, 'icons')
SIGPI_LOGO = os.path.join(SIGPI_HOME, 'logo')
SIGPI_DESKTOP = os.path.join(SIGPI_HOME, 'desktop')

# Desktop Destination Directories
DESKTOP_DIRECTORY = '/usr/share/desktop-directories'
DESKTOP_FILES = '/usr/share/applications'
DESKTOP_ICONS = '/usr/share/icons'
DESKTOP_XDG_MENU = '/usr/share/extra-xdg-menus'

# SIGpi Menu category
SIGPI_MENU_CATEGORY = 'SIGpi'
HAMRADIO_MENU_CATEGORY = 'HamRadio'

# Detect architecture (x86, x86_64, aarch64, ARMv8, ARMv7)
def get_hwarch():
    try:
        result = subprocess.check_output(['lscpu']).decode()
        for line in result.splitlines():
            if 'Architecture' in line:
                return line.split()[1]
    except Exception:
        return None

# Detect Operating system (Debian GNU/Linux 11 (bullseye) or Ubuntu 22.04.3 LTS)
def get_osname():
    try:
        with open('/etc/os-release') as f:
            for line in f:
                if line.startswith('PRETTY_NAME'):
                    return line.split('=')[1].strip().strip('"')
    except Exception:
        return None

# Is Platform good for install- true or false - we start with false
SIGPI_CERTIFIED = False

if __name__ == "__main__":
    print(f"SIGPI_HWARCH: {get_hwarch()}")
    print(f"SIGPI_OSNAME: {get_osname()}")
    print(f"SIGPI_CERTIFIED: {SIGPI_CERTIFIED}")
