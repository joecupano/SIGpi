FROM arm32v7/ubuntu

# Install dependencies
RUN apt-get update && apt-get install git cmake pkg-config libusb-1.0-0-dev -y

# Get driver repository
RUN git clone git://git.osmocom.org/rtl-sdr.git

# Compile drivers
RUN cd rtl-sdr && \
        mkdir build && \
        cd build && \
        cmake ../ -DINSTALL_UDEV_RULES=ON && \
        make && \
        make install && \
        ldconfig

# Execute RTL server
ENTRYPOINT ["rtl_tcp", "-a", "0.0.0.0"]
