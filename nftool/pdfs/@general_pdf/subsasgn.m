function p = subsasgn(p,prop,val)
% SUBSASGN
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:general:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'dim'
                p.dim = val;
            otherwise
                error('nft2:general:ind_oor','Index out of range');
        end
    case '{}'
        error('nft2:general:not_imp','Not implemented!');
end
