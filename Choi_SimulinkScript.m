clc
clear
% ORIGINAL CHOI VALUES
% m_s = 134;
% J_0 = [20.2012 -0.0899   -0.0469;
%       -0.0899   12.9943  -0.4187;
%      -0.0469  -0.4187    16.276;];

% r_0 = [-5*10^-6 5*10^-6 -3*10^-4]';

% SADS Values
m_s = 33.629; % [kg]
J_0 = [1.815  -0.014 0.004;
      -0.014  1.348  0.008;
       0.004  0.008 1.475];

r_0 = [-6*10^-3, 7*10^-3 ,-3*10^-2]'; % solveable condition (displaced battery)
% r_0 = 5.*[-6*10^-3, 7*10^-3 ,-1*10^-2]' % unsolvable condition
% r_0 = [0 0 0]';

omega_0 = [0 0.0001 0]';

EA_0 = deg2rad([0 0 0]'); 

q_0 = eul2quat(EA_0')'; % transformations are inertial to body DONT TRUST EUL2QUAT

q_d = [1 0 0 0]';

q_e_0 = quatmultiply(q_d',q_0');

q_e_0 = [q_e_0(2) q_e_0(3) q_e_0(4)]';

g_N = [0 0 -9.81];

% six screws + n plates + ballscrew
n = 5;
m_mmu = 2 * ((0.015*6) + (n*.236) + 0.177)
m_mmu2 = 2*((0.015*6) + (6*.193) + 0.177)

gainScale = 0.5;
K_omega = gainScale*3;
K_q = gainScale*1;
K_I = gainScale*1;

%%
out = sim('Choi_Simulink.slx');
%%
clc
t = out.tout;
r_b = out.r_b.signals.values;
r_mmus = out.r_mmus.signals.values;
% EA_b_N = rad2deg(quat2eul(out.q_b_N.signals.values));
EA_b_N = out.EA_b_N.signals.values;
figure;
plot(t,r_b,'LineWidth',1.2);
grid on;
ylim([-0.012 0.012])
legend("r_x","r_y","r_z")
xlabel("Time [s]")
ylabel("Center of Mass Components in Body Frame")

figure;
plot(t,r_mmus,'LineWidth',1.2)
hold on
grid on;
yline(0.087,'--','LineWidth',1.2)
yline(-0.087,'--','LineWidth',1.2)
xlabel("Time [s]")
ylabel("Sliding Mass Positions")
legend("x Mass","y Mass", "z Mass", "Travel Limit")

figure;
plot(t,EA_b_N,'LineWidth',1.2)
grid on
legend("Roll","Pitch","Yaw")