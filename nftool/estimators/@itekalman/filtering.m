function [filt]=filtering(p,pred,z)
% ITEKALMAN/FILTERING - proceeds filtering step
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

Mp = mean(pred);                % mean of prediction
Vp = var(pred);                 % variance of prediction

pvmean = mean(system.pv);       % mean of v noise
R = var(system.pv);             % variance of v noise

delta = system.delta;           % the DELTA matrix of system

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H = nfdiff(system.h,[Mp' zeros(1, system.nv)],system.x);    % H

h = nfeval(system.h,[Mp' zeros(1, system.nv)]);   % h(Mp)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Mi = Mp;            % first Mi is prediction Mp

while 1,

    Mi_old = Mi;                     % old filtering

    H = nfdiff(system.h,[Mi' zeros(1, system.nv)],system.x);    % H

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Kalman gain
    K = kalman_gain(p,Vp,H,R,delta);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % filtering - state, variance
    if (sum(sum(isnan(K))) == 0) && (sum(sum(isinf(K))) == 0)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering of state
        Mi = Mp + K * (z - h - delta * pvmean);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ricatti solution - variance
        Vi = riccati(p,Vp,K,H,R,delta);

    else

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % filtering of state
        Mi = Mp;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ricatti solution - variance
        Vi = zeros(size(Vp));
    end
    % end of loop
    if all(abs(Mi - Mi_old) < p.epsilon)
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% result

filt = gpdf(Mi,(Vi + Vi')/2);

% CHANGELOG 
