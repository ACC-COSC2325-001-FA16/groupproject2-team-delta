; configuration for blink
#include <avr/io.h>
#include "../include/AVRSpecialRegs.inc"

#define LED_PIN     5
#define LED_DIR     _DDRD
#define LED_PORT    _PORTD

#define LED_PIN1     3
#define LED_DIR1     _DDRD
#define LED_PORT1    _PORTD


;#define BUTTON_PIN     0
;#define BUTTON_DIR     _DDRB
;#define BUTTON_PORT    _PORTB