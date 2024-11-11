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

[Wokwi preview - running blinkly from RP2040-dlang](https://wokwi.com/experimental/viewer?diagram=https%3A%2F%2Fraw.githubusercontent.com%2Fkassane%2Frp2040-dlang%2Frefs%2Fheads%2Fmain%2Fdiagram.json&firmware=https%3A%2F%2Fgithub.com%2Fkassane%2Frp2040-dlang%2Freleases%2Fdownload%2Fv1.0.0%2Fd-blinky-rp2040.uf2)