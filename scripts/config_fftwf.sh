#!/bin/bash

###
### SIGpi
###
### config_fftwf
###

cd $HOME/.config/
mkdir f4exb
cd f4exb
# Generate a new wisdom file for FFT sizes : 128, 256, 512, 1024, 2048, 4096, 8192, 16384 and 32768.
# This will take a very long time.
fftwf-wisdom -v -n -o fftw-wisdom 128 256 512 1024 2048 4096 8192 16384 32768
echo "fftwf-wisdom" >> $SIGPI_CONFIG 




