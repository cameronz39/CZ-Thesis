/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: stm32_hwi_gettingstarted.h
 *
 * Code generated for Simulink model 'stm32_hwi_gettingstarted'.
 *
 * Model version                  : 7.5
 * Simulink Coder version         : 24.2 (R2024b) 21-Jun-2024
 * C/C++ source code generated on : Fri Feb  7 23:50:47 2025
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef stm32_hwi_gettingstarted_h_
#define stm32_hwi_gettingstarted_h_
#ifndef stm32_hwi_gettingstarted_COMMON_INCLUDES_
#define stm32_hwi_gettingstarted_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "main.h"
#include "BlinkWrapper.h"
#endif                           /* stm32_hwi_gettingstarted_COMMON_INCLUDES_ */

#include "mw_stm32_nvic.h"
#include "stm32_hwi_gettingstarted_types.h"
#include <stddef.h>
#include "MW_target_hardware_resources.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmStepTask
#define rtmStepTask(rtm, idx)          ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmTaskCounter
#define rtmTaskCounter(rtm, idx)       ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

/* Block signals (default storage) */
typedef struct {
  real_T TmpRTBAtMultiportSwitchInport3;/* '<Root>/Toggle at every 500ms' */
  real_T TmpRTBAtMultiportSwitchInport4;/* '<Root>/Toggle at every 1000ms' */
  real_T Out;                          /* '<S11>/Out' */
} B_stm32_hwi_gettingstarted_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  Sink_stm32_hwi_gettingstarted_T obj; /* '<Root>/MATLAB System' */
  real_T TmpRTBAtMultiportSwitchInport3_;/* synthesized block */
  real_T TmpRTBAtMultiportSwitchInport4_;/* synthesized block */
  int32_T clockTickCounter;            /* '<S5>/Pulse Generator' */
  int32_T clockTickCounter_b;          /* '<S6>/Pulse Generator' */
  int32_T clockTickCounter_c;          /* '<S4>/Pulse Generator' */
  uint8_T Output_DSTATE;               /* '<S12>/Output' */
} DW_stm32_hwi_gettingstarted_T;

/* Parameters (default storage) */
struct P_stm32_hwi_gettingstarted_T_ {
  real_T RepeatingSequenceStair_OutValue[3];
                              /* Mask Parameter: RepeatingSequenceStair_OutValue
                               * Referenced by: '<S11>/Vector'
                               */
  uint8_T WrapToZero_Threshold;        /* Mask Parameter: WrapToZero_Threshold
                                        * Referenced by: '<S14>/FixPt Switch'
                                        */
  real_T Out1_Y0;                      /* Computed Parameter: Out1_Y0
                                        * Referenced by: '<S3>/Out1'
                                        */
  real_T PulseGenerator_Amp;           /* Expression: 1
                                        * Referenced by: '<S5>/Pulse Generator'
                                        */
  real_T PulseGenerator_Period;        /* Expression: 2
                                        * Referenced by: '<S5>/Pulse Generator'
                                        */
  real_T PulseGenerator_Duty;          /* Expression: 1
                                        * Referenced by: '<S5>/Pulse Generator'
                                        */
  real_T PulseGenerator_PhaseDelay;    /* Expression: 0
                                        * Referenced by: '<S5>/Pulse Generator'
                                        */
  real_T TmpRTBAtMultiportSwitchInport3_;/* Expression: 0
                                          * Referenced by:
                                          */
  real_T TmpRTBAtMultiportSwitchInport4_;/* Expression: 0
                                          * Referenced by:
                                          */
  real_T PulseGenerator_Amp_i;         /* Expression: 1
                                        * Referenced by: '<S6>/Pulse Generator'
                                        */
  real_T PulseGenerator_Period_p;      /* Expression: 2
                                        * Referenced by: '<S6>/Pulse Generator'
                                        */
  real_T PulseGenerator_Duty_j;        /* Expression: 1
                                        * Referenced by: '<S6>/Pulse Generator'
                                        */
  real_T PulseGenerator_PhaseDelay_c;  /* Expression: 0
                                        * Referenced by: '<S6>/Pulse Generator'
                                        */
  real_T PulseGenerator_Amp_m;         /* Expression: 1
                                        * Referenced by: '<S4>/Pulse Generator'
                                        */
  real_T PulseGenerator_Period_m;      /* Expression: 2
                                        * Referenced by: '<S4>/Pulse Generator'
                                        */
  real_T PulseGenerator_Duty_a;        /* Expression: 1
                                        * Referenced by: '<S4>/Pulse Generator'
                                        */
  real_T PulseGenerator_PhaseDelay_a;  /* Expression: 0
                                        * Referenced by: '<S4>/Pulse Generator'
                                        */
  uint8_T Constant_Value;              /* Computed Parameter: Constant_Value
                                        * Referenced by: '<S14>/Constant'
                                        */
  uint8_T Output_InitialCondition;/* Computed Parameter: Output_InitialCondition
                                   * Referenced by: '<S12>/Output'
                                   */
  uint8_T FixPtConstant_Value;        /* Computed Parameter: FixPtConstant_Value
                                       * Referenced by: '<S13>/FixPt Constant'
                                       */
};

