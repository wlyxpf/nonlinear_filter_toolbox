function [filt]=filtering(p,pred,z)
% KALMAN/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting of variables
system = get(p,'system');       % system

H = system.H;                   % the H matrix of system

Mp = mean(pred);                % mean of prediction
Vp = var(pred);                 % variance of prediction

pvmean = mean(system.pv);       % mean of v noise
R = var(system.pv);             % variance of v noise

delta = system.delta;           % the DELTA matrix of system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman gain
K = kalman_gain(p,Vp,H,R,delta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtering - state, variance
if (sum(sum(isnan(K))) == 0) & (sum(sum(isinf(K))) == 0)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering of state
    M = Mp + K * (z - H * Mp - delta * pvmean);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ricatti solution - variance
    V = riccati(p,Vp,K,H,R,delta);

else

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering of state
    M = Mp;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ricatti solution - variance
    V = zeros(size(Vp));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% result
filt = gpdf(M,(V + V')/2);

% CHANGELOG
