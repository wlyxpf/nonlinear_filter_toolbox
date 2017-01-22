function p = nfPredatorPreyModel
% nfnfPredatorPreyModel - nfPredatorPreyModel constructor
%
% The nfnfPredatorPreyModel defines folloving nonlinear multivariate function
%
%      | T*(1-a)*x1 + T*b*x1*x2 + w1 | 
%  f = |                             |
%      | T*(1+c)*x2 + T*d*x1*x2 + w2 |
%
%           | x1 |                  | w1 |
% where x = |    | is state and w = |    | noise
%           | x2 |                  | w2 |
%
% Constants are given as follows: 
%  T = 1
%  a = 0.04
%  b = c = d = 0.08

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

p.nffun = '[0.96*x1+0.08*x1*x2+w1;1.08*x2-0.08*x1*x2+w2]'; % for display method
p.mappingDimension=2;                   % dimension of the vector mapping
p.parameters = {'x1' 'x2' 'w1' 'w2'};       % list names of all variables
p.nvar = 4;                                 % specify number of variables
%--------------------------------------------------------------------------
% alternativelly it is possible to use generic naming as used e.g. by class
% nfLinFuctin i.e
%
%       p.parameters = {'state' 'noise'};
%       p.nvar = 4;
%
% This variant is advisable for high dimension functions. The choise must
% be used consistently within the class methods (nfdiff,nfeval,get,...)
%--------------------------------------------------------------------------

p.nu  = 0;         % dimension of input
p.nx  = 2;         % dimension of state
p.nxi = 2;         % dimension of noise

p.linear = { 0 0 1 1 };          % set index of linearity for all variables

% Create object as a child of object nfFunction
NFFUNCTION = nfFunction(p.nffun,p.mappingDimension,p.parameters,p.nvar,p.nu,p.nx,p.nxi,p.linear);
p = class(p,'nfPredatorPreyModel2',NFFUNCTION);
