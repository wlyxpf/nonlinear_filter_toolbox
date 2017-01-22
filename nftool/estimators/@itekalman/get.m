function val = get(p,prop_name)
% ITEKALMAN/GET Get itekalman properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch prop_name
    case 'epsilon'
        val = p.epsilon;
    otherwise
        error([prop_name,' is not a valid property!'])
end

% CHANGELOG