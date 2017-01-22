function val = get(p,prop_name)
% NLNGA/ GET Get nlnga properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop_name
    case 'gamma'
        val = p.gamma;
    case 'delta'
        val = p.delta;
    otherwise
        val = get(p.nlng,prop_name);
end

% CHANGELOG