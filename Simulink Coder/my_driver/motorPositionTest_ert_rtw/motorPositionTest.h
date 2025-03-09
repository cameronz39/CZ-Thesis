/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: motorPositionTest.h
 *
 * Code generated for Simulink model 'motorPositionTest'.
 *
 * Model version                  : 1.4
 * Simulink Coder version         : 24.2 (R2024b) 21-Jun-2024
 * C/C++ source code generated on : Fri Dec 20 19:25:08 2024
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Atmel->AVR
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef motorPositionTest_h_
#define motorPositionTest_h_
#ifndef motorPositionTest_COMMON_INCLUDES_
#define motorPositionTest_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "ext_mode.h"
#include "MW_ArduinoEncoder.h"
#include "ShieldWrapper.h"
#endif                                 /* motorPositionTest_COMMON_INCLUDES_ */

#include "motorPositionTest_types.h"
#include <math.h>
#include <string.h>
#include "MW_target_hardware_resources.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetContStateDisabled
#define rtmGetContStateDisabled(rtm)   ((rtm)->contStateDisabled)
#endif

#ifndef rtmSetContStateDisabled
#define rtmSetContStateDisabled(rtm, val) ((rtm)->contStateDisabled = (val))
#endif

#ifndef rtmGetContStates
#define rtmGetContStates(rtm)          ((rtm)->contStates)
#endif

#ifndef rtmSetContStates
#define rtmSetContStates(rtm, val)     ((rtm)->contStates = (val))
#endif

#ifndef rtmGetContTimeOutputInconsistentWithStateAtMajorStepFlag
#define rtmGetContTimeOutputInconsistentWithStateAtMajorStepFlag(rtm) ((rtm)->CTOutputIncnstWithState)
#endif

#ifndef rtmSetContTimeOutputInconsistentWithStateAtMajorStepFlag
#define rtmSetContTimeOutputInconsistentWithStateAtMajorStepFlag(rtm, val) ((rtm)->CTOutputIncnstWithState = (val))
#endif

#ifndef rtmGetDerivCacheNeedsReset
#define rtmGetDerivCacheNeedsReset(rtm) ((rtm)->derivCacheNeedsReset)
#endif

#ifndef rtmSetDerivCacheNeedsReset
#define rtmSetDerivCacheNeedsReset(rtm, val) ((rtm)->derivCacheNeedsReset = (val))
#endif

#ifndef rtmGetFinalTime
#define rtmGetFinalTime(rtm)           ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetIntgData
#define rtmGetIntgData(rtm)            ((rtm)->intgData)
#endif

#ifndef rtmSetIntgData
#define rtmSetIntgData(rtm, val)       ((rtm)->intgData = (val))
#endif

#ifndef rtmGetOdeF
#define rtmGetOdeF(rtm)                ((rtm)->odeF)
#endif

#ifndef rtmSetOdeF
#define rtmSetOdeF(rtm, val)           ((rtm)->odeF = (val))
#endif

#ifndef rtmGetOdeY
#define rtmGetOdeY(rtm)                ((rtm)->odeY)
#endif

#ifndef rtmSetOdeY
#define rtmSetOdeY(rtm, val)           ((rtm)->odeY = (val))
#endif

#ifndef rtmGetPeriodicContStateIndices
#define rtmGetPeriodicContStateIndices(rtm) ((rtm)->periodicContStateIndices)
#endif

#ifndef rtmSetPeriodicContStateIndices
#define rtmSetPeriodicContStateIndices(rtm, val) ((rtm)->periodicContStateIndices = (val))
#endif

#ifndef rtmGetPeriodicContStateRanges
#define rtmGetPeriodicContStateRanges(rtm) ((rtm)->periodicContStateRanges)
#endif

#ifndef rtmSetPeriodicContStateRanges
#define rtmSetPeriodicContStateRanges(rtm, val) ((rtm)->periodicContStateRanges = (val))
#endif

#ifndef rtmGetRTWExtModeInfo
#define rtmGetRTWExtModeInfo(rtm)      ((rtm)->extModeInfo)
#endif

#ifndef rtmGetZCCacheNeedsReset
#define rtmGetZCCacheNeedsReset(rtm)   ((rtm)->zCCacheNeedsReset)
#endif

#ifndef rtmSetZCCacheNeedsReset
#define rtmSetZCCacheNeedsReset(rtm, val) ((rtm)->zCCacheNeedsReset = (val))
#endif

#ifndef rtmGetdX
#define rtmGetdX(rtm)                  ((rtm)->derivs)
#endif

