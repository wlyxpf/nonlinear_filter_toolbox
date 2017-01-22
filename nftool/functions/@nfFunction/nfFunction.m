function p = nfFunction(varargin)
% nffunction - class contructor of the general nonlinear multivariate
%              function
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument should be object of class nffunction
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'nfFunction')
            p = varargin{1};
        else
            error('Input argument is not a nFfunction object');
        end

    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % in case there is no argument create default object
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % FIXME: check whether atributes type and value are correct!!!

        p.nffun = '';                % string representing the function
        p.parameters = [''];         % this atribute stores variables occuring
                                     % in function

        p.nvar = [0];                % number of variables
        p.linear{1} = [1];           % appriori suppose the multivariate
                                     % function as linear

        p = class(p,'nfFunction');
    case 8
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % in case there all the object atributes are known
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        p.nffun = varargin{1};       % string representing the function
        p.mappingDimension = varargin{2}; % dimension of the vector mapping
        p.parameters = varargin{3};  % this atribute stores variables occuring
                                     % in function
        p.nvar = varargin{4};        % number of variables
        p.nu = varargin{5};          % dimension of input
        p.nx = varargin{6};          % dimension of state
        p.nxi = varargin{7};         % dimension of noise
        p.linear = varargin{8};      % linearity index

        p = class(p,'nfFunction');


    otherwise
        error('Wrong number of input arguments');
end

% CHANGELOG
