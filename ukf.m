
%% 4-state UKF used in the second phase of the hybrid balancing scheme for balancing the r z component.
clc
clear

tf = 100;          % simulation length [s]
dt = 0.1;          % simulation step size [s]
n  = 4;            % number of states

% Test-bed characteristics (see eom_ukf.m)
J   = [0.265 0 0; 0 0.246 0; 0 0 0.427];
Rcm = [0.1; -0.3; -5]*1e-3;   % CM offset vector [m]
m   = 14.307;            % mass of the test-bed [kg]
g   = 9.78;              % local gravity [m s⁻²]

% Filter matrices
R = diag([0.005 0.005 0.005].^2);      % measurement-noise covariance
H = [eye(3) zeros(3,1)];               % measurement matrix

% Initial conditions
xstate   = [0; 0; 0; Rcm(3)];          % true state
xhatukf  = 2*xstate;                   % initial state estimate
z        = H*xstate + sqrt(R)*randn(3,1);
W        = ones(2*n,1)/(2*n);          % equal σ-point weights
Q        = diag([5e-5 5e-5 5e-5 (0.1*Rcm(3))^2]);  % process noise
y        = [pi/6 pi/6 0 0 0 0 Rcm(3)]; % [φ θ ψ ωₓ ωᵧ ω_z r_z]

% Book-keeping
yArray        = y';
zArray        = z;
tArray        = 0;
zhatArray     = z;
xArray        = xstate;
xhatukfArray  = xhatukf;
dtPlot        = dt;
P             = 1e-5*eye(4);
Pukf          = P;
Parray        = diag(P);
Pukfarray     = diag(Pukf);
chi2lim       = chi2inv(0.95,n);
d2            = 0;

tic
opts = odeset('RelTol',1e-5,'AbsTol',1e-7);
for t = dt:dt:tf
    k  = round(t/dt)+1;
    tc = round(t/dt);          % time counter

    % Simulate “truth”

    [~,y_dt] = ode45('eom_ukf',[0 dt],y(:),opts);
    y(:)     = y_dt(end,:)';
    xstate(1:4) = y(4:7)' + sqrt(Q)*randn(4,1); % add process noise
    z = H*xstate + sqrt(R)*randn(3,1);          % noisy measurement
    z2 = y(1:3)' + sqrt(R)*randn(3,1);

    % Step 3: Time update
    [root,~] = chol(n*Pukf);         % Cholesky of nP
    for i = 1:n
        sigma(:,i)   = xhatukf + root(i,:)';
        sigma(:,i+n) = xhatukf - root(i,:)';
    end
    for i = 1 : 2*n %1:2n  
        x_k_i(:,i) = sigma(:,i);  
    end        

    % Step 3(b): Use the known f(.) non linear function to transform the  % sigma points into xhat_k(i) vectors.
    for i = 1:2*n
        x_k_idot   = eom_ukf(t,[z2; x_k_i(1:4,i)]);
        x_k_i(:,i) = x_k_i(:,i) + [x_k_idot(4:6); 0]*dt;
    end


    % Step 3(c): Combine the xhat_k(i) vectors to obtain the a priori state  % estimate at time k.
    xhatukf = zeros(n,1);  
    for i = 1 : 2*n % i=1:2n  
        xhatukf = xhatukf + W(i) * x_k_i(:,i); % W is the wheight function (see beginning of file)  
    end

    % Step 3(d): Estimate a priori error covariance.
    Pukf = zeros(n,n);  
    for i = 1 : 2*n %i=1:2n  
        Pukf = Pukf + W(i) * (x_k_i(:,i) - xhatukf) * (x_k_i(:,i) - xhatukf)';  
    end  
    Pukf = Pukf + Q;  
    d2(k) = (z - H * xhatukf)' * inv(H * Pukf * H' + R) * (z - H * xhatukf); %xhatukf and Pukf -> a priori

    % Step 4: Measurement update  
    % Step 4(a): Choose sigma points x_k(i).
    % Start of optional step (comment lines below if you want)
    % [root,~] = chol(n*Pukf); %n=15
    % for i = 1:n 
    %     sigma(:,i)   = xhatukf + root(i,:)';
    %     sigma(:,i+n) = xhatukf - root(i,:)';
    % end
    % 
    % for i = 1 : 2*n %1:2n  
    %     x_k_i(:,i) = sigma(:,i);  
    % end
    % End of optional step (comment lines above if you want)

    % Step 4(b): Apply the nonlinear measurement equation to the sigma points. In our case, the measurement equation is linear.
    for i = 1 : 2*n %i=1:2n  
        zukf(:,i) = H*x_k_i(:,i);  
    end

    % Step 4(c): Combine the yhat_k(i) vectors to obtain predicted  measurement at time k.
    zhat = zeros(3,1);  
    for i = 1 : 2*n %i=1:2n  
        zhat = zhat + W(i) * zukf(:,i);  
    end

    Py = zeros(3,3);  
    Pxy = zeros(n,3);
    for i = 1 : 2*n %i=1:2n  
        Py = Py + W(i) * (zukf(:,i) - zhat) * (zukf(:,i) - zhat)';  
        Pxy = Pxy + W(i) * (x_k_i(:,i) - xhatukf) * (zukf(:,i) - zhat)';  
    end  
    Py = Py + R;

    Kukf   = Pxy/Py;
    xhatukf = xhatukf + Kukf*(z-zhat);
    Pukf    = Pukf - Kukf*Py*Kukf';

    % Save data for plotting.  
    yArray(:,k) = y';  
    PArray(:,:,k) = Pukf;  
    xArray(:,tc+1) = xstate;  
    zArray(:,tc+1) = z;  
    zhatArray(:,tc+1) = zhat;  
    xhatukfArray(:,tc+1) = xhatukf;  
    Parray(:,tc+1) = diag(P);  
    Pukfarray(:,tc+1) = diag(Pukf);  
    tArray = [tArray t];
