%% 4-state UKF used in the second phase of the hybrid balancing scheme for balancing the r z component.
clc
clear




tf = 50;          % simulation length [s]
n  = 4;            % number of states

% Test-bed characteristics 
m_s = 33.629; % [kg]
J = [1.815  -0.014 0.004;
      -0.014  1.348  0.008;
       0.004  0.008 1.475];
% r_0 = [0.1*10^-3, 0.1*10^-3 ,-1*10^-3]';
r_0 = [0 0 0]';
g_N = [0 0 -9.81];

% for simulating plant ("truth")
process_variance = 1e-5; % variance of disturbance torques
% "sample time" for process noise, must be much shorter than the timescale of
% the system dynamics
T_s = 0.01; 
process_PSD = (process_variance^2)*T_s;

% for simulating IMU
noise_power = 5.235988e-5; % [rad/s/sqrt(Hz)] provided on sensor datasheet
sensor_PSD = noise_power^2; % IMU power spectral density
sample_rate = 10; % IMU sample rate
sample_time = 1/sample_rate; % IMU sample period


% Filter matrices
R = diag([0.005 0.005 0.005].^2);      % measurement-noise covariance
H = [eye(3)  zeros(3,4)];             % measurement matrix

Q  = diag([5e-5 5e-5 5e-5 4e-12 4e-12 4e-12 4e-12]);

omega_0 = [0 0.00 0.03]';
omega_0 = [0.50 0.10 0.30]';

EA_0 = deg2rad([1 0 0]'); 

% transformations are inertial to body
% XYZ rotation order must be explicitly specified
q_0 = eul2quat(EA_0',"XYZ")'; 

x_0 = [omega_0; q_0];
n = size(x_0,1);
P_0 = diag([1e-6 1e-6 1e-6 1e-6 1e-6 1e-6 1e-6]);



% Initial conditions
% xstate   = [0; 0; 0; r_0(3)];          % true state
% xhatukf  = 2*xstate;                   % initial state estimate
% z        = H*xstate + sqrt(R)*randn(3,1);
% W        = ones(2*n,1)/(2*n);          % equal σ-point weights
% Q        = diag([5e-5 5e-5 5e-5 (0.1*r_0(3))^2]);  % process noise
% y        = [pi/6 pi/6 0 0 0 0 r_0(3)]; % [φ θ ψ ωₓ ωᵧ ω_z r_z]