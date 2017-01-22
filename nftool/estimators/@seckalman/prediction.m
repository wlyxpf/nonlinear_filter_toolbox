function [predictionPdf]=prediction(p,filteringPdf,u)
% SECKALMAN/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
% 1st arg.: object
% 2nd arg.: necessary arguments (filtering)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting of variables
system = get(p,'system');       % system
transitionalMapping = system.f; % get the transitional vector mapping 
stateDimension = system.nx;     % get the dimension of the state;


filteringMean = mean(filteringPdf);     % mean of filtering
filteringVariance = var(filteringPdf);  % variance of filtering

noiseMean = mean(system.pw);    % mean of w noise
noiseVariance = var(system.pw); % variance of w noise

gamma = system.gamma;           % the GAMMA matrix of system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
% Evaluation of the transitional vector mapping and its partial derivatives
% in state point determined by mean valuse of the prediction probability
% density function from previous time step
%--------------------------------------------------------------------------

zeroNoise = zeros(1, system.nw);% zero vector with lenght corresponding to 
                                % dimension of the state noise
                                
if nargin == 3 && system.nu>0
    fx = nfdiff(transitionalMapping,[u' filteringMean' zeroNoise],system.x); % fx = df/dx|xf
    f = nfeval(transitionalMapping,[u' filteringMean' zeroNoise]);           % f = f(xf)
    fxx = nfsecpad(transitionalMapping,[filteringMean' zeroNoise],system.x); % fxx =d^2f/dx^2|xf    
else
    fx = nfdiff(transitionalMapping,[filteringMean' zeroNoise],system.x);    % fx = df/dx|xf
    f = nfeval(transitionalMapping,[filteringMean' zeroNoise]);              % f = f(xf)
    fxx = nfsecpad(transitionalMapping,[filteringMean' zeroNoise],system.x); % fxx =d^2f/dx^2|xf   
end

fa = fxx * reshape(filteringVariance,stateDimension*stateDimension,1); % fa = fxx*cs(Pf)
%--------------------------------------------------------------------------
% Evaluate the parameters of the predictive density function
%--------------------------------------------------------------------------

predictionMean = f + gamma * noiseMean + 0.5*fa;
predictionVariance = fx * filteringVariance * fx' + gamma * noiseVariance * gamma';
%--------------------------------------------------------------------------
% create predictive probability density function and by simple means ensure 
% symetry of the variance
%--------------------------------------------------------------------------
predictionPdf = gpdf(predictionMean,(predictionVariance + predictionVariance')/2);


% CHANGELOG
