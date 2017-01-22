function p = pmpdf(varargin)
% PMPDF - point-mass pdf
%
% P = PMPDF()
%     creates an object edf with a single grid point 0 and pdf value 1
% P = PMPDF(E) E must be an object of the pmpdf class
%     creates an object equal to E
% P = PMPDF(M,D,V,T,C) M is 1xN array of axis grid masses, i.e. distances of
%                        neighboring grid points in each coordinate (N is
%                        system dimension)
%                      D is 1xN array of numbers of axis grid points
%                      V is 1xprod(D) array of pdf values at grid points
%                      T is NxN transformation matrix defining the rotation
%                        of the grid in the state space (optional-default
%                        identity matrix)
%                      C is Nx1 center point of the grid (optional-default
%                        zero vector)
%     creates an pmpdf object with the specified parameters
% P = PMPDF(PS) PS must be a structure containing pdf parameters
%                  corresponding to the previous case
%               PS.mass   ~ M
%               PS.ngpts  ~ D
%               PS.values ~ V
%               PS.floatgrid.T      ~ T (optional-default identity matrix)
%               PS.floatgrid.center ~ C (optional-default zero vector)
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin

    case 0
        % if no input arguments, create a default object
        p.mass   = 0;                           % default setting
        p.ngpts  = 1;                           % default setting
        p.values = 1;                           % default setting
        p.floatgrid.T = 1;                      % default setting
        p.floatgrid.center = 0;                 % default setting
        p = class(p,'pmpdf',general_pdf);       % creates an object pmpdf
        p = set(p,'dim',1);                     % set dimension of random variable
        verifypdf = false;

    case 1
        if isa(varargin{1},'pmpdf')
            % if single argument of class pmpdf, return it
            p = varargin{1};
            verifypdf = false;
        elseif isstruct(varargin{1})
            % if single argument of structure compatible with pmpdf class,
            % create the object
            p = varargin{1};
            verifypdf = true;
        else
            error('nft2:pmpdf:mb_pmpdf','Must be an object of the pmpdf class or a compatible structure');
        end

    case {2,4}
        error('nft2:pmpdf:wn_ia','Wrong number of input arguments')

    case {3,5}
        % create object using specified arguments
        p.mass   = varargin{1};
        p.ngpts  = varargin{2};
        p.values = varargin{3};
        if nargin == 5
            p.floatgrid.T = varargin{4};
            p.floatgrid.center = varargin{5};
        end
        verifypdf = true;

    otherwise
        % error - too many input argumets
        error('nft2:pmpdf:too_m_a','Too many arguments');

end %switch nargin

if verifypdf
    % Verify the fields mass (axis grid mass), ngpts (number of axis grid
    % points) and values (pdf values)
    if ~isfield(p,'mass')   || ~isnumeric(p.mass)   || any(p.mass<0)   || ...
            ~isfield(p,'ngpts')  || ~isnumeric(p.ngpts)  || any(p.ngpts<=0) || (length(p.ngpts)~=length(p.mass)) || ...
            ~isfield(p,'values') || ~isnumeric(p.values) || any(p.values<0) || (length(p.values)~=prod(p.ngpts))
        error('nft2:pmpdf:mb_pmpdf','Must be an object of the pmpdf class or a compatible structure');
    end
    N = length(p.mass);
    % Verify floating grid parameters T (transformation matrix) and center
    % (grid center)
    if isfield(p,'floatgrid')
        % The pdf structure already contains the floatgrid sub-structure -
        % perform its verification
        if ~isfield(p.floatgrid,'T') || ~isnumeric(p.floatgrid.T) || any(size(p.floatgrid.T) ~=N ) || ...
                ~isfield(p.floatgrid,'center') || ~isnumeric(p.floatgrid.center) || (length(p.floatgrid.center) ~= N)
            error('nft2:pmpdf:mb_pmpdf','Must be an object of the pmpdf class or a compatible structure');
        else
            p.floatgrid.center = p.floatgrid.center(:);
        end
    else
        % The pdf structure does not contain the floatgrid sub-structure
        % but it may contain the floating grid parameters T and center
        if isfield(p,'T') && isnumeric(p.T) && all(size(p.T)==N)
            % The transformation matrix parameter exists
            p.floatgrid.T = p.T;
        else
            % Default setting of the transformation matrix
            p.floatgrid.T = eye(N);
        end
        if isfield(p,'T'), p = rmfield(p,'T'); end
        if isfield(p,'center') && isnumeric(p.center) && (length(p.center) == N)
            % The grid center parameter exists
            p.floatgrid.center = p.center(:);
        else
            % Default setting of the grid center
            p.floatgrid.center = zeros(N,1);
        end
        if isfield(p,'center'), p = rmfield(p,'center'); end
    end
    % Normalize pdf values
    p.values = p.values / (sum(p.values)*prod(p.mass));

    p = class(p,'pmpdf',general_pdf);          % create a pmpdf object
    p = set(p,'dim',N); % set dimension of random variable
    %verify(p);
end

% CHANGELOG