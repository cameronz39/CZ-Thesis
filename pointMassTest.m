%% Setup
clc
clear

g_N = [0 0 -9.81]'; % gravity acceleration in inertial frame

m_i =  0.6;
J_0 = diag([0.0226, 0.0257 0.0266]); % total inertia of simulator with masses at their home positions
m_s = 4.2;
saturation = 0.028;
k_p = 0.01;
Gamma = diag([10, 10, 10]);

r_b_0 = [1 -0.9 -1.4]'.*1e-4;
% r_b_0 = [0 0 -0.005]';

u = [1 0 0; % column vectors that each mass slides along
     0 1 0;
     0 0 1];

rho = [0 0 0; % column vectors of each mass' initial position
       0 0 0;
       0 0 0];

delta_d = [0 0 0]'; % initial displacement

sum = zeros(size(rho,2),size(rho,2));
for i = 1:size(rho,2)
    R_i = rho(:,i) + delta_d(i)*u(:,i);
    R_i_cross = [0 -R_i(3) R_i(2);
                 R_i(3) 0 -R_i(1);
                -R_i(2) R_i(1) 0];
    sum = sum - (m_i*R_i_cross*R_i_cross);
end

J_plat =  J_0 - sum; % inertia of the platform without sliding masses

C_f = 0.000; % coefficient of friction


r_hat_0 = [0 0 0]'; % initial estimation of r

w_0 = [0 0 0.02]'; % [rad/s]
% w_0 = [0.0888 0.8229 1.3611]';
q_0 = [0 0 0 1]';
EA_0 = [0 0 0]';

% A denotes the matrix that maps the change in the positions of the sliding
% masses along their axis (a 1 x N vector) to the change in the position
% of the overall simulator center of mass (a 1 x 3 vector). 
A = (m_i/m_s).*eye(3);

% The controller will need the inverse of this matrix to map a commanded 
% change in the center of mass to a change in the sliding masses' positions


tspan = 300;
%% Run Sim
out = sim('underactuatedBalancing.slx');
%% Run Sim Kim's method
out = sim('Kim_underactuatedBalancing.slx');
%% Plot Results
clc
n = length(out.tout);
% tStart = 0;
tStart = 10;
[~, iStart] = min(abs(out.tout - tStart));
% tEnd = n;
tEnd = 30;
[~, iEnd] = min(abs(out.tout - tEnd));

figure;
plot(out.tout, squeeze(out.EA_N_b.signals.values))
figure;
plot(out.tout,squeeze(out.w_b_out.signals.values));

% unpack quaternion
q_b_N = out.q_b_N.signals.values(:,:)';
q_b_N = [q_b_N(:,4) q_b_N(:,1:3)];
% convert to DCM
C_b_N = quat2dcm(q_b_N);


torque = out.torque.signals.values(:,:)';
g_b = out.g_b.signals.values;
w_b_out = out.w_b_out.signals.values(:,:)';

x_N = zeros(n,3);
y_N = zeros(n,3);
z_N = zeros(n,3);
g_N_out = zeros(n,3);
torque_N = zeros(n,3);
w_N = zeros(n,3);
norm_w_N = zeros(n,1);

for i = 1:n
    C_N_b = C_b_N(:,:,i)';
    g_N_out(i,:) = C_N_b*g_b(i,:)';
    x_N(i,:) = C_N_b*[1 0 0]';
    y_N(i,:) = C_N_b*[0 1 0]';
    z_N(i,:) = C_N_b*[0 0 1]';
    torque_N(i,:) = C_N_b*torque(i,:)';
    w_N(i,:) = C_N_b*w_b_out(i,:)';
    norm_w_N(i) = norm(w_N(i,:));
end

r_N = squeeze(out.r_N.signals.values)';

% Set up the figure
figure;
axis equal;
grid on;
hold on;


% Set axis limits (adjust based on your data)
scale = 1;
sliderScale = 0.25;
xlim([-1.3*scale, 1.3*scale]);
ylim([-1.3*scale, 1.3*scale]);
zlim([-1.3*scale, 1.3*scale]);

xlabel('X');
ylabel('Y');
zlabel('Z');
title('Moving Vector Animation');

% Camera settings
view(3);                     % Default 3D view
campos([5, 5, 5]);           % Camera position (adjust as needed)
camtarget([0, 0, 0]);        % Camera looks at the origin
           % Z-axis is the "up" direction

