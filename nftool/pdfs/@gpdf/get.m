function val = get(p,prop_name)
% GET Get gpdf properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop_name
    case 'mean'
        val = p.mean;
    case 'var'
        val = p.var;
    otherwise
        val = get(p.general_pdf,prop_name);
end

% CHANGELOG