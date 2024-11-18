% NOTE: the notation and approach used here directly follows from:
% Asaithambi, N. S. "A numerical method for the solution of the Falkner-Skan equation." 
% Applied Mathematics and Computation 81.2-3 (1997): 259-264.%

% the character 'a' has been used instead of alpha
% the character 'j' has been used instead of l

clc
clear

beta = 0.3;

error = 10^-7;

% 'm1' denotes the previous index ('minus one')
% 'p1' denotes the next index ('plus one')

% provide two initial guesses for the secant method for both 'a' and etaMax
etaMax_km1 = 1;
etaMax_k = 1.1;
a_jm1 = 1.2;
a_j = 1.21;

aStar_k = 1.2;


k = 1;
while (abs(h(aStar_k,etaMax_k,beta) - 0) > error)
    j = 1;
    if (k ~= 1) % update the guesses for etaMax
        etaMax_km1 = etaMax_k;
        etaMax_k = etaMax_kp1;
    end

    % iterate through different values of a to converge on aStar
    while (abs(g(a_j,etaMax_k,beta) - 1) > error)
        if (j ~= 1) % update the guesses for a
            a_jm1 = a_j;
            a_j = a_jp1;
        end
    
        % apply the secant method to converge on a
        delta_a_j = (1 - g(a_j,etaMax_k,beta)) * ( (a_j - a_jm1) / (g(a_j,etaMax_k,beta) - g(a_jm1,etaMax_k,beta)));
        a_jp1 = a_j + delta_a_j;
        j = j + 1;
    end
    % denote the converged on value for 'a' at iteration k as 'aStar_k'
    aStar_k = a_jp1;

    disp("----------------------------------------")
    disp("Iteration Number: " + k);
    disp("A value of etaMax = " + etaMax_k + " produced an aStar_k value of: " + aStar_k)

    % apply the secant method on etaMax using the current value of aStar
    delta_etaMax_k = (0 - h(aStar_k,etaMax_k,beta)) * ( (etaMax_k - etaMax_km1) / (h(aStar_k,etaMax_k,beta) - h(aStar_k,etaMax_km1,beta)));
    etaMax_kp1 = etaMax_k + delta_etaMax_k;
    
    disp("Change in etaMax: " + delta_etaMax_k);    
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
