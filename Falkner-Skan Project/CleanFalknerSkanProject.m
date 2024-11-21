% NOTE: the notation and approach used here directly follows from:
% Asaithambi, N. S. "A numerical method for the solution of the Falkner-Skan equation." 
% Applied Mathematics and Computation 81.2-3 (1997): 259-264.%

% the character 'a' has been used instead of alpha
% the character 'j' has been used instead of of the character 'l'
%% Converge on values for etaMax and f''(w)
clc
clear

beta = 2;
[a,etaMax] = FalkerRootFinder(beta,10^-6);

disp("-------------------------------------")
fprintf('Final etaMax: %.*g\n', 6, etaMax);
fprintf('Final aStar: %.*g\n', 6, a);


%% Solve for the thicknesses

% solve the ODE again using the final values for etaMax and aStar
options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
xiSpan = [0 1];
initialValue = [0 0 a];
[xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); %%#ok<ASGLU>

% convert the xi domain to the eta domain
etaSpan = xi*etaMax;

eta_d = etaMax - sol(end,1);
eta_m = (a - beta*eta_d)/(1+beta);
fprintf('Displacement Thickness: %.*g\n', 6, eta_d);
fprintf('Momentum Thickness: %.*g\n', 6, eta_m);

%% Plot some velocity profiles (part c)
alpha = 1;
u_inf = 20; % [m/s] velocity 1 meter downstream of wedge
wedgeAngle = pi/6;
beta = 2*wedgeAngle/pi;
m = beta/(2-beta);
nu = 1.48e-5; % [m^2/s] kinematic viscosity
rho = 1.225; % [kg/m^3] density

[a,etaMax] = FalkerRootFinder(beta,10^-5);
options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
xiSpan = [0 1];
initialValue = [0 0 a];
[xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax);
etaSpan = xi*etaMax;
fPrime = sol(:,2);

% case 1: s = 0.1 cm
s = 0.001; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS (WILL ALSO CHANGE Y_SPAN)
u = u_e*fPrime;

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));

figure
spacing = 25;
xline(u_e,'--');
plot([u_e, u_e],[0,ySpan(end)],'--','Color','black');
hold on
plot(u,ySpan,'LineWidth',2);
grid on

% case 2: s = 1.0 cm
s = 0.01; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS
u = u_e*fPrime;

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([u_e + spacing, u_e + spacing],[0,ySpan(end)],'--','Color','black');
plot(u + spacing,ySpan,'LineWidth',2);

% case 3: s = 5.0 cm
s = 0.05; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS
u = u_e*fPrime;

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([u_e + 2*spacing, u_e + 2*spacing],[0,ySpan(end)],'--','Color','black');
plot(u + 2*spacing,ySpan,'LineWidth',2);


legend('','s = 0.1 cm','','s = 1.0 cm','','s = 5.0 cm','Location','northwest');
ylabel('Normal Distance From Wall [m]');
xlabel('Streamwise Velocity [m/s]');
xticks([0 10 20 spacing spacing + 10 spacing + 20 2*spacing 2*spacing + 10 2*spacing + 20]);
xticklabels({'0','10','20','0','10','20','0','10','20'});

% OPTION 2: ALL ONE PLOT
s = [0.001 0.01 0.05];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS
u = u_e*fPrime;

ySpan1 = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s(1)));
ySpan2 = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s(2)));
ySpan3 = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s(3)));

figure
plot([u_e, u_e],[0,ySpan(end)],'--','Color','black');
hold on
plot(u,ySpan1,'LineWidth',2);
plot(u,ySpan2,'LineWidth',2);
plot(u,ySpan3,'LineWidth',2);
grid on 

legend('','s = 0.1 cm','','s = 1.0 cm','','s = 5.0 cm','Location','northwest');
ylabel('Normal Distance From Wall [m]');
xlabel('Streamwise Velocity [m/s]');

%% Plot some temperature profiles (part d)
Pr = 0.707; % Prandtl number of air at 1 atm and 300K
f = sol(:,1);
T_e = 300; % [K]
T_w = 250; % [K]

% define captial F
F = zeros(length(etaSpan),1);
for i = 1:length(etaSpan)
    F(i) = exp(-Pr*trapz(f(1:i)));
end

% solve for Theta at each eta
Theta = zeros(length(etaSpan),1);
for i = 1:length(etaSpan)
    den = trapz(F(1:end));
    num = trapz(F(1:i));
    Theta(i) = num/den;
end

T = Theta*(T_e - T_w) + T_w;

% case 1: s = 0.1 cm
s = 0.001; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS (WILL ALSO CHANGE Y_SPAN)


ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
figure
spacing = 75;
xline(T_e,'--');
plot([T_e, T_e],[0,ySpan(end)],'--','Color','black');
hold on
plot(T,ySpan,'LineWidth',2);
grid on

% case 2: s = 1.0 cm
s = 0.01; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS


ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([T_e + spacing, T_e + spacing],[0,ySpan(end)],'--','Color','black');
plot(T + spacing,ySpan,'LineWidth',2);

% case 3: s = 5.0 cm
s = 0.05; % [m];
u_e = 20; % [m/s] <---------------- DOUBLE CHECK THIS

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));    
plot([T_e + 2*spacing, T_e + 2*spacing],[0,ySpan(end)],'--','Color','black');
plot(T + 2*spacing,ySpan,'LineWidth',2);

