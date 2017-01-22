function val = subsref(p,prop)
% SUBSREF
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch prop.type
    case '()'
        error('nft2:gspdf:not_imp','Not implemented!');
    case '.'
        switch prop.subs
            case 'weights'
                val = p.weights;              % outputs weights of mixture terms
            case 'gpdfs'
                val = gpdfs(p);               % outputs Gausian mixture members
            case 'means'
                val = p.means;                % outputs means of mixture terms
            case 'vars'
                val = p.variances;            % outputs variances of mixture terms
            case 'n_members'
                val = p.n_members;            % outputs the number of mixture
                                              % terms
            case 'mean'
                val = mean(p);                % get the mean of the Gaussian
                                              % mixture
            case 'var'
                val = var(p);                 % get the variance of the Gaussian
                                              % mixture
            otherwise
                prop
                val = subsref(p.general_pdf,prop);
        end
    case '{}'
        error('nft2:gspdf:not_imp','Not implemented!');
end;

% CHANGELOG
