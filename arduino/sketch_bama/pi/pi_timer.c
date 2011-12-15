#include "pi.h" 
#include "pi_timer.h" 

#include <avr/io.h>
#include <avr/interrupt.h>

#define PI_TIMER1_RESOLUTION 65536    // Timer1 is a 16 bit timer


static unsigned int  pi_timer1_period          = 0;
static unsigned char pi_timer1_clockbits       = 0;
static unsigned char pi_timer1_oldsreg         = 0;
static void        (*pi_timer1_isr)(void)      = NULL;



// set up timer interrupt handler
ISR(TIMER1_OVF_vect)     {
  if(pi_timer1_isr) pi_timer1_isr();
}


void pi_timer1_init(long microseconds) {
  TCCR1A = 0;                 // Clear control register A 
  TCCR1B = _BV(WGM13);        // Set phase and frequency correct pwm, mode 8. Stop the timer.
  pi_timer1_period_(microseconds);
}  

void pi_timer1_period_(long microseconds) {
  long cycles = (F_CPU / 2000000) * microseconds;
  // Only accept valid periods.
  if(microseconds < 0) return;
  
  if        (cycles < PI_TIMER1_RESOLUTION) { 
    pi_timer1_clockbits = _BV(CS10); // no prescale  
  } else if ((cycles  >>=3) < PI_TIMER1_RESOLUTION) {
    pi_timer1_clockbits = _BV(CS11); // prescale / 8
  } else if ((cycles  >>=3) < PI_TIMER1_RESOLUTION) {
    pi_timer1_clockbits = _BV(CS11) | _BV(CS10); // prescale / 64
  } else if ((cycles  >>=2) < PI_TIMER1_RESOLUTION) {
    pi_timer1_clockbits = _BV(CS12); // prescale / 256
  } else if ((cycles  >>=2) < PI_TIMER1_RESOLUTION) {
    pi_timer1_clockbits = _BV(CS12) | _BV(CS10); // prescale / 1024
  } else { 
    pi_timer1_clockbits = _BV(CS12) | _BV(CS10); // Out of bounds, use max period
    cycles              = PI_TIMER1_RESOLUTION;     
  }       
  
  PI_CLI(pi_timer1_oldsreg);                        // Disable interrupts
  pi_timer1_period      = (unsigned int)cycles;     
  ICR1                  = pi_timer1_period;

  PI_STI(pi_timer1_oldsreg);                        // Re-enable interrupts
  // Reset clock register
  TCCR1B &= ~(_BV(CS10) | _BV(CS11) | _BV(CS12));
  TCCR1B |= pi_timer1_clockbits;
}  

/** Sets the duty of the PWM on pin, where duty is a 10 bits value (0-1024). */
void pi_timer1_pwmduty_(char pin, int duty) {
  unsigned long cycle = pi_timer1_period;  
  cycle  *= duty;
  cycle >>= 10;
  PI_CLI(pi_timer1_oldsreg);                        // Disable interrupts
  switch(pin) { 
    case 1: case 9:
      OCR1A = cycle;
      break;
    case 2: case 10:
      OCR1B = cycle;
      break;
    default:  
      break;
   }   
  PI_STI(pi_timer1_oldsreg);                        // Re-enable interrupts
}


void pi_timer1_pwmon(char pin, int duty, long microseconds) {
  pi_timer1_period_(microseconds);
  switch(pin) { 
    case 1: case 9:
      DDRB   |= _BV(PORTB1);  
      TCCR1A |= _BV(COM1A1);
      break;
    case 2: case 10:
      DDRB |= _BV(PORTB2);
      TCCR1A |= _BV(COM1B1);
      break;
    default:  
      break;
   }   
   pi_timer1_pwmduty_(pin, duty);
   pi_timer1_resume();
}  
 
void pi_timer1_pwmoff(char pin) {
  switch(pin) { 
    case 1: case 9:
      TCCR1A &= ~_BV(COM1A1);  
      break;
    case 2: case 10:
      TCCR1A |= ~_BV(COM1B1);
      break;
    default:  
      break;
   }     
}

void pi_timer1_attach(void (*isr)(void), long microseconds) {
  pi_timer1_period_(microseconds);
  pi_timer1_isr = isr;  // set interrupt request routine                                     
  TIMSK1 |= _BV(TOIE1); // enable interrupt on clock overflow                                     
  pi_timer1_resume();
}

void pi_timer1_detach(void) {
  TIMSK1 &= ~_BV(TOIE1);  // disables interrupt on clock overflow
}

void pi_timer1_resume(void) { 
  TCCR1B |= pi_timer1_clockbits;
}

void pi_timer1_start()	{
  unsigned int tcnt1;
  
  TIMSK1 &= ~_BV(TOIE1);       // disable interrupt on clock overflow                                           
  GTCCR  |= _BV(PSRSYNC);      // reset shared prescaler 
  PI_CLI(pi_timer1_oldsreg);   // disable interrupts
  TCNT1 = 0;                   // reset counter 	
  PI_STI(pi_timer1_oldsreg);   // reenable interrupts
  // Wait until timer is nonzero zero to avoid spurious interrupts
  do { 
      PI_CLI(pi_timer1_oldsreg);   // disable interrupts
      tcnt1 = TCNT1;
      PI_STI(pi_timer1_oldsreg);   // reenable interrupts
  } while(tcnt1 == 0);    
}  

void pi_timer1_stop() {
  // clears all clock selects bits
  TCCR1B &= ~(_BV(CS10) | _BV(CS11) | _BV(CS12));          
}


/** Returns the value of timer1 in microseconds. */
unsigned long pi_timer1_read() {	  
  unsigned long aid      ;
  unsigned int  tcnt1    ;
  signed   char scale = 0;
  PI_CLI(pi_timer1_oldsreg);
  aid = TCNT1;
  PI_STI(pi_timer1_oldsreg);
  switch (pi_timer1_clockbits) { 
    case 1: scale = 0; break;
    // x8 prescale
    case 2: scale = 3; break;
    // x64
    case 3: scale = 6; break;
    // x256
    case 4: scale = 8; break;
    // x1024
    case 5: scale = 10; break;
    default:scale = 10; break;
   }
   // Wait for a new timer tick.
   do {
     PI_CLI(pi_timer1_oldsreg);
     tcnt1 = TCNT1;
     PI_STI(pi_timer1_oldsreg);
   } while(tcnt1 == aid);
   // if we are counting up, aid is ok, but if we're couning down aid must be changed
   if (tcnt1<aid) {  
     // since the count goes up , and then down again, at the very most we have 2*ICR1
     // supstract current time from that for the actual result.
     aid = (long)(ICR1) + (long)(ICR1) - (long)(tcnt1);
   }  
   // scale and divide by CPU frequency
   return ((aid*1000L)/(F_CPU / 1000L))<<scale;
}


