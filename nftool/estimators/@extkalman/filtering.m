function [filt]=filtering(p,pred,z)
% EXTKALMAN/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%


% CHANGELOG % Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting of variables
Mp = mean(pred);                % mean of prediction
Vp = var(pred);                 % variance of prediction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = nfdiff(p.h,[Mp' zeros(1, p.nv)],p.x);      % H
h = nfeval(p.h,[Mp' zeros(1, p.nv)]);            % h(Mp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kalman gain
K = kalman_gain(p,Vp,H,p.R,p.delta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtering - state, variance
if (sum(sum(isnan(K))) == 0) && (sum(sum(isinf(K))) == 0)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering of state
    M = Mp + K * (z - h - p.delta * p.pvmean);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ricatti solution - variance
    V = riccati(p,Vp,K,H,p.R,p.delta);

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