end


rx_hat_mean = mean(xhatukfArray(4,round(end/2):end));


%% Plot results  
close all  
t = 0 : dtPlot : tf;  
for i = 1:size(PArray,3)  
    vwx_est(i) = PArray(1,1,i);  
    vwy_est(i) = PArray(2,2,i);  
    vwz_est(i) = PArray(3,3,i);  
    vrz_est(i) = PArray(4,4,i);  
end  
count = 0;  
for i = 1:length(d2)  
    if d2(i) > chi2lim  
        count = count + 1;  
    end  
end  
Performance = 1 - count/length(d2);  
display(sprintf('Percentage of inovation samples inside Chi-Square margin: %.2f  %%',100*Performance))

figure;  
plot(tArray, yArray(1:3,:));  
set(gca,'FontSize',12); 
set(gcf,'Color','White');  
xlabel('Seconds'); 
ylabel('Attitude [rad]');  
title('y(1:3) - rpy')  

% Plot results
subplot(421);  
plot(tArray,xArray(1,:)-xhatukfArray(1,:),'k'); 
hold on;  
plot(tArray,+3*sqrt(vwx_est),'k:'); 
plot(tArray,-3*sqrt(vwx_est),'k:');  
xlabel('t [s]'); 
ylabel('\omega_x [rad/s]'); 
title('Estimation error in \omega_x and  3\sigma intervals');  
subplot(422);  
plot(tArray,xArray(2,:)-xhatukfArray(2,:),'k'); 
hold on; 
plot(tArray,+3*sqrt(vwy_est),'k:');
plot(tArray,-3*sqrt(vwy_est),'k:');  
xlabel('t [s]'); ylabel('\omega_y [rad/s]'); 
title('Estimation error in \omega_y and  3\sigma intervals');

subplot(423);  
plot(tArray,xArray(3,:)-xhatukfArray(3,:),'k'); 
hold on;  
plot(tArray,+3*sqrt(vwz_est),'k:'); 
plot(tArray,-3*sqrt(vwz_est),'k:');  
xlabel('t [s]'); ylabel('\omega_z [rad/s]'); 
title('Estimation error in \omega_z and  3\sigma intervals'); 

subplot(424);  
plot(tArray,xArray(4,:)-xhatukfArray(4,:),'k'); 
hold on;  
plot(tArray,+3*sqrt(vrz_est),'k:'); 
plot(tArray,-3*sqrt(vrz_est),'k:');  
xlabel('t [s]'); 
ylabel('r_z [m]'); 
title('Estimation error in r_z and 3\sigma  intervals');


subplot(4,2,[5 6]);  
plot(tArray, d2,'k',[tArray(1) tArray(end)], chi2lim*[1 1],'k'); 
hold on; ylabel('d^2(k)');  
title('Chi-squared test');  
subplot(4,2, [7 8]); 
plot(t, xhatukfArray(4,:), 'k'); 
hold on; 
plot(t, sqrt(Pukfarray(4,:)), 'k');  
xlabel('t [s]'); ylabel('r_z [m]'); 
legend('r_zhat','P_{44}^{1/2}')  
title('Estimation of r_z and corresponding deviation');

scrsz = get(groot,'ScreenSize');  
figure('OuterPosition',[0 scrsz(4)/2 scrsz(3)/3 scrsz(4)/2]) 
%[(distance of left border from left margin of screen);  
% (distance of bottom border from bottom of screen);  
% width; height]'.  
plot(t, xArray(1:3,:));  
set(gca,'FontSize',12); 
set(gcf,'Color','White');  
xlabel('Seconds'); 
ylabel('\omega (in rad/s)'); 
disp(['Elapsed time = ', num2str(toc), ' seconds']);