/* Real-time Model Data Structure */
struct tag_RTM_stm32_hwi_gettingstar_T {
  const char_T * volatile errorStatus;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    struct {
      uint8_T TID[3];
    } TaskCounters;

    struct {
      boolean_T TID0_1;
      boolean_T TID0_2;
    } RateInteraction;
  } Timing;
};

/* Block parameters (default storage) */
extern P_stm32_hwi_gettingstarted_T stm32_hwi_gettingstarted_P;

/* Block signals (default storage) */
extern B_stm32_hwi_gettingstarted_T stm32_hwi_gettingstarted_B;

/* Block states (default storage) */
extern DW_stm32_hwi_gettingstarted_T stm32_hwi_gettingstarted_DW;

/* External function called from main */
extern void stm32_hwi_gettingstarted_SetEventsForThisBaseStep(boolean_T
  *eventFlags);

/* Model entry point functions */
extern void stm32_hwi_gettingstarted_initialize(void);
extern void stm32_hwi_gettingstarted_step0(void);/* Sample time: [0.1s, 0.0s] */
extern void stm32_hwi_gettingstarted_step1(void);/* Sample time: [0.5s, 0.0s] */
extern void stm32_hwi_gettingstarted_step2(void);/* Sample time: [1.0s, 0.0s] */
extern void stm32_hwi_gettingstarted_terminate(void);

/* Real-time Model object */
extern RT_MODEL_stm32_hwi_gettingsta_T *const stm32_hwi_gettingstarted_M;
extern volatile boolean_T stopRequested;
extern volatile boolean_T runModel;

#ifdef __cpluscplus

extern "C"
{

#endif

  void EXTI15_10_IRQHandler(void);
  void stm32_hwi_gettingstarted_configure_interrupts (void);
  void stm32_hwi_gettingstarted_unconfigure_interrupts (void);

#ifdef __cpluscplus

}

#endif

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<S12>/Data Type Propagation' : Unused code path elimination
 * Block '<S13>/FixPt Data Type Duplicate' : Unused code path elimination
 * Block '<S14>/FixPt Data Type Duplicate1' : Unused code path elimination
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'stm32_hwi_gettingstarted'
 * '<S1>'   : 'stm32_hwi_gettingstarted/Blue LED'
 * '<S2>'   : 'stm32_hwi_gettingstarted/Hardware Interrupt1'
 * '<S3>'   : 'stm32_hwi_gettingstarted/ISR for Event'
 * '<S4>'   : 'stm32_hwi_gettingstarted/Toggle at every 1000ms'
 * '<S5>'   : 'stm32_hwi_gettingstarted/Toggle at every 100ms'
 * '<S6>'   : 'stm32_hwi_gettingstarted/Toggle at every 500ms'
 * '<S7>'   : 'stm32_hwi_gettingstarted/Blue LED/ECSoC'
 * '<S8>'   : 'stm32_hwi_gettingstarted/Blue LED/ECSoC/ECSimCodegen'
 * '<S9>'   : 'stm32_hwi_gettingstarted/Hardware Interrupt1/ECSoC'
 * '<S10>'  : 'stm32_hwi_gettingstarted/Hardware Interrupt1/ECSoC/ECSimCodegen'
 * '<S11>'  : 'stm32_hwi_gettingstarted/ISR for Event/Repeating Sequence Stair'
 * '<S12>'  : 'stm32_hwi_gettingstarted/ISR for Event/Repeating Sequence Stair/LimitedCounter'
 * '<S13>'  : 'stm32_hwi_gettingstarted/ISR for Event/Repeating Sequence Stair/LimitedCounter/Increment Real World'
 * '<S14>'  : 'stm32_hwi_gettingstarted/ISR for Event/Repeating Sequence Stair/LimitedCounter/Wrap To Zero'
 */
#endif                                 /* stm32_hwi_gettingstarted_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
