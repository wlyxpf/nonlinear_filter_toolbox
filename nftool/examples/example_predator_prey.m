%% Example with system describing the Predator-Prey model

clear all
close all

useExplicitElementsnaming = false;
%% Definition of the pdf's within the NFT framework
%
disp('*************************************************')
disp('pdf definition')
pv = gpdf(0,0.01)                % the measurement noise
pw = gpdf([0;0],0.005*eye(2))    % the state noise
px0 = gpdf([1;1],0.001*eye(2))   % the pdf of the initial state

%% Definition of the transitional na measurement multivariate function
%
% The nfnfPredatorPreyModel defines folloving nonlinear multivariate function
%
%      | T*(1-a)*x1 + T*b*x1*x2 + w1 |
%  f = |                             |
%      | T*(1+c)*x2 + T*d*x1*x2 + w2 |
%
%           | x1 |                  | w1 |
% where x = |    | is state and w = |    | noise
%           | x2 |                  | w2 |
%
% Constants are given as follows:
%  T = 1
%  a = 0.04
%  b = c = d = 0.08

disp('*************************************************')
disp('The definition of the transient function definition')
if useExplicitElementsnaming
    f = nfPredatorPreyModel2
else
    f = nfPredatorPreyModel
end

disp('The definition of the measurement function')
H = [0 1];
Delta = 1;
if useExplicitElementsnaming
    disp(' - without explicitly naming the quantities elements')
    h = nfLinFunction(H,[],Delta,'','x1,x2','v')
else
    disp(' - with explicitly naming the quantities elements')
    h = nfLinFunction(H,[],Delta)
end
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

w = sampleset(pw,N);
v = sampleset(pv,N);
[z,x] = simulate(system,'state noise',w,'measurement noise',v);

%% Performing the estimation experiment using DD1
%
disp('*************************************************')
disp('performing of estimation experiment using DD1')
disp(' - filter initial condition')

% Set the apriory pdf necessary for the estimation.
p_apr = gpdf([5;5],diag([1,1]));

disp(' - constructor of estimator class for filtering')
% filtering lag=0, smoothing lag<0, prediction lag>0
lag = 0; % The estimator will compute the filtering

%% Creation of filter objects 
% A comparison of different variants of the DD1 will be provided. 
filterDD1 = dd1(system,lag,p_apr)
filterCDF = dd1(system,lag,p_apr,1)

%% The estimation process using prepared filters
%
disp(' - the estimation itself, see Figure')
[estDD1,filterDD1] = estimate(filterDD1,z,zeros(N));
[estCDF,filterCDF] = estimate(filterCDF,z,zeros(N));

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(estDD1) 
    point_DD1(:,i) = estDD1{i}.mean; 
    point_CDF(:,i) = estCDF{i}.mean; 
end;

%% Depiction of the gathered estimates
%
subplot(2,1,1)
plot(x(1,:))
hold on
plot(point_DD1(1,:),'r')
plot(point_CDF(1,:),'g--')
title('First state component')
subplot(2,1,2)
plot(x(2,:))
hold on
plot(point_DD1(2,:),'r')
plot(point_CDF(2,:),'g--')
title('Second state component')
legend('true state','DD1','CDF')