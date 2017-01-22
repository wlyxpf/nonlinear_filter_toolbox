function [filteringPdf]=filtering(p,predictionPdf,z)
% EXTKALMAN/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting of variables
system = get(p,'system');       % get object describing the system
measurementMapping = system.h;  % get the measurement vector mapping 
stateDimension = system.nx;     % get the dimension of the state;

predictionMean = mean(predictionPdf);    % mean of prediction 
predictionVariance = var(predictionPdf); % variance of prediction

noiseMean = mean(system.pv);    % mean of measurement noise
noisevariance = var(system.pv);% variance of the measurement noise         

delta = system.delta;           % the DELTA matrix of system weighting the
                                % measurement noise                                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% Evaluation of the measurement vector mapping and its partial derivatives
% in state point determined by mean valuse of the prediction probability
% density function from previous time step
%--------------------------------------------------------------------------

zeroNoise = zeros(1, system.nv);% zero vector with lenght corresponding to 
                                % dimension of the measurement noise

hx = nfdiff(measurementMapping,[predictionMean' zeroNoise],system.x);   % hx = dh/dx|xp
h = nfeval(measurementMapping,[predictionMean' zeroNoise]);             % h =h(xp)
hxx = nfsecpad(measurementMapping,[predictionMean' zeroNoise],system.x);% hxx =d^2h/dx^2|xp

ha = hxx * reshape(predictionVariance,stateDimension*stateDimension,1); % ha = hxx*cs(Pp)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Evaluate the parameters of the filtering density function
%--------------------------------------------------------------------------
% Evaluate the Kalman gain
K = kalman_gain(p,predictionVariance,hx,noisevariance,delta);

if (sum(sum(isnan(K))) == 0) && (sum(sum(isinf(K))) == 0)
    % mean value of the filtering probability density function
    filteringMean = predictionMean + K * (z - h - delta * noiseMean - 0.5 * ha');
    % variance of the filtering probability density function
    filteringVariance = riccati(p,predictionVariance,K,hx,noisevariance,delta);
else
    filteringMean = predictionMean;
    filteringVariance = zeros(size(predictionVariance));
end
%--------------------------------------------------------------------------

% create filtering probability density function and by simple means ensure 
% symetry of the variance
filteringPdf = gpdf(filteringMean,(filteringVariance + filteringVariance')/2);

% CHANGELOG 

