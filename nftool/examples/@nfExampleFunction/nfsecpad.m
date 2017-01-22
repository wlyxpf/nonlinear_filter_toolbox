function [secondPartialDerivative,p] = nfsecpad(p,varargin)
% nfExampleFunction/NFSECPAD - evaluate the second partial derivative along 
%    given parameters
%
%    [secondPartialDerivative,p] = nfsecpad(p,point,quantities)
%
%    Evaluates second partial derivative where point represents value
%    vector of the "hyperstate" given by state and noise quantities.
%    The point value is irrelevant because the second partial derivative is
%    allway zero matrix. The last parameter specifies quantities of both 
%    the first and second derivative along which is the vector mapping
%    differentiated.
%
%    [secondPartialDerivative,p] = nfsecpad(p,point,quantitiesFirst,quantitiesSecond)
%
%    Evaluates second partial derivative where point represents value
%    vector of the "hyperstate" given by state and noise quantities.
%    The point value is irrelevant because the second partial derivative is
%    allway zero matrix. The last two parameters specify quantities of both
%    the first and second derivative along which is the vector mapping
%    differentiated. The quantitiesFirst specify the first partial 
%    derivative quantities and the quantitiesSecond then the quantities
%    along which are the first partial derivatives differentiated.
%
%    [secondPartialDerivative,p] = nfsecpad(p) 
%    
%    This call does nothing, it is implemented only for compatibility
%    reasons. This call should implement the initialization of the second
%    derivative. However, the second derivative of linear vector mapping is
%    allways zero matrix.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        secondPartialDerivative=[];
    case {3,4}
        mappingDimension  = p.mappingDimension;  % get dimension of the vector mapping

        point = varargin{1};           % get the value of the hyperstate vector
        variablesFirst = varargin{2};  % get the names of quantities defining
                                       % the first partial derivatives

        if nargin == 4                        % if the quantities of first and
            variablesSecond = varargin{3};    % second partial derivatives differ
        else
            variablesSecond = variablesFirst; % if the names of first and
        end                                   % are the same

        if isempty(variablesFirst) || isempty(variablesSecond)
            error('nft2:nfExampleFunction:noDerivativeVariables','There are no variables specifying the partial derivative');
        end

        if length(point)~=p.nvar
            error('nft2:nfExampleFunction:wrongDimension','The multivariate value at whitch is the derivative evaluated has incorrect dimension');
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % determining and evaluation of the derivative
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numberOfFirstVariables = length(variablesFirst);
        numberOfSecondVariables = length(variablesSecond);

        % look for variable which defines the partial derivative
        [areFirstVariablesListed,firstVariablesIndex] = ismember(variablesFirst,p.parameters);
        [areSecondVariablesListed,secondVariablesIndex] = ismember(variablesSecond,p.parameters);
        
        if (sum(areSecondVariablesListed) ~= numberOfSecondVariables) || (sum(areFirstVariablesListed) ~= numberOfFirstVariables)
            error('nft2:nfExampleFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
        end
        
        secondPartialDerivative = zeros(mappingDimension,...
            numberOfFirstVariables*numberOfSecondVariables);
        
        %------------------------------------------------------------------
        % The second derivative has nonzero values only on these second
        % partial derivatives:
        %    d^2f_1/dx_1dx_1 = 2x_2
        %    d^2f_1/dx_1dx_2 = 2x_1
        %    d^2f_1/dx_2dx_1 = 2x_1
        %------------------------------------------------------------------
        matrixColumnBegin = 1; % first column of second partial derivative 
                               % starts at the first column of the matrix
        for secondQuantity = 1:numberOfSecondVariables
            for firstQuantity = 1:numberOfFirstVariables
                if ( firstVariablesIndex(firstQuantity) == 1 && secondVariablesIndex(secondQuantity) == 1 )
                    secondPartialDerivative(1,matrixColumnBegin)=2*point(2);
                end;
                if ( firstVariablesIndex(firstQuantity) == 1 && secondVariablesIndex(secondQuantity) == 2 ) || ...
                        ( firstVariablesIndex(firstQuantity) == 2 && secondVariablesIndex(secondQuantity) == 1 )
                    secondPartialDerivative(1,matrixColumnBegin)=2*point(1);
                end;
                matrixColumnBegin = matrixColumnBegin + 1;
            end
        end
        %------------------------------------------------------------------

    otherwise
        error('nft2:nfExampleFunction:wrongNumberOfArguments','Wrong number of input agruments of the method nfsecpad!');
end

% CHANGELOG
