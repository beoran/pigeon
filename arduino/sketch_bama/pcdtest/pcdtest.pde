#include "PCD8544.h"
#include "TimerOne.h"
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <stdlib.h>

#define DYMO


// pin 7 - Serial clock out (SCLK)
// pin 6 - Serial data out (DIN)
// pin 5 - Data/Command select (D/C)
// pin 4 - LCD chip select (CS)
// pin 3 - LCD reset (RST)
PCD8544 nokia = PCD8544(7, 6, 5, 4, 3);

// a bitmap of a 16x16 fruit icon
static unsigned char __attribute__ ((progmem)) logo16_glcd_bmp[]={
0x30, 0xf0, 0xf0, 0xf0, 0xf0, 0x30, 0xf8, 0xfe, 0x9f, 0xff, 0xf8, 0xc0, 0xc0, 0xc0, 0x80, 0x00, 
0x20, 0x3c, 0x3f, 0x3f, 0x1f, 0x19, 0x1f, 0x7b, 0xfb, 0xfe, 0xfe, 0x07, 0x07, 0x07, 0x03, 0x00, };

#define LOGO16_GLCD_HEIGHT 16 
#define LOGO16_GLCD_WIDTH  16 

#define PI_PROGMEM __attribute__((progmem))

#define IMAGE_OBAMA_HIGH 48
#define IMAGE_OBAMA_WIDE 48
static unsigned char __attribute__ ((progmem)) IMAGE_OBAMA_BMP[] = {

0b00000000, 0b00000000, 0b00001111, 0b11110000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00110111, 0b11111100, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b11111111, 0b11111110, 0b00000000, 0b00000000
, 0b00000000, 0b00000001, 0b01011111, 0b11111111, 0b10000000, 0b00000000
, 0b00000000, 0b00000011, 0b11111111, 0b11111111, 0b11000000, 0b00000000
, 0b00000000, 0b00000101, 0b01111111, 0b11111111, 0b11100000, 0b00000000
, 0b00000000, 0b00001111, 0b11111111, 0b11111111, 0b11110000, 0b00000000
, 0b00000000, 0b00010111, 0b10000001, 0b11111111, 0b11111000, 0b00000000
, 0b00000000, 0b00111100, 0b00000000, 0b00010000, 0b11111000, 0b00000000
, 0b00000000, 0b00111000, 0b00000000, 0b00000000, 0b01011000, 0b00000000
, 0b00000000, 0b01101000, 0b00000000, 0b00000000, 0b01111100, 0b00000000
, 0b00000000, 0b01111000, 0b00000000, 0b00000000, 0b01101100, 0b00000000
, 0b00000000, 0b01110000, 0b00000000, 0b00000000, 0b01111100, 0b00000000
, 0b00000000, 0b01010000, 0b00000000, 0b00000000, 0b01110100, 0b00000000
, 0b00000000, 0b01100000, 0b00000000, 0b00000000, 0b00111100, 0b00000000
, 0b00000000, 0b01100000, 0b00000000, 0b00000000, 0b01011100, 0b00000000
, 0b00000000, 0b01100000, 0b00000000, 0b00000000, 0b00011000, 0b00000000
, 0b00000000, 0b00100001, 0b11100000, 0b00001111, 0b10011000, 0b00000000
, 0b00000000, 0b01100011, 0b11110000, 0b00011111, 0b11001100, 0b00000000
, 0b00000000, 0b10100110, 0b00000100, 0b10000000, 0b01101010, 0b00000000
, 0b00000001, 0b00010000, 0b11100000, 0b10001110, 0b00001001, 0b00000000
, 0b00000001, 0b01000001, 0b01000100, 0b10100101, 0b00010101, 0b00000000
, 0b00000001, 0b01010000, 0b00010000, 0b10000000, 0b00010101, 0b00000000
, 0b00000001, 0b00100000, 0b00000100, 0b10010000, 0b01001001, 0b00000000
, 0b00000000, 0b10000100, 0b00100000, 0b01000101, 0b00001010, 0b00000000
, 0b00000000, 0b10000000, 0b10001000, 0b01000000, 0b00001010, 0b00000000
, 0b00000000, 0b01000000, 0b00000000, 0b00100000, 0b00010100, 0b00000000
, 0b00000000, 0b01010000, 0b00010000, 0b00100000, 0b00010100, 0b00000000
, 0b00000000, 0b00110000, 0b00001100, 0b11001000, 0b00011000, 0b00000000
, 0b00000000, 0b00001000, 0b01000011, 0b00001000, 0b00010000, 0b00000000
, 0b00000000, 0b00001000, 0b10000000, 0b00000100, 0b00100000, 0b00000000
, 0b00000000, 0b00001000, 0b00000000, 0b00000010, 0b00100000, 0b00000000
, 0b00000000, 0b00001001, 0b00000000, 0b00000011, 0b01000000, 0b00000000
, 0b00000000, 0b00000100, 0b00011100, 0b11100010, 0b01000000, 0b00000000
, 0b00000000, 0b00000101, 0b01111111, 0b11111010, 0b10000000, 0b00000000
, 0b00000000, 0b00000010, 0b00011000, 0b01100001, 0b10000000, 0b00000000
, 0b00000000, 0b00000011, 0b00001111, 0b11000011, 0b10000000, 0b00000000
, 0b00000000, 0b00000010, 0b10000000, 0b00000010, 0b11000000, 0b00000000
, 0b00000000, 0b00000010, 0b10000000, 0b00000101, 0b11100000, 0b00000000
, 0b00000000, 0b00000010, 0b01000000, 0b00001110, 0b10010000, 0b00000000
, 0b00000000, 0b00001110, 0b00100000, 0b00010101, 0b00011000, 0b00000000
, 0b00000000, 0b01111101, 0b00010000, 0b00101010, 0b00111100, 0b00000000
, 0b00000011, 0b11111101, 0b00001111, 0b11010100, 0b00111110, 0b00000000
, 0b00011111, 0b11111100, 0b10000010, 0b10111000, 0b01111111, 0b00000000
, 0b11111111, 0b11111100, 0b10000001, 0b01110000, 0b01111111, 0b11000000
, 0b11111111, 0b11111100, 0b01000000, 0b11000000, 0b11111111, 0b11110000
, 0b11111111, 0b11111100, 0b00100001, 0b00000000, 0b11111111, 0b11111100
, 0b11111111, 0b11111100, 0b00010010, 0b00000001, 0b11111111, 0b11111111
};

