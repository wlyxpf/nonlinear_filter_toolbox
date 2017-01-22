function [secondDerivativeValue] = nfsecpad(p,point,variables)
% nffunction/nfsecpad value of second partial derivative of the nonlinear 
%                      multivariate function along given parameters
%
% p         ... object of the class nffunction
% point     ... vector value at whitch is the derivative evaluated
% variables ... define which partial derivative is demanded

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


% FIXME: implement missing test of input arguments

%##########################################################################
% The nfsecpad method should do following operation:
%   1. check the argument "variables" and test whether it is meaningfull
%   2. check whether dimension op argument "point" corresponds to that of 
%      "variables"
%   3. select the right second partial derivative according "variables"
%   4. evaluate the second derivative considering that "variables" has 
%      the value given by "point"
%##########################################################################


secondPartialDerivative = [];

% CHANGELOG
