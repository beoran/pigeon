#ifndef PI_TIMER_H
#define PI_TIMER_H

void          pi_timer1_init(long microseconds);
void          pi_timer1_start();
void          pi_timer1_stop();
void          pi_timer1_resume();
unsigned long pi_timer1_read();
void          pi_timer1_pwmon(char pin, int duty, long microseconds);
void          pi_timer1_pwm(char pin, int duty);
void          pi_timer1_pwmoff(char pin);
void          pi_timer1_period_(long microseconds);
void          pi_timer1_pwmduty_(char pin, int duty);
void          pi_timer1_attach(void (*isr), long microseconds);
void          pi_timer1_detach();












#endif

