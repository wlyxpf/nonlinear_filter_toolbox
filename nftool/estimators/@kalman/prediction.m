function [next]=prediction(p,last,u)
% KALMAN/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
%
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

F = system.F;                   % the F matrix of system
G = system.G;                   % the G matrix of system

M = mean(last);                 % mean of filtering
V = var(last);                  % variance of filtering

pwmean = mean(system.pw);       % mean of w noise
Q = var(system.pw);             % variance of noise w

gamma = system.gamma;           % the GAMMA matrix of system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prediction

if nargin == 3 & system.nu>0
  % input passed as parameted and is defined in system

  % prediction
  Mp = F * M + G * u + gamma * pwmean;
  Vp = F * V * F' + gamma * Q * gamma';
  next = gpdf(Mp,(Vp + Vp')/2);
else
  % input is not defined in the system

  % prediction 
  Mp = F * M + gamma * pwmean;
  Vp = F * V * F' + gamma * Q * gamma';
  next = gpdf(Mp,(Vp + Vp')/2);

  if  ~isempty(find(G ~= 0))   
    warning('nft2:kalman:inp_n_spec','Input not specified, using zeros');
  end  
end
  
% CHANGELOG
