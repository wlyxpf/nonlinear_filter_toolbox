function val = subsref(p,prop)
% SUBSREF estimator
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:estimator:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'system'
                val = p.system;
            case 'lag'
                val = p.lag;
            case 'px0'
                val = p.px0;
            case 'time'
                val = p.time;
            case 'pipe'
                val = p.pipe;
            case 'result'
                val = p.result;
            otherwise
                error('nft2:estimator:ind_oor','Index out of range');
        end;
    case '{}'
        error('nft2:estimator:not_imp','Not implemented!');
end

% CHANGELOG
