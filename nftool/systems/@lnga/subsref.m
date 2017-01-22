function val = subsref(p,prop)
% SUBSREF lnga
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:lnga:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'F'
                val = p.F;               % matrix F
            case 'G'
                val = p.G;               % matrix G
            case 'H'
                val = p.H;               % matrix H
            otherwise
                val = subsref(p.nlnga,prop);
        end;
    case '{}'
        error('nft2:lnga:not_imp','Not implemented!');
end;

% CHANGELOG
