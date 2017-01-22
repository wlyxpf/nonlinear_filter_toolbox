function [derivativeValue] = nfdiff(p,point,variables)
% nfLinFunction/nfdiff value of partial derivative of the linear
%                      multivariate function along given parameters in
%                      defined point of state space
%
% p         ... object of the class nfLinFunction
% point     ... vector value at whitch is the derivative evaluated
% variables ... define which partial derivative is demanded

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if isempty(variables)
    error('nft2:nfLinFunction:noDerivativeVariables','There are no variables specifying the partial derivative');
end

if length(point)~=p.nvar
    error('nft2:nfLinFunction:wrongDimension','The multivariate value at whitch is the derivative evaluated has incorrect dimension');
end

if p.realVariableNames
    % look for variable which defines the partial derivative
    [areVariablesListed,variablesIndex] = ismember(variables, p.parameters);
    
    if sum(areVariablesListed) ~= length(variables)
       error('nft2:nflinFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
    end

    % select columns resulting in partial derivative
    derivative = p.parametersValue(:,[variablesIndex]);

else % Following algorithm looks horribly complicated, however, it makes
    % it possible to get arbitrary partial derivative in case only general
    % names of variables (i.e. 'input' 'state' and 'noise' ) are used

    % put together variable names and their dimensions in propper order
    parameters = {'input' 'state' 'noise';0 p.nu p.nu+p.nx;...
        p.nu p.nu+p.nx (p.nu+p.nx)+p.nxi};

    % look for variable which defines the partial derivative
    [areVariablesListed,variablesIndex] = ismember(variables,parameters(1,:));

    if sum(areVariablesListed) ~= length(variables)
        error('nft2:nfSymFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
    end
    
    derivative = [];     % Initialize the matrix that will contain derivative

    for variable = 1:length(variables)
        firstColumnIndex = parameters{2,variablesIndex(variable)}+1;
        lastColumnIndex  = parameters{3,variablesIndex(variable)};

        % add to the partial derivative contribution corresponding to
        % current variable
        derivative =[ derivative ...
            p.parametersValue(:,firstColumnIndex:lastColumnIndex) ];
    end
end

derivativeValue = derivative;

% CHANGELOG
