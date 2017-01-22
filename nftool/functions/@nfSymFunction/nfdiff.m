function [val] = nfdiff(p,point,variables)
% nfSymFunction/nfdiff value of partial derivative of the nonlinear
%                      multivariate function with respect to given 
%                      parameters in defined point of state space
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% FIXME: implement missing test of input arguments

if isempty(variables)
    error('nft2:nfSymFunction:noDerivativeVariables','There are no variables specifying the partial derivative');
end

if length(point)~=p.nvar
    error('nft2:nfSymFunction:noDerivativeVariables','The multivariate value at whitch is the derivative evaluated has incorrect dimension');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filling all the variables with values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:p.nvar                           % cycle trought all variables
    expr = [p.parameters{i},'= point(i);'];% coverting assigning expression
    % to string
    eval(expr);                            % evaluation of the expresion
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determining and evaluation of the derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numberOfVariables = length(variables);
subval = zeros(p.mappingDimension,numberOfVariables);

for i = 1:numberOfVariables
    % look for variable which defines the partial derivative
    derivative_variable = 1;
    while ~strcmp(p.parameters{derivative_variable},variables{i})
        derivative_variable = derivative_variable + 1;
        if derivative_variable > p.nvar
            error('nft2:nfSymFunction:incorrectVariableSpecification','Incorrect variable specification');
        end
    end

    % evaluation of the derivative
    %if p.nf2 == 1
        subval(:,i) = eval(p.derivative{derivative_variable});
    %else
    %    subval(i,:) = eval(p.derivative{derivative_variable});
    %end
end

val = subval;
% CHANGELOG