quiver3(0, 0, 0, scale/2, 0, 0, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % X-axis (red)
quiver3(0, 0, 0, 0, scale/2, 0, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % Y-axis (green)
quiver3(0, 0, 0, 0, 0, scale/2, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % Z-axis (blue)

% COM
hVector1 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', 'g');

% body basis vectors
hVector2 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');
hVector3 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');
hVector4 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');

% torque
% hVector5 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% gravity
% hVector6 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#7E2F8E");

% angular velocity
% hVector7 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#7E2F8E");

% x sliding rail
hVector8 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector9 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% y sliding rail
hVector10 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector11 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% z sliding rail
hVector12 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector13 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");



r_N = 1*(r_N./norm(r_N(1,:)));
torque_N = torque_N./norm(torque_N(1,:));
g_N_out = g_N_out./norm(g_N_out(1,:));
w_N = w_N./(max(norm_w_N));


legend("","","","COM","Body Frame","","","\omega")

% Animation loop
for i = iStart:iEnd-1
    disp(i)
    % COM
    hVector1.UData = r_N(i, 1);
    hVector1.VData = r_N(i, 2);
    hVector1.WData = r_N(i, 3);
    
    % x body
    hVector2.UData = scale*x_N(i, 1);
    hVector2.VData = scale*x_N(i, 2);
    hVector2.WData = scale*x_N(i, 3);

    % y body
    hVector3.UData = scale*y_N(i, 1);
    hVector3.VData = scale*y_N(i, 2);
    hVector3.WData = scale*y_N(i, 3);

    % z body
    hVector4.UData = scale*z_N(i, 1);
    hVector4.VData = scale*z_N(i, 2);
    hVector4.WData = scale*z_N(i, 3);

    % torque
    % hVector5.XData = r_N(i, 1);
    % hVector5.YData = r_N(i, 2);
    % hVector5.ZData = r_N(i, 3);
    % hVector5.UData = torque_N(i,1);
    % hVector5.VData = torque_N(i,2);
    % hVector5.WData = torque_N(i,3);

    % gravity
    % hVector6.XData = r_N(i, 1);
    % hVector6.YData = r_N(i, 2);
    % hVector6.ZData = r_N(i, 3);
    % hVector6.UData = g_N_out(i, 1);
    % hVector6.VData = g_N_out(i, 2);
    % hVector6.WData = g_N_out(i, 3);

    % angular velocity
    % hVector7.UData = w_N(i, 1);
    % hVector7.VData = w_N(i, 2);
    % hVector7.WData = w_N(i, 3);

    % x-sliding rail
    hVector8.XData = scale*z_N(i, 1);
    hVector8.YData = scale*z_N(i, 2);
    hVector8.ZData = scale*z_N(i, 3);

    hVector8.UData = scale*sliderScale*x_N(i,1);
    hVector8.VData = scale*sliderScale*x_N(i,2);
    hVector8.WData = scale*sliderScale*x_N(i,3);

    hVector9.XData = scale*z_N(i, 1);
    hVector9.YData = scale*z_N(i, 2);
    hVector9.ZData = scale*z_N(i, 3);

    hVector9.UData = -scale*sliderScale*x_N(i,1);
    hVector9.VData = -scale*sliderScale*x_N(i,2);
    hVector9.WData = -scale*sliderScale*x_N(i,3);

    % y-sliding rail
    hVector10.XData = scale*x_N(i, 1);
    hVector10.YData = scale*x_N(i, 2);
    hVector10.ZData = scale*x_N(i, 3);

    hVector10.UData = scale*sliderScale*y_N(i,1);
    hVector10.VData = scale*sliderScale*y_N(i,2);
    hVector10.WData = scale*sliderScale*y_N(i,3);

    hVector11.XData = scale*x_N(i, 1);
    hVector11.YData = scale*x_N(i, 2);
    hVector11.ZData = scale*x_N(i, 3);

    hVector11.UData = -scale*sliderScale*y_N(i,1);
    hVector11.VData = -scale*sliderScale*y_N(i,2);
    hVector11.WData = -scale*sliderScale*y_N(i,3);

    % z-sliding rail
    hVector12.XData = scale*y_N(i, 1);
    hVector12.YData = scale*y_N(i, 2);
    hVector12.ZData = scale*y_N(i, 3);

    hVector12.UData = scale*sliderScale*z_N(i,1);
    hVector12.VData = scale*sliderScale*z_N(i,2);
    hVector12.WData = scale*sliderScale*z_N(i,3);

    hVector13.XData = scale*y_N(i, 1);
    hVector13.YData = scale*y_N(i, 2);
    hVector13.ZData = scale*y_N(i, 3);

    hVector13.UData = -scale*sliderScale*z_N(i,1);
    hVector13.VData = -scale*sliderScale*z_N(i,2);
    hVector13.WData = -scale*sliderScale*z_N(i,3);

 
    % Pause for a short duration to create animation effect
    pause(out.tout(i)-out.tout(i))

end

disp('Animation complete!');


%% Plot one frame
i = 1435;

figure;
axis equal;
grid on;
hold on;


% Set axis limits (adjust based on your data)
scale = 1;
sliderScale = 0.25;
xlim([-1.3*scale, 1.3*scale]);
ylim([-1.3*scale, 1.3*scale]);
zlim([-1.3*scale, 1.3*scale]);

xlabel('X');
ylabel('Y');
zlabel('Z');
title('Moving Vector Animation');

% Camera settings
view(3);                     % Default 3D view
campos([5, 5, 5]);           % Camera position (adjust as needed)
camtarget([0, 0, 0]);        % Camera looks at the origin
           % Z-axis is the "up" direction

quiver3(0, 0, 0, scale/2, 0, 0, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % X-axis (red)
quiver3(0, 0, 0, 0, scale/2, 0, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % Y-axis (green)
quiver3(0, 0, 0, 0, 0, scale/2, 'b', 'LineWidth', 1, 'MaxHeadSize', 0.5); % Z-axis (blue)

% COM
hVector1 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', 'g');

% body basis vectors
hVector2 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');
hVector3 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');
hVector4 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.5, 'Color', 'r');

% torque
% hVector5 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% gravity
% hVector6 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#7E2F8E");

% angular velocity
% hVector7 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#7E2F8E");

% x sliding rail
hVector8 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector9 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% y sliding rail
hVector10 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector11 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");

% z sliding rail
hVector12 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");
hVector13 = quiver3(0, 0, 0, 0, 0, 0, 'LineWidth', 2, 'MaxHeadSize', 0.2, 'Color', "#D95319");



r_N = 1*(r_N./norm(r_N(1,:)));
torque_N = torque_N./norm(torque_N(1,:));
g_N_out = g_N_out./norm(g_N_out(1,:));
w_N = w_N./(max(norm_w_N));


legend("","","","COM","Body Frame","","","\omega")

% COM
hVector1.UData = r_N(i, 1);
hVector1.VData = r_N(i, 2);
hVector1.WData = r_N(i, 3);

% x body
hVector2.UData = scale*x_N(i, 1);
hVector2.VData = scale*x_N(i, 2);
hVector2.WData = scale*x_N(i, 3);

% y body
hVector3.UData = scale*y_N(i, 1);
hVector3.VData = scale*y_N(i, 2);
hVector3.WData = scale*y_N(i, 3);

% z body
hVector4.UData = scale*z_N(i, 1);
hVector4.VData = scale*z_N(i, 2);
hVector4.WData = scale*z_N(i, 3);

% torque
% hVector5.XData = r_N(i, 1);
% hVector5.YData = r_N(i, 2);
% hVector5.ZData = r_N(i, 3);
% hVector5.UData = torque_N(i,1);
% hVector5.VData = torque_N(i,2);
% hVector5.WData = torque_N(i,3);

% gravity
% hVector6.XData = r_N(i, 1);
% hVector6.YData = r_N(i, 2);
% hVector6.ZData = r_N(i, 3);
% hVector6.UData = g_N_out(i, 1);
% hVector6.VData = g_N_out(i, 2);
% hVector6.WData = g_N_out(i, 3);

% angular velocity
% hVector7.UData = w_N(i, 1);
% hVector7.VData = w_N(i, 2);
% hVector7.WData = w_N(i, 3);

% x-sliding rail
hVector8.XData = scale*z_N(i, 1);
hVector8.YData = scale*z_N(i, 2);
hVector8.ZData = scale*z_N(i, 3);

hVector8.UData = scale*sliderScale*x_N(i,1);
hVector8.VData = scale*sliderScale*x_N(i,2);
hVector8.WData = scale*sliderScale*x_N(i,3);

hVector9.XData = scale*z_N(i, 1);
hVector9.YData = scale*z_N(i, 2);
hVector9.ZData = scale*z_N(i, 3);

hVector9.UData = -scale*sliderScale*x_N(i,1);
hVector9.VData = -scale*sliderScale*x_N(i,2);
hVector9.WData = -scale*sliderScale*x_N(i,3);

% y-sliding rail
hVector10.XData = scale*x_N(i, 1);
hVector10.YData = scale*x_N(i, 2);
hVector10.ZData = scale*x_N(i, 3);

hVector10.UData = scale*sliderScale*y_N(i,1);
hVector10.VData = scale*sliderScale*y_N(i,2);
hVector10.WData = scale*sliderScale*y_N(i,3);

hVector11.XData = scale*x_N(i, 1);
hVector11.YData = scale*x_N(i, 2);
hVector11.ZData = scale*x_N(i, 3);

hVector11.UData = -scale*sliderScale*y_N(i,1);
hVector11.VData = -scale*sliderScale*y_N(i,2);
hVector11.WData = -scale*sliderScale*y_N(i,3);

% z-sliding rail
hVector12.XData = scale*y_N(i, 1);
hVector12.YData = scale*y_N(i, 2);
hVector12.ZData = scale*y_N(i, 3);

hVector12.UData = scale*sliderScale*z_N(i,1);
hVector12.VData = scale*sliderScale*z_N(i,2);
hVector12.WData = scale*sliderScale*z_N(i,3);

hVector13.XData = scale*y_N(i, 1);
hVector13.YData = scale*y_N(i, 2);
hVector13.ZData = scale*y_N(i, 3);

hVector13.UData = -scale*sliderScale*z_N(i,1);
hVector13.VData = -scale*sliderScale*z_N(i,2);
hVector13.WData = -scale*sliderScale*z_N(i,3);


