function p = lnga(varargin)
% LNGA lnga class constructor
% P = LNGA(tf,mf,input,state,w,v,pw,pv,px0)
%     creates an object lnga
% P = LNGA(O) O must be an object of the lnga class
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

        if isa(varargin{1},'lnga')
            p = varargin{1};
        else
            error('nft2:lnga:ia_n_lnga','Input argument is not a lnga object');
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
        NLNGA = nlnga(varargin{1},varargin{2},varargin{3},varargin{4},...
            varargin{5});

        %if iswarnoff
        %else
        %  warning on;
        %end

        islin = islinear(NLNGA.f,[NLNGA.u,NLNGA.x,NLNGA.w]) * ...
            islinear(NLNGA.h,[NLNGA.x,NLNGA.v]);
        isad = islinear(NLNGA.f,[NLNGA.w]) * islinear(NLNGA.h,[NLNGA.v]);

        % Check whether another system class wouldn't be more appropriate
        if isad
            if isgaussian(NLNGA)
                if islin
                    warning('nft2:lnga:lga_bet','The LGA class should be better used');
                else
                    warning('nft2:lnga:not_lin','This system is not linear');
                end
            else
                if islin
                else
                    warning('nft2:lnga:not_lin','This system is not linear');
                end
            end
        else
            error('nft2:lnga:not_add','This system is not additive');
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % The system is linears => it is possible to determine
        % matrices F,G,H
        %------------------------------------------------------------------
        % x(k+1) = F x(k) + G u(k) + Gamma w(k+1)
        % z(k) = H y(k) + Delta v(k)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        p.F = nfdiff(NLNGA.f,...
            [zeros(1, NLNGA.nu) ones(1, NLNGA.nx) zeros(1,NLNGA.nw)],NLNGA.x);    % F
        if ~isempty(NLNGA.u)
            p.G = nfdiff(NLNGA.f,...
                [ones(1, NLNGA.nu) zeros(1, NLNGA.nx) zeros(1,NLNGA.nw)],NLNGA.u);    % G
        else
            p.G=[];
        end;
        p.H = nfdiff(NLNGA.h,...
            [ones(1, NLNGA.nx) zeros(1, NLNGA.nv)],NLNGA.x);    % H
        p.t = 0;
        p.nu = NLNGA.nu;
        p.nv = NLNGA.nv;
        p.nw = NLNGA.nw;
        p.nx = NLNGA.nx;

        % Create instance of nlnga class as child class of nlnga
        p = class(p,'lnga', NLNGA);

    otherwise
        error('nft2:lnga:wn_ia','Wrong number of input arguments');
end

% CHANGELOG
