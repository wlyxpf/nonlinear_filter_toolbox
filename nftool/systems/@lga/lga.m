function p = lga(varargin)
% LGA lga class constructor
% P = LGA(tf,mf,pw,pv,px0)
%     creates an object lga
% P = LGA(O) O must be an object of the lga class
%     creates an object equal to O
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if single argument of class lnga, return it
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'lga')
            p = varargin{1}
        else
            error('nft2:lga:ia_n_lga','Input argument is not a lga object');
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

        % create instances of parrent classes to fill the common atributes with propper
        % values
        LNGA = lnga(varargin{1},varargin{2},varargin{3},varargin{4},...
            varargin{5});
        NLGA = nlga(varargin{1},varargin{2},varargin{3},varargin{4},...
            varargin{5});

        %if iswarnoff
        %else
        %  warning on;
        %end

        islin = islinear(LNGA.f,[LNGA.u,LNGA.x,LNGA.w]) * ...
            islinear(LNGA.h,[LNGA.x,LNGA.v]);
        isad = islinear(LNGA.f,[LNGA.w]) * islinear(LNGA.h,[LNGA.v]);

        % Check whether another system class wouldn't be more appropriate
        if isad
            if isgaussian(LNGA)
                if islin
                else
                    error('nft2:lga:not_lin','This system is not linear');
                end
            else
                error('nft2:lga:not_gaus','This system is not gaussian');
            end
        else
            error('nft2:lga:not_add','This system is not additive');
        end

        % Create instance of nlnga class as child class of nlnga
        p = class(struct([]),'lga',LNGA,NLGA);

    otherwise
        error('nft2:lga:wn_ia','Wrong number of input arguments');
end


% CHANGELOG
