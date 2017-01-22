function p = set(p,varargin)
% SET Set gpdf properties and return the updated object
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
        case 'mean'
            p.mean = val; % change the mean
            verify(p);    % verify the changes

        case 'var'
            p.var = val; % change the var
            verify(p);   % verify the changes
        otherwise
            p.general_pdf = set(p.general_pdf,prop,val);
    end
end

% CHANGELOG
