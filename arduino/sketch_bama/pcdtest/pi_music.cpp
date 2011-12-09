#include "pi_music.h"


/** Period of the notes, starting from C0, including half notes like C#0, etc.  */
static uint16_t PI_PROGMEM PI_NOTE_PERIOD[] = {
  30581, 28869, 27248, 25707, 24272, 22905, 21627, 20408, 19261, 18182, 17159, 16197, 
  15291, 14430, 13621, 12857, 12136, 11455, 10811, 10204,  9632,  9091,  8581,  8099, 
   7644,  7215,  6810,  6429,  6067,  5727,  5406,  5102,  4816,  4546,  4291,  4050, 
   3823,  3608,  3406,  3214,  3034,  2864,  2703,  2551,  2408,  2273,  2145,  2025, 
   1911,  1804,  1703,  1607,  1517,  1432,  1352,  1276,  1204,  1137,  1073,  1013, 
    956,   902,   852,   804,   759,   716,   676,   638,   602,   568,   537,   506, 
    478,   451,   426,   402,   379,   358,   338,   319,   301,   284,   268,   253, 
    239,   226,   213,   201,   190,   179,   169,   160,   151,   142,   134,   127,
    120,   113,   107,   101
};


  
/* This is a father Jacob tune for testing: 
 ,PI_C, PI_1_4, PI_D, PI_1_4, PI_E, PI_1_4, PI_C, PI_1_4
 ,PI_C, PI_1_4, PI_D, PI_1_4, PI_E, PI_1_4, PI_C, PI_1_4
 ,PI_E, PI_1_4, PI_F, PI_1_4, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_E, PI_1_4, PI_F, PI_1_4, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_R, PI_2_1 
 */

#define PI_ANALOG_OUT(PORT, VALUE)     analogWrite(PORT, VALUE)
#define PI_DIGITAL_OUT(PORT, VALUE)    digitalWrite(PORT, VALUE)

int       pi_note_phase    = 500;
int16_t   pi_note_playing  = 0;
int16_t   pi_note_period   = 100;
uint32_t  pi_note_start    = 0;
uint32_t  pi_note_duration = 0;
uint16_t  pi_music_size    = 0;
uint8_t * pi_music_data    = NULL;
uint32_t  pi_note_vibe     = 0;

unsigned long pi_music_timer = 0;

void pi_music_init(uint8_t * music_data, uint16_t music_size) {
  PI_ANALOG_OUT(PI_SOUND_PIN, 0);
  pi_note_playing  = 0;
  pi_note_duration = 0;
  pi_note_phase    = 0;
  pi_note_period   = 0;
  
  pi_music_data    = music_data; 
  pi_music_size    = music_size;
  pi_note_start    = micros();
  Timer1.initialize();
  Timer1.disablePwm(9);
}


/** Turns of the currently playing sound. */
void pi_sound_off() {
  Timer1.disablePwm(PI_SOUND_PIN);  
}

#define PI_SOUND_DUTY 100

/** Starts playing the sound with the given period * 2^16 (2^16/frequency). 
* This will keep playing until pi_sound_off() is called. 
*/
void pi_sound_on(long period) {
  Timer1.pwm(PI_SOUND_PIN, PI_SOUND_DUTY, period);
}


#define PI_NOTE_DURATION 30000

void pi_music_update() {
  uint32_t now    = micros();
  uint32_t delta  = now - pi_note_start;
  // note is almost done (1/64th), silence it so there is a pause.
  if(delta >= (pi_note_duration - (pi_note_duration >> 6))) {
    pi_sound_off();
  } 
  
  // Note has been playing long enough, play new note
  if (delta >= pi_note_duration ) {
    uint8_t note     = pgm_read_byte(pi_music_data + pi_note_playing); 
    uint8_t dura     = pgm_read_byte(pi_music_data + pi_note_playing + 1); 
    pi_note_duration = ((uint32_t)dura) * PI_NOTE_DURATION;
    pi_note_period   = (note ? pgm_read_word(PI_NOTE_PERIOD + note) : 0); 
    // On to next note. 
    pi_note_playing += 2;
    // Roll back to start of song if done.
    if (pi_note_playing >= pi_music_size) {
      pi_note_playing = 0;  
    }
    PI_ANALOG_OUT(PI_SOUND_PIN, 0); // start with a rest
    pi_note_phase = 0;
    pi_note_vibe  = 0;
    pi_note_start = now; // and be sure to update note start time! 
    // set to use PWM 
    if(pi_note_period) {  
       pi_sound_on(pi_note_period * 2);
    } else {  
      pi_sound_off();
    }  
  }  
  return;
}


