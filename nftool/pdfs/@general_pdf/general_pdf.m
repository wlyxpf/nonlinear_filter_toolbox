function p = general_pdf(varargin)
% GENERAL_PDF class constructor
% p = GENERAL_PDF() creates a general pdf object
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument of class general_pdf
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'general_pdf')
            p = varargin{1};
        else
            error('nft2:general:ia_n_genpdf','Input argument is not a general_pdf object');
        end

    case 0
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % without the argument
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        p.dim = 0;
        p = class(p,'general_pdf');

    otherwise
        error('nft2:general:wn_ia','Wrong number of input arguments');
end

% CHANGELOG
