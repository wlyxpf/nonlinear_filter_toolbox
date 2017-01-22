function val = subsref(p,prop)
% nfPredatorPreyModel/subsref
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('This type of referencing is not implemented!');
    case '.'
        switch prop.subs
            case 'u'
                if p.nu == 0
                    val = {};
                else
                    val = {'input'};
                end
            case 'x'
                if p.nx == 0
                    val = {};
                else
                    val = {'state'};
                end
            case 'xi'
                if p.nxi == 0
                    val = {};
                else
                    val = {'noise'};
                end
            otherwise
                release_number = str2num(version('-release'));
                if ( ispc==1 && release_number<=13 )
                    % The Windows version of MATLAB R13 interprets the case
                    % differently than the other releases/platforms
                    val = subsref(p.nffunction,prop);
                else
                    val = subsref(p.nfFunction,prop);
                end
        end
    case '{}'
        error('This type of referencing is not implemented!');
end

% CHANGELOG
