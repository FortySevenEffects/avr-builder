# Kudos:
# https://github.com/vyivanov/avr-docker/blob/master/Dockerfile
# https://github.com/NicoHood/AVR-Development-Environment-Script/blob/master/build.sh
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

# Binutils layer (with avr-size patch)
RUN echo "\033[1;32mBuilding binutils...\033[0m"                                \
 && wget -qO- http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2 | tar -xj   \
 && cd binutils-2.28                                                            \
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
 && cd ../.. && rm -rf binutils-2.28                                            \
 && avr-ld      -V                                                              \
 && avr-objdump --version                                                       \
 && avr-objcopy --version                                                       \
 && avr-size    --version

# AVR-GCC Layer
RUN echo "\033[1;32mBuilding AVR-GCC...\033[0m"                                 \
 && wget -qO- ftp://ftp.lip6.fr/pub/gcc/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2    \
  | tar -xj                                                                     \
 && cd gcc-6.3.0                                                                \
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
 && cd ../.. && rm -rf gcc-6.3.0                                                \
 && avr-gcc --version

# Cleanup GCC (to merge with previous if successful)
#RUN find /usr/local/avr/lib -type f -name "*.a"                                 \
#        -exec /usr/local/avr/bin/avr-strip --strip-debug '{}' \;                \
# && rm -rf /usr/local/avr/share/man/man7                                        \
# && rm -rf /usr/local/avr/share/info                                            \

# AVR-Libc Layer
RUN echo "\033[1;32mBuilding AVR libc...\033[0m"                                \
 && wget -qO- http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
  | tar -xj                                                                     \
 && cd avr-libc-2.0.0                                                           \
 && mkdir build && cd build                                                     \
 && CC=/usr/local/avr/bin/avr-gcc ../configure                                  \
    --prefix=/usr/local/avr                                                     \
    --build=$(../config.guess)                                                  \
    --host=avr                                                                  \
 && make && make install                                                        \
 && cd ../.. && rm -rf avr-libc-2.0.0

# Cleanup
RUN echo "\033[1;32mCleaning up...\033[0m"                                      \
 && apt-get remove --purge -y                                                   \
            build-essential                                                     \
            ca-certificates                                                     \
            wget                                                                \
 && apt-get autoremove -y                                                       \
 && apt-get clean                                                               \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /build