legend('','s = 0.1 cm','','s = 1.0 cm','','s = 5.0 cm','Location','northwest');
ylabel('Normal Distance From Wall [m]');
xlabel('Temperature [K]');  
xticks([T_w, 275, 300, T_w + spacing, 275 + spacing, 300 + spacing, T_w + 2*spacing, 275 + 2*spacing, 300 + 2*spacing]);
xticklabels({'250','275','300','250','275','300','250','275','300'});
xlim([250 460])

%% Find Drag Force, Drag Coefficient, and Heat Transfer
% find c_fw and tau_w at every streamwise location
c_fw = zeros(length(etaSpan),1);
tau_w = zeros(length(etaSpan),1);

s = linspace(0.1,1,1000); % [m]
for i = 1:length(etaSpan)
    
    c_fw(i) = 2*a*sqrt(nu / ((2*alpha - beta)*u_e*s(i)));
    tau_w(i) = c_fw(i)*1/2*rho*u_e^2;
end

% integrate over the plate to get the drag coefficient and drag force
C_f = trapz(c_fw);
F_d = trapz(tau_w);

% for heat transfer we'll need ThetaPrime_w
ThetaPrime_w = 1 / trapz(F(1:end));

% calculate heat transfer
kappa = 1.4;
q_w = C_f * F_d * ThetaPrime_w * rho * u_e^3 / kappa;
%%
function out = g(a,etaMax,beta,solver) 
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    if (solver == 0)
        xiSpan = [0 1];
        initialValue = [0 0 a];
        % disp("Now solving Falkner Skan with a = " + a + " and etaMax = " + etaMax)
        [xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); %#ok<ASGLU>
        out = sol(end,2);
    end

    if(solver == 1)
        etaSpan = [0 etaMax];
        initialValue = [0 0 a];
        % disp("Now solving Falkner Skan with a = " + a + " and etaMax = " + etaMax)
        [eta,sol] = ode45(@FalknerSkan2,etaSpan,initialValue,options,beta); %%#ok<ASGLU>
        out = sol(end,2);
    end
end

function out = h(a,etaMax,beta,solver) %#ok<*DEFNU>
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    if (solver == 0)
        xiSpan = [0 1];
        initialValue = [0 0 a];
        [xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); %#ok<ASGLU>
        out = sol(end,3);
    end  
    
    if(solver == 1)
        etaSpan = [0 etaMax];
        initialValue = [0 0 a];
        [eta,sol] = ode45(@FalknerSkan2,etaSpan,initialValue,options,beta);
        out = sol(end,3);
    end
end

function out = FalknerSkan(xi,initialValue, beta, etaMax) %#ok<INUSD>
    % initial conditions
    f = initialValue(1);
    u = initialValue(2);
    v = initialValue(3);
    
    % calculate derivatives
    df = etaMax * u;
    du = etaMax * v;
    dv = etaMax * (-f * v + beta*u^2 - beta);
    
    out = [df du dv]';
end

function odeOutput = FalknerSkan2(eta,initialValue, beta) %#ok<INUSD>
    % initial conditions
    f = initialValue(1);
    df = initialValue(2);
    ddf = initialValue(3);
    
    % calculate derivatives
    
    dddf = -f*ddf + beta*(df^2) - beta;
    
    odeOutput = [df ddf dddf]';
end

function [a,etaMax] = FalkerRootFinder(beta,error)
    solver = 0; % 0 for Asaithambi change of variables, 1 for direct ODE45 on Falkner-Skan equation
    
    % 'm1' denotes the previous index ('minus one')
    % 'p1' denotes the next index ('plus one')
    
    % provide two initial guesses for the secant method for both 'a' and etaMax
    etaMax_km1 = 1;
    etaMax_k = 1.1;
    a_jm1 = 1.2;
    a_j = 1.21;
    aStar_k = 1.2;
    
    
    k = 1;
    while (abs(h(aStar_k,etaMax_k,beta,solver) - 0) > error)
        % disp("----------------------------------------")
        % disp("k Iteration Number: " + k);
       
        if (k ~= 1) % update the guesses for etaMax
            etaMax_km1 = etaMax_k;
            etaMax_k = etaMax_kp1;
    
            a_jm1 = aStar_k;
            a_j = aStar_k + 0.01;
        end
        j = 1;
        % iterate through different values of a to converge on aStar
        while (abs(g(a_j,etaMax_k,beta,solver) - 1) > error)
            % disp("J iteration number: " + j)
            if (j ~= 1) % update the guesses for a
                a_jm1 = a_j;
                a_j = a_jp1;
            end
        
            % apply the secant method to converge on a
            delta_a_j = (1 - g(a_j,etaMax_k,beta,solver)) * ( (a_j - a_jm1) / (g(a_j,etaMax_k,beta,solver) - g(a_jm1,etaMax_k,beta,solver)));
            a_jp1 = a_j + delta_a_j;
            j = j + 1;
        end
        % denote the converged on value for 'a' at iteration k as 'aStar_k'
        aStar_k = a_jp1;
        % disp("A value of etaMax = " + etaMax_k + " produced an aStar_k value of: " + aStar_k)
    
        % apply the secant method on etaMax using the current value of aStar
        delta_etaMax_k = (0 - h(aStar_k,etaMax_k,beta,solver)) * ( (etaMax_k - etaMax_km1) / (h(aStar_k,etaMax_k,beta,solver) - h(aStar_k,etaMax_km1,beta,solver)));
        etaMax_kp1 = etaMax_k + delta_etaMax_k;
        
        % disp("Change in etaMax: " + delta_etaMax_k);    
        % disp("New value of etaMax: " + etaMax_kp1);
        k = k + 1;
    end
    a = aStar_k;
    etaMax = etaMax_k;
end