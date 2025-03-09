#ifndef BlinkWrapper_h
#define BlinkWrapper_h
#ifdef __cplusplus
extern "C" {
#endif

void BlinkWrapper_Init(void);
void BlinkWrapper_Step(void);
void BlinkWrapper_Terminate(void);

#ifdef __cplusplus
}
#endif
#endif