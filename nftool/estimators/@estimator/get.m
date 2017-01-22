function val = get(p,prop_name)
% GET Get estimator properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch prop_name
    case 'system'
        val = p.system;
    case 'lag'
        val = p.lag;
    case 'px0'
        val = p.px0;
    case 'time'
        val = p.time;
    case 'pipe'
        val = p.pipe;
    case 'result'
        val = p.result;
    otherwise
        error([prop_name,' Is not a valid property'])
end

% CHANGELOG
