#ifndef PI_MUSIC_H
#define PI_MUSIC_H

#include "pi.h"

#ifndef PI_PROGMEM
#define PI_PROGMEM __attribute__((progmem))
#endif

#define PI_LED_PIN       13
#define PI_SOUND_PIN     9 
#define PI_N(NAME,DURA)  PI_##NAME, PI_##DURA

/** Definitions for note constants, and for a rest. */

#define PI_REST         0
#define PI_C0           1
#define PI_CS0          2
#define PI_D0           3
#define PI_DS0          4
#define PI_E0           5
#define PI_F0           6
#define PI_FS0          7
#define PI_G0           8
#define PI_GS0          9
#define PI_A0           10
#define PI_AS0          11
#define PI_B0           12
#define PI_C1           13
#define PI_CS1          14
#define PI_D1           15
#define PI_DS1          16
#define PI_E1           17
#define PI_F1           18
#define PI_FS1          19
#define PI_G1           20
#define PI_GS1          21
#define PI_A1           22
#define PI_AS1          23
#define PI_B1           24
#define PI_C2           25
#define PI_CS2          26
#define PI_D2           27
#define PI_DS2          28
#define PI_E2           29
#define PI_F2           30
#define PI_FS2          31
#define PI_G2           32
#define PI_GS2          33
#define PI_A2           34
#define PI_AS2          35
#define PI_B2           36
#define PI_C3           37
#define PI_CS3          38
#define PI_D3           39
#define PI_DS3          40
#define PI_E3           41
#define PI_F3           42
#define PI_FS3          43
#define PI_G3           44
#define PI_GS3          45
#define PI_A3           46
#define PI_AS3          47
#define PI_B3           48
#define PI_C4           49
#define PI_CS4          50
#define PI_D4           51
#define PI_DS4          52
#define PI_E4           53
#define PI_F4           54
#define PI_FS4          55
#define PI_G4           56
#define PI_GS4          57
#define PI_A4           58
#define PI_AS4          59
#define PI_B4           60
#define PI_C5           61
#define PI_CS5          62
#define PI_D5           63
#define PI_DS5          64
#define PI_E5           65
#define PI_F5           66
#define PI_FS5          67
#define PI_G5           68
#define PI_GS5          69
#define PI_A5           70
#define PI_AS5          71
#define PI_B5           72
#define PI_C6           73
#define PI_CS6          74
#define PI_D6           75
#define PI_DS6          76
#define PI_E6           77
#define PI_F6           78
#define PI_FS6          79
#define PI_G6           80
#define PI_GS6          81
#define PI_A6           82
#define PI_AS6          83
#define PI_B6           84
#define PI_C7           85
#define PI_CS7          86
#define PI_D7           87
#define PI_DS7          88
#define PI_E7           89
#define PI_F7           90
#define PI_FS7          91
#define PI_G7           92
#define PI_GS7          93
#define PI_A7           94
#define PI_AS7          95
#define PI_B7           96
#define PI_C8           97
#define PI_CS8          98
#define PI_D8           99
#define PI_DS8          100

/** Convenience notes */
#define PI_C_           PI_C3
#define PI_D_           PI_D3
#define PI_E_           PI_E3
#define PI_F_           PI_F3
#define PI_G_           PI_G3
#define PI_A_           PI_A4
#define PI_B_           PI_B4
#define PI_C            PI_C4
#define PI_D            PI_D4
#define PI_E            PI_E4
#define PI_F            PI_F4
#define PI_G            PI_G4
#define PI_A            PI_A5
#define PI_B            PI_B5
#define PI_c            PI_C5
#define PI_d            PI_D5
#define PI_e            PI_E5
#define PI_f            PI_F5
#define PI_g            PI_G5
#define PI_a            PI_A6
#define PI_b            PI_B6
#define PI_R            PI_REST


/** Defines for relative note durations. Notation for a A/B note is PI_A_B.
* Note durations up to 1/64 are supported, although not dotted (1/32 can be dotted )
* There is no notation of length zero since that is useless. 
* The notation uses duration+1/64 as a whole note, hence duration is 
* (tempo * (duration) + tempo) / 64 or tempo * (duration) + tempo) >> 64
*/

#define PI_1_64         1
#define PI_1_32         2
#define PI_3_32         6
#define PI_1_16         4
#define PI_3_16         12
#define PI_1_8          8
#define PI_2_8          16
#define PI_3_8          24
#define PI_1_4          16
#define PI_3_4          48
#define PI_1_2          32
#define PI_3_2          96
#define PI_1_1          64
#define PI_2_1          128
#define PI_3_1          192



/** Prepares the given music buffer with the given size for playing. */
extern void pi_music_init(uint8_t * music_data, uint16_t music_size);

/** Turns of the currently playing sound. */
extern void pi_sound_off();

/** Starts playing the sound with the given period * 2^16 (2^16/frequency). 
* This will keep playing until pi_sound_off() is called. 
*/
extern void pi_sound_on(long period);

/** Call this in the main loop to update the music that is being played.*/
extern void pi_music_update();

#endif

