#ifndef PI_LCD_H
#define PI_LCD_H

/** The Pigeon LCD is a PCD8544 controlled LCD with a size of 84x48, 
and it was widely used in Nokia phones. */

#define BLACK 1
#define WHITE 0

#define PI_LCD_WIDE 84
#define PI_LCD_HIGH 48
/** Logical height of a single column of bits sent as a byte is 6 */
#define PI_LCD_COLHIGH 6

#define PI_LCD_POWERDOWN           0x04
#define PI_LCD_ENTRYMODE           0x02
#define PI_LCD_EXTENDEDINSTRUCTION 0x01
#define PI_LCD_DISPLAYBLANK        0x00
#define PI_LCD_DISPLAYNORMAL       0x04
#define PI_LCD_DISPLAYALLON        0x01
#define PI_LCD_DISPLAYINVERT       0x05

// H = 0
#define PI_LCD_FUNCTIONSET 0x20
#define PI_LCD_DISPLAYCONTROL 0x08
#define PI_LCD_SETYADDR 0x40
#define PI_LCD_SETXADDR 0x80

// H = 1
#define PI_LCD_SETTEMP 0x04
#define PI_LCD_SETBIAS 0x10
#define PI_LCD_SETVOP  0x80

#define PI_FONT_HIGH 8
#define PI_FONT_WIDE 6

extern unsigned char __attribute__ ((progmem)) PI_FONT_BMP[];


void pi_lcd_open(int8_t sclk, int8_t din, int8_t dc, int8_t cs, int8_t rst);
void pi_lcd_init(uint8_t contrast);
void pi_lcd_contrast(uint8_t contrast);
void pi_lcd_command(uint8_t command);
void pi_lcd_data(uint8_t data);
void pi_lcd_clear(void);
void pi_lcd_display(void);
void pi_lcd_setone(uint8_t x, uint8_t y, uint8_t pixels);
void pi_lcd_setrev(uint8_t x, uint8_t y, uint8_t pixels);
void pi_lcd_allon(void); 
void pi_lcd_normal(void);
void pi_lcd_flush(void);
void pi_lcd_rawblit_p(uint8_t x, uint8_t y, const uint8_t *bitmap, uint8_t w, uint8_t h, uint8_t color);

void pi_lcd_putc(uint8_t x, uint8_t y, char c);
void pi_lcd_puts(uint8_t x, uint8_t y, char * c);
void pi_lcd_puts_p(uint8_t x, uint8_t y, char * c);























#endif
