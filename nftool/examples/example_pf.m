%% Example of the PF filter implementation usage

clear all
close all

useMatlabSymbolicToolbox = false;

%% Definition of the pdf's within the NFT framework
%
disp('*************************************************')
disp('pdf definition')
pv = gpdf(0,0.5)                          % the measurement noise
pw = gpdf([0;0],0.005*eye(2))               % the state noise
px0 = gpdf([0.9;-0.85],diag([0.09,10^-1])) % the pdf of the initial state

%% Definition of the transitional na measurement multivariate function
%
disp('*************************************************')
disp('The definition of the transient function definition')
if useMatlabSymbolicToolbox
    disp(' - with symbolic toolbox')
    f = nfSymFunction('[x1*x2+w1;x2+w2]','','x1,x2','w1,w2')
else % use the user defined multivariate function prepared beforehand
    disp(' - without symbolic toolbox')
    f = nfPmfExampleTransFunction 
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
N = 20;  

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


%% Performing the estimation experiment using PF
%
disp('*************************************************')
disp('performing of estimation experiment using PF')
disp(' - filter initial condition')

% Set the apriory pdf necessary for the estimation.
p_apr = gpdf([0.9;-0.85],diag([1,1])); 

disp(' - constructor of estimator class for filtering')
% filtering lag=0, smoothing lag<0, prediction lag>0
lag = 0; % The estimator will compute the one step smoothing

%% Creation of filter objects 
filterPF = pf(system,lag,p_apr,struct('ss',1000,'restyp','static','rescnt',5,'resmet','multinomial','sdtyp','prior'));

%% The estimation process using prepared filter
%
disp(' - the estimation itself, see Figure')
[estPF,filterPF] = estimate(filterPF,z,[]);

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(estPF) 
 xest(:,i) = samples(estPF{i})*weights(estPF{i})';
end;

%% Depiction of the gathered estimates
%
time = [0:length(estPF)-1];
subplot(2,1,1)
plot(time,x(1,:),time,xest(1,:))
hold on
title('First state component')
subplot(2,1,2)
plot(time,x(2,:),time,xest(2,:))
hold on
title('Second state component')
legend('true state','PF estimate')
