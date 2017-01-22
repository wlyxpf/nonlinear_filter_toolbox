function p = set(p,varargin)
% PMPDF/SET
%
%

% Nonlinear Filtering Toolbox version 2.0rc1
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

property_argin = varargin;
while length(property_argin) >= 2
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case 'values'
            % Verification
            if ~isnumeric(val) || any(val<0) || (length(val)~=prod(p.ngpts))
                error('nft2:pmpdf:mb_pmpdf','Must be an object of the pmpdf class or a compatible structure');
            end
            % Normalize and assign pdf values
            p.values = val / (sum(val)*prod(p.mass));
        otherwise
            p.general_pdf = set(p.general_pdf,prop,val);
    end
end
