#include "Arduino.h"
#include "ShieldArduino.h"
ShieldArduino::ShieldArduino()
{
 motorValue = 0;
 directions = (0 << MOTOR1_A) | (0 << MOTOR1_B) | // Motor 1 off
                     0 | 0 |
                     0 | 0 |
                     0 | 0; 
}
void ShieldArduino::setMotorValue(long in)
{
   motorValue = in;
}
long ShieldArduino::getMotorValue()
{
   return motorValue;
}
void ShieldArduino::setDirections(byte in)
{
   directions = in;
}
byte ShieldArduino::getDirections()
{
   return directions;
}

void ShieldArduino::begin() {
 pinMode(DIR_SER, OUTPUT);
 pinMode(DIR_CLK, OUTPUT);
 pinMode(DIR_LATCH, OUTPUT);
 pinMode(DIR_EN, OUTPUT);
 // Set up PWM pins for motors
 pinMode(enM1, OUTPUT);
 digitalWrite(DIR_EN, LOW);
}

void ShieldArduino::updateMotor(double potValue, int mode) {
  /*if (mode == 1) {
    if (potValue > (potMax/2)) {
    setDirections(0b00000100);
    shiftWrite(getDirections());
    long temp = map(potValue, (potMax/2), potMax, 0, 255);
    setMotorValue(temp);
    } else {
      setDirections(0b00001000);
      shiftWrite(getDirections());
      long temp = map(potValue, (potMax/2), 0, 0, 255);
      setMotorValue(temp);
    }
    analogWrite(enM1, getMotorValue());
  */
  
  if(potValue > 0) {
    setDirections(0b00000100);
    shiftWrite(getDirections());   
  } else {
    setDirections(0b00001000);
    shiftWrite(getDirections());
  }
  setMotorValue(abs(potValue) + 60);
  analogWrite(enM1, getMotorValue()); 
}

 

void ShieldArduino::shiftWrite(byte input) {
  digitalWrite(DIR_LATCH, LOW); // Open latch

  // Loop through each bit in the value
  for (uint8_t i = 0; i < 8; i++) {
 
    if (input & 10000000) { // if MSB == 1
      digitalWrite(DIR_SER, HIGH); // write high to serial data
      } else {
        digitalWrite(DIR_SER, LOW); // write low to serial data
      }
      input <<= 1; // Shift input left one bit
    // Pulse clock
    digitalWrite(DIR_CLK, HIGH);
    delayMicroseconds(1); // Small delay
    digitalWrite(DIR_CLK, LOW);
    delayMicroseconds(1); // Small delay
  }
  digitalWrite(DIR_LATCH, HIGH); // Close latch
}

void ShieldArduino::shiftOutCustom(uint8_t dataPin, uint8_t clockPin, uint8_t val) {
    uint8_t i;
    // Loop through each bit in the value
    for (i = 0; i < 8; i++) {

            // MSB first
            if (val & 10000000) {
                digitalWrite(dataPin, HIGH);
            } else {
                digitalWrite(dataPin, LOW);
            }
            val <<= 1; // Shift data left
        // Pulse the clock pin to shift the data into the register
        digitalWrite(clockPin, HIGH);
        delayMicroseconds(100); // Small delay for clock pulse
        digitalWrite(clockPin, LOW);
        delayMicroseconds(100); // Small delay for clock pulse
    }
}
