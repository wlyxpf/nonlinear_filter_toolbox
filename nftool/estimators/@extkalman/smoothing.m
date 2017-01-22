function [sm]=smoothing(p,cur,lastp,lastf,u)
% EXTKALMAN/SMOOTHING - proceeds smoothing step of the extkalman filter
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

if nargin == 5 && p.nu>0
    % input passed as parameted and is defined in system
    F = nfdiff(p.f,[u' mean(lastf)' zeros(1, p.nw)],p.x);
else
    % input is not defined in the system
    F = nfdiff(p.f,[mean(lastf)' zeros(1, p.nw)],p.x);
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smoothing
Kv = var(lastf) * F' * inv(var(lastp));
M = mean(lastf) + Kv * (mean(cur) - mean(lastp));
V = var(lastf) - Kv * (var(lastp) - var(cur)) * Kv';
sm = gpdf(double(M),(double(V)+double(V)')/2);

% CHANGELOG
