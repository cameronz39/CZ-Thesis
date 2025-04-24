function ydot = eom_ukf(~, y)
% Equations of motion for the 4-state UKF.
% State vector layout:
%   y = [phi, theta, psi, omega_x, omega_y, omega_z, r_z]

ydot  = zeros(7, 1);

% Center-of-mass offset (only z-component varies)
Rcm   = [0; 0; y(7)];

% Nominal inertia tensor (kg·m²)
J0    = [0.265  0      0;
         0      0.246  0;
         0      0      0.427];

% Test-bed parameters
mass  = 14.307;     % kg
gravity = 9.78;     % m/s²

% Augmented inertia tensor due to the offset
Jaug = mass * [ ...
     (Rcm(2)^2 + Rcm(3)^2),  -Rcm(1)*Rcm(2),    -Rcm(1)*Rcm(3);
     -Rcm(1)*Rcm(2),         (Rcm(1)^2 + Rcm(3)^2),  -Rcm(2)*Rcm(3);
     -Rcm(1)*Rcm(3),         -Rcm(2)*Rcm(3),    (Rcm(1)^2 + Rcm(2)^2) ];

J = J0 + Jaug;      % total inertia tensor

% Unpack the state vector for readability
phi      = y(1);
theta    = y(2);
psi      = y(3);    %#ok<NASGU>  % not used in dynamics but kept for completeness
omega_x  = y(4);
omega_y  = y(5);
omega_z  = y(6);

omega    = [omega_x; omega_y; omega_z];

% Trig shorthands
sin_phi   = sin(phi);
cos_phi   = cos(phi);
sin_theta = sin(theta);
cos_theta = cos(theta);

%% Kinematics: Euler-angle rates
E = [ 1,  sin_phi * tan(theta),  cos_phi * tan(theta);
      0,  cos_phi,             -sin_phi;
      0,  sin_phi / cos_theta,  cos_phi / cos_theta ];

euler_dot = E * omega;

%% Dynamics: Euler’s rotational equation with gravity torque
% Gravity-induced torque about the offset in body frame
tau_gravity = [ gravity * sin_phi   * cos_theta * mass * y(7);
                gravity * sin_theta               * mass * y(7);
                0 ];

omega_dot = J \ ( -cross(omega, J * omega) + tau_gravity );

%% Assemble derivatives
ydot(1:3) = euler_dot;  % [phi_dot, theta_dot, psi_dot]
ydot(4:6) = omega_dot;  % [omega_x_dot, omega_y_dot, omega_z_dot]
ydot(7)   = 0;          % r_z is assumed constant here
end
