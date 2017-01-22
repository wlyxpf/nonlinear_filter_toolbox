function p = subsasgn(p,prop,val)
% NLNGA/SUBSASGN nlnga
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch prop.type
    case '()'
        error('nft2:nlnga:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'gamma'
                p.gamma = val;
            case 'delta'
                p.delta = val;
            otherwise
                p.nlng = subsasgn(p.nlng,prop,val);
        end
    case '{}'
        error('nft2:nlnga:not_imp','Not implemented!');
end

% CHANGELOG
