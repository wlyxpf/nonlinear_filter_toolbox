%% Example of the UKF filter implementation usage

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
lag = -1; % The estimator will compute the one step smoothing

%% Creation of filter objects 
% A comparison of different variants of the UKF will be provided. 
% It is possible to decide between 'standard' and 'square-root' version and
% to choose the scaling parameter kappa.
filterSUKF = ukf(system,lag,p_apr,'squareroot')
filterUKF = ukf(system,lag,p_apr)
filterSUKF1 = ukf(system,lag,p_apr,'squareroot',-5)

%% The estimation process using prepared filters
%
disp(' - the estimation itself, see Figure')
[estSUKF,filterSUKF] = estimate(filterSUKF,z,[]);
[estSUKF1,filterSUKF1] = estimate(filterSUKF1,z,[]);
[estUKF,filterUKF] = estimate(filterUKF,z,[]);

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(estSUKF) 
    point_SUKF(:,i) = estSUKF{i}.mean; 
    point_SUKF1(:,i) = estSUKF1{i}.mean; 
    point_UKF(:,i) = estUKF{i}.mean; 
end;

%% Depiction of the gathered estimates
%
subplot(2,1,1)
plot(x(1,:))
hold on
plot(point_SUKF(1,:),'r')
plot(point_SUKF1(1,:),'m:')
plot(point_UKF(1,:),'g--')
title('First state component')
subplot(2,1,2)
plot(x(2,:))
hold on
plot(point_SUKF(2,:),'r')
plot(point_SUKF1(2,:),'m:')
plot(point_UKF(2,:),'g--')
title('Second state component')
legend('true state','SUKF kappa = 2','SUKF kappa = 5','UKF')