#ifdef DYMO

#define IMAGE_DYMO_HIGH 32
#define IMAGE_DYMO_WIDE 80

static unsigned char __attribute__ ((progmem)) IMAGE_DYMO_BMP[] = {
  0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00111000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b01000100
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b10110010, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000001, 0b00101001, 0b00000111, 0b11111100, 0b00011111, 0b00000111
, 0b11011111, 0b11000011, 0b11111000, 0b00011111, 0b11000001, 0b00110001
, 0b00001111, 0b11111111, 0b00001111, 0b10001111, 0b10011111, 0b11000111
, 0b11111000, 0b11111111, 0b11111001, 0b00101001, 0b00001111, 0b11111111
, 0b11000111, 0b10011111, 0b00111111, 0b11000111, 0b11110001, 0b11111000
, 0b01111100, 0b10000010, 0b00001111, 0b00000011, 0b11100111, 0b11011110
, 0b00111111, 0b11101111, 0b11110011, 0b11110000, 0b00111110, 0b01000100
, 0b00011110, 0b00000001, 0b11100011, 0b11011100, 0b00111111, 0b11111111
, 0b11110111, 0b11100000, 0b00111110, 0b00111000, 0b00011110, 0b00000001
, 0b11100011, 0b11101000, 0b00111111, 0b11111111, 0b11110111, 0b11000000
, 0b00111110, 0b00000000, 0b00011110, 0b00000011, 0b11100001, 0b11100000
, 0b01111111, 0b11111111, 0b11100111, 0b11000000, 0b00111110, 0b00000000
, 0b00111100, 0b00000111, 0b11000001, 0b11100000, 0b01111101, 0b11111101
, 0b11100111, 0b11000000, 0b01111100, 0b00000000, 0b00111111, 0b11111111
, 0b10000011, 0b11100000, 0b01111001, 0b11111001, 0b11100011, 0b11100001
, 0b11111000, 0b00000000, 0b01111111, 0b11111111, 0b00000011, 0b11100000
, 0b11111001, 0b11111011, 0b11000001, 0b11111111, 0b11110000, 0b00000000
, 0b01111111, 0b11111100, 0b00000111, 0b11000000, 0b11110001, 0b11110011
, 0b11000000, 0b01111111, 0b11000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000, 0b00000000
, 0b00000000, 0b00000000
};

