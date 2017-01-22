function vgrid = gridpts(pmpdf)
% GRIDPTS creates grid points from the given pdf.
%   The grid points are created by the cartesian product of axis grids and
%   transformation according to the floating grid parameters. The grid
%   points are stored as column vectors in an array structure; i.e. the
%   resulting structure is an n-by-N matrix where n is system dimension and
%   N is total number of grid points.

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

vgrid = pmpdf.floatgrid.T * cartprod(axisgrids(pmpdf)) + repmat(pmpdf.floatgrid.center,1,prod(pmpdf.ngpts));