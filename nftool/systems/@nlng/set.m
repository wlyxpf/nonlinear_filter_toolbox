function p = set(p,varargin)
% NLNG/SET Set nlng properties and return the updated object
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case 'f'
            p.f = val;
        case 'h'
            p.h = val;
        case 'u'
            p.u = val;
        case 'x'
            p.x = val;
        case 'w'
            p.w = val;
        case 'v'
            p.v = val;
        case 'pw'
            p.pw = val;
        case 'pv'
            p.pv = val;
        case 'px0'
            p.px0 = val;
        case 'nu'
            p.nu = val;
        case 'nx'
            p.nx = val;
        case 'nw'
            p.nw = val;
        case 'nv'
            p.nv = val;
        case 'currentState'
            p.currentState = val;
        otherwise
            error([prop,' Is not a valid property'])
    end
end

% CHANGELOG
