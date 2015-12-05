#include "leds.h"

/* This is a simple 'library' to test my Makefile */

GPIO_InitTypeDef GPIOA_init_params;

void init_leds()
{
	/* Set up GPIO structure and LED initial state */
	GPIOA_init_params.GPIO_Pin = GPIO_Pin_11;
	GPIOA_init_params.GPIO_Speed = GPIO_Speed_10MHz;
	GPIOA_init_params.GPIO_OType = GPIO_OType_PP;
	GPIOA_init_params.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_Init(GPIOA, &GPIOA_init_params);
};

void set_led(int val) {
	if(val) {
		GPIO_SetBits(GPIOA, GPIO_Pin_11);
	} else {
		GPIO_ResetBits(GPIOA, GPIO_Pin_11);
	};
};
