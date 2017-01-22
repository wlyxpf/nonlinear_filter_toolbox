function p = nlga(varargin)
% NLGA nlga class constructor
% P = NLGA(tf,mf,pw,pv,px0)
%     creates an object nlga
% P = NLGA(O) O must be an object of the nlga class
%     creates an object equal to O
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument of class nlna
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isa(varargin{1},'nlga')
            p = varargin{1}
        else
            error('nft2:nlga:ia_n_nlnga','Input argument is not a nlnga object');
        end
    case 5
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1st arg: transition equation
        % 2nd arg: measurement equation
        % 3th arg: type of state noise  variable (object)
        % 4th arg: type of measurement noise  variable (object)
        % 5th arg: type of initial density p(x0) (object)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        war = warning;
        iswarnoff = strcmp(war(1).state,'off');

        warning off;
        NLNGA = nlnga(varargin{1},varargin{2},varargin{3},varargin{4},...
            varargin{5});

        if iswarnoff
        else
            warning on;
        end

        islin = islinear(NLNGA.f,[NLNGA.u,NLNGA.x,NLNGA.w]) * ...
            islinear(NLNGA.h,[NLNGA.x,NLNGA.v]);
        isad = islinear(NLNGA.f,[NLNGA.w]) * islinear(NLNGA.h,[NLNGA.v]);

        % Check whether another system class wouldn't be more appropriate
        if isad
            if isgaussian(NLNGA)
                if islin
                    warning('nft2:nlga:lga_bet','The LGA class should be better used');
                end
            else
                warning('nft2:nlga:not_gaus','This system is not gaussian');
            end
        else
            warning('nft2:nlga:not_add','This system is not additive');
        end

        % Create instance of nlga class as child class of nlnga
        p = class(struct([]),'nlga',NLNGA);


    otherwise
        error('nft2:nlga:wn_ia','Wrong number of input arguments');
end
