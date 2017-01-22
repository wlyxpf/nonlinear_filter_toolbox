function p = set(p,varargin)
% NLNGA/SET Set nlnga properties and return the updated object
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
        case 'gamma'
            p.gamma = val;
        case 'delta'
            p.delta = val;
        otherwise
            p.nlng = set(p.nlng,prop,val);
    end
end

% CHANGELOG
