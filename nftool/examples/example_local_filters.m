%% Example of the sigma point local filters and of the Extended Kalman Filter implementation usage

clear all
close all

useMatlabSymbolicToolbox = false;

%% Definition of the pdf's within the NFT framework
%
disp('*************************************************')
disp('pdf definition')
pv = gpdf(0,0.01)                          % the measurement noise
pw = gpdf([0;0],0.05*eye(2))               % the state noise
px0 = gpdf([0.9;-0.85],diag([0.09,10^-1])) % the pdf of the initial state

%% Definition of the transitional na measurement multivariate function
%
disp('*************************************************')
disp('The definition of the transient function definition')
if useMatlabSymbolicToolbox
    disp(' - with symbolic toolbox')
    f = nfSymFunction('[x1^2*x2+w1;x2+w2]','','x1,x2','w1,w2')
else % use the user defined multivariate function prepared beforehand
    disp(' - without symbolic toolbox')
    f = nfExampleFunction 
end

disp('The definition of the measurement function')
disp(' - without symbolic toolbox')
H = [4 1];
Delta = 1;
h = nfLinFunction(H,[],Delta,'','x1,x2','v')

%% Creation of object describing the system defined by transient and measurement functions
% creates object describin Non-Linear Gaussian system with Additive noises
disp('*************************************************')
disp('creating of system object')
system = nlga(f,h,pw,pv,px0)

%% Simulation of the system trajectory
% Calling the system object method simulate for processing of the
% trajectory simulation.
%
% The method returns the evolution of the state and measurement
%
disp('*************************************************')
disp('simulated system trajectory is stored in variables x and z')

% Set the number of time instants determining length of the simulation
N = 40;

[z,x,system] = simulate(system,zeros(1,N));
% Alternatively it is possible to proceed with the simulation using following
% commands:
% 
% w = sampleset(pw,N);
% v = sampleset(pv,N);
% [z,x,system] = simulate(system,'state noise',w,'measurement noise',v);
%
% Another alternative is to use following "for" cycle:
%
% for i = 1:N
%   [z,x,system] = simulate(system);
% end
%

%% Performing the estimation experiment using various local filters
%
disp('*************************************************')
disp('performing of estimation experiment using local filters')
disp(' - filter initial condition')

% Set the apriory pdf necessary for the estimation.
p_apr = gpdf([0.9;-0.85],diag([1,1]));

disp(' - constructor of estimator class for filtering')
% filtering lag=0, smoothing lag<0, prediction lag>0
lag = 2; % The estimator will compute the two step prediction

%% Creation of filter objects 
% A comparison of different variants of local filters will be provided.
%
filterUKF = ukf(system,lag,p_apr)
filterDD1 = dd1(system,lag,p_apr)
filterDD2 = dd2(system,lag,p_apr)
filterEKF = extkalman(system,lag,p_apr)
filterSEC = seckalman(system,lag,p_apr)
%% The estimation process using prepared filters
%
disp(' - the estimation itself, see Figure')
[estUKF,filterUKF] = estimate(filterUKF,z,zeros(N));
[estDD1,filterDD1] = estimate(filterDD1,z,zeros(N));
[estDD2,filterDD2] = estimate(filterDD2,z,zeros(N));
[estEKF,filterEKF] = estimate(filterEKF,z,zeros(N));
[estSEC,filterSEC] = estimate(filterSEC,z,zeros(N));

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(estUKF) 
    point_UKF(:,i) = estUKF{i}.mean; 
    point_DD1(:,i) = estDD1{i}.mean; 
    point_DD2(:,i) = estDD2{i}.mean;
    point_EKF(:,i) = estEKF{i}.mean; 
    point_SEC(:,i) = estSEC{i}.mean; 
end;

% transfer of resultin structure of eg. UKF into the gpdf form
gpdfUKF = lfstruct2gpdf(estUKF);
disp('*******************************************')
disp('First estimate produced by the UKF in gpdf form (transformed via lfstruct2gpdf.m)')
disp('*******************************************')
gpdfUKF{1}


%% Depiction of the gathered estimates
%
subplot(2,1,1)
plot(x(1,:))
hold on
plot(point_UKF(1,:),'r')
plot(point_DD1(1,:),'g--')
plot(point_DD2(1,:),'c-.')
plot(point_EKF(1,:),'m:')
plot(point_SEC(1,:),'y-')
title('First state component')
subplot(2,1,2)
plot(x(2,:))
hold on
plot(point_UKF(2,:),'r')
plot(point_DD1(2,:),'g--')
plot(point_DD2(2,:),'c-.')
plot(point_EKF(2,:),'m:')
plot(point_SEC(2,:),'y-')
title('Second state component')
legend('true state','UKF','DD1','DD2','EKF','SEC')
