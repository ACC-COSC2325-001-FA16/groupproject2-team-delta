; configuration for blink
#include <avr/io.h>
#include "include/AVRSpecialRegs.inc"

#define LED_PIN     5
#define LED_DIR     _DDRD
#define LED_PORT    _PORTD

#define LED_PIN1    7
#define LED_DIR1     _DDRD
#define LED_PORT1    _PORTD

#define BUTTON_PIN_UP   0
#define BUTTON_PIN_DOWN 1