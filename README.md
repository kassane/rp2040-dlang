# rp2040-dlang

Use D programming language in Raspberry Pi Pico and other RP2040 boards

## Requirements

- [Raspberry Pi Pico SDK](https://github.com/raspberrypi/pico-sdk)
- [ARM GCC toolchain](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [D compiler](https://dlang.org/download.html)
- [CMake](https://cmake.org/download/)

## How to build

```bash
git clone https://github.com/raspberrypi/pico-sdk.git
export PICO_SDK_PATH=$PWD/pico-sdk
export PICO_PLATFORM=rp2040
```

```bash
git clone https://github.com/kazuki-yoshii/rp2040-dlang.git
cd rp2040-dlang
cmake -B build
cmake --build build
```