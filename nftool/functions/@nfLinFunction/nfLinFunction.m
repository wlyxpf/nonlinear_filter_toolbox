function p = nfLinFunction(varargin)
% nfLinFunction - nfLinFunction constructor
%
% The nfSymFunction is supposed in form f=A*x+B*u+Gamma*xi)
%         where - x denotes multivariate state
%                 u denotes multivariate input/control
%                 xi denotes multivariate noise
%                 A,B,Gamma are matrices with corresponding dimensions
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 0
        warning('nft2:nfLinFunction:not_enough_params','Not enough input parameters!');
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument should be object of class nffunction
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'nfLinFunction')
            p = varargin{1};
        else
            error('Input argument is not a nfLinFunction object');
        end
    case {3,6}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1st arg: State gain matrix A
        % 2nd arg: Input gain matrix B
        % 3th arg: Noise gain matrix Gamma
        % ======================   optional parameters ====================
        % 4th arg: list of state variables (comma separated)
        % 5th arg: list of input variables (comma separated)
        % 6th arg: list of noise variables (comma separated)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Test whether input matrices have propper dimensionality
        if ~( (ndims(varargin{1})==2) && (ndims(varargin{2})==2) && ...
                (ndims(varargin{3})==2) )
            error('Improper dimension of matrix');
        end

        %==================================================================
        % Analyze and store the parameters of the system
        %
        % FIXME: Test whether the matrix dimension are meaningful!!
        %==================================================================
        tmp_papameters = {};
        tmp_parametersValue = [];

        if nargin==6
            p.realVariableNames = true;
        else
            p.realVariableNames = false;
        end

        % as first is stored the input gain matrix
        [row_dim,col_dim]=size(varargin{2});

        p.nu = col_dim;
        if col_dim~=0
            tmp_parametersValue = [ tmp_parametersValue, varargin{2} ];
            if nargin==6
                tmp_papameters = [ tmp_papameters, all_vars(varargin{4})];
            else % if the variables are not specified use generic name
                tmp_papameters = [ tmp_papameters, {'input'}];
            end
        end

        % as second one is stored the state gain matrix
        [row_dim,col_dim]=size(varargin{1});

        p.nx = col_dim;
        %==================================================================
        % FIXME: This works only when the state appears in the mapping!!
        %        There is needed further testing of validity and sanity 
        %        of the mapping specified by the varargins!!!!
        %==================================================================
        p.mappingDimension = row_dim; 
        
        if col_dim~=0
            tmp_parametersValue = [ tmp_parametersValue, varargin{1} ];
            if nargin==6
                tmp_papameters = [ tmp_papameters, all_vars(varargin{5})];
            else % if the variables are not specified use generic name
                tmp_papameters = [ tmp_papameters, {'state'} ];
            end
        end

        

        % as last store the noise gain matrix
        [row_dim,col_dim]=size(varargin{3});

        p.nxi = col_dim;
        if col_dim~=0
            tmp_parametersValue = [ tmp_parametersValue, varargin{3} ];
            if nargin==6
                tmp_papameters = [ tmp_papameters, all_vars(varargin{6})];
            else % if the variables are not specified use generic name
                tmp_papameters = [ tmp_papameters, {'noise'}];
            end
        end
        
        %==================================================================

        p.parametersValue = tmp_parametersValue; % store the matrices
                                                 % as atribute of the class
        p.parameters = tmp_papameters;  % store names of variables
        p.nvar = p.nx + p.nu + p.nxi;   % number of variables = number
                                        % of partial derivatives

        p.nffun = 'A*x + B*u + Gamma*xi';
        %==================================================================

        % Create object as a child of object nfFunction
        NFFUNCTION = nfFunction(p.nffun,p.mappingDimension,p.parameters,p.nvar,p.nu,p.nx,p.nxi,[]);

        p = class(p,'nfLinFunction',NFFUNCTION);
    otherwise
        error('Wrong number of input arguments');
end
