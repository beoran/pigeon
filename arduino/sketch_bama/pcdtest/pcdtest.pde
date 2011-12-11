#include "PCD8544.h"
#include "TimerOne.h"
#include "pi_music.h"
#include "pi_lcd.h"
#include <avr/pgmspace.h>
#include <util/delay.h>
#include <stdlib.h>

#undef DYMO

#define PI_BREADBOARD    1
#define PI_SOLDERBOARD   2
#define PI_HARDWARE      PI_BREADBOARD

// pin 7 - Serial clock out (SCLK) real pin: 13  violet
// pin 7 is in use for programmer, use pin 12 real pin 18 
// pin 6 - Serial data out (DIN) real pin:  12 blue 
// pin 5 - Data/Command select (D/C) 11 green
// pin 4 - LCD chip select (CS) 
// Pin 4 is in use by usb, use pin 8 in stead real pin 14 yellow
// pin 3 - LCD reset (RST) real pin 5 orange
#define LCD_SCLK_PIN   12
#define LCD_DIN_PIN     6 
#define LCD_DC_PIN      5 
#define LCD_CS_PIN      8
#define LCD_RST_PIN     3

// PCD8544 lcd = PCD8544(LCD_SCLK_PIN, LCD_DIN_PIN, LCD_DC_PIN, LCD_CS_PIN, LCD_RST_PIN);

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

};
  
#define MUSIC_HAIL_TO_THE_CHIEF3_SIZE (sizeof(MUSIC_HAIL_TO_THE_CHIEF3))
#define MUSIC_HAIL_TO_THE_CHIEF3_NOTES (sizeof(MUSIC_HAIL_TO_THE_CHIEF3)/2)

  

#define KEY_LEFT_PIN  A4
#define KEY_DOWN_PIN  A3
#define KEY_RIGHT_PIN A2
#define KEY_UP_PIN    A1
#define KEY_A_PIN     A0
#define KEY_B_PIN     11
#define KEY_X_PIN     13
#define KEY_Y_PIN      7


void pi_key_initone(int pin) {
  pinMode(pin, INPUT); 
  digitalWrite(pin,HIGH); // enble pull-up resistor
}

void pi_key_init() {
  pi_key_initone(KEY_LEFT_PIN);
  pi_key_initone(KEY_RIGHT_PIN);
  pi_key_initone(KEY_UP_PIN);
  pi_key_initone(KEY_DOWN_PIN);
  pi_key_initone(KEY_A_PIN);
  pi_key_initone(KEY_B_PIN);
  pi_key_initone(KEY_Y_PIN);
  pi_key_initone(KEY_X_PIN);
  /*
  pinMode(A4, INPUT); 
  // in the prototype this is wired though a pull down, in the breadboard not    
  digitalWrite(A4,HIGH); // enble pull-up resistor
  // it should be changed in the final design
  pinMode(A3, INPUT);
  digitalWrite(A3,HIGH); // enble pull-up resistor
  pinMode(A2, INPUT);
  digitalWrite(A2, HIGH); // enble pull-up resistor
  pinMode(A1, INPUT);
  digitalWrite(A1,HIGH); // enble pull-up resistor
  pinMode(A0, INPUT);
  digitalWrite(A0,HIGH); // enble pull-up resistor
  pinMode(7, INPUT);
  digitalWrite(7,HIGH); // enble pull-up resistor
  pinMode(7, INPUT);
  digitalWrite(7,HIGH); // enble pull-up resistor
  pinMode(11, INPUT);
  digitalWrite(11,HIGH); // enble pull-up resistor
  pinMode(13, INPUT);
  digitalWrite(13,HIGH); // enble pull-up resistor
  */
}

#define PI_KEY_IS(PIN) (!digitalRead(PIN))

char pi_key_left() {
  return PI_KEY_IS(KEY_LEFT_PIN);
}

char pi_key_down() {
  return PI_KEY_IS(KEY_DOWN_PIN);
}

char pi_key_right() {
  return PI_KEY_IS(KEY_RIGHT_PIN);
}

char pi_key_up() {
  return PI_KEY_IS(KEY_UP_PIN);
}

char pi_key_a() {
  return PI_KEY_IS(KEY_A_PIN);
}

char pi_key_b() {
  return PI_KEY_IS(KEY_B_PIN);
}

char pi_key_x() {
  // On breadboard the X key is inverted due to the led and wiring needed on pin 13 of the Arduino.
  #if PI_HARDWARE == PI_BREADBOARD 
    return !PI_KEY_IS(KEY_X_PIN);
  #else  
    return PI_KEY_IS(KEY_X_PIN);  
  #endif  
}

char pi_key_y() {
  return PI_KEY_IS(KEY_Y_PIN);
}


