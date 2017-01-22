function p = subsasgn(p,prop,val)
% SUBSASGN lnga
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
                p.F = val;
            case 'G'
                p.G = val;
            case 'H'
                p.H = val;
            otherwise
                p.nlnga = subsasgn(p.nlnga,prop,val);
        end
    case '{}'
        eerror('nft2:lnga:not_imp','Not implemented!');
end

% CHANGELOG
