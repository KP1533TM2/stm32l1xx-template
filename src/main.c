#include "simple_led_lib/leds.h"

void RCC_init() {
  /* enable clocking on Port A */
  RCC_AHBPeriphClockCmd(RCC_AHBENR_GPIOAEN, ENABLE);
}

int main(void) {
	RCC_init();
	init_leds();
	int x = 0;
	while (1) {
		set_led(x&1);
		x++;
		volatile int delay = 400000;
		while(delay--);
	}
}