#ifndef rtmSetdX
#define rtmSetdX(rtm, val)             ((rtm)->derivs = (val))
#endif

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmStepTask
#define rtmStepTask(rtm, idx)          ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   (rtmGetTPtr((rtm))[0])
#endif

#ifndef rtmGetTFinal
#define rtmGetTFinal(rtm)              ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
#define rtmGetTPtr(rtm)                ((rtm)->Timing.t)
#endif

#ifndef rtmGetTStart
#define rtmGetTStart(rtm)              ((rtm)->Timing.tStart)
#endif

#ifndef rtmTaskCounter
#define rtmTaskCounter(rtm, idx)       ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

/* Block signals (default storage) */
typedef struct {
  real_T Integrator;                   /* '<Root>/Integrator' */
  real_T TmpRTBAtSumInport1;           /* '<Root>/Subtract' */
  real_T FilterCoefficient;            /* '<S39>/Filter Coefficient' */
  real_T Sum;                          /* '<S45>/Sum' */
  real_T Gain2;                        /* '<Root>/Gain2' */
  real_T IntegralGain;                 /* '<S33>/Integral Gain' */
  real_T Gain1;                        /* '<Root>/Gain1' */
  int32_T Encoder;                     /* '<Root>/Encoder' */
} B_motorPositionTest_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  codertarget_arduinobase_inter_T obj; /* '<Root>/Encoder' */
  ShieldSysObj_motorPositionTes_T obj_p;/* '<Root>/MATLAB System' */
  real_T TmpRTBAtSumInport1_Buffer0;   /* synthesized block */
  struct {
    void *LoggedData;
  } Scope_PWORK;                       /* '<Root>/Scope' */

  struct {
    void *LoggedData;
  } Scope2_PWORK;                      /* '<Root>/Scope2' */

  struct {
    void *LoggedData;
  } Scope1_PWORK;                      /* '<Root>/Scope1' */

  struct {
    void *LoggedData;
  } Scope4_PWORK;                      /* '<Root>/Scope4' */

  struct {
    void *LoggedData;
  } Scope3_PWORK;                      /* '<Root>/Scope3' */

  int32_T UnitDelay_DSTATE;            /* '<Root>/Unit Delay' */
  int32_T clockTickCounter;            /* '<Root>/Pulse Generator' */
} DW_motorPositionTest_T;

/* Continuous states (default storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<Root>/Integrator' */
  real_T Integrator_CSTATE_e;          /* '<S36>/Integrator' */
  real_T Filter_CSTATE;                /* '<S31>/Filter' */
} X_motorPositionTest_T;

/* State derivatives (default storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<Root>/Integrator' */
  real_T Integrator_CSTATE_e;          /* '<S36>/Integrator' */
  real_T Filter_CSTATE;                /* '<S31>/Filter' */
} XDot_motorPositionTest_T;

/* State disabled  */
typedef struct {
  boolean_T Integrator_CSTATE;         /* '<Root>/Integrator' */
  boolean_T Integrator_CSTATE_e;       /* '<S36>/Integrator' */
  boolean_T Filter_CSTATE;             /* '<S31>/Filter' */
} XDis_motorPositionTest_T;

#ifndef ODE3_INTG
#define ODE3_INTG

/* ODE3 Integration Data */
typedef struct {
  real_T *y;                           /* output */
  real_T *f[3];                        /* derivatives */
} ODE3_IntgData;

#endif

