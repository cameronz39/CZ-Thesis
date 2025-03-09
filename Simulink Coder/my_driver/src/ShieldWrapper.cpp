#include "ShieldWrapper.h"
#include "ShieldArduino.h"

ShieldArduino shieldInstance; // Create instance of the Shield class
extern "C" void ShieldWrapper_Init(void) {
   shieldInstance.begin(); // Initialize the motor shield
}
extern "C" void ShieldWrapper_Step(double potValue, int mode) {
   shieldInstance.updateMotor(potValue, mode); // Update motor based on potentiometer value
}
extern "C" void ShieldWrapper_Terminate(void) {
   // No termination needed for this example
}