#endif

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

/*
X: 1
T: Hail to the Chief
C: James Sanderson (ca.1810)
M: C
L: 1/8
K: Bb
|: z2 \
| F2 G>A B2 AG | F>G FD C2 B,2 | F2 B>c d2 cB | c>B cd cB AG \
| F2 G>A B2 AG | F>G FD C2 B,2 | F2 B>A GB DF | F2 B>c B2 :|
|: Bc \
| d2 d>d d2 ed | c>=B cd cA F2 | d2 d>d ed cB | c2 f>f fe dc \
| B2 B>A G>A BG | F2 B>c d2 cB | G>A BG F>G FD | F2 B>c B2 :|
*/

#define PI_LED_PIN       13
#define PI_PIEZO_PIN     9 



uint8_t PROGMEM MUSIC_HAIL_TO_THE_CHIEF[] = {
  PI_REST, PI_1_4, PI_F4, PI_1_4, PI_G4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_1_4, PI_A4, PI_1_8, PI_G4, PI_1_8, PI_F4, PI_3_16
, PI_G4, PI_3_16, PI_F4, PI_1_8, PI_D4, PI_1_8, PI_C4, PI_1_4, PI_B3, PI_1_4, PI_F4, PI_1_4, PI_B4, PI_3_16, PI_C5, PI_3_16
, PI_D5, PI_1_4, PI_C5, PI_1_8, PI_B4, PI_1_8, PI_C5, PI_3_16, PI_B4, PI_3_16, PI_C5, PI_1_8, PI_D5, PI_1_8, PI_C5, PI_1_8
, PI_B4, PI_1_8, PI_A4, PI_1_8, PI_G4, PI_1_8, PI_F4, PI_1_4, PI_G4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_1_4, PI_A4, PI_1_8
, PI_G4, PI_1_8, PI_F4, PI_3_16, PI_G4, PI_3_16, PI_F4, PI_1_8, PI_D4, PI_1_8, PI_C4, PI_1_4, PI_B3, PI_1_4, PI_F4, PI_1_4
, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_G4, PI_1_8, PI_B4, PI_1_8, PI_D4, PI_1_8, PI_F4, PI_1_8, PI_F4, PI_1_4, PI_B4, PI_3_16
, PI_C5, PI_3_16, PI_B4, PI_1_4, PI_B4, PI_1_8, PI_C5, PI_1_8, PI_D5, PI_1_4, PI_D5, PI_3_16, PI_D5, PI_3_16, PI_D5, PI_1_4
, PI_E5, PI_1_8, PI_D5, PI_1_8, PI_C5, PI_3_16, PI_B4, PI_3_16, PI_C5, PI_1_8, PI_D5, PI_1_8, PI_C5, PI_1_8, PI_A4, PI_1_8
, PI_F4, PI_1_4, PI_D5, PI_1_4, PI_D5, PI_3_16, PI_D5, PI_3_16, PI_E5, PI_1_8, PI_D5, PI_1_8, PI_C5, PI_1_8, PI_B4, PI_1_8
, PI_C5, PI_1_4, PI_F5, PI_3_16, PI_F5, PI_3_16, PI_F5, PI_1_8, PI_E5, PI_1_8, PI_D5, PI_1_8, PI_C5, PI_1_8, PI_B4, PI_1_4
, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_G4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_1_8, PI_G4, PI_1_8, PI_F4, PI_1_4, PI_B4, PI_3_16
, PI_C5, PI_3_16, PI_D5, PI_1_4, PI_C5, PI_1_8, PI_B4, PI_1_8, PI_G4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_1_8, PI_G4, PI_1_8
, PI_F4, PI_3_16, PI_G4, PI_3_16, PI_F4, PI_1_8, PI_D4, PI_1_8, PI_F4, PI_1_4, PI_B4, PI_3_16, PI_C5, PI_3_16, PI_B4, PI_1_4
};

#define MUSIC_HAIL_TO_THE_CHIEF_SIZE  208
#define MUSIC_HAIL_TO_THE_CHIEF_NOTES 104