/* Parameters (default storage) */
struct P_motorPositionTest_T_ {
  real_T PIDController_D;              /* Mask Parameter: PIDController_D
                                        * Referenced by: '<S29>/Derivative Gain'
                                        */
  real_T PIDController_I;              /* Mask Parameter: PIDController_I
                                        * Referenced by: '<S33>/Integral Gain'
                                        */
  real_T PIDController_InitialConditionF;
                              /* Mask Parameter: PIDController_InitialConditionF
                               * Referenced by: '<S31>/Filter'
                               */
  real_T PIDController_InitialConditio_j;
                              /* Mask Parameter: PIDController_InitialConditio_j
                               * Referenced by: '<S36>/Integrator'
                               */
  real_T PIDController_N;              /* Mask Parameter: PIDController_N
                                        * Referenced by: '<S39>/Filter Coefficient'
                                        */
  real_T PIDController_P;              /* Mask Parameter: PIDController_P
                                        * Referenced by: '<S41>/Proportional Gain'
                                        */
  real_T Integrator_IC;                /* Expression: 90
                                        * Referenced by: '<Root>/Integrator'
                                        */
  real_T TmpRTBAtSumInport1_InitialCondi;/* Expression: 0
                                          * Referenced by:
                                          */
  real_T Gain2_Gain;                   /* Expression: -1
                                        * Referenced by: '<Root>/Gain2'
                                        */
  real_T Constant2_Value;              /* Expression: 48*45
                                        * Referenced by: '<Root>/Constant2'
                                        */
  real_T Gain1_Gain;                   /* Expression: 360
                                        * Referenced by: '<Root>/Gain1'
                                        */
  real_T Constant_Value;               /* Expression: 90
                                        * Referenced by: '<Root>/Constant'
                                        */
  real_T PulseGenerator_Amp;           /* Expression: 180
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  real_T PulseGenerator_Period;     /* Computed Parameter: PulseGenerator_Period
                                     * Referenced by: '<Root>/Pulse Generator'
                                     */
  real_T PulseGenerator_Duty;         /* Computed Parameter: PulseGenerator_Duty
                                       * Referenced by: '<Root>/Pulse Generator'
                                       */
  real_T PulseGenerator_PhaseDelay;    /* Expression: 0
                                        * Referenced by: '<Root>/Pulse Generator'
                                        */
  int32_T Constant1_Value;             /* Computed Parameter: Constant1_Value
                                        * Referenced by: '<Root>/Constant1'
                                        */
  int32_T UnitDelay_InitialCondition;
                               /* Computed Parameter: UnitDelay_InitialCondition
                                * Referenced by: '<Root>/Unit Delay'
                                */
  int32_T Gain_Gain;                   /* Computed Parameter: Gain_Gain
                                        * Referenced by: '<Root>/Gain'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_motorPositionTest_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;
  RTWSolverInfo solverInfo;
  X_motorPositionTest_T *contStates;
  int_T *periodicContStateIndices;
  real_T *periodicContStateRanges;
  real_T *derivs;
  XDis_motorPositionTest_T *contStateDisabled;
  boolean_T zCCacheNeedsReset;
  boolean_T derivCacheNeedsReset;
  boolean_T CTOutputIncnstWithState;
  real_T odeY[3];
  real_T odeF[3][3];
  ODE3_IntgData intgData;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
    int_T numContStates;
    int_T numPeriodicContStates;
    int_T numSampTimes;
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    time_T stepSize0;
    uint32_T clockTick1;
    uint16_T clockTick2;
    struct {
      uint16_T TID[3];
    } TaskCounters;

    struct {
      boolean_T TID1_2;
    } RateInteraction;

    time_T tStart;
    time_T tFinal;
    SimTimeStep simTimeStep;
    boolean_T stopRequestedFlag;
    time_T *t;
    time_T tArray[3];
  } Timing;
};

/* Block parameters (default storage) */
extern P_motorPositionTest_T motorPositionTest_P;

/* Block signals (default storage) */
extern B_motorPositionTest_T motorPositionTest_B;

/* Continuous states (default storage) */
extern X_motorPositionTest_T motorPositionTest_X;

/* Disabled states (default storage) */
extern XDis_motorPositionTest_T motorPositionTest_XDis;

/* Block states (default storage) */
extern DW_motorPositionTest_T motorPositionTest_DW;

/* External function called from main */
extern void motorPositionTest_SetEventsForThisBaseStep(boolean_T *eventFlags);

/* Model entry point functions */
extern void motorPositionTest_initialize(void);
extern void motorPositionTest_step0(void);
extern void motorPositionTest_step2(void);/* Sample time: [5.0s, 0.0s] */
extern void motorPositionTest_terminate(void);

/* Real-time Model object */
extern RT_MODEL_motorPositionTest_T *const motorPositionTest_M;
extern volatile boolean_T stopRequested;
extern volatile boolean_T runModel;

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
 * '<Root>' : 'motorPositionTest'
 * '<S1>'   : 'motorPositionTest/PID Controller'
 * '<S2>'   : 'motorPositionTest/PID Controller/Anti-windup'
 * '<S3>'   : 'motorPositionTest/PID Controller/D Gain'
 * '<S4>'   : 'motorPositionTest/PID Controller/External Derivative'
 * '<S5>'   : 'motorPositionTest/PID Controller/Filter'
 * '<S6>'   : 'motorPositionTest/PID Controller/Filter ICs'
 * '<S7>'   : 'motorPositionTest/PID Controller/I Gain'
 * '<S8>'   : 'motorPositionTest/PID Controller/Ideal P Gain'
 * '<S9>'   : 'motorPositionTest/PID Controller/Ideal P Gain Fdbk'
 * '<S10>'  : 'motorPositionTest/PID Controller/Integrator'
 * '<S11>'  : 'motorPositionTest/PID Controller/Integrator ICs'
 * '<S12>'  : 'motorPositionTest/PID Controller/N Copy'
 * '<S13>'  : 'motorPositionTest/PID Controller/N Gain'
 * '<S14>'  : 'motorPositionTest/PID Controller/P Copy'
 * '<S15>'  : 'motorPositionTest/PID Controller/Parallel P Gain'
 * '<S16>'  : 'motorPositionTest/PID Controller/Reset Signal'
 * '<S17>'  : 'motorPositionTest/PID Controller/Saturation'
 * '<S18>'  : 'motorPositionTest/PID Controller/Saturation Fdbk'
 * '<S19>'  : 'motorPositionTest/PID Controller/Sum'
 * '<S20>'  : 'motorPositionTest/PID Controller/Sum Fdbk'
 * '<S21>'  : 'motorPositionTest/PID Controller/Tracking Mode'
 * '<S22>'  : 'motorPositionTest/PID Controller/Tracking Mode Sum'
 * '<S23>'  : 'motorPositionTest/PID Controller/Tsamp - Integral'
 * '<S24>'  : 'motorPositionTest/PID Controller/Tsamp - Ngain'
 * '<S25>'  : 'motorPositionTest/PID Controller/postSat Signal'
 * '<S26>'  : 'motorPositionTest/PID Controller/preInt Signal'
 * '<S27>'  : 'motorPositionTest/PID Controller/preSat Signal'
 * '<S28>'  : 'motorPositionTest/PID Controller/Anti-windup/Passthrough'
 * '<S29>'  : 'motorPositionTest/PID Controller/D Gain/Internal Parameters'
 * '<S30>'  : 'motorPositionTest/PID Controller/External Derivative/Error'
 * '<S31>'  : 'motorPositionTest/PID Controller/Filter/Cont. Filter'
 * '<S32>'  : 'motorPositionTest/PID Controller/Filter ICs/Internal IC - Filter'
 * '<S33>'  : 'motorPositionTest/PID Controller/I Gain/Internal Parameters'
 * '<S34>'  : 'motorPositionTest/PID Controller/Ideal P Gain/Passthrough'
 * '<S35>'  : 'motorPositionTest/PID Controller/Ideal P Gain Fdbk/Disabled'
 * '<S36>'  : 'motorPositionTest/PID Controller/Integrator/Continuous'
 * '<S37>'  : 'motorPositionTest/PID Controller/Integrator ICs/Internal IC'
 * '<S38>'  : 'motorPositionTest/PID Controller/N Copy/Disabled'
 * '<S39>'  : 'motorPositionTest/PID Controller/N Gain/Internal Parameters'
 * '<S40>'  : 'motorPositionTest/PID Controller/P Copy/Disabled'
 * '<S41>'  : 'motorPositionTest/PID Controller/Parallel P Gain/Internal Parameters'
 * '<S42>'  : 'motorPositionTest/PID Controller/Reset Signal/Disabled'
 * '<S43>'  : 'motorPositionTest/PID Controller/Saturation/Passthrough'
 * '<S44>'  : 'motorPositionTest/PID Controller/Saturation Fdbk/Disabled'
 * '<S45>'  : 'motorPositionTest/PID Controller/Sum/Sum_PID'
 * '<S46>'  : 'motorPositionTest/PID Controller/Sum Fdbk/Disabled'
 * '<S47>'  : 'motorPositionTest/PID Controller/Tracking Mode/Disabled'
 * '<S48>'  : 'motorPositionTest/PID Controller/Tracking Mode Sum/Passthrough'
 * '<S49>'  : 'motorPositionTest/PID Controller/Tsamp - Integral/TsSignalSpecification'
 * '<S50>'  : 'motorPositionTest/PID Controller/Tsamp - Ngain/Passthrough'
 * '<S51>'  : 'motorPositionTest/PID Controller/postSat Signal/Forward_Path'
 * '<S52>'  : 'motorPositionTest/PID Controller/preInt Signal/Internal PreInt'
 * '<S53>'  : 'motorPositionTest/PID Controller/preSat Signal/Forward_Path'
 */
#endif                                 /* motorPositionTest_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
