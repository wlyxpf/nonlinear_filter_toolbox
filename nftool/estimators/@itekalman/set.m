function p = set(p,varargin)
% ITEKALMAN/SET Sets itekalman property and returns the updated object
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
        case 'epsilon'
            p.epsilon = val;
        otherwise
            error([prop,' Is not a valid property'])
    end
end
