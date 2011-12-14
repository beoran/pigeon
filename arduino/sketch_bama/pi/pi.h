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

#define PI_PROGMEM __attribute__((progmem))

#define PI_ANALOG_OUT(PORT, VALUE)     analogWrite(PORT, VALUE)
#define PI_DIGITAL_OUT(PORT, VALUE)    digitalWrite(PORT, VALUE)

// disables interrupts and saves the SREG register in the given variable
// which should be an unsigned char
#define PI_CLI(STORE_SREG) do { STORE_SREG = SREG;  cli(); } while(0)

// Rei-enables interrupts by restoring the sreg value from STORE_SREG
// which should be an unsigned char
#define PI_STI(STORE_SREG) do { SREG       = STORE_SREG  ; } while(0)

#endif

