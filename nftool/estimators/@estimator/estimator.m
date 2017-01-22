function p = estimator(varargin)
% ESTIMATOR - constructor of the clas ESTIMATOR
% FUNCTION P = ESTIMATOR(SYSTEM,TIME,PX0)
% creates an object of the estimator class
% SYSTEM - object of the systems class
% (nlng, nlnga, lnga, nlga, lga, ...)
% TIME - specifies action:
%   0 - filtering
%   n - n-step ahead prediction
%  -n - fixed n lag smoothing
% PX0 - init px0

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch nargin
    case 1
        % if single argument of class estimator, return it
        if isa(varargin{1},'estimator')
            p = varargin{1};
        else
            error('nft2:estimator:ia_n_est','Input argument is not an estimator object');
        end
    case {2,3}
        % specification of general estimator

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        p.system = varargin{1};       % system
        p.lag = varargin{2};          % lag

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % verify nlng class
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isa(p.system,'nlng')
            error('nft2:estimator:nlga_saa','Only nlng systems are allowed');
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        p.time = 0;                   % init of time

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % init px0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if nargin == 2
            p.px0 = get(p.system,'px0');
        else
            p.px0 = varargin{3};
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % different structure for operations of estimator
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        switch sign(p.lag)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % filtring
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 0
                % filtering
                p.pipe = container(1);
                p.result = struct([]);
                p.pipe = insert(p.pipe,p.px0);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % prediction
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 1
                % prediction
                p.pipe = container(1);
                p.result = struct([]);
                p.pipe = insert(p.pipe,p.px0);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % smoothing
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case -1
                % smoothing
                p.pipe = container(abs(p.lag)*2+1);
                p.result = struct([]);
                p.pipe = insert(p.pipe,p.px0);

            otherwise
                disp('Unknown typ of estimation')
        end

        p = class(p,'estimator');

    otherwise
        error('nft2:estimator:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
