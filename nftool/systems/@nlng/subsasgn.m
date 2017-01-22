function p = subsasgn(p,prop,val)
% NLNG/SUBSASGN nlng
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
                p.f = val;              % transition function
            case 'h'
                p.h = val;               % measurement function
            case 'u'
                p.u = val;               % system input
            case 'x'
                p.x = val;               % system state
            case 'w'
                p.w = val;               % state noise
            case 'v'
                p.v = val;               % measurement noise
            case 'pw'
                p.pw = val;              % state noise density object
            case 'pv'
                p.pv = val;              % measurement noise density object
            case 'px0'
                p.px0 = val;             % initial state density object
            case 'nx'
                p.nx = val;              % state dimension
            case 'nu'
                p.nu = val;              % input dimension
            case 'nw'
                p.nw = val;              % state noise dimension
            case 'nv'
                p.nv = val;              % measurement noise dimension
            case 'currentState'
                p.currentState = val;    % value of the current state
            otherwise
                error('nft2:nlng:ind_oor','Index out of range');
        end
    case '{}'
        error('nft2:nlng:not_imp','Not implemented!');
end

