#ifndef ShieldArduino_h
#define ShieldArduino_h
#include "Arduino.h"
#define  DIR_CLK 4 //SHCP of the Shift Register 74HC595
#define  DIR_EN  7 //OE of the Shift Register 74HC595
#define  DIR_SER 8 //DS of the Shift Register 74HC595
#define  DIR_LATCH 12 //STCP of the Shift Register 74HC595
#define enM1 11 //For slots M1&M2 on the L293D Motor Shield
#define potMax 1023
//Bit positions in the 74HCT595 shift register output
#define  MOTOR1_A 2 //Q2
#define  MOTOR1_B 3 //Q3
class ShieldArduino
{
 public:
   ShieldArduino();
   void updateMotor(double potValue, int mode);
   void shiftWrite(byte input);
   void shiftOutCustom(uint8_t dataPin, uint8_t clockPin, uint8_t val);
  
   void begin();
   void setMotorValue(long in);
   long getMotorValue();
   void setDirections(byte in);
   byte getDirections();
 private:
   long motorValue;
   byte directions;
};
#endif