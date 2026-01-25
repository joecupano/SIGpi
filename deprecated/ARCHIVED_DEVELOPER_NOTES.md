# Developer Notes

The following is my notepad on SIGpi. It includes unvarnished ramblings on philosophy
behind SIGpi, approach development, noted idiosyncracies, tweaks to be addressed, etc.


## Philosophy

As with most projects, SIGpi started out as a project to meet the needs of a few and 
evolve over time to be available to others who have similar interest plus the spirit
and drive for experimentation. That persona doesnt look to be spoonfed images, applications
and mods but is motivated to create apps/tools or make changes themselves. To get people
started, SIGpi provides native support for RTLSDR and HackRF inclusive of
the applications.

This is why SIGpi is delivered as a toolkit and not an SDcard or distro image. In our toolkit
approach we deliver SIGpi as a command-line tool with a package manager approach for 
install/maintenance/removal etc of SDR devcies and applications. Motivated persons can install
other SDR devices and uses our non-developer command-line tools to compile applications to
support those devices as well. SIGpi 7.0 finds our development approach following a continuous
release model to keep with our toolkit approach.


## Hardware
SIGpi started with RPi3 and over time has focused on RPi3 as server-only and RPi4 and RPi5 for full
install. This does not negates using other ARM-based SBCs, it's just full testing has been
done on them.

## Operating Systems
SIGpi moved to Ubuntu 22.04 LTS for both amd64 and arm64 platforms

