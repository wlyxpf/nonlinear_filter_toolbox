function val = subsref(p,prop)
% NLNG/SUBSREF nlng
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:nlng:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'f'
                val = p.f;               % transition function
            case 'h'
                val = p.h;               % measurement function
            case 'u'
                val = p.u;               % system input
            case 'x'
                val = p.x;               % system state
            case 'w'
                val = p.w;               % state noise
            case 'v'
                val = p.v;               % measurement noise
            case 'pw'
                val = p.pw;              % state noise density object
            case 'pv'
                val = p.pv;              % measurement noise density object
            case 'px0'
                val = p.px0;             % initial state density object
            case 'nx'
                val = p.nx;              % state dimension
            case 'nu'
                val = p.nu;              % input dimension
            case 'nw'
                val = p.nw;              % state noise dimension
            case 'nv'
                val = p.nv;              % measurement noise dimension
            case 'nx'
                val = p.nx;              % state dimension
            case 'currentState'
                val = p.currentState;    % current state
            otherwise
                error('nft2:nlng:ind_oor','Index out of range');
        end;
    case '{}'
        error('nft2:nlng:not_imp','Not implemented!');
end

% CHANGELOG
