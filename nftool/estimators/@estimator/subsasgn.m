function p = subsasgn(p,prop,val)
% SUBSASGN estimator
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
                p.system = val;
            case 'lag'
                p.lag = val;
            case 'px0'
                p.px0 = val;
            case 'time'
                p.time = val;
            case 'pipe'
                p.pipe = val;
            case 'result'
                p.result = val;
            otherwise
                error('nft2:estimator:ind_oor','Index out of range');
        end
    case '{}'
        error('nft2:estimator:not_imp','Not implemented!');
end



