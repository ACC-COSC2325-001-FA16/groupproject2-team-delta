; ARDUINO_LED_BRIGHTNESS

#include <avr/io.h>
#include "config.inc"

        .section .text
        .global     main
        .extern     delay   
		.extern     timer_init		
        .org        0x0000
main:
        ; set up the stack
        ldi         r28, (RAMEND & 0x00ff)
        ldi         r29, (RAMEND >> 8)
        out         _SPH, r29
        out         _SPL, r28

        ; initilaize the chip for blinking
        call        init   	

loop:   
		
		rjmp	loop
		
		
init:   eor         r1, r1                  ; zero out the r1 register
        out         _SREG, r1               ; initialize the status reg
        ldi         r24, 0x80
        sts         CLKPR, r24              ; allow access to clock setup
        sts         CLKPR, r1               ; run at full speed       
       
	   ; set up the LED port for timer0 pin 5
        sbi         LED_DIR, LED_PIN        ; set LED pin to output
        cbi         LED_PORT, LED_PIN       ; start with the LED off
		
		; set up the LED port for timer2 pin 11
        sbi         LED_DIR1, LED_PIN1        ; set LED pin to output
        cbi         LED_PORT1, LED_PIN1       ; start with the LED off
		
		; set up PWM with timer0
		ldi		r18, ((1 << COM0A1) | (1 << COM0B1) | (1 << WGM01) | (1 << WGM00))
		out		_TCCR0A, r18
		ldi		r18, ((1 << WGM02) |(1<< CS00))
		out		_TCCR0B, r18
		ldi		r18, 255
		out		_OCR0A, r18
		ldi		r18, 255
		sts		_OCR0B, r18	
        ret

