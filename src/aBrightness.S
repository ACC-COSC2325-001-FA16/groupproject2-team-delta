; Brightness
; Author: Danh Pham, Samuel Bowker, Micheal Harper	
; Date: 11/28/2016

#include <avr/io.h>
#include "config.inc"
;#define __SFR_OFFSET        0

		.extern Timer1Setup
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

; Polling Loop
loop:   
		sbic    _PINB, 0        ; skips rjmp if button isn't being pressed
		rjmp    bright_up       ; If button is pressed, skip to increasing the brightness
        
        sbic    _PINB, 1        ; skips rjmp if button isn't being pressed
        rjmp    bright_down     ; If button is pressed, skip to decreasing the brightness
        rjmp    loop
        
bright_up:        
        in      r18, _OCR0B     ; copy timer compare register
       
        inc     r18             ; increase by one
        out     _OCR0B, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
        
bright_down:        
        in      r18, _OCR0B     ; copy timer compare register
        dec     r18             
        out     _OCR0B, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
		
		
init:   eor         r1, r1                  ; zero out the r1 register
        out         _SREG, r1               ; initialize the status reg
        ldi         r24, 0x80
        sts         CLKPR, r24              ; allow access to clock setup
        sts         CLKPR, r1               ; run at full speed       
       
	    ; set up the LED port
        sbi         LED_DIR, LED_PIN        ; set LED pin to output
        sbi         LED_PORT, LED_PIN       ; start with the LED on
		
		 ; set up the LED port
        ;sbi         LED_DIR1, LED_PIN1        ; set LED pin to output
        ;cbi         LED_PORT1, LED_PIN1       ; start with the LED off
		
		;set up ADC
	
		;ldi		r19, (1 << ADPS2)
		;out		_ADCSRA, r19
		;sbi		_ADCSRA, ADATE
		;ldi 	r19, ((1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0) | (1 << ADATE) | (1 << ADEN) | (1 << ADSC))
		
		;out	_ADCSRA , r19
		;ldi	r19, ((1 << REFS0) | (1 << ADLAR))
		;out 	_ADMUX, r19
		;ldi		r19, (1 << ADFR)
		;or		_ADCSRA, r19
		;ldi		r19, (1 << ADEN)
		;or		ADCSRA, r19
		;ldi		r19, (1 << ADSC)
		;or		ADCSRA, r19
		
		; set up PWM with timer0
		ldi		r18, ((1 << COM0A1) | (1 << COM0B1) | (1 << WGM01) | (1 << WGM00))
		out		_TCCR0A, r18
		ldi		r18, ((1 << WGM02) |(1<< CS00))
		out		_TCCR0B, r18
		ldi		r18, 255
		out		_OCR0A, r18
		ldi		r18, 10
		out		_OCR0B, r18
	
		
        ret

toggle:
        in          r24, LED_PORT1           ; get current bits
        ldi         r25, (1 << LED_PIN1)     ; LED is pin 5
        eor         r24, r25                ; flip the bit
        out         LED_PORT1, r24           ; write the bits back
        ret
