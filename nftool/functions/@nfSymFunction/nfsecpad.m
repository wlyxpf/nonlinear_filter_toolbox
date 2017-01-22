function [secondPartialDerivative,p] = nfsecpad(p,varargin)
% nfSymFunction/NFSECPAD - evaluate the second partial derivative along 
%    given parameters
%
%    [secondPartialDerivative,p] = nfsecpad(p) 
%
%    initializes the data structure holding the second derivative of the
%    vector mapping along all quantities. The differentiated vector mapping 
%    is defined by the parameter p which has to be and object of the 
%    nfSymFunction class In order the initialization is done only once for 
%    the nfSymFunction object assign the second output parameter nfFunction
%    to the original nfSymFunction object.
%
%    [secondPartialDerivative,p] = nfsecpad(p,point,quantities)
%
%    evaluates second partial derivative where point represents value
%    vector of the "hyperstate" given by input, state and noise quantities.
%    The last parameter specifies quantities of both the first and second
%    derivative along which is the vector mapping differentiated.
%
%    [secondPartialDerivative,p] = nfsecpad(p,point,quantitiesFirst,quantitiesSecond)
%
%    evaluates second partial derivative where point represents value
%    vector of the "hyperstate" given by input, state and noise quantities.
%    The last two parameters specify quantities of both the first and second
%    derivative along which is the vector mapping differentiated. The
%    quantitiesFirst specify the first partial derivative quantities and
%    the quantitiesSecond then the quantities along which are the first
%    partial derivatives differentiated.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        p = initializeSecondPartialDerivative(p);
        secondPartialDerivative=[];
    case {3,4}
        %------------------------------------------------------------------
        % If the data structure holding the second partial derivative along
        % all quanties defined in the vector is empty fill it
        %------------------------------------------------------------------
        if isempty(p.secondDerivative)         
            p = initializeSecondPartialDerivative(p);
        end;
        %------------------------------------------------------------------

        nvars = p.nvar;                          % get the number of the variables
        mappingDimension  = p.mappingDimension;  % get dimension of the vector mapping

        point = varargin{1};           % get the value of the hyperstate vector
        variablesFirst = varargin{2};  % get the names of quantities defining
                                       % the first partial derivatives

        if nargin == 4                        % if the quantities of first and
            variablesSecond =varargin{3};     % second partial derivatives differ
        else
            variablesSecond = variablesFirst; % if the names of first and
        end                                   % are the same

        if isempty(variablesFirst) || isempty(variablesSecond)
            error('nft2:nfSymFunction:noDerivativeVariables','There are no variables specifying the partial derivative');
        end

        if length(point)~=p.nvar
            error('nft2:nfSymFunction:wrongDimension','The multivariate value at whitch is the derivative evaluated has incorrect dimension');
        end

        %------------------------------------------------------------------
        % replacing quantities with their values
        %------------------------------------------------------------------
        for i = 1:nvars
            % convert value assigning into variable to string
            expr = [p.parameters{i},'= point(i);'];
            % evaluate the string, i.e. define value of variable named as content
            % of the p.parameters{i} cell
            eval(expr);
        end
        %------------------------------------------------------------------

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % determining and evaluation of the derivative
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        numberOfFirstVariables = length(variablesFirst);
        numberOfSecondVariables = length(variablesSecond);

        % look for variable which defines the partial derivative
        [areFirstVariablesListed,firstVariablesIndex] = ismember(variablesFirst,p.parameters);
        [areSecondVariablesListed,secondVariablesIndex] = ismember(variablesSecond,p.parameters);

        if (sum(areSecondVariablesListed) ~= numberOfSecondVariables) || (sum(areFirstVariablesListed) ~= numberOfFirstVariables)
            error('nft2:nfSymFunction:unknownVariable','There was an unknown variable in the specification of the derivative');
        end
      
        secondPartialDerivative = zeros(mappingDimension,...
            numberOfFirstVariables*numberOfSecondVariables);
        %------------------------------------------------------------------
        % Evaluation of all the columns of the second partial derivative in
        % specified point of the hyperstate
        %------------------------------------------------------------------
        matrixColumnBegin = 1; % first column of second partial derivative 
                               % starts at the first column of the matrix
        for secondQuantity = 1:numberOfSecondVariables
            for firstQuantity = 1:numberOfFirstVariables
                secondPartialDerivative(:,matrixColumnBegin) = eval(p.secondDerivative{firstVariablesIndex(firstQuantity),secondVariablesIndex(secondQuantity)});
                matrixColumnBegin = matrixColumnBegin + 1;
            end
        end
        %------------------------------------------------------------------        
    otherwise
        error('nft2:nfSymFunction:wrongNumberOfArguments','Wrong number of input agruments of the method nfsecpad!');
end


% CHANGELOG
