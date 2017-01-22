function p = nlng(varargin)
% NLNG class constructor
% P = NLNG(f,h,pw,pv,px0)  creates an object nlng
% P = NLNG(Obj) creates an object equal to Obj if Obj is an object of the
%               nlng class
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch nargin
    case 1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % single argument of class nlng
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if isa(varargin{1},'nlng')
            p = varargin{1}
        else
            error('nft2:nlng:ia_n_nlng','Input argument is not a nlng object');
        end

    case 5
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 1st arg: transition equation
        % 2nd arg: measurement equation
        % 3th arg: type of state noise  variable (object)
        % 4th arg: type of measurement noise  variable (object)
        % 5th arg: type of initial density p(x0) (object)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %----------------------------------------------------------------------
        % Store the measurement multivariate function and get its
        % properties
        %----------------------------------------------------------------------
        measurement_fcn = varargin{2};
        if measurement_fcn.nu~=0
            error('The measurement function should not dependent on any input');
        end

        % Store the state transitional multivariate function and get its
        % properties
        transitional_fcn = varargin{1};

        %======================================================================
        % Test correctnes of the system given by transitional and measurement
        % functions
        %======================================================================
        % check dimension of multivariate states
        if transitional_fcn.nx ~= measurement_fcn.nx
            error('nft2:nlng:wrongDimesions',...
                'The dimensions of multivariate state occuring in the transitional and measurement functions doesn''t correspond');
        end

        % check that both multivariate states contain the same variables
        % TODO: find out whether it is not to strong condition!
        if ( ~isempty(setdiff(transitional_fcn.x,measurement_fcn.x)) )
            error('ft2:nlng:notCorrespondingVariables',...
                'The variables of transitional and measurement function doesn''t correspond')
        end

        % check that the state and state noise have the same dimension
        if (transitional_fcn.nx ~= transitional_fcn.nxi),
            error('nft2:nlng:differentDimesions',...
                'Dimension of the state variables doesn''t correspond to dimension of the noise variables');
        end
        %======================================================================

        % Set transitional and measurement functions atribute of the nlng object
        p.f = transitional_fcn;
        p.h = measurement_fcn;

        % Set the atributes of nlng object holding list of variables
        p.x = transitional_fcn.x;
        p.u = transitional_fcn.u;
        p.w = transitional_fcn.xi;
        p.v = measurement_fcn.xi;

        % Set the atributes of nlng object holding number of variables
        p.nx = transitional_fcn.nx;
        p.nu = transitional_fcn.nu;
        p.nw = transitional_fcn.nxi;
        p.nv = measurement_fcn.nxi;
        %----------------------------------------------------------------------

        %----------------------------------------------------------------------
        % Test and store the probability density functions atributes
        %----------------------------------------------------------------------
        % pw, pv, px0 must inherit from general_pdf class
        if isa(varargin{3},'general_pdf') & ...
                isa(varargin{4},'general_pdf') & ...
                isa(varargin{5},'general_pdf'),
            p.pw = varargin{3};
            p.pv = varargin{4};
            p.px0 = varargin{5};
        else
            error('nft2:nlng:must_inh_genpdf','Must inherit from ''general_pdf'' class');
        end

        % verify the dimensions of multivariate random variables and
        % corresponding probability density functions
        if (p.nw ~= dim(p.pw)),
            error('nft2:nlng:pw_vs_w','Pdf pw doesn''t correspond to dimension of random vector w');
        end
        if (p.nv ~= dim(p.pv)),
            error('nft2:nlng:pv_vs_v','Pdf pv doesn''t correspond to dimension of random vector v');
        end
        if (p.nx ~= dim(p.px0)),
            error('nft2:nlng:px0_vs_x','Pdf px0 doesn''t correspond to dimension of state x');
        end
        %----------------------------------------------------------------------

        % Generate initial state as realization random variable described by
        % probability density function px0
        p.currentState = sample(varargin{5});

        % Set initial time instant to zero
        p.t = 0;

        % Create new instance of the nlng class
        p = class(p,'nlng');

        islin = islinear(p.f,[p.u,p.x,p.w]) * islinear(p.h,[p.x,p.v]);
        isad = islinear(p.f,[p.w]) * islinear(p.h,[p.v]);

        % checking system
        war = warning;

        iswarnoff = strcmp(war(1).state,'off');

        if iswarnoff
        else
            % checking whether the use of lga class constructor would be
            % advisable
            if isad
                if isgaussian(p)
                    if islin
                        warning('nft2:nlng:lga_bet','The LGA class should be better used');
                    else
                        warning('nft2:nlng:nlga_bet','The NLGA class should be better used');
                    end
                else
                    if islin
                        warning('nft2:nlng:lnga_bet','The LNGA class should be better used');
                    else
                        warning('nft2:nlng:nlnga_bet','The NLNGA class should be better used');
                    end
                end
            end
        end
    otherwise
        error('nft2:nlng:wn_ia','Wrong number of input arguments');
end

% CHANGELOG
