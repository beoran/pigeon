#ifndef PI_H
#define PI_H

#include <stdlib.h>
#include <stdint.h>

#include <avr/pgmspace.h>
#include <util/delay.h>

#if defined(ARDUINO) && ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
#endif


#define PORTMSK_AT_PIN_0      _BV(0)  /* 0  port D */
#define PORTMSK_AT_PIN_1      _BV(1) 
#define PORTMSK_AT_PIN_2      _BV(2) 
#define PORTMSK_AT_PIN_3      _BV(3) 
#define PORTMSK_AT_PIN_4      _BV(4) 
#define PORTMSK_AT_PIN_5      _BV(5) 
#define PORTMSK_AT_PIN_6      _BV(6) 
#define PORTMSK_AT_PIN_7      _BV(7) 
#define PORTMSK_AT_PIN_8      _BV(0)  /* 8  port B */
#define PORTMSK_AT_PIN_9      _BV(1) 
#define PORTMSK_AT_PIN_10     _BV(2) 
#define PORTMSK_AT_PIN_11     _BV(3) 
#define PORTMSK_AT_PIN_12     _BV(4) 
#define PORTMSK_AT_PIN_13     _BV(5) 
#define PORTMSK_AT_PIN_14     _BV(0)  /* 14  port C */
#define PORTMSK_AT_PIN_15     _BV(1) 
#define PORTMSK_AT_PIN_16     _BV(2) 
#define PORTMSK_AT_PIN_17     _BV(3) 
#define PORTMSK_AT_PIN_18     _BV(4) 
#define PORTMSK_AT_PIN_19     _BV(5) 

#define PORTMSK_AT_PIN_20     _BV(6) 
#define PORTMSK_AT_PIN_21     _BV(7) 
#endif 
////////////PORT to DDRX mapping
#define DIR_REG_AT_PortA DDRA

#define DIR_REG_AT_PortB DDRB

#if defined(__AVR_ATtiny2313__)  
//no PortC on tiny2313
#else
#define DIR_REG_AT_PortC DDRC
#endif

#define DIR_REG_AT_PortD DDRD

////////////PORT to PORTX mapping
#define OUTPUT_REG_AT_PortA PORTA
#define OUTPUT_REG_AT_PortB PORTB

#if defined(__AVR_ATtiny2313__)  
//no PortC on tiny2313
#else
#define OUTPUT_REG_AT_PortC PORTC
#endif

#define OUTPUT_REG_AT_PortD PORTD

////////////PORT to PINX(input regs) mapping
#define INPUT_REG_AT_PortA PINA

#define INPUT_REG_AT_PortB PINB

#if defined(__AVR_ATtiny2313__)  
//no PortC on tiny2313
#else
#define INPUT_REG_AT_PortC PINC
#endif

#define INPUT_REG_AT_PortD PIND


#if defined(__AVR_ATtiny2313__) 

#define TIMER_AT_PIN_5   0B
#define TCCR_AT_PIN_5    TCCR0A

#define TIMER_AT_PIN_9   0A
#define TCCR_AT_PIN_9    TCCR0A

#define TIMER_AT_PIN_10  1A
#define TCCR_AT_PIN_10   TCCR1A

#define TIMER_AT_PIN_11  1B
#define TCCR_AT_PIN_11   TCCR1A

#elif  defined(__AVR_ATtiny26__)
/*
#define TIMER_AT_PIN_0   1A
#define TCCR_AT_PIN_0    TCCR1A
*/
#define TIMER_AT_PIN_1   1A
#define TCCR_AT_PIN_1    TCCR1A
/*
#define TIMER_AT_PIN_2   1B
#define TCCR_AT_PIN_2    TCCR1A
*/
#define TIMER_AT_PIN_3   1B
#define TCCR_AT_PIN_3    TCCR1A

#else

#if !defined(__AVR_ATmega8__)    //for Atmega48/88/168/328
#define TIMER_AT_PIN_3   2B
#define TCCR_AT_PIN_3    TCCR2A

#define TIMER_AT_PIN_5   0B
#define TCCR_AT_PIN_5    TCCR0A

#define TIMER_AT_PIN_6   0A
#define TCCR_AT_PIN_6    TCCR0A
#endif

#define TIMER_AT_PIN_9   1A
#define TCCR_AT_PIN_9    TCCR1A

#define TIMER_AT_PIN_10  1B
#define TCCR_AT_PIN_10   TCCR1A

#if defined(__AVR_ATmega8__)    
#define TIMER_AT_PIN_11  2
#define TCCR_AT_PIN_11   TCCR2
#else                            //for Atmega48/88/168/328
#define TIMER_AT_PIN_11  2A
#define TCCR_AT_PIN_11   TCCR2A
#endif


#define PI_PROGMEM __attribute__((progmem))

#define PI_PIN_MODE(PIN, MODE)                 pi_pin_mode(PIN, MODE)
#define PI_ANALOG_OUT(PORT, VALUE)             pi_analog_out(PORT, VALUE)
#define PI_DIGITAL_OUT(PORT, VALUE)            pi_digital_out(PORT, VALUE)
#define PI_DIGITAL_IN(PORT)                    pi_digital_in(PORT, VALUE)
#define PI_SHIFT_OUT(PIN, CLOCK, ORDER, VALUE) pi_shift_out(PIN, CLOCK, ORDER, VALUE)

// disables interrupts and saves the SREG register in the given variable
// which should be an unsigned char
#define PI_CLI(STORE_SREG) do { STORE_SREG = SREG;  cli(); } while(0)

// Rei-enables interrupts by restoring the sreg value from STORE_SREG
// which should be an unsigned char
#define PI_STI(STORE_SREG) do { SREG       = STORE_SREG  ; } while(0)


typedef uint8_t pin_t;

void pi_pin_mode(pin_t pin, uint8_t mode);
void pi_analog_out(pin_t pin, uint8_t value);
void pi_digital_out(pin_t pin, uint8_t value);
uint8_t pi_digital_in(pin_t pin);
uint8_t pi_shift_out(pin_t pin, pin_t clock, uint8_t order, uint8_t value);
void pi_delay(long delay);


#endif

