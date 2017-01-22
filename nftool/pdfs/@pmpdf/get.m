function val = get(pmpdf,parameter)
% PMPDF/GET
%
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch parameter

    case 'mass'      % point masses for axis grids (distances of points)
        val = pmpdf.mass;

    case 'grmass'    % volume mass of the grid
        val = prod(pmpdf.mass);

    case 'ngpts'     % number of individual axis grid points
        val = pmpdf.ngpts;

    case 'grngpts'   % total number of axis grid points
        val = prod(pmpdf.ngpts);

    case 'values'    % pdf values
        val = pmpdf.values;

    case 'axisgrids' % axis grids
        val = axisgrids(pmpdf);

    case 'T'         % floating grid transformation matrix
        val = pmpdf.floatgrid.T;

    case 'center'    % floating grid center
        val = pmpdf.floatgrid.center;

    case 'gridpts'   % grid points ("vector" grid structure)
        val = gridpts(pmpdf);

    case 'mean'      % mean value
        val = mean(pmpdf);

    case 'var'       % variance/covariance matrix
        val = var(pmpdf);

    case 'ObjectParameters'
        val = {'dim';'mass';'grmass';'ngpts';'grngpts';'values';'axisgrids';'T';'center';'gridpts';'mean';'var'};

    otherwise
        val = get(pmpdf.general_pdf,parameter);
        %error([parameter, ' is not valid parameter name!']);

end

