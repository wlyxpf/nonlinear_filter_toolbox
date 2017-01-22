function [sm]=smoothing(p,curfil,lastpred,lastsmooth)
% SMOOTHING - proceeds smoothing step
% returns information structure about
% smoothing pdf
% 1st arg.: object
% 2nd arg.: current filtering info
% 3rd arg.: last predictive info
% 4th arg.: last smoothing info
%   

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% CHANGELOG