uint8_t PROGMEM MUSIC_HAIL_TO_THE_CHIEF2[] = {
  PI_A4, PI_1_4, PI_B4, PI_3_16, PI_C5, PI_3_16, PI_D5, PI_1_4, PI_C5, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_3_16
, PI_A4, PI_3_16, PI_F4, PI_3_16, PI_E4, PI_1_4, PI_D4, PI_1_4, PI_A4, PI_1_4, PI_D5, PI_3_16, PI_E5, PI_3_16, PI_F5, PI_1_4
, PI_E5, PI_3_16, PI_D5, PI_3_16, PI_E5, PI_3_16, PI_D5, PI_3_16, PI_E5, PI_3_16, PI_F5, PI_3_16, PI_E5, PI_1_8, PI_D5, PI_1_8
, PI_C5, PI_1_8, PI_B4, PI_1_8, PI_A4, PI_1_4, PI_B4, PI_3_16, PI_C5, PI_3_16, PI_D5, PI_1_4, PI_C5, PI_3_16, PI_B4, PI_3_16
, PI_A4, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_F4, PI_3_16, PI_E4, PI_1_4, PI_D4, PI_1_4, PI_A4, PI_1_4, PI_D5, PI_3_16
, PI_C5, PI_3_16, PI_B4, PI_3_16, PI_D5, PI_3_16, PI_A4, PI_3_16, PI_F4, PI_3_16, PI_A4, PI_1_4, PI_D5, PI_3_16, PI_E5, PI_3_16
, PI_D5, PI_1_4, PI_REST, PI_1_4, PI_F5, PI_1_4, PI_F5, PI_3_16, PI_F5, PI_3_16, PI_F5, PI_1_4, PI_G5, PI_3_16, PI_F5, PI_3_16
, PI_E5, PI_3_16, PI_D5, PI_3_16, PI_E5, PI_1_8, PI_F5, PI_1_8, PI_E5, PI_1_4, PI_A4, PI_1_4, PI_F5, PI_1_4, PI_F5, PI_3_16
, PI_F5, PI_3_16, PI_F5, PI_1_4, PI_E5, PI_3_16, PI_D5, PI_3_16, PI_E5, PI_1_4, PI_A5, PI_3_16, PI_A5, PI_3_16, PI_A5, PI_3_16
, PI_G5, PI_3_16, PI_F5, PI_3_16, PI_E5, PI_3_16, PI_D5, PI_1_4, PI_D5, PI_3_16, PI_C5, PI_3_16, PI_B4, PI_3_16, PI_C5, PI_3_16
, PI_D5, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_1_4, PI_D5, PI_3_16, PI_E5, PI_3_16, PI_F5, PI_1_4, PI_D5, PI_1_4, PI_B4, PI_1_4
, PI_D5, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_1_8, PI_F4, PI_1_8, PI_A4, PI_1_4, PI_D5, PI_3_16
, PI_E5, PI_3_16, PI_D5, PI_1_4, PI_REST, PI_1_4, PI_D4, PI_1_4, PI_D5, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_F4, PI_3_16
, PI_D4, PI_1_4, PI_E4, PI_1_4, PI_E5, PI_3_16, PI_F5, PI_3_16, PI_E5, PI_3_16, PI_D4, PI_3_16, PI_E4, PI_1_4, PI_F4, PI_1_8
, PI_A4, PI_1_8, PI_D5, PI_1_8, PI_E5, PI_1_8, PI_F5, PI_1_4, PI_E5, PI_1_8, PI_D5, PI_1_8, PI_B4, PI_1_16, PI_D5, PI_3_16
, PI_A4, PI_1_8, PI_F4, PI_1_8, PI_E4, PI_1_2, PI_D4, PI_1_4, PI_D5, PI_3_16, PI_B4, PI_3_16, PI_A4, PI_3_16, PI_F4, PI_3_16
, PI_D4, PI_1_4, PI_E4, PI_3_16, PI_E5, PI_3_16, PI_E5, PI_3_16, PI_F5, PI_3_16, PI_E5, PI_3_16, PI_D5, PI_3_16, PI_B4, PI_1_4
, PI_A4, PI_3_16, PI_A4, PI_3_16, PI_D5, PI_1_8, PI_C5, PI_1_8, PI_A4, PI_1_8, PI_F4, PI_1_8, PI_A4, PI_1_8, PI_B4, PI_1_8
, PI_A4, PI_1_4, PI_D5, PI_3_16, PI_D5, PI_3_16, PI_D5, PI_1_4, PI_REST, PI_1_4};

