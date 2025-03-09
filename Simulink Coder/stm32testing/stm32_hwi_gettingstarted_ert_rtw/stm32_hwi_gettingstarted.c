/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: stm32_hwi_gettingstarted.c
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

#include "stm32_hwi_gettingstarted.h"
#include "stm32_hwi_gettingstarted_private.h"
#include "rtwtypes.h"

/* Block signals (default storage) */
B_stm32_hwi_gettingstarted_T stm32_hwi_gettingstarted_B;

/* Block states (default storage) */
DW_stm32_hwi_gettingstarted_T stm32_hwi_gettingstarted_DW;

/* Real-time model */
static RT_MODEL_stm32_hwi_gettingsta_T stm32_hwi_gettingstarted_M_;
RT_MODEL_stm32_hwi_gettingsta_T *const stm32_hwi_gettingstarted_M =
  &stm32_hwi_gettingstarted_M_;
static void rate_monotonic_scheduler(void);

/*
 * Set which subrates need to run this base step (base rate always runs).
 * This function must be called prior to calling the model step function
 * in order to remember which rates need to run this base step.  The
 * buffering of events allows for overlapping preemption.
 */
void stm32_hwi_gettingstarted_SetEventsForThisBaseStep(boolean_T *eventFlags)
{
  /* Task runs when its counter is zero, computed via rtmStepTask macro */
  eventFlags[1] = ((boolean_T)rtmStepTask(stm32_hwi_gettingstarted_M, 1));
  eventFlags[2] = ((boolean_T)rtmStepTask(stm32_hwi_gettingstarted_M, 2));
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

  /* tid 0 shares data with slower tid rates: 1, 2 */
  stm32_hwi_gettingstarted_M->Timing.RateInteraction.TID0_1 =
    (stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[1] == 0);
  stm32_hwi_gettingstarted_M->Timing.RateInteraction.TID0_2 =
    (stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[2] == 0);

  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[1])++;
  if ((stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[1]) > 4) {/* Sample time: [0.5s, 0.0s] */
    stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[1] = 0;
  }

  (stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[2])++;
  if ((stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[2]) > 9) {/* Sample time: [1.0s, 0.0s] */
    stm32_hwi_gettingstarted_M->Timing.TaskCounters.TID[2] = 0;
  }
}

/* Model step function for TID0 */
void stm32_hwi_gettingstarted_step0(void) /* Sample time: [0.1s, 0.0s] */
{
  GPIO_TypeDef * portNameLoc;
  real_T rtb_PulseGenerator;
  real_T rtb_TmpRTBAtISRforEventOutport1;
  int32_T c;

  {                                    /* Sample time: [0.1s, 0.0s] */
    rate_monotonic_scheduler();
  }

  /* DiscretePulseGenerator: '<S5>/Pulse Generator' */
  rtb_PulseGenerator = (stm32_hwi_gettingstarted_DW.clockTickCounter <
                        stm32_hwi_gettingstarted_P.PulseGenerator_Duty) &&
    (stm32_hwi_gettingstarted_DW.clockTickCounter >= 0) ?
    stm32_hwi_gettingstarted_P.PulseGenerator_Amp : 0.0;
  if (stm32_hwi_gettingstarted_DW.clockTickCounter >=
      stm32_hwi_gettingstarted_P.PulseGenerator_Period - 1.0) {
    stm32_hwi_gettingstarted_DW.clockTickCounter = 0;
  } else {
    stm32_hwi_gettingstarted_DW.clockTickCounter++;
  }

  /* End of DiscretePulseGenerator: '<S5>/Pulse Generator' */
  /* RateTransition generated from: '<Root>/ISR for Event' */
  rtb_TmpRTBAtISRforEventOutport1 = stm32_hwi_gettingstarted_B.Out;

  /* RateTransition generated from: '<Root>/Multiport Switch' */
  if (stm32_hwi_gettingstarted_M->Timing.RateInteraction.TID0_1) {
    /* RateTransition generated from: '<Root>/Multiport Switch' */
    stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport3 =
      stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport3_;
  }

  /* End of RateTransition generated from: '<Root>/Multiport Switch' */

  /* RateTransition generated from: '<Root>/Multiport Switch' */
  if (stm32_hwi_gettingstarted_M->Timing.RateInteraction.TID0_2) {
    /* RateTransition generated from: '<Root>/Multiport Switch' */
    stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport4 =
      stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport4_;
  }

  /* End of RateTransition generated from: '<Root>/Multiport Switch' */

  /* MultiPortSwitch: '<Root>/Multiport Switch' */
  switch ((int32_T)rtb_TmpRTBAtISRforEventOutport1) {
   case 0:
    break;

   case 1:
    rtb_PulseGenerator =
      stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport3;
    break;

   default:
    rtb_PulseGenerator =
      stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport4;
    break;
  }

  /* End of MultiPortSwitch: '<Root>/Multiport Switch' */

  /* MATLABSystem: '<S8>/Digital Port Write' */
  portNameLoc = GPIOA;
  if (rtb_PulseGenerator != 0.0) {
    c = 32;
  } else {
    c = 0;
  }

  LL_GPIO_SetOutputPin(portNameLoc, (uint32_T)c);
  LL_GPIO_ResetOutputPin(portNameLoc, ~(uint32_T)c & 32U);

  /* End of MATLABSystem: '<S8>/Digital Port Write' */

  /* MATLABSystem: '<Root>/MATLAB System' */
  /*         %% Define input properties */
  /*  Call C-function implementing device output */
  BlinkWrapper_Step();
}

