% NOTE: the notation and approach used here directly follows from:
% Asaithambi, N. S. "A numerical method for the solution of the Falkner-Skan equation." 
% Applied Mathematics and Computation 81.2-3 (1997): 259-264.%

% the character 'a' has been used instead of alpha to denote the second derivative of f at the wall
% the character 'j' has been used instead of of the character 'l' to index the secant method loop

clc
clear

%% Use the root finder and solve for the thicknesses (part a)
beta = 2;
[a,etaMax] = FalkerRootFinder(beta,10^-6);

disp("-------------------------------------")
fprintf('Final etaMax: %.*g\n', 6, etaMax);
fprintf('Final aStar: %.*g\n', 6, a);




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

%% Solve for f' and compare to book solution (part b)

etasBook = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.5 5.0];
fPrime = sol(:,2);

fPrimeComparison = interp1(etaSpan,fPrime,etasBook,'linear');

for i = 1:length(etasBook)
    fprintf('fPrime at eta = %.*g: %.*g\n', 6, etasBook(i), 6, fPrimeComparison(i));
end



%% Plot some velocity profiles (part c)
alpha = 1;
u_inf = 20; % [m/s] velocity 1 meter downstream of wedge
wedgeAngle = pi/6;
beta = 2*wedgeAngle/pi;
m = beta/(2-beta);
nu = 1.48e-5; % [m^2/s] kinematic viscosity
rho = 1.225; % [kg/m^3] density
C = 20; % given that u_e = C*s^m, u_e at s = 1 implies C = 20

[a,etaMax] = FalkerRootFinder(beta,10^-5);
options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
xiSpan = [0 1];
initialValue = [0 0 a];
[xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax);
etaSpan = xi*etaMax;
fPrime = sol(:,2);

% case 1: s = 0.1 cm
s = 0.001; % [m];
u_e = C*(s^m); 
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
u_e = C*(s^m); % [m/s] 
u = u_e*fPrime;

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([u_e, u_e],[0,ySpan(end)],'--','Color','black');
plot(u,ySpan,'LineWidth',2);

% case 3: s = 5.0 cm
s = 0.05; % [m];
u_e = C*(s^m); % [m/s] 
u = u_e*fPrime;

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([u_e, u_e],[0,ySpan(end)],'--','Color','black');
plot(u,ySpan,'LineWidth',2);


legend('','s = 0.1 cm','','s = 1.0 cm','','s = 5.0 cm','Location','northwest');
ylabel('Normal Distance From Wall [m]');
xlabel('Streamwise Velocity [m/s]');


%% Plot some temperature profiles (part d)
Pr = 0.707; % Prandtl number of air at 1 atm and 300K
f = sol(:,1);
T_e = 300; % [K]
T_w = 250; % [K]

% define captial F at each eta
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
u_e = C*(s^m); % [m/s] 


ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
figure
xline(T_e,'--');
plot([T_e, T_e],[0,ySpan(end)],'--','Color','black');
hold on
plot(T,ySpan,'LineWidth',2);
grid on

% case 2: s = 1.0 cm
s = 0.01; % [m];
u_e = C*(s^m); % [m/s] 


ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));
plot([T_e, T_e],[0,ySpan(end)],'--','Color','black');
plot(T,ySpan,'LineWidth',2);

% case 3: s = 5.0 cm
s = 0.05; % [m];
u_e = C*(s^m); % [m/s] 

ySpan = etaSpan / sqrt( ((m+1)*u_e) / (2*alpha*nu*s));    
plot([T_e, T_e],[0,ySpan(end)],'--','Color','black');
plot(T,ySpan,'LineWidth',2);

legend('','s = 0.1 cm','','s = 1.0 cm','','s = 5.0 cm','Location','northwest');
ylabel('Normal Distance From Wall [m]');
xlabel('Temperature [K]');  
xlim([250,305])

%% Find Drag Force, Drag Coefficient, and Heat Transfer (part e)
% find tau_w at every streamwise location

% the force of drag may be found be integrating tau_w over the plate
% this integral may be solved for exactly using the antidifferentiation 
% and the fundamental theorem of calculus
F_d = ((rho*nu*a*C^(3/2))/sqrt(nu*(2*alpha-beta)))*(1^0.8/0.8);

% non-dimensionalize for coefficient of drag
C_f = F_d / (0.5*rho*u_inf^2);

% for heat transfer we'll need ThetaPrime_w
ThetaPrime_w = 1 / trapz(F(1:end));

% calculate heat transfer
kappa = 0.026;
q_w = (sqrt(C)*kappa*(T_w - T_e)*ThetaPrime_w)/sqrt(nu*(2*alpha-beta)) * (1^0.6/0.6);



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