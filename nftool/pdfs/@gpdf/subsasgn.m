function p = subsasgn(p,prop,val)
% SUBSASGN gpdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:gpdf:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'mean'
                p.mean = val;  %change mean
                verify(p);     % verify changes
            case 'var'
                p.var = val;   % change var
                verify(p);     % verify changes

            otherwise
                p.general_pdf = subsasgn(p.general_pdf,prop,val);
        end
    case '{}'
        error('nft2:gpdf:not_imp','Not implemented!');
end

% CHANGELOG