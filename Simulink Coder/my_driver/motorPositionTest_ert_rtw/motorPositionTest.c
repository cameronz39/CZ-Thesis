/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: motorPositionTest.c
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

#include "motorPositionTest.h"
#include "rtwtypes.h"
#include "multiword_types.h"
#include "motorPositionTest_private.h"

/* Block signals (default storage) */
B_motorPositionTest_T motorPositionTest_B;

/* Continuous states */
X_motorPositionTest_T motorPositionTest_X;

/* Disabled State Vector */
XDis_motorPositionTest_T motorPositionTest_XDis;

/* Block states (default storage) */
DW_motorPositionTest_T motorPositionTest_DW;

/* Real-time model */
static RT_MODEL_motorPositionTest_T motorPositionTest_M_;
RT_MODEL_motorPositionTest_T *const motorPositionTest_M = &motorPositionTest_M_;
static void rate_monotonic_scheduler(void);
real_T sMultiWord2Double(const uint32_T u1[], int16_T n1, int16_T e1)
{
  real_T y;
  uint32_T cb;
  uint32_T u1i;
  int16_T exp_0;
  int16_T i;
  y = 0.0;
  exp_0 = e1;
  if ((u1[n1 - 1] & 2147483648UL) != 0UL) {
    cb = 1UL;
    for (i = 0; i < n1; i++) {
      u1i = ~u1[i];
      cb += u1i;
      y -= ldexp(cb, exp_0);
      cb = (uint32_T)(cb < u1i);
      exp_0 += 32;
    }
  } else {
    for (i = 0; i < n1; i++) {
      y += ldexp(u1[i], exp_0);
      exp_0 += 32;
    }
  }

  return y;
}

void sMultiWordMul(const uint32_T u1[], int16_T n1, const uint32_T u2[], int16_T
                   n2, uint32_T y[], int16_T n)
{
  uint32_T a0;
  uint32_T a1;
  uint32_T b1;
  uint32_T cb;
  uint32_T cb1;
  uint32_T cb2;
  uint32_T u1i;
  uint32_T w01;
  uint32_T w10;
  uint32_T yk;
  int16_T i;
  int16_T j;
  int16_T k;
  int16_T ni;
  boolean_T isNegative1;
  boolean_T isNegative2;
  isNegative1 = ((u1[n1 - 1] & 2147483648UL) != 0UL);
  isNegative2 = ((u2[n2 - 1] & 2147483648UL) != 0UL);
  cb1 = 1UL;

  /* Initialize output to zero */
  for (k = 0; k < n; k++) {
    y[k] = 0UL;
  }

  for (i = 0; i < n1; i++) {
    cb = 0UL;
    u1i = u1[i];
    if (isNegative1) {
      u1i = ~u1i + cb1;
      cb1 = (uint32_T)(u1i < cb1);
    }

    a1 = u1i >> 16U;
    a0 = u1i & 65535UL;
    cb2 = 1UL;
    ni = n - i;
    ni = n2 <= ni ? n2 : ni;
    k = i;
    for (j = 0; j < ni; j++) {
      u1i = u2[j];
      if (isNegative2) {
        u1i = ~u1i + cb2;
        cb2 = (uint32_T)(u1i < cb2);
      }

      b1 = u1i >> 16U;
      u1i &= 65535UL;
      w10 = a1 * u1i;
      w01 = a0 * b1;
      yk = y[k] + cb;
      cb = (uint32_T)(yk < cb);
      u1i *= a0;
      yk += u1i;
      cb += (uint32_T)(yk < u1i);
      u1i = w10 << 16U;
      yk += u1i;
      cb += (uint32_T)(yk < u1i);
      u1i = w01 << 16U;
      yk += u1i;
      cb += (uint32_T)(yk < u1i);
      y[k] = yk;
      cb += w10 >> 16U;
      cb += w01 >> 16U;
      cb += a1 * b1;
      k++;
    }

    if (k < n) {
      y[k] = cb;
    }
  }

  /* Apply sign */
  if (isNegative1 != isNegative2) {
    cb = 1UL;
    for (k = 0; k < n; k++) {
      yk = ~y[k] + cb;
      y[k] = yk;
      cb = (uint32_T)(yk < cb);
    }
  }
}

