function p = gsm(varargin)
% @gsm - Gaussian sum estimator for estimation of unknown state
%        of nonlinear non-Gaussian system
%
%    filter = gsm(gsmFilter) 
%      creates copy of an existing object of the gsm class
%
%    filter = gsm(system,lag) 
%      creates an filter object of the gsm class. The state of the system
%      will be estimated. The estimation task is specified by the second
%      parameter lag (filtering lag=0, smoothing lag<0, prediction lag>0).
%      The a priori pdf for the estimation is set equal to the probability
%      density function of the initial state.
%
%    filter = gsm(system,lag,aprioriPDF)     (deprecated contructor call)
%    filter = gsm(system,lag,'PriorPDF',aprioriPDF)
%
%      the parameter aprioriPDF (must be of gpdf or gspdf class type) 
%      specifies the a priori pdf for the estimation.
%
%    filter = gsm(system,lag,reduction)      (deprecated contructor call)
%    filter = gsm(system,lag,'MaxTerms',reduction)
%
%      the parameter reduction (must be integer value) specifies the maximal 
%      number of terms in the Gaussian mixture describing the filtering 
%      probability density function
%
%    filter = gsm(system,lag,'PriorPDF',aprioriPDF,'MaxTerms',reduction)
%
%      the parameter aprioriPDF (must be of gpdf or gspdf class type) 
%      specifies the a priori pdf for the estimation. The parameter
%      reduction (must be integer value) specifies the maximal  number of
%      terms in the Gaussian mixture describing the filtering probability 
%      density function
%
% References:
% Daniel L. Alspach, Harold W. Sorenson (1972):
%   Nonlinear Bayesian estimation using Gaussian sum approximations,
%   IEEE Trans. Automat. Contr., vol. 17, pp. 439 - 448


% Nonlinear Filtering Toolbox version 2.0rc2
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
    case 1
        % if single argument of class gsm, return it
        if ~isa(varargin{1},'gsm')
            error('nft2:gsm:ia_n_gsm','Input argument is not a GSM filter');
        else
             p = varargin{1};
        end
    case 2 
        % Only the system and estimator type is specified. Get a priori pdf
        % of state from the system. The number of term to which the mixture
        % will be pruned is not determined so the mixture can grow with
        % time.
        if isa(varargin{1},'nlnga')
            px_apr = gspdf(get(varargin{1},'px0'));
            p.reduction = -1;
            warning('nft2:gsm:notPruned','The number of mixture term is not bounded. It is possible that it can grow fast with time!');
        else
            error('nft2:gsm:not_valid_system','The first argument doesn''t seem to be valid system');
        end
    case 3
        % support the old constructors convention, i.e. don't use the property
        % names of constructor argument
        if ~isa(varargin{3},'gpdf') || ~isa(varargin{1},'gspdf')
            if varargin{3} == fix(varargin{3})
                p.reduction = varargin{3};
                % A priori pdf for estimation not specified, get it for the
                % system.
                px_apr = gspdf(get(varargin{1},'px0')); 
            else
                error('nft2:gsm:reductionNotInteger','The reduction has to be specified as an integer value.');
            end
        else
            % The a priori pdf for the estimation is also specified. The
            % number of term to which the mixture will be pruned is not
            % determined so the mixture can grow with time.
            px_apr =  gspdf(varargin{3});
            p.reduction = -1;
            warning('nft2:gsm:notPruned','The number of mixture term is not bounded. It is possible that it can grow fast with time!');
        end
    case {4,6}
        properties = {'PriorPDF','MaxTerms'};
        propertyNames = varargin(3:2:nargin-1);
        propertyValues = varargin(4:2:nargin);
        [arePropertiessListed,propertiesIndex] = ismember(propertyNames,properties);
                
        if sum(arePropertiessListed) ~= length(propertyNames)
            error('nft2:gsm:unkwownProperty','Unknow property specified is input argument.');
        end
        
        for property = propertiesIndex
            switch propertyNames{property}
                case 'PriorPDF'
                    px_apr = gspdf(propertyValues{propertiesIndex(property)});
                    if nargin == 4 % A priori pdf for estimation not specified
                        p.reduction = -1;
                        warning('nft2:gsm:notPruned','The number of mixture term is not bounded. It is possible that it can grow fast with time!');
                    end
                case 'MaxTerms'
                    p.reduction = propertyValues{propertiesIndex(property)};
                    if nargin == 4 % A priori pdf for estimation not specified
                        px_apr = gspdf(get(varargin{1},'px0'));  
                    end
            end
        end
    otherwise
        error('nft2:gsm:incomp_ia','Incompatible input arguments');
end

if nargin > 1
    if ~isa(varargin{1},'nlnga')
        error('nft2:gsm:not_valid_system','The first argument doesn''t seem to be valid system');
    end
    p.system = varargin{1};                      % store the estimated system

    if varargin{2} ~= fix(varargin{2})
        error('nft2:gsm:lagNotInteger','The lag has to be specified as an integer value.');
    end

    pw       = gspdf(get(p.system,'pw'));  % get state noise pdf
    pv       = gspdf(get(p.system,'pv'));  % get measurement noise pdf
    p.delta  = get(p.system,'delta');
    p.gamma  = get(p.system,'gamma');


    p.w_means   = pw.means;                % get all means of mixture pw
    p.v_means   = pv.means;                % get all means of mixture pv

    p.w_vars    = pw.vars;                 % get all variances of mixture pw
    p.v_vars    = pv.vars;                 % get all variances of mixture pv

    p.w_weights = pw.weights;              % get all weigths of terms in
    % mixture pw
    p.v_weights = pv.weights;              % get all weigths of terms in
    % mixture pv

    p.q         = pw.n_members;            % get number of weigths of terms in
                                           % mixture pw
    p.r         = pv.n_members;            % get number of weigths of terms in
                                           % mixture pv

    % Check the reduction and correct it if necessary
    pred_terms_num=px_apr.n_members;

    if (p.r==1)&&(p.q==1)&&(p.reduction>pred_terms_num),
        p.reduction=pred_terms_num;
    end;
    
    if (p.r==1)&&(p.q==1)&&(pred_terms_num==1),
        warning('on','nft2:gsm:use_extkal');
        warning('nft2:gsm:use_extkal','You''d better use function nfextkal for this task next time!');
    end;

    % GSM is child class of class estimator
    ESTIMATOR = estimator(p.system,varargin{2},px_apr);
end

% Create object of class GSM
p = class(p,'gsm',ESTIMATOR);

% CHANGELOG
