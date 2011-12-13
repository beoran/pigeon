#ifndef PI_H
#define PI_H

#include <stdlib.h>
#include <stdint.h>

#include "TimerOne.h"
#include <avr/pgmspace.h>
#include <util/delay.h>

#if defined(ARDUINO) && ARDUINO >= 100
  #include "Arduino.h"
#else
  #include "WProgram.h"
#endif

#define PI_PROGMEM __attribute__((progmem))


#endif

