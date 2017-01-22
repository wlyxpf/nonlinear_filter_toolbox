function p = nfPmfExampleMeasFunction()
% nfPmfExampleMeasFunction - nfPmfExampleMeasFunction constructor
%
% The nfPmfExampleMeasFunctiondefines folloving nonlinear multivariate function
%
%                               | x1 |
%  h = | 0.2*x1^2+v | where x = |    | is state and v noise
%                               | x2 |
%
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

p.nffun = '[0.2*x1^2*x2+v]';         % necessary for display method
p.mappingDimension=1;                % dimension of the vector mapping
p.parameters = {'x1' 'x2' 'v'};      % list names of all variables
p.nvar = 3;                          % specify number of variables
%--------------------------------------------------------------------------
% alternativelly it is possible to use generic naming as used e.g. by class
% nfLinFuctin i.e
%
%       p.parameters = {'state' 'noise'};
%       p.nvar = 3;
%
% This variant is advisable for high dimension functions. The choise must
% be used consistently within the class methods (nfdiff,nfeval,get,...)
%--------------------------------------------------------------------------

p.nu  = 0;         % dimension of input
p.nx  = 2;         % dimension of state
p.nxi = 1;         % dimension of noise

p.linear = { 0 1 1 1 };          % set index of linearity for all variables

% Create object as a child of object nfFunction
NFFUNCTION = nfFunction(p.nffun,p.mappingDimension,p.parameters,p.nvar,p.nu,p.nx,p.nxi,p.linear);
p = class(p,'nfPmfExampleMeasFunction',NFFUNCTION);