#define MUSIC_HAIL_TO_THE_CHIEF2_SIZE 298
#define MUSIC_HAIL_TO_THE_CHIEF2_NOTES 149
#define PI_N(NAME,DURA) PI_##NAME, PI_##DURA

uint8_t PROGMEM MUSIC_HAIL_TO_THE_CHIEF3[] = {
/*  PI_R, PI_1_4 
 ,PI_D, PI_3_16, PI_D, PI_1_16, PI_D, PI_1_16, PI_D, PI_1_8, PI_D, PI_1_8, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_D, PI_3_16, PI_D, PI_1_16, PI_D, PI_1_16, PI_D, PI_1_8, PI_D, PI_1_8, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_D, PI_3_16, PI_D, PI_1_16, PI_D, PI_1_16, PI_D, PI_1_8, PI_D, PI_1_8, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_D, PI_3_16, PI_D, PI_1_16, PI_D, PI_1_16, PI_D, PI_1_8, PI_D, PI_1_8, PI_G, PI_1_4, PI_R, PI_1_4
*/ 
  PI_R, PI_1_2
, PI_G4, PI_1_4, PI_A4, PI_3_16, PI_B4, PI_1_16, PI_C5, PI_1_4, PI_B4, PI_3_16, PI_A4, PI_1_16
, PI_G4, PI_3_16, PI_A4, PI_1_16, PI_G4, PI_3_16, PI_E4, PI_1_16, PI_D4, PI_1_4, PI_C4, PI_1_4
, PI_G4, PI_1_4, PI_C5, PI_3_16, PI_D5, PI_1_16, PI_E5, PI_1_4, PI_D5, PI_3_16, PI_C5, PI_1_16
, PI_D5, PI_3_16, PI_C5, PI_1_16, PI_D5, PI_3_16, PI_E5, PI_1_16, PI_D5, PI_1_4, PI_REST, PI_1_4
, PI_G4, PI_1_4, PI_A4, PI_3_16, PI_B4, PI_1_16, PI_C5, PI_1_4, PI_B4, PI_3_16, PI_A4, PI_1_16
, PI_G4, PI_3_16, PI_A4, PI_1_16, PI_G4, PI_3_16, PI_E4, PI_1_16, PI_D4, PI_1_4, PI_C4, PI_1_4
, PI_G4, PI_1_4, PI_C5, PI_3_16, PI_B4, PI_1_16, PI_A4, PI_1_16, PI_C5, PI_3_16, PI_G4, PI_3_16, PI_E4, PI_1_16
, PI_G4, PI_1_4, PI_C5, PI_3_16, PI_C5, PI_1_16, PI_C5, PI_1_4, PI_REST, PI_1_4

, PI_E5, PI_1_4, PI_E5, PI_3_16, PI_E5, PI_1_16, PI_E5, PI_1_4, PI_F5, PI_1_8, PI_E5, PI_1_8
, PI_D5, PI_3_16, PI_C5, PI_1_16, PI_D5, PI_1_8, PI_E5, PI_1_8, PI_D5, PI_1_8, PI_B4, PI_1_8, PI_G4, PI_1_4
, PI_E5, PI_1_4, PI_E5, PI_3_16, PI_E5, PI_1_16, PI_E5, PI_1_4, PI_D5, PI_1_8, PI_C5, PI_1_8
, PI_D5, PI_1_4, PI_G5, PI_3_16, PI_G5, PI_1_16, PI_G5, PI_1_8, PI_F5, PI_1_8, PI_E5, PI_1_8, PI_D5, PI_1_8
, PI_C5, PI_1_4, PI_C5, PI_3_16, PI_B4, PI_1_16, PI_A4, PI_1_4, PI_C5, PI_3_16, PI_A4, PI_1_16
, PI_G4, PI_1_8, PI_C5, PI_1_8, PI_C5, PI_1_8, PI_D5, PI_1_8, PI_E5, PI_1_4, PI_D5, PI_1_8, PI_C5, PI_1_8
, PI_A4, PI_1_4, PI_C5, PI_1_8, PI_A4, PI_1_8, PI_G4, PI_3_16, PI_A4, PI_1_16, PI_G4, PI_1_8, PI_E4, PI_1_8
, PI_G4, PI_1_4, PI_C5, PI_3_16, PI_C5, PI_1_16, PI_C5, PI_1_4, PI_REST, PI_1_4

, PI_C4, PI_1_4, PI_C5, PI_3_16, PI_A4, PI_1_16, PI_G4, PI_3_16, PI_E4, PI_1_16, PI_C4, PI_1_4
, PI_F4, PI_1_4, PI_D5, PI_3_16, PI_E5, PI_1_16, PI_D5, PI_3_16, PI_C5, PI_1_16, PI_A4, PI_1_4
, PI_E4, PI_1_8, PI_G4, PI_1_8, PI_C5, PI_1_8, PI_D5, PI_1_8, PI_E5, PI_1_4, PI_D5, PI_1_8, PI_C5, PI_1_8
, PI_A4, PI_1_16, PI_C5, PI_3_16, PI_G4, PI_1_8, PI_E4, PI_1_8, PI_D4, PI_3_16, PI_F4, PI_1_16, PI_E4, PI_3_16, PI_D4, PI_1_16
, PI_C4, PI_1_4, PI_C5, PI_3_16, PI_A4, PI_1_16, PI_G4, PI_3_16, PI_E4, PI_1_16, PI_C4, PI_1_4
, PI_D4, PI_1_8, PI_D5, PI_1_8, PI_D5, PI_1_8, PI_E5, PI_1_8, PI_D5, PI_3_16, PI_C5, PI_1_16, PI_A4, PI_1_4
, PI_G4, PI_1_4, PI_C5, PI_1_8, PI_B4, PI_1_8, PI_A4, PI_1_8, PI_C5, PI_1_8, PI_G4, PI_1_8, PI_E4, PI_1_8
, PI_C5, PI_1_4, PI_C5, PI_3_16, PI_C5, PI_1_16, PI_C5, PI_1_4, PI_REST, PI_1_4
  
/* This is a father Jacob tune for testing: 
 ,PI_C, PI_1_4, PI_D, PI_1_4, PI_E, PI_1_4, PI_C, PI_1_4
 ,PI_C, PI_1_4, PI_D, PI_1_4, PI_E, PI_1_4, PI_C, PI_1_4
 ,PI_E, PI_1_4, PI_F, PI_1_4, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_E, PI_1_4, PI_F, PI_1_4, PI_G, PI_1_4, PI_R, PI_1_4
 ,PI_R, PI_2_1 
 */
};
  
