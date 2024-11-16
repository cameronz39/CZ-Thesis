%% Question 2

nu = 15.43e-6; % [m^2 / s]

t_1 = 1; % [s]
t_2 = 2; % [s]

y = linspace(0, 0.02, 1000);

eta_1 = (y./(2.*sqrt(nu*t_1)));
eta_2 = (y./(2.*sqrt(nu*t_2)));

f_1 = erfc(eta_1);
f_2 = erfc(eta_2);

figure;
plot(f_1, y,'LineWidth',1.5)
hold on
plot(f_2, y,'LineWidth',1.5)
grid on
ylabel("Height y [m]")
xlabel("Normalized Velocity in x-direction [m/s]")
legend("t = 1s","t = 2s")
title("Velocity Profile of Suddenly Accelerated Plate")

%% Question 5

options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
etaSpan = [0 3];
F_0 = 0;
dF_0 = 0;
ddF_0 = 1.2326;

initialState = [F_0 dF_0 ddF_0]';
[eta1,F1] = ode45(@stagnationFlow2D,etaSpan,initialState,options);

ddF_0 = 1.31194;
initialState = [F_0 dF_0 ddF_0]';
[eta2,F2] = ode45(@stagnationFlowAxi,etaSpan, initialState,options);

tolerance = 0.0001;
etaMaxIndex1 = findMax(F1(:,2),tolerance);
etaMax1 = eta1(etaMaxIndex1);

etaMaxIndex2 = findMax(F2(:,2),tolerance);
etaMax2 = eta2(etaMaxIndex2);

figure;
plot(eta1,F1(:,1),'Color',"#0072BD",'LineWidth',1.5);
hold on
plot(eta2,F2(:,1),'Color',"#0072BD",'LineStyle','--','LineWidth',1.5)

plot(eta1,F1(:,2),'Color',"#D95319",'LineWidth',1.5);
plot(eta2,F2(:,2),'Color',"#D95319",'LineStyle','--','LineWidth',1.5);

plot(eta1,F1(:,3),'Color',"#77AC30",'LineWidth',1.5);
plot(eta2,F2(:,3),'Color',"#77AC30",'LineStyle','--','LineWidth',1.5);
grid on;

xline(0)
xline(0,'LineStyle','--')

legend("F","","F'","","F''","","2D","Axisymmetric","Location","northwest")
title("Solutions to Stagnation Point Flows")

xlabel("$\eta = y\sqrt{{B}/{\nu}}$",'Interpreter','latex')

etaSpanTable = linspace(0,3,31);
dF_vals_2D = interp1(eta1,F1(:,2),etaSpanTable);
dF_vals_axi = interp1(eta2,F2(:,2),etaSpanTable);

table = [etaSpanTable' dF_vals_2D' dF_vals_axi']; % CONVERT TO LATEX TABLE




function odeOutput = stagnationFlow2D(time,initialState)
    % initial conditions
    F = initialState(1);
    dF = initialState(2);
    ddF = initialState(3);
    
    % third derivative as given by equation in lecture
    dddF = -F * ddF + (dF^2) - 1;
    
    odeOutput = [dF ddF dddF]';
end

function odeOutput = stagnationFlowAxi(time,initialState)
    % initial conditions
    F = initialState(1);
    dF = initialState(2);
    ddF = initialState(3);
    
    % third derivative as given by equation in lecture
    dddF = -2 * F * ddF + (dF^2) - 1;
    
    odeOutput = [dF ddF dddF]';
end

function maxIndex = findMax(solution,tolerance) 
    for i = 2:length(solution)
        if(abs(solution(i) - solution(i-1)) < tolerance)
            maxIndex = i;
            break;
        end
    end
end