# Description
This is a minimalistic template
for STM32L1xx project I've made after I've tried many old, outdated
and just messy ones and got fed up fixing them.

It requires arm-none-eabi-gcc to compile, and uses either `st-flash`
or `stm32flash` to program target microcontroller.

It also has a separate 'user application' source directory `src`,
where you should put your own sources to keep things clean. On each build,
makefile will search this directory recursively for your C sources,
so you don't need to add them manually anywhere.

This template was tested to work on fairly recent (at the time of writing)
Arch Linux (amd64, 4.2.5 kernel) with arm-none-eabi-gcc version 5.2.0. I can't guarantee
that it will work on different distro/OS, but it's sure the most hassle-free template I've ever had so far :)

# Useful `make` targets
* `all` generates executable and linkable format;
* `hex` generates ready to upload firmware in Intel HEX format;
* `st-flash` generates firmware in HEX format and attempts to upload it using `st-flash` utility;
* `stm32flash` generates firmware in binary format and attempts to upload it using `stm32flash`
utility using specified serial port and baudrate;
* `clean` removes object and compiled firmware files according to the makefile;
* `hard-clean` blindly removes **every signle object (*.o) file it will recursively find in project directory**.
It will also remove firmware files from the project root directory. This target is useful if you forgot to clean
your project before changing your makefile (i.e. excluded some module from build, and left its object file).
**Use with caution.**
