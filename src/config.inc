; configuration for blink
#include <avr/io.h>
#include "./include/AVRSpecialRegs.inc"

#define LED_B    3
#define LED_R     5
#define LED_G    6
#define LED_DIR     _DDRD
#define LED_PORT    _PORTD


;#define BUTTON_PIN     0
;#define BUTTON_DIR     _DDRB
;#define BUTTON_PORT    _PORTB