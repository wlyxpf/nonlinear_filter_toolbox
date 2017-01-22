%% Example of the DD2 filter implementation usage

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
H = [4 1];
Delta = 1;
h = nfLinFunction(H,[],Delta,'','x1,x2','v')

%% Creation of object describing the system defined by transient and measurement functions
% creates object describin Non-Linear Gaussian system with Additive noises
disp('*************************************************')
disp('Creating of system object')
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


%% Performing the estimation experiment using UKF
%
disp('*************************************************')
disp('performing of estimation experiment using UKF')
disp(' - filter initial condition')

% Set the apriory pdf necessary for the estimation.
p_apr = gpdf([0.9;-0.85],diag([1,1]));

disp(' - constructor of estimator class for filtering')
% filtering lag=0, smoothing lag<0, prediction lag>0
lag = 0; % The estimator will compute the filtering

%% Creation of filter objects 
% A comparison of different variants of the DD2 will be provided. 
% It is possible to choose a scaling parameter h^2.
filterDD2 = dd2(system,lag,p_apr)
filterDD2a = dd2(system,lag,p_apr,1)

%% The estimation process using prepared filters
%
disp(' - the estimation itself, see Figure')
[estDD2,filterDD2] = estimate(filterDD2,z,zeros(N));
[estDD2a,filterDD2a] = estimate(filterDD2a,z,zeros(N));

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(estDD2) 
    point_DD2(:,i) = estDD2{i}.mean; 
    point_DD2a(:,i) = estDD2a{i}.mean; 
end;

%% Depiction of the gathered estimates
%
subplot(2,1,1)
plot(x(1,:))
hold on
plot(point_DD2(1,:),'r')
plot(point_DD2a(1,:),'g--')
title('First state component')
subplot(2,1,2)
plot(x(2,:))
hold on
plot(point_DD2(2,:),'r')
plot(point_DD2a(2,:),'g--')
title('Second state component')
legend('true state','DD2 (h^2=3)','DD2 (h^2=1)')