function p = extkalman(varargin)
% @EXTKALMAN - extanded kalman filter
% input parameters
%  #1 system
%  #2 lag
%  #3 px0
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        % if single argument of class nlng, return it
        if isa(varargin{1},'extkalman')
            p = varargin{1};
        else
            error('nft2:extkalman:ia_n_ekal','Input argument is not an extkalman object');
        end
    case {2,3}
        % specification of extended kalman filter
        system   = varargin{1};             % get the estimated system

        pw       = gspdf(get(system,'pw')); % get state noise pdf
        pv       = gspdf(get(system,'pv')); % get measurement noise pdf

        p.pwmean = pw.mean;                 % get mean of noise w
        p.pvmean = pv.mean;                 % get mean of noise v

        p.Q    = pw.var;                    % get variance of noise w
        p.R    = pv.var;                    % get variance of noise v

        p.x    = system.x;  % get variable names defining the state
        p.nw   = system.nw; % get variable names defining the state noise
        p.nv   = system.nv; % get variable names defining the measurement noise

        p.f    = system.f;  % get the transitional multivariate function
        p.h    = system.h;  % get the measurement multivariate function

        p.nu   = system.nu;  % get dimension of the input

        p.delta  = get(system,'delta');     % the Delta matrix of system
        p.gamma  = get(system,'gamma');     % the Gamma matrix of system

        % interites from ESTIMATOR
        if nargin == 2
            ESTIMATOR = estimator(varargin{1},varargin{2});
        else
            ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
        end

        p = class(p,'extkalman',ESTIMATOR);

        % verify nlga class
        if ~isa(get(p,'system'),'nlga')
            error('nft2:extkalman:only_nlga','Only NLGA systems are allowed');
        end

    otherwise
        error('nft2:extkalman:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
