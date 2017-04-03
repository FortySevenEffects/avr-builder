# Kudos: https://github.com/vyivanov/avr-docker/blob/master/Dockerfile
# Updated with latest versions of each tool (at the time of writing).

FROM debian:jessie

ENV PATH $PATH:/usr/local/avr/bin:/usr/local/bin

RUN apt-get update && apt-get install -y --no-install-recommends                \
            build-essential                                                     \
            ca-certificates                                                     \
            libgmp3-dev                                                         \
            libmpc-dev                                                          \
            libmpfr-dev                                                         \
            make                                                                \
            wget

# CMake Layer
RUN echo "\033[1;32mInstalling CMake...\033[0m"                                 \
 && wget -q https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.sh            \
 && mkdir -p /opt/cmake                                                         \
 && sh cmake-3.7.2-Linux-x86_64.sh --prefix=/opt/cmake --skip-license           \
 && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake                             \
 && rm cmake-3.7.2-Linux-x86_64.sh                                              \
 && cmake --version

# Binutils layer
RUN echo "\033[1;32mBuilding binutils...\033[0m"                                \
 && wget -qO- http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2 | tar -xj   \
 && cd binutils-2.28                                                            \
 && mkdir build && cd build                                                     \
 && ../configure --prefix=/usr/local/avr --target=avr --disable-nls             \
 && make && make install                                                        \
 && cd ../.. && rm -rf binutils-2.28                                            \
 && avr-ld      -V                                                              \
 && avr-objdump --version                                                       \
 && avr-objcopy --version                                                       \
 && avr-size    --version

# AVR-GCC Layer
RUN echo "\033[1;32mBuilding AVR-GCC...\033[0m"                                 \
 && wget -O- ftp://ftp.lip6.fr/pub/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2     \
  | tar -xj                                                                     \
 && cd gcc-6.3.0                                                                \
 && mkdir build && cd build                                                     \
 && ../configure                                                                \
    --prefix=/usr/local/avr                                                     \
    --target=avr                                                                \
    --enable-languages=c,c++                                                    \
    --disable-nls                                                               \
    --disable-libssp                                                            \
    --with-dwarf2                                                               \
 && make && make install                                                        \
 && cd ../.. && rm -rf gcc-6.3.0                                                \
 && avr-gcc --version

# AVR-Libc Layer
RUN echo "\033[1;32mBuilding AVR libc...\033[0m"                                \
 && wget -qO- http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
  | tar -xj                                                                     \
 && cd avr-libc-2.0.0                                                           \
 && mkdir build && cd build                                                     \
 && ../configure --prefix=/usr/local/avr --build=`../config.guess` --host=avr   \
 && make && make install                                                        \
 && cd ../.. && rm -rf avr-libc-2.0.0

# Cleanup
RUN echo "\033[1;32mCleaning up...\033[0m"                                      \
 && apt-get remove -y                                                           \
            build-essential                                                     \
            ca-certificates                                                     \
            libgmp3-dev                                                         \
            libmpc-dev                                                          \
            libmpfr-dev                                                         \
            wget                                                                \
 && apt-get autoremove -y                                                       \
 && apt-get clean                                                               \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
