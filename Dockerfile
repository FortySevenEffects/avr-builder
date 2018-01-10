# Kudos:
# https://github.com/vyivanov/avr-docker/blob/master/Dockerfile
# https://github.com/NicoHood/AVR-Development-Environment-Script/blob/master/build.sh
# Updated with latest versions of each tool (at the time of writing).
# Note: avrdude is not present as not all Docker environments can forward the USB
# stack of the host to the VM (macOS). It will have to be installed on the host.

FROM debian:jessie

ENV PATH /usr/local/avr/bin:$PATH

LABEL                   \
    cmake="3.10.1"      \
    binutils="2.29.1"   \
    avrgcc="7.2.0"      \
    avrlibc="2.0.0"

RUN apt-get update && apt-get install -y --no-install-recommends                \
            build-essential                                                     \
            ca-certificates                                                     \
            libgmp3-dev                                                         \
            libmpc-dev                                                          \
            libmpfr-dev                                                         \
            make                                                                \
            wget                                                                \
# CMake Layer
 && echo "\033[1;32mInstalling CMake...\033[0m"                                 \
 && mkdir -p /opt/cmake                                                         \
 && wget -q https://cmake.org/files/v3.10/cmake-3.10.1-Linux-x86_64.sh          \
 && sh cmake-3.10.1-Linux-x86_64.sh --prefix=/opt/cmake --skip-license          \
 && ln -s /opt/cmake/bin/cmake  /usr/local/bin/cmake                            \
 && ln -s /opt/cmake/bin/ccmake /usr/local/bin/ccmake                           \
 && ln -s /opt/cmake/bin/ctest  /usr/local/bin/ctest                            \
 && rm -f /opt/cmake/bin/cmake-gui                                              \
 && rm -rf /opt/cmake/doc /otp/cmake/man                                        \
 && rm cmake-3.10.1-Linux-x86_64.sh                                             \
 && cmake --version                                                             \
# Binutils layer (with avr-size patch)
 && echo "\033[1;32mBuilding binutils...\033[0m"                                \
 && mkdir -p /usr/local/avr                                                     \
 && wget -qO- http://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.bz2 | tar -xj \
 && cd binutils-2.29.1                                                          \
 && wget -qO 01-avr-size.patch https://projects.archlinux.org/svntogit/community.git/plain/trunk/avr-size.patch?h=packages/avr-binutils \
 && patch -Np0 < 01-avr-size.patch                                              \
 && mkdir build && cd build                                                     \
 && ../configure                                                                \
    --prefix=/usr/local/avr                                                     \
    --target=avr                                                                \
    --disable-nls                                                               \
    --enable-gold                                                               \
    --enable-ld=default                                                         \
    --enable-plugins                                                            \
    --enable-threads                                                            \
    --with-pic                                                                  \
    --enable-lto                                                                \
    --disable-shared                                                            \
    --disable-multilib                                                          \
 && make && make install                                                        \
 && cd ../.. && rm -rf binutils-2.29.1                                          \
 && avr-ld      -V                                                              \
 && avr-objdump --version                                                       \
 && avr-objcopy --version                                                       \
 && avr-size    --version                                                       \
# AVR-GCC Layer
 && echo "\033[1;32mBuilding AVR-GCC...\033[0m"                                 \
 && wget -qO- ftp://ftp.lip6.fr/pub/gcc/releases/gcc-7.2.0/gcc-7.2.0.tar.gz     \
  | tar -xz                                                                     \
 && cd gcc-7.2.0                                                                \
 && mkdir build && cd build                                                     \
 && ../configure                                                                \
    --prefix=/usr/local/avr                                                     \
    --target=avr                                                                \
    --disable-__cxa_atexit                                                      \
    --disable-doc                                                               \
    --disable-install-libiberty                                                 \
    --disable-libada                                                            \
    --disable-libssp                                                            \
    --disable-libstdcxx-pch                                                     \
    --disable-libunwind-exceptions                                              \
    --disable-nls                                                               \
    --disable-plugin                                                            \
    --disable-shared                                                            \
    --enable-checking=release                                                   \
    --enable-clocale=gnu                                                        \
    --enable-fixed-point                                                        \
    --enable-gnu-unique-object                                                  \
    --enable-gold                                                               \
    --enable-languages=c,c++                                                    \
    --enable-long-long                                                          \
    --enable-lto                                                                \
    --with-avrlibc=yes                                                          \
    --with-dwarf2                                                               \
    --with-gnu-ld                                                               \
 && make && make install                                                        \
 && cd ../.. && rm -rf gcc-7.2.0                                                \
 && find /usr/local/avr/lib -type f -name "*.a"                                 \
        -exec /usr/local/avr/bin/avr-strip --strip-debug '{}' \;                \
 && rm -rf /usr/local/avr/share/man/man7                                        \
 && rm -rf /usr/local/avr/share/info                                            \
 && avr-gcc --version                                                           \
# AVR-Libc Layer
 && echo "\033[1;32mBuilding AVR libc...\033[0m"                                \
 && wget -qO- http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
  | tar -xj                                                                     \
 && cd avr-libc-2.0.0                                                           \
 && mkdir build && cd build                                                     \
 && CC=/usr/local/avr/bin/avr-gcc ../configure                                  \
    --prefix=/usr/local/avr                                                     \
    --build=$(../config.guess)                                                  \
    --host=avr                                                                  \
 && make && make install                                                        \
 && cd ../.. && rm -rf avr-libc-2.0.0                                           \
# Cleanup
 && echo "\033[1;32mCleaning up...\033[0m"                                      \
 && for name in $(find /usr/local/avr/avr/bin -exec basename {} \;);            \
        do ln -s /usr/local/avr/bin/avr-$name /usr/local/avr/bin/$name;         \
    done                                                                        \
 && rm -rf /usr/local/avr/avr/bin                                               \
 && apt-get remove --purge -y                                                   \
            build-essential                                                     \
            ca-certificates                                                     \
            wget                                                                \
 && apt-get autoremove -y                                                       \
 && apt-get clean                                                               \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
