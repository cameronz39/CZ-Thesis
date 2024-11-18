
%{
 --------------- BACKGROUND ------------------------------------
The Falkner-Skan Equation is given by
dddF + F * ddF + beta * (1 - dF^2) = 0;

where F is a function of the non-demensional flow parameter eta

The boundary conditions are given by
F = 0 at eta = 0
dF = 0 at eta = 0
dF = 1 as eta approaches infinity

Which constitutes a two-point boundary value problem. Given ODE45 may only 
solve initial value problems, we add the arbitrary initial condition 
ddF = a at eta = 0

Different values of 'a' will result in different values of dF as eta 
approaches infinity. We would like to find the value of 'a' that results 
in dF = 1 as eta approaches infinity.

Another issue is that ODE45 may not actually propogate to infinity. We i
nstead define an abritrary stop condition of etaMax so that
dF = 1 as eta approaches etaMax 

To verify etaMax is a succicient approximation for infinity, we introduce 
one final "asymptotic" boundary condition:
ddF = 0 as eta approches etaMax

The initial conditions are given by
F = 0 
dF = 0 
ddF = a 

where the choice of 'a' is verified when
dF = 1 as eta approaches etaMax

and the choice of etaMax is verified when
ddF = 0 as eta approches etaMax 

---------------------- CHANGE OF VARIABLES ----------------------
To handle the difficulty of converging on values of 'a' and etaMax, we 
introduce the change of variables
xi = eta / etaMax

The Falkner-Skan Equation is then given by
(1/etaMax^3) * dddF + (1/etaMax^2) * F * ddF + beta * (1 - (1/etaMax^2) * dF^2) = 0;

where F is now a function xi

The initial conditions are given by
F = 0 
dF = 0 
ddF = etaMax^2 * a

with additional boundary conditions
dF = etaMax as xi approaches 1
ddF = 0 as xi approaches 1

Solving the ODE the traditional way in terms of F, dF, ddF leads to further 
numerical complications due to multiplication by etaMax^2 and etaMax^3. To 
avoid this, we introduce one final change of variables
f = F                                    
u = (1/etaMax) * dF                      
v = (1/etaMax^2) * ddF                   

---------------------- FINAL EQUATION ---------------------------
The Falkner-Skan Equation is now given by the system of ODEs
df = etaMax*u
du = etaMax*v
dv = etaMax*(f*v + beta*(1 - u^2))

With intial conditions of
f = 0
u = 0
v = a

And boundary conditions of
u = 1 as xi approaches 1
v = 0 as xi approaches 1
%}


%% ------------------ IVP SOLVER -------------------------------
% The first function to write is simply the one that solves the IVP for a given 'a' and etaMax
clc
clear

beta = 10;
a = 3.6752;
etaMax = 2;
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
beta = 2;
a = 1.687218;
etaMax = 4.52599;
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

%% Testing the iterative scheme for a
clc
clear
beta = 1;
% apply the following initial guesses
etaMax = 1;
a_lm1 = 1.234;
a_l = 1.2;

% iterate through different values of a to converge on aStar (using the secant method)
error = 10^-6;
l = 1;
while (abs(g(a_l,etaMax,beta) - 1) > error)
    if (l ~= 1)
        a_lm1 = a_l;
        a_l = a_lp1;
    end

    del_a_l = (1 - g(a_l,etaMax,beta)) * ( (a_l - a_lm1) / (g(a_l,etaMax,beta) - g(a_lm1,etaMax,beta)));
    a_lp1 = a_l + del_a_l;
    % disp("Iteration Number: " + l);
    % disp("Change in a: " + del_a_l);
    % disp("New value of a: " + a_lp1);
    l = l + 1;
end
aStar = a_lp1

% plot the results for a
a_test = linspace(-3,3,50);
for i = 1:length(a_test)
    g_test(i) = g(a_test(i),etaMax,beta);
end
figure;
plot(a_test,g_test);
hold on
yline(1);
title("Testing a Scheme"); 
plot(aStar,g(aStar,etaMax,beta),"*");

%% Testing the iterative scheme for etaMax
clc
clear
beta = 1;
error = 10^-6;

aStar = 1;
% iterate through different values of etaMax to converge on etaMaxStar (using the secant method)
etaMax_km1 = 2;
etaMax_k = 2.1;

k = 1;
while (abs(h(aStar,etaMax_k,beta) - 0) > error)
    if (k ~= 1)
        etaMax_km1 = etaMax_k;
        etaMax_k = etaMax_kp1;
    end

    del_etaMax_k = (0 - h(aStar,etaMax_k,beta)) * ( (etaMax_k - etaMax_km1) / (h(aStar,etaMax_k,beta) - h(aStar,etaMax_km1,beta)));
    etaMax_kp1 = etaMax_k + del_etaMax_k;
    k = k + 1;
end
etaMaxStar = etaMax_kp1;

% plot the results for etaMax
eta_test = linspace(-1,3,50);
for i = 1:length(eta_test)
    h_test(i) = h(aStar,eta_test(i),beta);
end
figure;
plot(eta_test,h_test);
hold on
yline(0);   
title("Testing etaMax Scheme"); 
plot(etaMaxStar,h(aStar,etaMaxStar,beta),"*");

%% Putting it all together
clc
clear
beta = 0;
error = 10^-6;

etaMax_km1 = 1;
etaMax_k = 1.1;

aStar_k = 1.2;
a_lm1 = 1.2;
a_l = 1.21;

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
function out = g(a,etaMax,beta) 
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    xiSpan = [0 1];
    initialValue = [0 0 a];
    [xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); %#ok<ASGLU>

    out = sol(end,2);
end

function out = h(a,etaMax,beta) %#ok<*DEFNU>
    options = odeset('RelTol',1e-6,'AbsTol',1e-6); 
    xiSpan = [0 1];
    initialValue = [0 0 a];
    [xi,sol] = ode45(@FalknerSkan,xiSpan,initialValue,options,beta,etaMax); %#ok<ASGLU>

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
