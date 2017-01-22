function axgrid = axisgrid(p,dimension)
% AXISGRID returns the axis grid of the point-mass pdf in the specified
%   dimension.

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

N = p.ngpts(dimension);
axgrid = p.mass(dimension) * ([1:N] - (N+1)/2);