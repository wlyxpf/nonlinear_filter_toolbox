function [sm]=smoothing(p,cur,lastp,lastf,u)
% KALMAN/SMOOTHING - proceeds smoothing step of the kalman filter
% returns information structure about
% smoothing pdf
% 1st arg.: object
% 2nd arg.: current smoothing info
% 3rd arg.: last predictive info
% 4th arg.: last filtering info
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting of variables
system = get(p,'system');       % system

F = system.F;                   % the F matrix of system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smoothing
Kv = var(lastf) * F' * inv(var(lastp));
M = mean(lastf) + Kv * (mean(cur) - mean(lastp));
V = var(lastf) - Kv * (var(lastp) - var(cur)) * Kv';
sm = gpdf(double(M),(double(V)+double(V)')/2);

% CHANGELOG 
