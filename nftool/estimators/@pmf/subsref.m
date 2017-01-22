function val = subsref(p,prop)
% SUBSREF estimator
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:pmf:not_impl','Not implemented!');
    case '.'
        switch prop.subs
            case 'system'
                val = p.system;
            case 'lag'
                val = p.lag;
            case 'time'
                val = p.time;
            case 'pipe'
                val = p.pipe;
            case 'result'
                val = p.result;
            otherwise
                error('nft2:pmf:ind_oor','Index out of range');
        end
    case '{}'
        error('nft2:pmf:not_impl','Not implemented!');
end

% CHANGELOG
