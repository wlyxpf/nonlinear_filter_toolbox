function p = pmf(varargin)
% @pmf - filter with point mass method
% input parameters
%  #1 system
%  #2 lag
%  #3 fixed number of grid points
%  #4 parameter a
%  #5 parameter gamma
%  #6 parameter epsilon

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch nargin

    case 1
        if isa(varargin{1},'pmf')
            p = varargin{1};
        elseif isa(varargin{1},'nlnga')
            ESTIMATOR = estimator(varargin{1},0); % filtering is default
            p = class(struct([]),'pmf',ESTIMATOR);         % create object
        else
            error('nft2:pmf:ia_n_pmf''Input argument is not an pmf object');
        end

    otherwise
        % system specification
        if isa(varargin{1},'nlnga')
            system = varargin{1};
        else
            error('nft2:pmf:ia_n_nlnga','Input argument is not a nlnga object');
        end
        % time lag
        if isnumeric(varargin{2})
            lag = varargin{2};
        else
            lag = 0; % filtering is default
        end
        % initial pdf
        if isa(varargin{2},'general_pdf')
            px0 = varargin{2};
        elseif (nargin > 2) && isa(varargin{3},'general_pdf')
            px0 = varargin{3};
        else
            px0 = get(system,'px0');
        end

        % Extracting other parameters
        % Parameters are specified similarly to property specification,
        % e.g. pm = pmf(sys,0,'epsilon',1e-6,'gamma',1/2).
        % Parameters which are not specified are assigned default values.
        parameters = struct('fixedNGPTS', [], 'epsilon', [], 'a', [], 'b', [], 'gamma', [], 'c', [], 'ThriftyConvolution', '');
        cellarray = {};
        indset    = [];
        % collect all explicitly specified parameters
        for i = 2:length(varargin)
            if ischar(varargin{i})
                cellarray{end+1,1} = varargin{i};
                indset(end+1,1)    = i;
            end
        end
        param_names = fieldnames(parameters);
        for i = 1:length(param_names)
            I = strmatch(param_names{i},cellarray,'exact');
            if ~isempty(I) % parameter name found among the arguments
                parameters.(param_names{i}) = varargin{indset(I(1))+1};
            end
        end
        p.parameters = defaultParams(parameters);  % assign default values to parameters that are not specified explicitly

        if isa(px0,'pmpdf')
            ESTIMATOR = estimator(system,lag,px0);
        else
            px0pm = agd( px0,system,p.parameters ); % Grid design by anticipative approach
            px0pm = set( px0pm, 'values', evaluate(px0,px0pm.gridpts) );  % Assign pdf values
            ESTIMATOR = estimator(system,lag,px0pm);
        end


        p = class(p,'pmf',ESTIMATOR); % create object

end


%**************************************************************************

