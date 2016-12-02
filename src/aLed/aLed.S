; aLed.S
; Authors: Team Delta
; Date: December 1, 2016

#include "config.inc"

    .section    .text
    .org        0x00
    .extern     timer_init
    .extern     timer_delay

    .global     main

main:
; set stack to top of available ram
    ldi         r28, (RAMEND & 0x00ff)
    ldi         r29, (RAMEND >> 8)
    out         _SPH, r29
    out         _SPL, r28


    call        Init            ; complete initialization


1:  call        Toggle          ; flip LED on/off
    call        timer_delay     ; wait a bit
    rjmp        1b              ; loop forever


Init:
    ; set up a register with zero for convenience
    eor         r1, r1          ; cheap zero

    ; clear flag register
    out         _SREG, r1

    ; set up the system clock
    ldi         r24, 0x80       ; set up prescaler
    sts         CLKPR, r24
    sts         CLKPR, r1       ; run at full speed

    ; setup the led pin
    sbi         LED_DIR, LED_PIN  ; set pin 5 on port B for output
    cbi         LED_PORT, LED_PIN ; set pin 5 on port B off

    call        timer_init      ; set up the timer
    ret


Toggle:
    in          r24, LED_PORT          ; get current port B values
    ldi         r25, (1 << LED_PIN)    ; LED pin number
    eor         r24, r25               ; toggle bit
    out         LED_PORT, r24          ; write it back in place
    ret