#define MUSIC_HAIL_TO_THE_CHIEF3_SIZE (sizeof(MUSIC_HAIL_TO_THE_CHIEF3))
#define MUSIC_HAIL_TO_THE_CHIEF3_NOTES (sizeof(MUSIC_HAIL_TO_THE_CHIEF3)/2)

  
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
  PI_ANALOG_OUT(PI_PIEZO_PIN, 0);
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


#define PI_NOTE_DURATION 30000

void pi_music_update() {
  uint32_t now    = micros();
  uint32_t delta  = now - pi_note_start;
  /*
  Serial.print("Delta: ");
  Serial.print(delta, DEC);   
  Serial.println("");
  Serial.print("Duration: ");
  Serial.print(pi_note_, DEC);   
  Serial.println("");
*/
  // note is almost done (1/64th), silence it so there is a pause.
  if(delta >= (pi_note_duration - (pi_note_duration >> 6))) {
    Timer1.disablePwm(9);  
  } 
  
  // Note has been playing long enough, play new note
  if (delta >= pi_note_duration ) {
    uint8_t note     = pgm_read_byte(pi_music_data + pi_note_playing); 
    uint8_t dura     = pgm_read_byte(pi_music_data + pi_note_playing + 1); 
    pi_note_duration = ((uint32_t)dura) * PI_NOTE_DURATION;
    pi_note_period   = (note ? pgm_read_word(PI_NOTE_PERIOD + note) : 0); 
    Serial.print("Note: ");
    Serial.print(note, DEC);
    Serial.println("");
    Serial.print("Period: ");
    Serial.print(pi_note_period, DEC);
    Serial.println("");
    Serial.print("Dura: ");
    Serial.print(dura, DEC);
    Serial.println("");
    Serial.print("Dura2: ");
    Serial.print(pi_note_duration, DEC);
    Serial.println("");
    // On to next note. 
    pi_note_playing += 2;
    // Roll back to start of song if done.
    if (pi_note_playing >= pi_music_size) {
      pi_note_playing = 0;  
    }
    PI_ANALOG_OUT(PI_PIEZO_PIN, 0); // start with a rest
    pi_note_phase = 0;
    pi_note_vibe  = 0;
    pi_note_start = now; // and be sure to update note start time! 
    // set to use PWM 
    if(pi_note_period) {  
      Timer1.pwm(9, 100, pi_note_period * 2);
    } else {  
      Timer1.disablePwm(9);
    }  
  }
  
  // pi_note_period = 1000;
  
  // no period means rest
/*  if (!pi_note_period) {
    return;
  }  
  */
  /*
  delayMicroseconds(pi_note_period);
  PI_ANALOG_OUT(PI_PIEZO_PIN, 500);    
  delayMicroseconds(pi_note_period);
  PI_ANALOG_OUT(PI_PIEZO_PIN, 0);
  *//*
  if(pi_note_vibe >= pi_note_period) {
    pi_note_phase = ( pi_note_phase > 0 ? 0 : 500);    
    PI_ANALOG_OUT(PI_PIEZO_PIN, pi_note_phase);
    pi_note_vibe  = 0;
  }  
  pi_note_vibe ++;  
  */
  /*
  // now bit bang 
  if((now % ((uint32_t)pi_note_period)) == 0) {
    // toggle on and off every period ticks. 
    pi_note_phase = ( pi_note_phase > 0 ? 0 : 128);    
    PI_ANALOG_OUT(PI_PIEZO_PIN, pi_note_phase);
  }*/
  return;
}