void setup(void) {
  // pinMode(ledPin, OUTPUT);  
  pi_music_init(MUSIC_HAIL_TO_THE_CHIEF3, MUSIC_HAIL_TO_THE_CHIEF3_SIZE);
  pi_key_init();


//  Serial.begin(9600);  
//  Serial.println("Start!");
  // lcd.init();
  pi_lcd_open(LCD_SCLK_PIN, LCD_DIN_PIN, LCD_DC_PIN, LCD_CS_PIN, LCD_RST_PIN);
  pi_lcd_init(35);
  // Clear the display. 
  pi_lcd_clear();
  
  // you can change the contrast around to adapt the display
  // for the best viewing!
  // pi_lcd_contrast(50);
  // lcd.setContrast(50);
  // turn all the pixels on (a handy test)
  // lcd.command(PCD8544_DISPLAYCONTROL | PCD8544_DISPLAYALLON);
  pi_lcd_allon();
  delay(500);
  pi_lcd_normal();
  //  back to normal
  // lcd.command(PCD8544_DISPLAYCONTROL | PCD8544_DISPLAYNORMAL);

  // show splashscreen
  // lcd.display();
  /*
  //delay(2000);
  lcd.clear();

  // draw a single pixel
  lcd.setPixel(10, 10, BLACK);
  lcd.display();        // show the changes to the buffer
  delay(2000);
  lcd.clear();
 
   // draw many lines
  testdrawline();
  lcd.display();       // show the lines
 // lcd.clear();
  
  // draw rectangles
  testdrawrect();
  lcd.display();
  delay(2000);
  lcd.clear();
  
  
  // draw multiple rectangles
  testfillrect();
  lcd.display();
  delay(2000);
  lcd.clear();
  
  // draw mulitple circles
  testdrawcircle();
  lcd.display();
  delay(2000);
  lcd.clear();
  
  // draw the first ~120 characters in the font
  testdrawchar();
  lcd.display();
  delay(2000);
  lcd.clear();

  // draw a string at location (0,0)
  lcd.setCursor(0, 0);
  lcd.print("Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor");
  lcd.display();
  delay(2000);
  lcd.clear();

  // draw other characters, variables and such
  lcd.setCursor(0, 20);
  lcd.println(0xAB, HEX);
  lcd.print(99.99);
  lcd.println('%');
  lcd.display();
  delay(2000);
  lcd.clear();
  */
  // draw a bitmap icon and 'animate' movement
  // testdrawbitmap(logo16_glcd_bmp, LOGO16_GLCD_HEIGHT, LOGO16_GLCD_WIDTH);
  pi_lcd_setone(0, 0, 0xff);
  pi_lcd_setone(2, 2, 0xff); 
  pi_lcd_setone(4, 4, 0xff);
  pi_lcd_flush();
  // pi_lcd_setone(6, 6, 0xff);
//  Serial.println("Drawing!");
  draw_obama();

//  Serial.println("Draw ok!");
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
	//lcd.setPixel(x+xx, y+yy, color);
      } /*else {
        lcd.setPixel(x+xx, y+yy, WHITE);
      }*/
    }
  }
}

void draw_obama(void) {
  /*
  lcd.clear();
  #ifdef DYMO
  for(int i = -32 ; i < 1; i ++) {  
    lcd.clear();
//    my_drawbitmap(-10, i-1, IMAGE_DYMO_BMP, IMAGE_DYMO_WIDE, IMAGE_DYMO_HIGH, WHITE);
    my_drawbitmap(0, i, IMAGE_DYMO_BMP, IMAGE_DYMO_WIDE, IMAGE_DYMO_HIGH, BLACK);    
    lcd.display();
    // delay(100);    
  }  
  #else
  my_drawbitmap(0, 0, IMAGE_OBAMA_BMP, IMAGE_OBAMA_WIDE, IMAGE_OBAMA_HIGH, BLACK);
  #endif
  #ifdef DYMO
  lcd.setCursor(0, 34);
  lcd.println("BDM 0528");
  #else
  lcd.setCursor(48, 10);
  lcd.println("Obama!");
  #endif
  lcd.display();
  */
}

void check_key(int res, char * buf, int index, char chon, int choff) {
  if(res) {
    buf[index] = chon;
  } else {  
    buf[index] = choff;
  }  
}

void loop(void) {
  pi_music_update();  
  char buf[9] = "        ";   
  /* lcd.setCursor(0, 34); */
  check_key(pi_key_left() , buf, 0, 'L', 'l');
  check_key(pi_key_down() , buf, 1, 'D', 'd');
  check_key(pi_key_right(), buf, 2, 'R', 'r');
  check_key(pi_key_up()   , buf, 3, 'U', 'u');
  check_key(pi_key_a()    , buf, 4, 'A', 'a');
  check_key(pi_key_b()    , buf, 5, 'B', 'b');
  check_key(pi_key_x()    , buf, 6, 'X', 'x');
  check_key(pi_key_y()    , buf, 7, 'Y', 'y');
  /*
  lcd.println(buf);        
  lcd.display();
  */
}



