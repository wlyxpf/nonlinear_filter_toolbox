function p = set(p,varargin)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% SET Set estimator properties and return the updated object
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case 'system'
            p.system = val;
        case 'lag'
            p.lag = val;
        case 'px0'
            p.px0 = val;
        case 'time'
            p.time = val;
        case 'pipe'
            p.pipe = val;
        case 'result'
            p.result = val;
        otherwise
            error([prop,' Is not a valid property'])
    end
end