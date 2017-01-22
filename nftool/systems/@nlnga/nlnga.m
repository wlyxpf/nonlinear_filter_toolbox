function p = nlnga(varargin)
% NLNGA nlnga class constructor
% P = NLNGA(tf,mf,pw,pv,px0)
%     creates an object nlnga
% P = NLNGA(O) O must be an object of the nlnga class
%     creates an object equal to O
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument of class nlnga
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'nlnga')
            p = varargin{1}
        else
            error('nft2:nlnga:ia_n_nlnga','Input argument is not a nlnga object');
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

        % create instance of parrent class to fill the common atributes with propper
        % values
        NLNG = nlng(varargin{1},varargin{2},varargin{3},varargin{4}, ...
            varargin{5});

        if iswarnoff
        else
            warning on;
        end

        % Test the linearity and additivity of the system
        islin = islinear(NLNG.f,[NLNG.u,NLNG.x,NLNG.w]) * ...
            islinear(NLNG.h,[NLNG.x,NLNG.v]);
        isad = islinear(NLNG.f,[NLNG.w]) * islinear(NLNG.h,[NLNG.v]);

        % Check whether another system class wouldn't be more appropriate
        if isad
            if isgaussian(NLNG)
                if islin
                    warning('nft2:nlnga:lga_bet','The LGA class should be better used');
                else
                    warning('nft2:nlnga:nlga_bet','The NLGA class should be better used');
                end
            else
                if islin
                    warning('nft2:nlnga:lnga_bet','The LNGA class should be better used');
                end
            end
        else
            warning('nft2:nlnga:not_add','This system is not additive');
        end

        % The noises are additive => it is possible to determine gaim
        % matrices gamma and delta
        p.gamma = nfdiff(NLNG.f,...
            [zeros(1, NLNG.nu) zeros(1, NLNG.nx) ones(1,NLNG.nw)],NLNG.w);
        p.delta = nfdiff(NLNG.h,[zeros(1,NLNG.nx) ones(1,NLNG.nv)],NLNG.v);

        % Create instance of nlnga class as child class of nlng
        p = class(p,'nlnga',NLNG);

    otherwise
        error('nft2:nlnga:wn_ia','Wrong number of input arguments');
end

% CHANGELOG
