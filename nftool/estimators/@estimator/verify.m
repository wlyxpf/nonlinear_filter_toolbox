function res = verify(p,ferr)
% ESTIMATOR/VERIFY verify parameters ESTIMATOR
% ferr = 1 >>> error
% ferr = 0 >>> warning
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% suppose any error
res = 0;

% system must be from nlng
if ~isa(p.system,'nlng')
    error('nft2:estimator:nlga_saa','Only nlng systems are allowed');
    return
end

% OK
res = 1;

% CHANGELOG