/* Model step function for TID1 */
void stm32_hwi_gettingstarted_step1(void) /* Sample time: [0.5s, 0.0s] */
{
  real_T rtb_PulseGenerator;

  /* DiscretePulseGenerator: '<S6>/Pulse Generator' */
  rtb_PulseGenerator = (stm32_hwi_gettingstarted_DW.clockTickCounter_b <
                        stm32_hwi_gettingstarted_P.PulseGenerator_Duty_j) &&
    (stm32_hwi_gettingstarted_DW.clockTickCounter_b >= 0) ?
    stm32_hwi_gettingstarted_P.PulseGenerator_Amp_i : 0.0;
  if (stm32_hwi_gettingstarted_DW.clockTickCounter_b >=
      stm32_hwi_gettingstarted_P.PulseGenerator_Period_p - 1.0) {
    stm32_hwi_gettingstarted_DW.clockTickCounter_b = 0;
  } else {
    stm32_hwi_gettingstarted_DW.clockTickCounter_b++;
  }

  /* End of DiscretePulseGenerator: '<S6>/Pulse Generator' */

  /* RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport3_ =
    rtb_PulseGenerator;
}

/* Model step function for TID2 */
void stm32_hwi_gettingstarted_step2(void) /* Sample time: [1.0s, 0.0s] */
{
  real_T rtb_PulseGenerator;

  /* DiscretePulseGenerator: '<S4>/Pulse Generator' */
  rtb_PulseGenerator = (stm32_hwi_gettingstarted_DW.clockTickCounter_c <
                        stm32_hwi_gettingstarted_P.PulseGenerator_Duty_a) &&
    (stm32_hwi_gettingstarted_DW.clockTickCounter_c >= 0) ?
    stm32_hwi_gettingstarted_P.PulseGenerator_Amp_m : 0.0;
  if (stm32_hwi_gettingstarted_DW.clockTickCounter_c >=
      stm32_hwi_gettingstarted_P.PulseGenerator_Period_m - 1.0) {
    stm32_hwi_gettingstarted_DW.clockTickCounter_c = 0;
  } else {
    stm32_hwi_gettingstarted_DW.clockTickCounter_c++;
  }

  /* End of DiscretePulseGenerator: '<S4>/Pulse Generator' */

  /* RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport4_ =
    rtb_PulseGenerator;
}

/* Model initialize function */
void stm32_hwi_gettingstarted_initialize(void)
{
  /* Start for RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport3 =
    stm32_hwi_gettingstarted_P.TmpRTBAtMultiportSwitchInport3_;

  /* Start for RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_B.TmpRTBAtMultiportSwitchInport4 =
    stm32_hwi_gettingstarted_P.TmpRTBAtMultiportSwitchInport4_;

  /* InitializeConditions for RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport3_ =
    stm32_hwi_gettingstarted_P.TmpRTBAtMultiportSwitchInport3_;

  /* InitializeConditions for RateTransition generated from: '<Root>/Multiport Switch' */
  stm32_hwi_gettingstarted_DW.TmpRTBAtMultiportSwitchInport4_ =
    stm32_hwi_gettingstarted_P.TmpRTBAtMultiportSwitchInport4_;

  /* SystemInitialize for S-Function (HardwareInterrupt_sfun): '<S10>/Hardware Interrupt' incorporates:
   *  SubSystem: '<Root>/ISR for Event'
   */

  /* System initialize for function-call system: '<Root>/ISR for Event' */

  /* InitializeConditions for Sum: '<S13>/FixPt Sum1' incorporates:
   *  UnitDelay: '<S12>/Output'
   */
  stm32_hwi_gettingstarted_DW.Output_DSTATE =
    stm32_hwi_gettingstarted_P.Output_InitialCondition;

  /* SystemInitialize for SignalConversion: '<S11>/Out' incorporates:
   *  Outport: '<S3>/Out1'
   */
  stm32_hwi_gettingstarted_B.Out = stm32_hwi_gettingstarted_P.Out1_Y0;

  /* End of SystemInitialize for S-Function (HardwareInterrupt_sfun): '<S10>/Hardware Interrupt' */

  /* Start for MATLABSystem: '<Root>/MATLAB System' */
  /*  Constructor */
  /*  Support name-value pair arguments when constructing the object. */
  stm32_hwi_gettingstarted_DW.obj.matlabCodegenIsDeleted = false;
  stm32_hwi_gettingstarted_DW.obj.isInitialized = 1;

  /*         %% Define input properties */
  /*  Call C-function implementing device initialization */
  BlinkWrapper_Init();
  stm32_hwi_gettingstarted_DW.obj.isSetupComplete = true;
}

/* Model terminate function */
void stm32_hwi_gettingstarted_terminate(void)
{
  /* Terminate for MATLABSystem: '<Root>/MATLAB System' */
  if (!stm32_hwi_gettingstarted_DW.obj.matlabCodegenIsDeleted) {
    stm32_hwi_gettingstarted_DW.obj.matlabCodegenIsDeleted = true;
  }

  /* End of Terminate for MATLABSystem: '<Root>/MATLAB System' */
}

void stm32_hwi_gettingstarted_configure_interrupts(void)
{
  /* Register interrupt service routine */
  MW_NVIC_ConfigureIRQ(55,&EXTI15_10_IRQHandler,2);
  MW_NVIC_EnableIRQ(55);
}

/* Hardware Interrupt Block: '<S10>/Hardware Interrupt' */
void EXTI15_10_IRQHandler(void)
{
  /* Event: EXTI13 Event */
  /* Check event EXTI13 Event occurred */
  if (0 != ((0 != LL_EXTI_IsEnabledIT_0_31(LL_EXTI_LINE_13)) && (0 !=
        LL_EXTI_IsActiveFlag_0_31(LL_EXTI_LINE_13)))) {
    /* Clear occurred EXTI13 Event event */
    LL_EXTI_ClearFlag_0_31(LL_EXTI_LINE_13);
    if (1 == runModel) {
      {
        /* S-Function (HardwareInterrupt_sfun): '<S10>/Hardware Interrupt' */

        /* Output and update for function-call system: '<Root>/ISR for Event' */

        /* SignalConversion: '<S11>/Out' incorporates:
         *  Constant: '<S11>/Vector'
         *  MultiPortSwitch: '<S11>/Output'
         *  UnitDelay: '<S12>/Output'
         */
        stm32_hwi_gettingstarted_B.Out =
          stm32_hwi_gettingstarted_P.RepeatingSequenceStair_OutValue[stm32_hwi_gettingstarted_DW.Output_DSTATE];

        /* Sum: '<S13>/FixPt Sum1' incorporates:
         *  Constant: '<S13>/FixPt Constant'
         *  UnitDelay: '<S12>/Output'
         */
        stm32_hwi_gettingstarted_DW.Output_DSTATE +=
          stm32_hwi_gettingstarted_P.FixPtConstant_Value;

        /* Switch: '<S14>/FixPt Switch' */
        if (stm32_hwi_gettingstarted_DW.Output_DSTATE >
            stm32_hwi_gettingstarted_P.WrapToZero_Threshold) {
          /* Sum: '<S13>/FixPt Sum1' incorporates:
           *  Constant: '<S14>/Constant'
           *  UnitDelay: '<S12>/Output'
           */
          stm32_hwi_gettingstarted_DW.Output_DSTATE =
            stm32_hwi_gettingstarted_P.Constant_Value;
        }

        /* End of Switch: '<S14>/FixPt Switch' */

        /* End of Outputs for S-Function (HardwareInterrupt_sfun): '<S10>/Hardware Interrupt' */
      }
    }
  }

  __ISB();
  __DSB();
}

void stm32_hwi_gettingstarted_unconfigure_interrupts (void)
{
  MW_NVIC_DisableIRQ(55);
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
