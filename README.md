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

# Things to customize
* Project name in the `BIN` variable;
* Set `TOOLS_PATH`. `TOOLS_PREFIX`, `TOOLS_VERSION` and check the rest
of the tools definitions according to your compiler;
* Check `UART` and `BAUD`, if you're using serial connection and stm32flash;
* `STD` variable that contains STDPeripheralLibrary modules required by
your project;
* Check `STARTUP` variable and set it according to your device family.
You'll find the list of families and devices in the comments of `stm32l1xx.h.`
file, where you also need to uncomment corresponding device family `#define`. 
* Take a look at the `stdperiphlib/device_support/gcc/STM32L152VB_FLASH.ld` linker script,
you might need to change memory sizes, or completely replace it according to your microcontroller.

# Sample program
I've made this template for my own barebone STM32L152R8T6 prototype board. 
With this template I've included a simple 'Hello world' blink program,
that will slowly blink a LED on PA11. You can compile this sample to test
if you have your compiler properly installed on your system and properly
configured (i.e. path and version) in the makefile.

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
