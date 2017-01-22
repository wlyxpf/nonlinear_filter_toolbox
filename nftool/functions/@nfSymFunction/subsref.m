function val = subsref(p,prop_name)
% SUBSREF nffunction
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch prop_name.type
    case '()'
        error('This type of referencing is not implemented!');
    case '.'
        switch prop_name.subs
            case 'secondDerivatives'
                val = p.secondDerivative;
            case 'firstDerivatives'
                val = p.derivative;
            otherwise
                release_number = str2num(version('-release'));
                if ( ispc==1 && release_number<=13 )
                    % The Windows version of MATLAB R13 interprets the case
                    % differently than the other releases/platforms
                    val = subsref(p.nffunction,prop_name);
                else
                    val = subsref(p.nfFunction,prop_name);
                end
        end;
    case '{}'
        error('This type of referencing is not implemented!');
end

% CHANGELOG