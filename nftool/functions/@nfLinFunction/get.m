function val = get(p,prop_name)
% nfLinFunction/get Get nfLinFunction properties from the specified object
% and return the value
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

if p.realVariableNames
    val = get(p.nfFunction,prop);
else
    switch prop_name

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
                val = subsref(p.nffunction,prop_name);
            else
                val = subsref(p.nfFunction,prop_name);
            end
    end
end

% CHANGELOG
