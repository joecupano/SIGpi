#!/bin/bash

###
### SIGpi
###
### installer_radiosonde
###

echo -e "${SIGPI_BANNER_COLOR}           Install RadioSonde"
echo -e "${SIGPI_BANNER_RESET}"

echo " "
echo " ##"
echo " - Clone RadioSonde (RS)"
echo " ##"
echo " "
cd $SIGPI_SOURCE
git clone https://github.com/rs1729/RS.git

echo "  #"
echo "  - RS92"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/rs92
gcc rs92gps.c -lm -o rs92gps
sudo chown root:root rs92gps
sudo cp rs92gps /usr/local/bin

echo "  #"
echo "  - RS41"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/rs41
cp $SIGPI_SOURCE/RS/ecc/bch_ecc.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.h .
gcc rs41ptu.c -lm -o rs41ptu
sudo chown root:root rs41ptu
sudo cp rs41ptu /usr/local/bin

echo "  #"
echo "  - DropSonde"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/dropsonde
gcc rd94drop.c -lm -o rd94drop
sudo chown root:root rd94drop
sudo cp rd94drop /usr/local/bin

echo "  #"
echo "  - M10"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/m10
gcc m10ptu.c -lm -o m10ptu
gcc m10gtop.c -lm -o m10gtop
sudo chown root:root m10ptu m10gtop
sudo cp m10ptu m10gtop $SIGPI_EXE
cd $SIGPI_SOURCE/RS/m10/pilotsonde
gcc m12.c -lm -o m12
sudo chown root:root m12
sudo cp root:root m12 /usr/local/bin

echo "  #"
echo "  - dfm (06 and 09)"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/dfm
gcc dfm06ptu.c -lm -o dfm06ptu
sudo chown root:root dfm06ptu
sudo cp dfm06ptu /usr/local/bin

echo "  #"
echo "  - imet"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/imet
gcc imet1ab.c -lm -o imet1ab
gcc imet1ab_cpafsk.c -lm -o imet1ab_cpafsk
gcc imet1rs_dft.c -lm -o imet1rs_dft
gcc imet1rs_dft_1.c -lm -o imet1rs_dft_1
gcc imet1rsb.c -lm -o imet1rsb
sudo chown root:root imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1
sudo cp root:root imet1ab imet1rsb imet1ab_cpafsk imet1rs_dft imet1rs_dft_1 /usr/local/bin

echo "  #"
echo "  - c34"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/c34
gcc c34dft.c -lm -o c34dft
gcc c50dft.c -lm -o c50dft
sudo chown root:root c34dft c50dft
sudo cp root:root c34dft c50dft /usr/local/bin


echo "  #"
echo "  - lms6"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/lms6
cp $SIGPI_SOURCE/RS/ecc/bch_ecc.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.h .
gcc lms6.c -lm -o lms6
gcc lms6ccsds.c -lm -o lms6ccsds
gcc lms6ecc.c -lm -o lms6ecc
gcc lmsX2446.c -lm -o lmsX2446 
sudo chown root:root lms6 lms6ccsds lms6ecc lmsX2446 
sudo cp lms6 lms6ccsds lms6ecc lmsX2446 /usr/local/bin

echo "  #"
echo "  - mk2A"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/mk2a
gcc mk2a.c -lm -o mk2a
gcc mk2a1680mod.c -lm -o mk2a1680mod
gcc mk2a_lms1680.c -lm -o mk2a_lms1680
sudo chown root:root mk2a mk2a1680mod mk2a_lms1680
sudo cp mk2a mk2a1680mod mk2a_lms1680 /usr/local/bin

echo "  #"
echo "  - Meisei"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/meisei
cp $SIGPI_SOURCE/RS/ecc/bch_ecc.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.h .
gcc meisei_ecc.c -lm -o meisei_ecc
gcc meisei_ims.c -lm -o meisei_ims
gcc meisei_rs.c -lm -o meisei_rs
sudo chown root:root meisei_ecc meisei_ims meisei_rs
sudo cp meisei_ecc meisei_ims meisei_rs /usr/local/bin


echo "  #"
echo "  - MRZ"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/mrz
gcc mp3h1.c -lm -o mp3h1
sudo chown root:root mp3h1

echo "  #"
echo "  - Decoders"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/demod
cp $SIGPI_SOURCE/RS/ecc/bch_ecc.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.c .
cp $SIGPI_SOURCE/RS/demod/mod/bch_ecc_mod.h .
cp $SIGPI_SOURCE/RS/rs92/nav_gps_vel.c .
sudo gcc -c demod_dft.c
gcc rs41dm_dft.c demod_dft.o -lm -o rs41dm_dft
gcc dfm09dm_dft.c demod_dft.o -lm -o dfm09dm_dft
gcc m10dm_dft.c demod_dft.o -lm -o m10dm_dft
gcc lms6dm_dft.c demod_dft.o -lm -o lms6dm_dft
gcc rs92dm_dft.c demod_dft.o -lm -o rs92dm_dft
sudo chown root:root rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft
sudo cp rs41dm_dft dfm09dm_dft m10dm_dft lms6dm_dft rs92dm_dft /usr/local/bin

echo "  #"
echo "  - IQ"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/iq
gcc shift_IQ.c -lm -o shift_IQ
gcc wavIQ.c -lm -o wavIQ
sudo chown root:root shift_IQ wavIQ
sudo cp shift_IQ wavIQ /usr/local/bin

echo "  #"
echo "  - Scan"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/scan
#gcc -C dft_detect.c -lm -o dft_detect # Compile issues with line 88 and 93
gcc -C reset_usb.c -lm -o reset_usb
gcc -C rs_detect.c -lm -o rs_detect
gcc -C scan_fft_pow.c -lm -o scan_fft_pow
gcc -C scan_fft_simple.c -lm -o scan_fft_simple
sudo chown root:root reset_usb rs_detect scan_fft_pow scan_fft_simpl
sudo cp diff_detect reset_usb rs_detect scan_fft_pow scan_fft_simpl /usr/local/bin

echo "  #"
echo "  - Decod RS Module"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/rs_module
gcc -c rs_datum.c
gcc -c rs_demod.c
gcc -c rs_bch_ecc.c
gcc -c rs_rs41.c
gcc -c rs_rs92.c
gcc -c rs_main41.c
gcc rs_main41.o rs_rs41.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs41mod
gcc -c rs_main92.c
gcc rs_main92.o rs_rs92.o rs_bch_ecc.o rs_demod.o rs_datum.o -lm -o rs92mod
sudo chown root:root rs41mod rs92mod
sudo cp rs41mod rs92mod /usr/local/bin
	

echo "  #"
echo "  - Tools"
echo "  #"
echo " "
cd $SIGPI_SOURCE/RS/tools
#pa-stdout.c  compile issued with undfined references so skipping
#chown root:root metno_netcdf_gpx.py pos2pars.py pos2gpx.pl pos2kml.pl
sudo cp metno_netcdf_gpx.py pos2pars.py pos2gpx.pl pos2kml.pl postnmea.p1 /usr/local/bin

# Copy Menu items into relevant directories
#sudo cp $SIGPI_SOURCE/themes/desktop/xastir.desktop $DESKTOP_FILES
	
# Add SigPi Category for each installed application
#sudo sed -i "s/Categories.*/Categories=$SIGPI_MENU_CATEGORY;/" $DESKTOP_FILES/xastir.desktop

echo -e "${SIGPI_BANNER_COLOR}"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#   Installation Complete !!"
echo -e "${SIGPI_BANNER_COLOR} #SIGPI#"
echo -e "${SIGPI_BANNER_RESET}"