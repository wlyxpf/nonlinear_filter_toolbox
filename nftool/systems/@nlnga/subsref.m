function val = subsref(p,prop)
% NLNGA/SUBSREF nlnga
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
                val = p.gamma;           % gamma matrix
            case 'delta'
                val = p.delta;               % delta matrix
            otherwise
                val = subsref(p.nlng,prop);
        end;
    case '{}'
        error('nft2:nlnga:not_imp','Not implemented!');
end;

% CHANGELOG