void setup(void) {
  // pinMode(ledPin, OUTPUT);  
  pi_music_init(MUSIC_HAIL_TO_THE_CHIEF3, MUSIC_HAIL_TO_THE_CHIEF3_SIZE);
  Serial.begin(9600);  
  Serial.println("Start!");
  nokia.init();
  
  // you can change the contrast around to adapt the display
  // for the best viewing!
  // nokia.setContrast(60);
  // turn all the pixels on (a handy test)
  //nokia.command(PCD8544_DISPLAYCONTROL | PCD8544_DISPLAYALLON);
  //delay(500);
  // back to normal
  //nokia.command(PCD8544_DISPLAYCONTROL | PCD8544_DISPLAYNORMAL);

  // show splashscreen
  nokia.display();
  /*
  //delay(2000);
  nokia.clear();

  // draw a single pixel
  nokia.setPixel(10, 10, BLACK);
  nokia.display();        // show the changes to the buffer
  delay(2000);
  nokia.clear();
 
   // draw many lines
  testdrawline();
  nokia.display();       // show the lines
 // nokia.clear();
  
  // draw rectangles
  testdrawrect();
  nokia.display();
  delay(2000);
  nokia.clear();
  
  
  // draw multiple rectangles
  testfillrect();
  nokia.display();
  delay(2000);
  nokia.clear();
  
  // draw mulitple circles
  testdrawcircle();
  nokia.display();
  delay(2000);
  nokia.clear();
  
  // draw the first ~120 characters in the font
  testdrawchar();
  nokia.display();
  delay(2000);
  nokia.clear();

  // draw a string at location (0,0)
  nokia.setCursor(0, 0);
  nokia.print("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor");
  nokia.display();
  delay(2000);
  nokia.clear();

  // draw other characters, variables and such
  nokia.setCursor(0, 20);
  nokia.println(0xAB, HEX);
  nokia.print(99.99);
  nokia.println('%');
  nokia.display();
  delay(2000);
  nokia.clear();
  */
  // draw a bitmap icon and 'animate' movement
  // testdrawbitmap(logo16_glcd_bmp, LOGO16_GLCD_HEIGHT, LOGO16_GLCD_WIDTH);
  Serial.println("Drawing!");
  draw_obama();

  Serial.println("Draw ok!");
}

