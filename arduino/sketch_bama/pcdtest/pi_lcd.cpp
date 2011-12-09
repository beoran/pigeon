
#include "pi.h"
#include "pi_lcd.h"

static uint8_t cursor_x, cursor_y, textsize, textcolor;
static int8_t din_, sclk_, dc_, rst_, cs_;

void pi_lcd_open(int8_t sclk, int8_t din, int8_t dc, int8_t cs, int8_t rst) {
  din_   = din;
  sclk_  = sclk;
  dc_    = dc;
  rst_   = rst;
  cs_    = cs;
  cursor_x = cursor_y = 0;
  textsize = 1;
  textcolor = BLACK;
}

static inline void pi_lcd_out(uint8_t c) {
  shiftOut(din_, sclk_, MSBFIRST, c);
}

void pi_lcd_command(uint8_t c) {
  digitalWrite(dc_, LOW);
  pi_lcd_out(c);
}

void pi_lcd_data(uint8_t c) {
  digitalWrite(dc_, HIGH);
  pi_lcd_out(c);
}

// Get into the EXTENDED mode!
void pi_lcd_extended_mode(void) {
  pi_lcd_command(PI_LCD_FUNCTIONSET | PI_LCD_EXTENDEDINSTRUCTION );
}

// Get into the NORMAL mode!
inline void pi_lcd_normal_mode(void) {
  pi_lcd_command(PI_LCD_FUNCTIONSET);
}

/** Sets the contrast of the screen by asjusting the VOP and the bias of the lcd. */
void pi_lcd_contrast_(uint8_t contrast) {
  if (contrast > 0x7f) {  contrast = 0x7f; }
  pi_lcd_extended_mode();
  pi_lcd_command(PI_LCD_SETBIAS | 0x4);     // Set the bias to 4 which seems best?
  pi_lcd_command(PI_LCD_SETVOP  | contrast); // Experimentally determined  
  pi_lcd_normal_mode();
}


void pi_lcd_init(uint8_t contrast) {
  // set pins to output mode
  pinMode(din_, OUTPUT);
  pinMode(sclk_, OUTPUT);
  pinMode(dc_, OUTPUT);
  pinMode(rst_, OUTPUT);
  pinMode(cs_, OUTPUT);

  // toggle RST low to reset; CS low so it'll listen to us
  if (cs_ > 0)  digitalWrite(cs_, LOW);
  digitalWrite(rst_, LOW);
  _delay_ms(500);
  digitalWrite(rst_, HIGH);
  pi_lcd_contrast_(contrast);
  
  // Set display to Normal
  pi_lcd_normal();

  // initial display line
  // set page address
  // set column address
  // write display data
  // set up a bounding box for screen updates
  // Clear the display
}

void pi_lcd_setyaddr(uint8_t p) { 
  pi_lcd_command(PI_LCD_SETYADDR | p);
}

void pi_lcd_setxaddr(uint8_t p) { 
  pi_lcd_command(PI_LCD_SETXADDR | p);
}

void pi_lcd_setone(uint8_t x, uint8_t y, uint8_t pixels) {
  pi_lcd_setyaddr(y);
  pi_lcd_setxaddr(x);
  pi_lcd_data(pixels);
}

void pi_lcd_invert(void) {  
  pi_lcd_command(PI_LCD_DISPLAYCONTROL | PI_LCD_DISPLAYINVERT);
}


void pi_lcd_allon(void) {  
  pi_lcd_command(PI_LCD_DISPLAYCONTROL | PI_LCD_DISPLAYALLON);
}

void pi_lcd_normal(void) {  
  pi_lcd_command(PI_LCD_DISPLAYCONTROL | PI_LCD_DISPLAYNORMAL);
}

void pi_lcd_clear(void) {
  int x, y;
  pi_lcd_setxaddr(0);
  pi_lcd_setyaddr(0);
  for (x = 0 ; x < PI_LCD_WIDE; x++) {
    for(y = 0; y < PI_LCD_COLHIGH; y++) {
      pi_lcd_data(0);
    }      
  }
}  

void pi_lcd_flush(void) { 
  // Needed to flush the sent bytes and finish the data communication.
  pi_lcd_command(PI_LCD_SETYADDR );  
}    




