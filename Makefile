BIN=stm32l1xx_template

# Tools definitions
TOOLS_PATH=/usr
TOOLS_PREFIX=arm-none-eabi-
TOOLS_VERSION=5.2.0
CC=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)gcc-$(TOOLS_VERSION)
OBJCOPY=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)objcopy
AS=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)as
SIZE=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)size
STRIP=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)strip

# CMSIS
CMSIS_DIR=./cmsis
CMSIS_SRC=./cmsis/core_cm3.h
CMSIS_HEADER=./stm32l1xx.h
CMSIS_OUT=$(CMSIS_SRC)

# Bootloader vars
UART=/dev/ttyACM0
BAUD=115200

# stm32*_conf.h file (with directory)
STM_CONF=./stm32l1xx_conf.h

# Ordinary source directory
SRC_DIR=./src
SRC=$(shell find $(SRC_DIR) -name '*.c')
SRC_OBJS:=$(SRC:%.c=%.c.o)

# StdPeripheralLibrary directory and files
# Right now it compiles the entire library, but you 
STD_DIR=./stdperiphlib
# Uncomment this if you want to compile absolutely everything
#STD=$(shell find $(STD_DIR) -name '*.c')
# Or uncomment only certain modules
STD=./stdperiphlib/system_stm32l1xx.c

STD+=./stdperiphlib/stm32l1xx_adc.c
#STD+=./stdperiphlib/stm32l1xx_iwdg.c
#STD+=./stdperiphlib/stm32l1xx_sdio.c
#STD+=./stdperiphlib/stm32l1xx_flash_ramfunc.c
#STD+=./stdperiphlib/stm32l1xx_usart.c
#STD+=./stdperiphlib/stm32l1xx_dbgmcu.c
#STD+=./stdperiphlib/stm32l1xx_dac.c
STD+=./stdperiphlib/stm32l1xx_gpio.c
#STD+=./stdperiphlib/stm32l1xx_lcd.c
#STD+=./stdperiphlib/stm32l1xx_flash.c
#STD+=./stdperiphlib/stm32l1xx_aes.c
#STD+=./stdperiphlib/stm32l1xx_syscfg.c
STD+=./stdperiphlib/misc.c
#STD+=./stdperiphlib/stm32l1xx_i2c.c
STD+=./stdperiphlib/stm32l1xx_rcc.c
STD+=./stdperiphlib/stm32l1xx_it.c
#STD+=./stdperiphlib/stm32l1xx_exti.c
#STD+=./stdperiphlib/stm32l1xx_opamp.c
#STD+=./stdperiphlib/stm32l1xx_wwdg.c
#STD+=./stdperiphlib/stm32l1xx_aes_util.c
#STD+=./stdperiphlib/stm32l1xx_dma.c
#STD+=./stdperiphlib/stm32l1xx_tim.c
#STD+=./stdperiphlib/stm32l1xx_comp.c
#STD+=./stdperiphlib/stm32l1xx_fsmc.c
#STD+=./stdperiphlib/stm32l1xx_pwr.c
#STD+=./stdperiphlib/stm32l1xx_crc.c
#STD+=./stdperiphlib/stm32l1xx_spi.c
#STD+=./stdperiphlib/stm32l1xx_rtc.c
STD_OBJS:=$(STD:%.c=%.c.o)

# Startup file
STARTUP=./stdperiphlib/device_support/gcc/startup_stm32l1xx_md.s
STARTUP_OUT=$(STARTUP:%.s=%.s.o)

# Compiler flags
CFLAGS=-c -mcpu=cortex-m3 -mthumb -Wall -O2 -mapcs-frame -D__thumb2__=1 
CFLAGS+=-msoft-float -gdwarf-2 -mno-sched-prolog -fno-hosted -mtune=cortex-m3 
CFLAGS+=-march=armv7-m -mfix-cortex-m3-ldrd -ffunction-sections -fdata-sections -Wl,--gc-sections 
CFLAGS+=-I$(CMSIS_DIR) -I$(SRC_DIR) -I$(STD_DIR) -I. -include $(STM_CONF) 
# Recent CMSIS doesn't have a core_cm3.c file, and also requies CMSIS header file to be included
CCMSISFLAGS=-I$(CMSIS_DIR) -include $(CMSIS_HEADER) -include $(CMSIS_SRC)

#assembler flags
ASFLAGS=-mcpu=cortex-m3 -I$(CMSIS_DIR) -I$(STD_DIR) -gdwarf-2 -gdwarf-2 

# linker script
LINK_SCRIPT=./stdperiphlib/device_support/gcc/STM32L152VB_FLASH.ld

#linker flags
LDFLAGS=-static -mcpu=cortex-m3 -mthumb 
LDFLAGS+=-mthumb-interwork -Wl,--start-group 
LDFLAGS+=-L$(TOOLS_PATH)/lib/gcc/arm-none-eabi/$(TOOLS_VERSION)/thumb2 
LDFLAGS+=-L$(TOOLS_PATH)/arm-none-eabi/lib/thumb2 -lc -lg -lstdc++ -lsupc++ -lgcc -lm 
LDFLAGS+=--specs=nosys.specs 
LDFLAGS+=-Wl,--end-group -Xlinker -Map -Xlinker $(BIN).map -Xlinker 
LDFLAGS+=-T $(LINK_SCRIPT) -o $(BIN).elf

#OBJS=$(SRC_OBJS) $(STARTUP_OUT) $(CMSIS_OUT) $(STD_OBJS)
OBJS=$(SRC_OBJS) $(STARTUP_OUT) $(STD_OBJS)

%.s.o: %.s
	echo $(STARTUP_OUT)
	$(AS) $(ASFLAGS) $*.s -o $*.s.o

%.c.o: %.c
	$(CC) $(CFLAGS) $*.c -o $*.c.o

all: $(SRC_OBJS) $(STD_OBJS) $(STARTUP_OUT)
	$(CC) $(OBJS) $(LDFLAGS)
	$(SIZE) $(BIN).elf
	
$(BIN).elf: all

$(BIN).bin: $(BIN).elf
	$(OBJCOPY) -O binary $(BIN).elf $(BIN).bin	
	
$(BIN).hex: $(BIN).elf
	$(OBJCOPY) -O ihex $(BIN).elf $(BIN).hex

hex: $(BIN).hex

st-flash: $(BIN).bin
	st-flash write $(BIN).bin 0x8000000

stm32flash: $(BIN).hex
	stm32flash -b $(BAUD) -v -w $(BIN).hex $(UART) 
	
clean:
	rm -f $(OBJS) $(BIN).hex $(BIN).bin $(BIN).elf $(BIN).map
	
# This target removes ALL OBJECT, BINARY and MAP files from the entire project. Use with caution.
hard-clean:
	rm -f $(shell find . -name '*.o') $(BIN).hex $(BIN).bin $(BIN).elf $(BIN).map
