%% Example of Example of utilizing the point-mass filter (pmf).
clear all
close all

useMatlabSymbolicToolbox = false;

%% Definition of the pdf's within the NFT framework
%
disp('*************************************************')
disp('pdf definition')
pw=gpdf(0,0.25)
pv=gpdf(0,1)
px0=gpdf(-.25,.25)

%% Definition of the transitional na measurement multivariate function
%
disp('*************************************************')
disp('The definition of the transient function definition')
if useMatlabSymbolicToolbox
    disp(' - with symbolic toolbox')
    f = nfSymFunction('x-0.2*x^2+w','','x','w')
else % use the user defined multivariate function prepared beforehand
    %disp(' - without symbolic toolbox')
    %f = nfPmfExampleTransFunction 
end

disp('The definition of the measurement function')
if useMatlabSymbolicToolbox
    disp(' - with symbolic toolbox')
    h=nfSymFunction('x^2+v','','x','v')
else
    %h = nfPmfExampleMeasFunction 
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
N = 10;  

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
%% Performing the estimation experiment using PMF
%
% Creation of filter object
p=pmf(system, 'epsilon', 1/500000, 'a', 4, 'b', 4, 'gamma', .5)

% The estimation process using prepared filter
pdf_time=estimate(p,z,zeros(1,length(z)))

%% Extraction of the point estimates from the stored data delivered by the estimators
%
for i=1:1:length(pdf_time) 
    point_pmf(:,i) = pdf_time{i}.mean; 
end;

%% Depiction of the gathered estimates
%
t = 0:length(pdf_time)-1;
for i = 1:size(x,1)
    subplot(size(x,1),1,i)
    plot(t,x(i,:),t,point_pmf(i,:),'r')
    grid on
    title(['State component #' int2str(i)])
end
legend('true state','PMF')

button = questdlg('Plot probability density functions?','Plot pdfs','Yes','No','Yes');
if strcmp(button,'Yes')
    for k = 1:length(pdf_time)
        plot(pdf_time{k})
        title(['time = ' int2str(t(k))])
        if k < length(pdf_time)
            pause
            close
        end
    end
end
