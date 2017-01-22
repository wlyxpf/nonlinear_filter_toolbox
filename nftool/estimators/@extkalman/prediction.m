function [next]=prediction(p,last,u)
% EXTKALMAN/PREDICTION - proceeds prediction step
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
% getting of variables
M = mean(last);                 % mean of filtering
V = var(last);                  % variance of filtering

if nargin == 3 && p.nu>0
    % input passed as parameted and is defined in system
    F = nfdiff(p.f,[u' M' zeros(1, p.nw)],p.x);
    f = nfeval(p.f,[u' M' zeros(1, p.nw)]);
else
    % input is not defined in the system
    F = nfdiff(p.f,[M' zeros(1, p.nw)],p.x);
    f = nfeval(p.f,[M' zeros(1, p.nw)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prediction


Mp = f + p.gamma * p.pwmean;
Vp = F * V * F' + p.gamma * p.Q * p.gamma';
next = gpdf(Mp,(Vp + Vp')/2);


% CHANGELOG