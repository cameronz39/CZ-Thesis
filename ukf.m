function UKFForBalancing_Chesi  % 4-state UKF used in the second phase of the hybrid  
% balancing scheme for balancing the rz component.  
tf = 100;  % simulation length  
dt = 0.1;  % simulation step size  
n=4;  % number of states  
% Testbed characteristics  % (see eom_ukf.m)  
J = [0.265 0 0; 0 0.246 0; 0 0 0.427];  
Rcm = [0; 0; -5]*10^-3; % CM offset vector  
m = 14.307; % mass of the testbed  
g = 9.78; % in m/s^2, local gravity  

% Filter matrices  
R = [0.005^2 0 0; 0 0.005^2 0; 0 0 0.005^2];  
H = [eye(3) zeros(3,1)]; % measurement matrix  

% Initialization of variables  
xstate = [0; 0; 0; Rcm(3)]; % initial state  
xhatukf = 2 * xstate; % initial UKF state estimate  
z = H * xstate + sqrt(R) * [randn; randn; randn];  
W = ones(2*n,1)/(2*n); % UKF weights (in this case, equal wheights for all sigma points)  
Q = diag([0.00005 0.00005 0.00005 (0.1*Rcm(3))^2]);  
y = [pi/6 pi/6 0 0 0 0 Rcm(3)];  %% Initialize arrays for later plotting

yArray = y';  
zArray = z;  
tArray = 0;  
zhatArray = z;  
xArray = xstate;  
dtPlot = dt; % how often to plot output data  
xhatukfArray = xhatukf;  
P = 1e-5*eye(4);  
Pukf = P;  
Parray = diag(P);  
Pukfarray = diag(Pukf);  
chi2lim = chi2inv(0.95,length(xstate));  
d2 = 0;