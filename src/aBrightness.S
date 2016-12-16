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


loop:    
	sbic    _PINB, 0        ; skips rjmp if button isn't being pressed
	rjmp    bright_up_r       ; If button is pressed, skip to increasing the brightness
        
        sbic    _PINB, 1        ; skips rjmp if button isn't being pressed
        rjmp    bright_down_r     ; If button is pressed, skip to decreasing the brightness
		
		
	sbic    _PINB, 2        ; skips rjmp if button isn't being pressed
	rjmp    bright_up_g       ; If button is pressed, skip to increasing the brightness
        
        sbic    _PINB, 3        ; skips rjmp if button isn't being pressed
        rjmp    bright_down_g    ; If button is pressed, skip to decreasing the brightness
		
        
	sbic    _PINB, 4        ; skips rjmp if button isn't being pressed
	rjmp    bright_up_b       ; If button is pressed, skip to increasing the brightness
        
        sbic    _PINB, 5        ; skips rjmp if button isn't being pressed
        rjmp    bright_down_b    ; If button is pressed, skip to decreasing the brightness
		
        rjmp    loop
        
bright_up_r:        
        in     r18, _OCR0B     ; copy timer compare register
        cpi     r18, 255        ; prevent overflow wrap-around
        breq    loop
        inc     r18             ; increase by one
        out     _OCR0B, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
        
bright_down_r:        
        in      r18, _OCR0B    ; copy timer compare register
        cpi     r18, 0          ; prevent overflow wrap-around
        breq    loop
        dec     r18             
        out     _OCR0B, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
		
bright_up_g:        
        in     r18, _OCR0A     ; copy timer compare register
        cpi     r18, 255        ; prevent overflow wrap-around
        breq    loop
        inc     r18             ; increase by one
        out     _OCR0A, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
        
bright_down_g:        
        in      r18, _OCR0A    ; copy timer compare register
        cpi     r18, 0          ; prevent overflow wrap-around
        breq    loop
        dec     r18             
        out     _OCR0A, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop

bright_up_b:        
        lds     r18, 0xB4     ; copy timer compare register
        cpi     r18, 255        ; prevent overflow wrap-around
        breq    loop
        inc     r18             ; increase by one
        sts     0xB4, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop
        
bright_down_b:        
        lds      r18, 0xB4    ; copy timer compare register
        cpi     r18, 0          ; prevent overflow wrap-around
        breq    loop
        dec     r18             
        sts     0xB4, r18     ; write cmp reg back 
        call    delay           ; delay some, otherwise otherwise PWM increases by too much per press
		rjmp	loop


		
		
init:  
	eor         r1, r1                  ; zero out the r1 register
        out         _SREG, r1               ; initialize the status reg
        ldi         r24, 0x80
        sts         CLKPR, r24              ; allow access to clock setup
        sts         CLKPR, r1               ; run at full speed       
       
	    ; set up the RED LED port
        sbi         LED_DIR, LED_R        ; set LED pin to output
        sbi         LED_PORT, LED_R       ; start with the LED on
		
		; set up the GREEN LED port
        sbi         LED_DIR, LED_G      ; set LED pin to output
        sbi         LED_PORT, LED_G       ; start with the LED on
		
		; set up the BLUE LED port
        sbi         LED_DIR, LED_B        ; set LED pin to output
        sbi         LED_PORT, LED_B       ; start with the LED on
		
		
		
	; set up Fast PWM with timer0
	ldi			r18, ((1 << COM0A1) | (1 << COM0B1) | (1 << WGM01) | (1 << WGM00))		; Clear OC0A/OC0B on Compare Match, and
	out			_TCCR0A, r18															; set OC0A/OC0B on BOTTOM
	;ldi		r18, ((1 << WGM02) |(1<< CS00))
	ldi			r18, (1<< CS00)								;no prescaling (16 Mhz)
	out			_TCCR0B, r18
	ldi			r18, 255			; change the brightness of GREEN LED									
	out			_OCR0A, r18
	ldi			r18, 255			; change the brightness of RED LED
	out			_OCR0B, r18

	eor		r18, r18
	; set up Fast PWM with timer2
	ldi			r18, ((1 << COM2A1) | (1 << COM2B1) | (1 << WGM21) | (1 << WGM20))	; Clear OC2A/OC2B on Compare Match, and						
	sts			0xB0, r18								; set OC2A/OC2B on BOTTOM
	ldi			r18, (1<< CS20)								;no prescaling (16 Mhz)
	sts			0xB1, r18
	ldi			r18, 255			; pin PD3 for Compare Match B Timer2 BIRGHTNESS BLUE		
	sts			0xB4, r18
        ret