void my_drawbitmap(uint8_t x, uint8_t y, 
		   const uint8_t *bitmap, 
                   uint8_t w, uint8_t h,
		   uint8_t color)
{
  
  for (uint8_t yy=0; yy < h; yy++) {
    for (uint8_t xx=0; xx < w; xx++ ) {
      uint16_t dif = yy*(w/8) + (xx/8);
      uint8_t   by = pgm_read_byte(bitmap + dif); 
      if (by & (1 << (7 - (xx%8)))) {
	nokia.setPixel(x+xx, y+yy, color);
      } /*else {
        nokia.setPixel(x+xx, y+yy, WHITE);
      }*/
    }
  }
}

void draw_obama(void) {
  nokia.clear();
  #ifdef DYMO
  for(int i = -32 ; i < 1; i ++) {  
    nokia.clear();
//    my_drawbitmap(-10, i-1, IMAGE_DYMO_BMP, IMAGE_DYMO_WIDE, IMAGE_DYMO_HIGH, WHITE);
    my_drawbitmap(0, i, IMAGE_DYMO_BMP, IMAGE_DYMO_WIDE, IMAGE_DYMO_HIGH, BLACK);    
    nokia.display();
    // delay(100);    
  }  
  #else
  my_drawbitmap(0, 0, IMAGE_OBAMA_BMP, IMAGE_OBAMA_WIDE, IMAGE_OBAMA_HIGH, BLACK);
  #endif
  #ifdef DYMO
  nokia.setCursor(48, 34);
  nokia.println("BDM!");
  #else
  nokia.setCursor(48, 10);
  nokia.println("Obama!");
  #endif
  nokia.display();
}

void loop(void) {
  pi_music_update();  
}

#define NUMFLAKES 8
#define XPOS 0
#define YPOS 1
#define DELTAY 2

void testdrawbitmap(const uint8_t *bitmap, uint8_t w, uint8_t h) {
  uint8_t icons[NUMFLAKES][3];
  srandom(666);     // whatever seed
 
  // initialize
  for (uint8_t f=0; f< NUMFLAKES; f++) {
    icons[f][XPOS] = random() % LCDWIDTH;
    icons[f][YPOS] = 0;
    icons[f][DELTAY] = random() % 5 + 1;
  }

  while (1) {
    // draw each icon
    for (uint8_t f=0; f< NUMFLAKES; f++) {
      nokia.drawbitmap(icons[f][XPOS], icons[f][YPOS], logo16_glcd_bmp, w, h, BLACK);
    }
    nokia.display();
    delay(200);
    
    // then erase it + move it
    for (uint8_t f=0; f< NUMFLAKES; f++) {
      nokia.drawbitmap(icons[f][XPOS], icons[f][YPOS],  logo16_glcd_bmp, w, h, 0);
      // move it
      icons[f][YPOS] += icons[f][DELTAY];
      // if its gone, reinit
      if (icons[f][YPOS] > LCDHEIGHT) {
	icons[f][XPOS] = random() % LCDWIDTH;
	icons[f][YPOS] = 0;
	icons[f][DELTAY] = random() % 5 + 1;
      }
    }
  }
}

void testdrawchar(void) {
  for (uint8_t i=0; i < 64; i++) {
    nokia.drawchar((i % 14) * 6, (i/14) * 8, i);
  }    
  nokia.display();
  delay(2000);
  for (uint8_t i=0; i < 64; i++) {
    nokia.drawchar((i % 14) * 6, (i/14) * 8, i + 64);
  }    
}

void testdrawcircle(void) {
  for (uint8_t i=0; i<48; i+=2) {
    nokia.drawcircle(41, 23, i, BLACK);
  }
}


void testdrawrect(void) {
  for (uint8_t i=0; i<48; i+=2) {
    nokia.drawrect(i, i, 96-i, 48-i, BLACK);
  }
}

void testfillrect(void) {
  for (uint8_t i=0; i<48; i++) {
      // alternate colors for moire effect
    nokia.fillrect(i, i, 84-i, 48-i, i%2);
  }
}

void testdrawline() {
  for (uint8_t i=0; i<84; i+=4) {
    nokia.drawline(0, 0, i, 47, BLACK);
  }
  for (uint8_t i=0; i<48; i+=4) {
    nokia.drawline(0, 0, 83, i, BLACK);
  }

  nokia.display();
  delay(1000);
  for (uint8_t i=0; i<84; i+=4) {
    nokia.drawline(i, 47, 0, 0, WHITE);
  }
  for (uint8_t i=0; i<48; i+=4) {
    nokia.drawline(83, i, 0, 0, WHITE);
  }
}
