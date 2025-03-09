/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: motorPositionTest_data.c
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

/* Block parameters (default storage) */
P_motorPositionTest_T motorPositionTest_P = {
  /* Mask Parameter: PIDController_D
   * Referenced by: '<S29>/Derivative Gain'
   */
  0.0,

  /* Mask Parameter: PIDController_I
   * Referenced by: '<S33>/Integral Gain'
   */
  1.2,

  /* Mask Parameter: PIDController_InitialConditionF
   * Referenced by: '<S31>/Filter'
   */
  0.0,

  /* Mask Parameter: PIDController_InitialConditio_j
   * Referenced by: '<S36>/Integrator'
   */
  0.0,

  /* Mask Parameter: PIDController_N
   * Referenced by: '<S39>/Filter Coefficient'
   */
  100.0,

  /* Mask Parameter: PIDController_P
   * Referenced by: '<S41>/Proportional Gain'
   */
  1.0,

  /* Expression: 90
   * Referenced by: '<Root>/Integrator'
   */
  90.0,

  /* Expression: 0
   * Referenced by:
   */
  0.0,

  /* Expression: -1
   * Referenced by: '<Root>/Gain2'
   */
  -1.0,

  /* Expression: 48*45
   * Referenced by: '<Root>/Constant2'
   */
  2160.0,

  /* Expression: 360
   * Referenced by: '<Root>/Gain1'
   */
  360.0,

  /* Expression: 90
   * Referenced by: '<Root>/Constant'
   */
  90.0,

  /* Expression: 180
   * Referenced by: '<Root>/Pulse Generator'
   */
  180.0,

  /* Computed Parameter: PulseGenerator_Period
   * Referenced by: '<Root>/Pulse Generator'
   */
  2.0,

  /* Computed Parameter: PulseGenerator_Duty
   * Referenced by: '<Root>/Pulse Generator'
   */
  1.0,

  /* Expression: 0
   * Referenced by: '<Root>/Pulse Generator'
   */
  0.0,

  /* Computed Parameter: Constant1_Value
   * Referenced by: '<Root>/Constant1'
   */
  0,

  /* Computed Parameter: UnitDelay_InitialCondition
   * Referenced by: '<Root>/Unit Delay'
   */
  0,

  /* Computed Parameter: Gain_Gain
   * Referenced by: '<Root>/Gain'
   */
  1677721600
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
