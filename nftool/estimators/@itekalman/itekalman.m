function p = itekalman(varargin)
% @ITEKALMAN - iterative extanded kalman filter
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
        if isa(varargin{1},'itekalman')
            p = varargin{1};
        else
            error('nft2:itekalman:ia_n_ikal','Input argument is not an itekalman object');
        end
    case {2,3}
        % specification of iterative extended kalman filter

        % interites from ESTIMATOR
        if nargin == 2
            EXTKALMAN = extkalman(varargin{1},varargin{2});
        else
            EXTKALMAN = extkalman(varargin{1},varargin{2},varargin{3});
        end

        p.epsilon = 0.00001;

        p = class(p,'itekalman',EXTKALMAN);

        % verify lga class
        if ~isa(get(p,'system'),'nlga')
            error('nft2:itekalman:only_nlnga','Only NLNGA systems are allowed');
        end

    otherwise
        error('nft2:itekalman:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
