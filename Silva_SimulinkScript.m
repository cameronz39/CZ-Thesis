clc
clear
% Adaptive control method for balancing the transverse plane
% components of the unbalance vector developed by Chesi.
% y = [q1, q2, q3, q4, wx, wy, wz, rx, ry, rz, rx_est, ry_est, rz_est, r_mmux, r_mmuy, r_mmuz]
tspan = 30;

%% Testbed characteristics
J_0 = [0.265 -0.014 -0.035; -0.014 0.246 -0.018; -0.035 -0.018 0.427];
r_b_0 = [-1 -3 -5]'*10^-3; % CM offset vector
m = 14.307; % mass of the testbed, in kg
m_mmu = 0.7; % mass of one Movable Mass Unit (MMU), in kg
g = 9.78; % in m/s^2, local gravity
kp = 0.5; % Gain constant in the controller
v_mmu = 0.001; % velocity of the MMUs (1mm/s approx.)
control_sample = 0.05;



omega_0 = [0 0 0.005]';
q_0 = [1 0 0 0]';
r_est_0 = [0 0 0]';


%%

u = [1 0 0; % column vectors that each mass slides along
     0 1 0;
     0 0 1];

delta_d = [0.02 0.06 0]'; % initial displacement

sum = zeros(size(u,2), 1);
for i = 1:size(u,2)
    sum = sum + m_mmu*delta_d(i)*u(:,i)
end
del_r_b = (1/m).*sum;
r_b = r_b_0 + del_r_b