/*
 * Set which subrates need to run this base step (base rate always runs).
 * This function must be called prior to calling the model step function
 * in order to remember which rates need to run this base step.  The
 * buffering of events allows for overlapping preemption.
 */
void motorPositionTest_SetEventsForThisBaseStep(boolean_T *eventFlags)
{
  /* Task runs when its counter is zero, computed via rtmStepTask macro */
  eventFlags[2] = ((boolean_T)rtmStepTask(motorPositionTest_M, 2));
}

/*
 *         This function updates active task flag for each subrate
 *         and rate transition flags for tasks that exchange data.
 *         The function assumes rate-monotonic multitasking scheduler.
 *         The function must be called at model base rate so that
 *         the generated code self-manages all its subrates and rate
 *         transition flags.
 */
static void rate_monotonic_scheduler(void)
{
  /* To ensure a deterministic data transfer between two rates,
   * data is transferred at the priority of a fast task and the frequency
   * of the slow task.  The following flags indicate when the data transfer
   * happens.  That is, a rate interaction flag is set true when both rates
   * will run, and false otherwise.
   */

  /* tid 1 shares data with slower tid rate: 2 */
  if (motorPositionTest_M->Timing.TaskCounters.TID[1] == 0) {
    motorPositionTest_M->Timing.RateInteraction.TID1_2 =
      (motorPositionTest_M->Timing.TaskCounters.TID[2] == 0);
  }

  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (motorPositionTest_M->Timing.TaskCounters.TID[2])++;
  if ((motorPositionTest_M->Timing.TaskCounters.TID[2]) > 499) {/* Sample time: [5.0s, 0.0s] */
    motorPositionTest_M->Timing.TaskCounters.TID[2] = 0;
  }
}

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 3;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  motorPositionTest_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  motorPositionTest_step0();
  motorPositionTest_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  motorPositionTest_step0();
  motorPositionTest_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function for TID0 */
