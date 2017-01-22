function val = get(p,prop_name)
% GET Get lnga properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop_name
    case 'F'
        val = p.F;
    case 'G'
        val = p.G;
    case 'H'
        val = p.H;
    otherwise
        val = get(p.nlnga,prop_name);
end

% CHANGELOG