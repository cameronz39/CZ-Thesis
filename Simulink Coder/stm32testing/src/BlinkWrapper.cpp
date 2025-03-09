#include "BlinkWrapper.h"
#include "main.h"
extern "C" void BlinkWrapper_Init(void) {
   int hello = TEST + 1;
}
extern "C" void BlinkWrapper_Step(void) {

}
extern "C" void BlinkWrapper_Terminate(void) {
   // No termination needed for this example
}