clc
% Adaptive control method for balancing the transverse plane
% components of the unbalance vector developed by Chesi.
% y = [q1, q2, q3, q4, wx, wy, wz, rx, ry, rz, rx_est, ry_est, rz_est, r_mmux, r_mmuy, r_mmuz]

tf = 30; % simulation length
dt = 0.01; % simulation step size

%% Testbed characteristics
% (see eom_chesi.m)
%J = [0.265 0 0; 0 0.246 0; 0 0 0.427];
J = [0.265 -0.014 -0.035; -0.014 0.246 -0.018; -0.035 -0.018 0.427];
Rcm = [-1; -2; -5]*10^-3; % CM offset vector
m = 14.307; % mass of the testbed, in kg
m_mmu = 0.7; % mass of one Movable Mass Unit (MMU), in kg
g = 9.78; % in m/s^2, local gravity
kp = 0.5; % Gain constant in the controller
v_mmu = 0.001; % velocity of the MMUs (1mm/s approx.)

%% Initialize arrays for later plotting
tArray = 0;
omegaArray = zeros(3,1);
r_mmusArray = zeros(3,1);
ctrltorqueArray = zeros(3,1);
r_estArray = zeros(3,1);

%% Initialization of model initial conditions
y = [[1 zeros(1,3)] [0 0 0.005] Rcm' zeros(1,3) zeros(1,3)];

tic;
for t = dt : dt : tf

    tc=round(t/dt); % Time counter

    %% Simulation of the system model
    [~, y_dt] = ode45(@eom_chesi, [0 dt], y(:));
    y(:)=y_dt(size(y_dt,1),:)'; % y = [q omega r r_est, r_mmu]

    %% MMUs operation
    omega = [y(5); y(6); y(7)];
    % gb cross operator at end of time step
    q = [y(1); y(2); y(3); y(4)];
    Rbi = [2*q(1)^2-1+2*q(2)^2 2*q(2)*q(3)-2*q(1)*q(4) 2*q(2)*q(4)+2*q(1)*q(3);
           2*q(2)*q(3)+2*q(1)*q(4) 2*q(1)^2-1+2*q(3)^2 2*q(3)*q(4)-2*q(1)*q(2);
           2*q(2)*q(4)-2*q(1)*q(3) 2*q(3)*q(4)+2*q(1)*q(2) 2*q(1)^2-1+2*q(4)^2];

    gb = Rbi' * [0; 0; -g];
    gbcross = [0 -gb(3) gb(2);
               gb(3) 0 -gb(1);
              -gb(2) gb(1) 0];

    % control torque at end of time step
    r_est = [y(11); y(12); y(13)];
    Phi = -m*gbcross;
    P = eye(3) - gb*gb'/norm(gb)^2;
    omegap = P*omega;
    control_torque = -Phi*r_est-kp*omegap;

    % Determine the new r_mmus vector. Dynamics of the MMUs are not considered,
    % which means r_mmus changes instantaneously
    r_mmus = gbcross*control_torque/(norm(gb)^2*m_mmu);
    for mmu_counter=1:3
        y(13+mmu_counter) = r_mmus(mmu_counter);
    end

    %% Save data for plotting.
    tArray = [tArray t];
    omegaArray = [omegaArray omega];
    r_mmusArray = [r_mmusArray r_mmus];
    r_estArray = [r_estArray r_est];
    ctrltorqueArray = [ctrltorqueArray control_torque];

end

%% Plot results
figure;
plot(tArray, omegaArray(1,:));
hold on
plot(tArray, omegaArray(2,:));
hold on
plot(tArray, omegaArray(3,:));
title('Angular velocities of the testbed')
legend('\omega_x', '\omega_y', '\omega_z')
xlabel('Time (s)')
ylabel('Angular velocities [rad/s]')

figure;
plot(tArray, r_mmusArray(1,:));
hold on
plot(tArray, r_mmusArray(2,:));
hold on
plot(tArray, r_mmusArray(3,:));
title('Balance masses positions')
legend('r_{mmux}', 'r_{mmuy}', 'r_{mmuz}')
xlabel('Time (s)')
ylabel('Positions [m]')

figure;
plot(tArray, ctrltorqueArray(1,:));
hold on
plot(tArray, ctrltorqueArray(2,:));
hold on
plot(tArray, ctrltorqueArray(3,:));
title('Control torque components')
legend('\tau_{x}', '\tau_{y}', '\tau_{z}')
xlabel('Time (s)')
ylabel('Torques [N\cdot m]')

figure;
plot(tArray, r_estArray(1,:));
hold on
plot(tArray, r_estArray(2,:));
hold on
plot(tArray, r_estArray(3,:));
title('Estimated unbalance vector components')
legend('r_{x-estimated}', 'r_{y-estimated}', 'r_{z-estimated}')
xlabel('Time (s)')
ylabel('Length [m]')
disp(['Elapsed time = ', num2str(toc), ' seconds']);



function ydot = eom_chesi(t,y)
% Equations of motion developed in the work of Chesi.
% y = [q1, q2, q3, q4, wx, wy, wz, rx, ry, rz, rx_est, ry_est, rz_est, r_mmux, r_mmuy, r_mmuz]
kp = 0.5; % Control gain
ydot = zeros(16,1);
dt = 0.01;
v_mmu = 0.001; %1mm/s

q = [y(1); y(2); y(3); y(4)];
omega = [y(5); y(6); y(7)];
Rcm = [y(8); y(9); y(10)];
r_est = [y(11); y(12); y(13)];
MMUx = [y(14); -0.22; 0];
MMUy = [0.22; y(15); 0];
MMUz = [-0.22; 0; y(16)];

% Testbed characteristics
J0 = [0.265 -0.014 -0.035; -0.014 0.246 -0.018; -0.035 -0.018 0.427];
%J0 = [0.265 0 0; 0 0.246 0; 0 0 0.427];
%J0 = eye(3);
m = 14.307; % mass of the testbed
m_mmu = 0.7; % mass of movable part of a MMU
g = 9.78; % in m/s^2, local gravity
Jaug = [m*(Rcm(2)^2+Rcm(3)^2) -m*Rcm(1)*Rcm(2) -m*Rcm(1)*Rcm(3);
        -m*Rcm(1)*Rcm(2) m*(Rcm(1)^2+Rcm(3)^2) -m*Rcm(2)*Rcm(3);
        -m*Rcm(1)*Rcm(3) -m*Rcm(2)*Rcm(3) m*(Rcm(1)^2+Rcm(2)^2)];
%Jaug=0;
J = J0 + Jaug;

% Update of inertia tensor
MMUxCross = [0 -MMUx(3) MMUx(2);
             MMUx(3) 0 -MMUx(1);
             -MMUx(2) MMUx(1) 0];

MMUyCross = [0 -MMUy(3) MMUy(2);
             MMUy(3) 0 -MMUy(1);
             -MMUy(2) MMUy(1) 0];

MMUzCross = [0 -MMUz(3) MMUz(2);
             MMUz(3) 0 -MMUz(1);
             -MMUz(2) MMUz(1) 0];

J = J - m_mmu * (MMUxCross*MMUxCross + MMUyCross*MMUyCross + MMUzCross*MMUzCross);

%% Model equations
% Kinematic equation
% Quaternion rates
qdot = 0.5*[0 -omega(1) -omega(2) -omega(3);
             omega(1) 0 omega(3) -omega(2);
             omega(2) -omega(3) 0 omega(1);
             omega(3) omega(2) -omega(1) 0]*q;

% Gravity vector in body-frame
Rbi = [2*q(1)^2-1+2*q(2)^2 2*q(2)*q(3)-2*q(1)*q(4) 2*q(2)*q(4)+2*q(1)*q(3);
       2*q(2)*q(3)+2*q(1)*q(4) 2*q(1)^2-1+2*q(3)^2 2*q(3)*q(4)-2*q(1)*q(2);
       2*q(2)*q(4)-2*q(1)*q(3) 2*q(3)*q(4)+2*q(1)*q(2) 2*q(1)^2-1+2*q(4)^2];

gb = Rbi' * [0; 0; -g];

% Projection operator
P = eye(3) - gb*gb'/norm(gb)^2;
omegap = P*omega;
gbcross = [0 -gb(3) gb(2);
           gb(3) 0 -gb(1);
          -gb(2) gb(1) 0];

Phi = -m*gbcross;
control_torque = -Phi*r_est-kp*omegap;

r_mmu = gbcross*control_torque/(norm(gb)^2*m_mmu);
control_torque = m_mmu * cross(r_mmu,gb);

% Adaptive control law for the estimated unbalance vector
r_est_dot = Phi'*omega;

%% Dynamics equation
omegadot=J\(-cross(omega,J*omega)+cross(Rcm,gb*m)+control_torque);

%% Derivatives (xdot)
% qdot
ydot(1:4) = qdot;
% Euler angles (dot)
ydot(5:7) = omegadot;
% unbalance vector derivative - the vector does not change dynamically
ydot(8:10) = 0;
% adaptive control law for estimated unbalance vector
ydot(11:13) = r_est_dot;
% mmu positions derivative
ydot(14:16) = 0;
end