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

# Warning
I'm not really sure what's going on in the linker script I've mentioned above. By default, it had
FLASH and RAM sizes set to 128K and 16K accordingly, even though STM32L152R8T6 (that I'm using in
my own project) only has 10K of RAM (according to the datasheet). Different sources specify
different figures for some bizarre reason :\
* http://www.st.com/web/en/resource/technical/document/datasheet/CD00277537.pdf, page 11 implies that
it has 64K of FLASH and 10K of SRAM;
* http://uk.rs-online.com/web/p/microcontrollers/7957568/ implies that it has 128K of FLASH and 16K of SRAM;
* http://ru.mouser.com/ProductDetail/STMicroelectronics/STM32L152R8T6/?qs=G0rgft3hAxKHKmHne1A%252bnw%3d%3d - 64K FLASH, 16K SRAM.
* My own chip shows up in stm32flash as having 16K of SRAM and 128K of FLASH. Go figure.
 
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
