function val = get(p,prop_name)
% NLNG/GET Get nlng properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop_name
    case 'f'
        val = p.f;
    case 'h'
        val = p.h;
    case 'u'
        val = p.u;
    case 'x'
        val = p.x;
    case 'w'
        val = p.w;
    case 'v'
        val = p.v;
    case 'pw'
        val = p.pw;
    case 'pv'
        val = p.pv;
    case 'px0'
        val = p.px0;
    case 'nu'
        val = p.nu;
    case 'nx'
        val = p.nx;
    case 'nw'
        val = p.nw;
    case 'nv'
        val = p.nv;
    case 'currentState'
        val = p.currentState;
    otherwise
        error([prop_name,' Is not a valid property'])
end

% CHANGELOG
