function val = subsref(p,prop)
% SUBSREF gpdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '.'
        switch prop.subs
            case 'samples'
                val = p.samples;
            case 'weights'
                val = p.weights;
            otherwise
                val = subsref(p.general_pdf,prop);
        end
    case '{}'
        error('nft2:epdf:not_imp','Not implemented!');
end

% CHANGELOG
