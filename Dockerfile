# Kudos: https://github.com/vyivanov/avr-docker/blob/master/Dockerfile
# Updated with latest versions of each tool (at the time of writing).

FROM debian:jessie

ENV PATH $PATH:/usr/local/avr/bin

# Simple: install from packages 

RUN apt-get update && apt-get install -y --no-install-recommends \
    make            \
    cmake           \
    avr-libc        \
    avrdude         \
    binutils-avr    \
    gcc-avr         \

# Variant: build from source

# RUN \
#     #### install build tools ####
#     apt-get install -y --no-install-recommends \
#                               wget                               \
#                               make                               \
#                               build-essential                    \
#                               libmpc-dev                         \
#                               libmpfr-dev                        \
#                               libgmp3-dev                        \
#  && mkdir /usr/local/avr /opt/distr && cd /opt/distr \
#     #### build and install cmake-3.7.2 ####
#  && echo "\033[1;32mBuilding CMake...\033[0m" \
#  && wget https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz --no-check-certificate \
#  && tar -zxvf cmake-3.7.2.tar.gz && cd cmake-3.7.2 \
#  && ./bootstrap && make && make install && cd .. \
#     #### build and install binutils-2.28 ####
#  && echo "\033[1;32mBuilding binutils...\033[0m" \
#  && wget http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2 \
#  && bunzip2 -c binutils-2.28.tar.bz2 | tar xf - && cd binutils-2.28 \
#  && mkdir build && cd build \
#  && ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
#  && make && make install && cd ../.. \
#     #### build and install gcc-6.3.0 ####
#  && echo "\033[1;32mBuilding GCC...\033[0m" \
#  && wget ftp://ftp.lip6.fr/pub/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2 \
#  && bunzip2 -c gcc-6.3.0.tar.bz2 | tar xf - && cd gcc-6.3.0 \
#  && mkdir build && cd build \
#  && ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
#  && make && make install && cd ../.. \
#     #### build and install libc-2.0.0 ####
#  && echo "\033[1;32mBuilding AVR libc...\033[0m" \
#  && wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
#  && bunzip2 -c avr-libc-2.0.0.tar.bz2 | tar xf - && cd avr-libc-2.0.0 \
#  && ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr \
#  && make && make install && cd .. \
#     #### clean up the image ####
#  && echo "\033[1;32mCleaning up...\033[0m" \
#  && cd .. && rm -rf distr   \
#  && apt-get remove -y       \
#             wget            \
#             build-essential \
#  && apt-get autoremove -y   \
#  && apt-get clean           \
#  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*