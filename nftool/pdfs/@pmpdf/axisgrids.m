function axgrids = axisgrids(p)
% AXISGRIDS returns the cell array containing axis grids of the point-mass
%   pdf.

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

mass  = p.mass;
ngpts = p.ngpts;

dimension = get(p,'dim');
axgrids = cell(dimension,1);

for l = 1:dimension
    axgrids{l,1} = mass(l) * ([1:ngpts(l)] - (ngpts(l)+1)/2);
end