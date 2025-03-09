#ifndef ShieldWrapper_h
#define ShieldWrapper_h
#ifdef __cplusplus
extern "C" {
#endif

void ShieldWrapper_Init(void);
void ShieldWrapper_Step(double potValue, int mode);
void ShieldWrapper_Terminate(void);

#ifdef __cplusplus
}
#endif
#endif
