
%% ------------------ IVP SOLVER -------------------------------
% The first function to write is simply the one that solves the IVP for a given 'a' and etaMax
clc
clear

beta = 10;
a = 3.6752;
etaMax = 3;
% Format state the vector as [ f, u, v ]
initialValue = [0 0 a];

options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
xiSpan = [0 1];
[xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); 

% Plot the results
figure;
plot(xi,sol(:,1));
hold on
plot(xi,sol(:,2));
plot(xi,sol(:,3));
legend('f','u','v');
xlabel('xi');

% The next step is to define the function g as 
% g(a) = u(1,a);
% g will take an initial guess of etaMax and iterate through different 
% values of a until it  satisfies the equation g(a) = 1, once it does we 
% call this value aStar

% Once a value of aStar has been found, we define the function h as
% h(etaMax) = v(1,etaMax)
% h uses aStar and iterates through different values of etaMax until it 
% satisfies the equation h(etaMax) = 0


%% Another IVP approach
clc
clear
beta = 10;
a = 3.6752;
etaMax = 2;
% Format state the vector as [ f, df, ddf ]
initialValue = [0 0 a*(etaMax^2)];

options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
xiSpan = [0 1];
[xi,sol] = ode45(@FalknerSkan2,xiSpan,initialValue,options,beta,etaMax); 
% if you want to go from f as a function of xi to a function of eta
% remember the (1/etaMax) factor for df and (1/etaMax^2) factor for ddf


% Plot the results
figure;
plot(xi*etaMax,sol(:,1));
hold on
plot(xi*etaMax,sol(:,2)/etaMax);
plot(xi*etaMax,sol(:,3)/etaMax^2);
legend('f','df','ddf');
xlabel('eta');

%% And another IVP approach
clc
clear
beta = 2;
a = 1.687218;
etaMax = 4.525991;
% Format state the vector as [ f, df, ddf ]
initialValue = [0 0 a];

options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
etaSpan = [0 etaMax];
[eta,sol] = ode45(@FalknerSkan3,etaSpan,initialValue,options,beta); 



% Plot the results
figure;
plot(eta,sol(:,1));
hold on
plot(eta,sol(:,2));
plot(eta,sol(:,3));
legend('f','df','ddf');
xlabel('eta');

%% Putting it all together
clc
clear
beta = 10;
error = 10^-6;

etaMax_km1 = 1.9;
etaMax_k = 2;

aStar_k = 3.6752;
a_lm1 = 3.67;
a_l = 3.5;

k = 1;
while (abs(h(aStar_k,etaMax_k,beta) - 0) > error)
    l = 1;
    if (k ~= 1)
        etaMax_km1 = etaMax_k;
        etaMax_k = etaMax_kp1;
    end

    while (abs(g(a_l,etaMax_k,beta) - 1) > error)
        if (l ~= 1)
            a_lm1 = a_l;
            a_l = a_lp1;
        end
    
        del_a_l = (1 - g(a_l,etaMax_k,beta)) * ( (a_l - a_lm1) / (g(a_l,etaMax_k,beta) - g(a_lm1,etaMax_k,beta)));
        a_lp1 = a_l + del_a_l;
        l = l + 1;
    end
    aStar_k = a_lp1;
    disp("----------------------------------------")
    disp("Iteration Number: " + k);
    disp("A value of etaMax = " + etaMax_k + " produced an aStar_k value of: " + aStar_k)

    del_etaMax_k = (0 - h(aStar_k,etaMax_k,beta)) * ( (etaMax_k - etaMax_km1) / (h(aStar_k,etaMax_k,beta) - h(aStar_k,etaMax_km1,beta)));
    etaMax_kp1 = etaMax_k + del_etaMax_k;
    
    disp("Change in etaMax: " + del_etaMax_k);    
    disp("New value of etaMax: " + etaMax_kp1);
    k = k + 1;
end

disp("")
disp("-------------------------------------")
disp("Final etaMax: " + etaMax_kp1)
disp("Final aStar: " + aStar_k)
%%






%%
function out = g(a,etaMax,beta) 
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    etaSpan = [0 etaMax];
    initialValue = [0 0 a];
    [eta,sol] = ode45(@FalknerSkan3,etaSpan,initialValue,options,beta); %#ok<ASGLU>

    out = sol(end,2);
end

function out = h(a,etaMax,beta) %#ok<*DEFNU>
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    etaSpan = [0 etaMax];
    initialValue = [0 0 a];
    [eta,sol] = ode45(@FalknerSkan3,etaSpan,initialValue,options,beta); %#ok<ASGLU>

    out = sol(end,3);
end

function odeOutput = FalknerSkan(xi,initialValue, beta, etaMax) %#ok<INUSD>
    % initial conditions
    f = initialValue(1);
    u = initialValue(2);
    v = initialValue(3);
    
    % calculate derivatives
    df = etaMax * u;
    du = etaMax * v;
    dv = etaMax * (-f * v + beta*u^2 - beta);
    
    odeOutput = [df du dv]';
end

function odeOutput = FalknerSkan2(xi,initialValue, beta, etaMax) %#ok<INUSD>
    % initial conditions
    f = initialValue(1);
    df = initialValue(2);
    ddf = initialValue(3);
    
    % calculate derivatives
    
    dddf = -etaMax*f*ddf + beta*etaMax*(df^2) - beta*etaMax^3;
    
    odeOutput = [df ddf dddf]';
end

function odeOutput = FalknerSkan3(eta,initialValue, beta) %#ok<INUSD>
    % initial conditions
    f = initialValue(1);
    df = initialValue(2);
    ddf = initialValue(3);
    
    % calculate derivatives
    
    dddf = -f*ddf + beta*(df^2) - beta;
    
    odeOutput = [df ddf dddf]';
end
