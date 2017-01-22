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
        quantitiesFirst = varargin{2}; % get the names of quantities defining
                                       % the first partial derivatives

        if nargin == 4                        % if the quantities of first and
            quantitiesSecond = varargin{3};   % second partial derivatives differ
        else
            quantitiesSecond = quantitiesFirst; % if the names of first and
        end                                     % are the same

        if isempty(quantitiesFirst) || isempty(quantitiesSecond)
            error('nft2:nfPredatorPreyFunction:noDerivativeVariables','There are no variables specifying the partial derivative');
        end

        if length(point)~=p.nvar
            error('nft2:nfPredatorPreyFunction:wrongDimension','The multivariate value at whitch is the derivative evaluated has incorrect dimension');
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % determining and evaluation of the derivative
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numberOfFirstQuantities = length(quantitiesFirst);
        numberOfSecondQuantities = length(quantitiesSecond);

        % put together variable names and their dimensions in propper order
        parameters = {'input' 'state' 'noise';p.nu p.nx p.nxi};

        % look for variable which defines the partial derivative
        [areFirstQuantitiesListed,firstQuantitiesIndex] = ismember(quantitiesFirst,parameters(1,:));
        [areSecondQuantitiesListed,secondQuantitiesIndex] = ismember(quantitiesSecond,parameters(1,:));
        
        if (sum(areSecondQuantitiesListed) ~= numberOfSecondQuantities) || (sum(areFirstQuantitiesListed) ~= numberOfFirstQuantities)
            error('nft2:nfPredatorPreyFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
        end
        
        % determine the number of variables along which is proceeded the
        % first partial derivative
        numberOfFirstVariables = 0;
        for i = firstQuantitiesIndex
             numberOfFirstVariables = numberOfFirstVariables + parameters{2,i};
        end
        
        % determine the number of variables along which is proceeded the
        % second partial derivative
        numberOfSecondVariables = 0;
        for i = secondQuantitiesIndex
             numberOfSecondVariables = numberOfSecondVariables + parameters{2,i};
        end
        
        % prealocate the matrix holding the second partial derivative
        secondPartialDerivative = zeros(mappingDimension,...
            numberOfFirstVariables*numberOfSecondVariables);
        %------------------------------------------------------------------
        % fill in the nonzero elements of the second partial derivative
        %------------------------------------------------------------------
        matrixBlockBegin = 1;  % first block of second partial derivative 
                               % starts at the first column of the matrix
        for secondQuantity = 1:numberOfSecondQuantities
            for ithSecondVariable = 1:parameters{2,secondQuantitiesIndex(secondQuantity)}
                for firstQuantity = 1:numberOfFirstQuantities
                    % test for nonzero partial derivative blocks
                    if ( strcmp(parameters{1,firstQuantitiesIndex(firstQuantity)},'state')...
                            && ( strcmp(parameters{1,secondQuantitiesIndex(secondQuantity)},'state')...
                            &&  ithSecondVariable == 1))
                        % the partial derivative d^2f_x/dx_1, where
                        % f_x=[df/dx_1,df/dx_2]
                        secondPartialDerivative(:,matrixBlockBegin:matrixBlockBegin+1) = [0 0.08;0 -0.08];
                    end
                    
                    if (strcmp(parameters{1,firstQuantitiesIndex(firstQuantity)},'state')...
                            && ( strcmp(parameters{1,secondQuantitiesIndex(secondQuantity)},'state')...
                            &&  ithSecondVariable == 2))
                        % the partial derivative d^2f_x/dx_2, where
                        % f_x=[df/dx_1,df/dx_2]
                        secondPartialDerivative(:,matrixBlockBegin:matrixBlockBegin+1) = [0.08 0;-0.08 0];
                    end
                    % determine column where begins the next block for
                    % storing second partial derivative
                    matrixBlockBegin = matrixBlockBegin + parameters{2,firstQuantitiesIndex(firstQuantity)};
                end
            end
        end
        %------------------------------------------------------------------
    otherwise
        error('nft2:nfPredatorPreyFunction:wrongNumberOfArguments','Wrong number of input agruments of the method nfsecpad!');
end

% CHANGELOG
