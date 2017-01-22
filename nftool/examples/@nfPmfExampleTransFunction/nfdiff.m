function [derivativeValue] = nfdiff(p,point,variables)
% nfPmfExampleTransFunction/nfdiff value of partial derivative of the nonlinear
%                      multivariate function along given parameters in
%                      defined point of state space
%
% p         ... object of the class nfPmfExampleTransFunction
% point     ... vector value at whitch is the derivative evaluated
% variables ... define which partial derivative is demanded

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if isempty(variables)
    error('There are no variables specifying the partial derivative');
end

if length(point)~=p.nvar
    error('The multivariate value at whitch is the derivative evaluated has incorrect dimension');
end

% f='[x1*x2+w1;x2+w2]'
% df/dx1 = '[x2;0]'
% df/dx2 = '[x1;1]'
% df/dw1 = '[1;0]'
% df/dw2 = '[0;1]'

derivative = [point(2) point(1) 1 0;0 1 0 1];

% look for variable which defines the partial derivative
[areVariablesListed,variablesIndex] = ismember(variables,p.parameters);

if sum(areVariablesListed) ~= length(variables)
    error('nft2:nfSymFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
end
    
% select columns resulting in partial derivative
derivativeValue = derivative(:,[variablesIndex]);


% CHANGELOG
