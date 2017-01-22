function [derivativeValue] = nfdiff(p,point,variables)
% nffunction/nfdiff value of partial derivative of the nonlinear 
%                   multivariate function along given parameters
%
% p         ... object of the class nffunction
% point     ... vector value at whitch is the derivative evaluated
% variables ... define which partial derivative is demanded

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen



%##########################################################################
% The nfdiff method should do following operation:
%   1. check the argument "variables" and test whether it is meaningfull
%   2. check whether dimension op argument "point" corresponds to that of 
%      "variables"
%   3. select the right partial derivative according "variables"
%   4. evaluate the derivative considering that "variables" has the value
%      given by "point"
%##########################################################################


derivativeValue = [];

% CHANGELOG