void motorPositionTest_step0(void)     /* Sample time: [0.0s, 0.0s] */
{
  int64m_T tmp_0;
  real_T rtb_Sum;
  uint32_T tmp_1;
  uint32_T tmp_2;
  boolean_T tmp;
  if (rtmIsMajorTimeStep(motorPositionTest_M)) {
    /* set solver stop time */
    rtsiSetSolverStopTime(&motorPositionTest_M->solverInfo,
                          ((motorPositionTest_M->Timing.clockTick0+1)*
      motorPositionTest_M->Timing.stepSize0));

    {                                  /* Sample time: [0.0s, 0.0s] */
      rate_monotonic_scheduler();
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(motorPositionTest_M)) {
    motorPositionTest_M->Timing.t[0] = rtsiGetT(&motorPositionTest_M->solverInfo);
  }

  /* Integrator: '<Root>/Integrator' */
  motorPositionTest_B.Integrator = motorPositionTest_X.Integrator_CSTATE;
  tmp = rtmIsMajorTimeStep(motorPositionTest_M);
  if (tmp) {
    /* RateTransition generated from: '<Root>/Sum' */
    if (motorPositionTest_M->Timing.RateInteraction.TID1_2) {
      /* RateTransition generated from: '<Root>/Sum' */
      motorPositionTest_B.TmpRTBAtSumInport1 =
        motorPositionTest_DW.TmpRTBAtSumInport1_Buffer0;
    }

    /* End of RateTransition generated from: '<Root>/Sum' */
  }

  /* Sum: '<Root>/Sum' */
  rtb_Sum = motorPositionTest_B.TmpRTBAtSumInport1 -
    motorPositionTest_B.Integrator;

  /* Gain: '<S39>/Filter Coefficient' incorporates:
   *  Gain: '<S29>/Derivative Gain'
   *  Integrator: '<S31>/Filter'
   *  Sum: '<S31>/SumD'
   */
  motorPositionTest_B.FilterCoefficient = (motorPositionTest_P.PIDController_D *
    rtb_Sum - motorPositionTest_X.Filter_CSTATE) *
    motorPositionTest_P.PIDController_N;

  /* Sum: '<S45>/Sum' incorporates:
   *  Gain: '<S41>/Proportional Gain'
   *  Integrator: '<S36>/Integrator'
   */
  motorPositionTest_B.Sum = (motorPositionTest_P.PIDController_P * rtb_Sum +
    motorPositionTest_X.Integrator_CSTATE_e) +
    motorPositionTest_B.FilterCoefficient;
  if (tmp) {
  }

  /* Gain: '<Root>/Gain2' */
  motorPositionTest_B.Gain2 = motorPositionTest_P.Gain2_Gain *
    motorPositionTest_B.Sum;

  /* MATLABSystem: '<Root>/MATLAB System' incorporates:
   *  Constant: '<Root>/Constant1'
   */
  /*         %% Define input properties */
  /*  Call C-function implementing device output */
  ShieldWrapper_Step(motorPositionTest_B.Gain2,
                     motorPositionTest_P.Constant1_Value);
  if (tmp) {
  }

  /* Gain: '<S33>/Integral Gain' */
  motorPositionTest_B.IntegralGain = motorPositionTest_P.PIDController_I *
    rtb_Sum;
  if (tmp) {
    /* MATLABSystem: '<Root>/Encoder' */
    if (motorPositionTest_DW.obj.TunablePropsChanged) {
      motorPositionTest_DW.obj.TunablePropsChanged = false;
    }

    /* MATLABSystem: '<Root>/Encoder' */
    MW_EncoderRead(motorPositionTest_DW.obj.Index, &motorPositionTest_B.Encoder);

    /* Gain: '<Root>/Gain' incorporates:
     *  Sum: '<Root>/Add'
     *  UnitDelay: '<Root>/Unit Delay'
     */
    tmp_1 = (uint32_T)motorPositionTest_P.Gain_Gain;
    tmp_2 = (uint32_T)(motorPositionTest_B.Encoder -
                       motorPositionTest_DW.UnitDelay_DSTATE);
    sMultiWordMul(&tmp_1, 1, &tmp_2, 1, &tmp_0.chunks[0U], 2);

    /* Gain: '<Root>/Gain1' incorporates:
     *  Constant: '<Root>/Constant2'
     *  Product: '<Root>/Divide'
     */
    motorPositionTest_B.Gain1 = sMultiWord2Double(&tmp_0.chunks[0U], 2, 0) *
      5.9604644775390625E-8 / motorPositionTest_P.Constant2_Value *
      motorPositionTest_P.Gain1_Gain;
  }

  if (rtmIsMajorTimeStep(motorPositionTest_M)) {
    if (rtmIsMajorTimeStep(motorPositionTest_M)) {
      /* Update for UnitDelay: '<Root>/Unit Delay' */
      motorPositionTest_DW.UnitDelay_DSTATE = motorPositionTest_B.Encoder;
    }

    {
      extmodeErrorCode_T returnCode = EXTMODE_SUCCESS;
      extmodeSimulationTime_T extmodeTime = (extmodeSimulationTime_T)
        ((motorPositionTest_M->Timing.clockTick1 * 1) + 0);

      /* Trigger External Mode event */
      returnCode = extmodeEvent(1, extmodeTime);
      if (returnCode != EXTMODE_SUCCESS) {
        /* Code to handle External Mode event errors
           may be added here */
      }
    }
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(motorPositionTest_M)) {
    rt_ertODEUpdateContinuousStates(&motorPositionTest_M->solverInfo);

    /* Update absolute time */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     */
    ++motorPositionTest_M->Timing.clockTick0;
    motorPositionTest_M->Timing.t[0] = rtsiGetSolverStopTime
      (&motorPositionTest_M->solverInfo);

    /* Update absolute time */
    /* The "clockTick1" counts the number of times the code of this task has
     * been executed. The resolution of this integer timer is 0.01, which is the step size
     * of the task. Size of "clockTick1" ensures timer will not overflow during the
     * application lifespan selected.
     */
    motorPositionTest_M->Timing.clockTick1++;
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void motorPositionTest_derivatives(void)
{
  XDot_motorPositionTest_T *_rtXdot;
  _rtXdot = ((XDot_motorPositionTest_T *) motorPositionTest_M->derivs);

  /* Derivatives for Integrator: '<Root>/Integrator' */
  _rtXdot->Integrator_CSTATE = motorPositionTest_B.Gain1;

  /* Derivatives for Integrator: '<S36>/Integrator' */
  _rtXdot->Integrator_CSTATE_e = motorPositionTest_B.IntegralGain;

  /* Derivatives for Integrator: '<S31>/Filter' */
  _rtXdot->Filter_CSTATE = motorPositionTest_B.FilterCoefficient;
}

/* Model step function for TID2 */
void motorPositionTest_step2(void)     /* Sample time: [5.0s, 0.0s] */
{
  real_T rtb_PulseGenerator;

  /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
  rtb_PulseGenerator = (motorPositionTest_DW.clockTickCounter <
                        motorPositionTest_P.PulseGenerator_Duty) &&
    (motorPositionTest_DW.clockTickCounter >= 0L) ?
    motorPositionTest_P.PulseGenerator_Amp : 0.0;
  if (motorPositionTest_DW.clockTickCounter >=
      motorPositionTest_P.PulseGenerator_Period - 1.0) {
    motorPositionTest_DW.clockTickCounter = 0L;
  } else {
    motorPositionTest_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */

  /* RateTransition generated from: '<Root>/Sum' incorporates:
   *  Constant: '<Root>/Constant'
   *  Sum: '<Root>/Subtract'
   */
  motorPositionTest_DW.TmpRTBAtSumInport1_Buffer0 =
    motorPositionTest_P.Constant_Value + rtb_PulseGenerator;

  /* Update absolute time */
  /* The "clockTick2" counts the number of times the code of this task has
   * been executed. The resolution of this integer timer is 5.0, which is the step size
   * of the task. Size of "clockTick2" ensures timer will not overflow during the
   * application lifespan selected.
   */
  motorPositionTest_M->Timing.clockTick2++;
}

/* Model initialize function */
void motorPositionTest_initialize(void)
{
  /* Registration code */
  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&motorPositionTest_M->solverInfo,
                          &motorPositionTest_M->Timing.simTimeStep);
    rtsiSetTPtr(&motorPositionTest_M->solverInfo, &rtmGetTPtr
                (motorPositionTest_M));
    rtsiSetStepSizePtr(&motorPositionTest_M->solverInfo,
                       &motorPositionTest_M->Timing.stepSize0);
    rtsiSetdXPtr(&motorPositionTest_M->solverInfo, &motorPositionTest_M->derivs);
    rtsiSetContStatesPtr(&motorPositionTest_M->solverInfo, (real_T **)
                         &motorPositionTest_M->contStates);
    rtsiSetNumContStatesPtr(&motorPositionTest_M->solverInfo,
      &motorPositionTest_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&motorPositionTest_M->solverInfo,
      &motorPositionTest_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&motorPositionTest_M->solverInfo,
      &motorPositionTest_M->periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&motorPositionTest_M->solverInfo,
      &motorPositionTest_M->periodicContStateRanges);
    rtsiSetContStateDisabledPtr(&motorPositionTest_M->solverInfo, (boolean_T**)
      &motorPositionTest_M->contStateDisabled);
    rtsiSetErrorStatusPtr(&motorPositionTest_M->solverInfo, (&rtmGetErrorStatus
      (motorPositionTest_M)));
    rtsiSetRTModelPtr(&motorPositionTest_M->solverInfo, motorPositionTest_M);
  }

  rtsiSetSimTimeStep(&motorPositionTest_M->solverInfo, MAJOR_TIME_STEP);
  rtsiSetIsMinorTimeStepWithModeChange(&motorPositionTest_M->solverInfo, false);
  rtsiSetIsContModeFrozen(&motorPositionTest_M->solverInfo, false);
  motorPositionTest_M->intgData.y = motorPositionTest_M->odeY;
  motorPositionTest_M->intgData.f[0] = motorPositionTest_M->odeF[0];
  motorPositionTest_M->intgData.f[1] = motorPositionTest_M->odeF[1];
  motorPositionTest_M->intgData.f[2] = motorPositionTest_M->odeF[2];
  motorPositionTest_M->contStates = ((X_motorPositionTest_T *)
    &motorPositionTest_X);
  motorPositionTest_M->contStateDisabled = ((XDis_motorPositionTest_T *)
    &motorPositionTest_XDis);
  motorPositionTest_M->Timing.tStart = (0.0);
  rtsiSetSolverData(&motorPositionTest_M->solverInfo, (void *)
                    &motorPositionTest_M->intgData);
  rtsiSetSolverName(&motorPositionTest_M->solverInfo,"ode3");
  rtmSetTPtr(motorPositionTest_M, &motorPositionTest_M->Timing.tArray[0]);
  rtmSetTFinal(motorPositionTest_M, -1);
  motorPositionTest_M->Timing.stepSize0 = 0.01;

  /* External mode info */
  motorPositionTest_M->Sizes.checksums[0] = (4090582505U);
  motorPositionTest_M->Sizes.checksums[1] = (1956083064U);
  motorPositionTest_M->Sizes.checksums[2] = (2814557647U);
  motorPositionTest_M->Sizes.checksums[3] = (3995076718U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[3];
    motorPositionTest_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    systemRan[2] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(motorPositionTest_M->extModeInfo,
      &motorPositionTest_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(motorPositionTest_M->extModeInfo,
                        motorPositionTest_M->Sizes.checksums);
    rteiSetTFinalTicks(motorPositionTest_M->extModeInfo, -1);
  }

  /* Start for RateTransition generated from: '<Root>/Sum' */
  motorPositionTest_B.TmpRTBAtSumInport1 =
    motorPositionTest_P.TmpRTBAtSumInport1_InitialCondi;

  /* InitializeConditions for Integrator: '<Root>/Integrator' */
  motorPositionTest_X.Integrator_CSTATE = motorPositionTest_P.Integrator_IC;

  /* InitializeConditions for RateTransition generated from: '<Root>/Sum' */
  motorPositionTest_DW.TmpRTBAtSumInport1_Buffer0 =
    motorPositionTest_P.TmpRTBAtSumInport1_InitialCondi;

  /* InitializeConditions for Integrator: '<S36>/Integrator' */
  motorPositionTest_X.Integrator_CSTATE_e =
    motorPositionTest_P.PIDController_InitialConditio_j;

  /* InitializeConditions for Integrator: '<S31>/Filter' */
  motorPositionTest_X.Filter_CSTATE =
    motorPositionTest_P.PIDController_InitialConditionF;

  /* InitializeConditions for UnitDelay: '<Root>/Unit Delay' */
  motorPositionTest_DW.UnitDelay_DSTATE =
    motorPositionTest_P.UnitDelay_InitialCondition;

  /* Start for MATLABSystem: '<Root>/MATLAB System' */
  /*  Constructor */
  /*  Support name-value pair arguments when constructing the object. */
  motorPositionTest_DW.obj_p.matlabCodegenIsDeleted = false;
  motorPositionTest_DW.obj_p.isInitialized = 1L;

  /*         %% Define input properties */
  /*  Call C-function implementing device initialization */
  ShieldWrapper_Init();
  motorPositionTest_DW.obj_p.isSetupComplete = true;

  /* Start for MATLABSystem: '<Root>/Encoder' */
  motorPositionTest_DW.obj.Index = 0U;
  motorPositionTest_DW.obj.matlabCodegenIsDeleted = false;
  motorPositionTest_DW.obj.isInitialized = 1L;
  MW_EncoderSetup(20UL, 21UL, &motorPositionTest_DW.obj.Index);
  motorPositionTest_DW.obj.isSetupComplete = true;
  motorPositionTest_DW.obj.TunablePropsChanged = false;

  /* InitializeConditions for MATLABSystem: '<Root>/Encoder' */
  MW_EncoderReset(motorPositionTest_DW.obj.Index);
}

/* Model terminate function */
void motorPositionTest_terminate(void)
{
  /* Terminate for MATLABSystem: '<Root>/MATLAB System' */
  if (!motorPositionTest_DW.obj_p.matlabCodegenIsDeleted) {
    motorPositionTest_DW.obj_p.matlabCodegenIsDeleted = true;
  }

  /* End of Terminate for MATLABSystem: '<Root>/MATLAB System' */
  /* Terminate for MATLABSystem: '<Root>/Encoder' */
  if (!motorPositionTest_DW.obj.matlabCodegenIsDeleted) {
    motorPositionTest_DW.obj.matlabCodegenIsDeleted = true;
    if ((motorPositionTest_DW.obj.isInitialized == 1L) &&
        motorPositionTest_DW.obj.isSetupComplete) {
      MW_EncoderRelease();
    }
  }

  /* End of Terminate for MATLABSystem: '<Root>/Encoder' */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
