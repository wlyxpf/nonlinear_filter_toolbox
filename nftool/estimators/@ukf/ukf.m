function p = ukf(varargin)
% @UKF - unscented kalman filter (original version)
% input parameters
%  #1 system
%  #2 lag
%  #3 px0
%  #4 standard or square-root algoritm (optional, standard version is default)
%       - alternatives: 'standard','squareroot'
%  #5 scaling parameter kappa (optional, default value is kappa = system.nx - 3 or kappa = 0 for system.nx > 3)
%       - any integer (for squareroot version any non-negative integer)
%       - preceding input parameter about the type of algorithm has to be set at least
%         as empty string, i.e. as ''
%       - recomended setting is kappa = 3 - system.nx if system.nx < 3 else
%         kappa = 0
%       - for details see references in @ukf/ukf.m
%  

% References:
% S.J. Julier, J. K. Uhlmann and H. F. Durrant-White (2000): 
% A new method for the nonlinear transformation of means and covariances in filters and estimators. 
% IEEE Trans. On AC 45(3), 477–482.
%
% M. Simandl, and J. Dunik (2005):
% Sigma point gaussian sum filter design using square root unscented filters. 
% In: Preprints of 16th IFAC World Congress. Prague, Czech Republic.
%
% M. Simandl and J. Dunik (2006):
% Design of derivative-free smoothers and predictors. 
% In: Preprints of the 14th IFAC Symposium on System Identification.
% Newcastle, Australia.

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
case 1
  % if single argument of class nlng, return it
  if isa(varargin{1},'ukf')
    p = varargin{1};
  else
    error('nft2:ukf:ia_n_ukf','Input argument is not a ukf object');
  end    
case {2,3,4,5}
  % specification of UKF   
  
  % choice between standard and square-root verison
  % default is standard version
  p.system = varargin{1};
  if ~isa(p.system,'nlga')
    error('The first argument doesn''t seem to be valid system.');
  end

  % check the type of algorithm
  if nargin >= 4
      if strcmp(varargin{4},'standard') | strcmp(varargin{4},'squareroot')
          p.at = varargin{4};
      else
          disp('----')
          disp('Standard or square-root version of UKF are available only.')
          disp('Details can be found in documenatation.')
          disp('The standard version has been chosen.')
          disp('----')
          p.at = 'standard';
      end;
  else
      disp('----')
      disp('Standard and square-root version of UKF are available (the fourth input argument in ukf class).')
      disp('The standard version has been chosen.')
      disp('----')
      p.at = 'standard';
  end;
  
  % checking of scaling parameter kappa
  if nargin == 5
      if isnumeric(varargin{5}) %if scaling parameter is a number
          if round(varargin{5}) == varargin{5} %if scaling parameter is integer
              p.kappa = varargin{5};
              if (varargin{5} < 0) & strcmp(p.at,'standard') % standard algrithm can lost possitive definitness of filtering covariance matrix
                  disp('----')
                  disp('This choice of scaling parameter kappa can cause the loss of positive definitness of covariance matrix.')
                  disp('The scaling parameter kappa should be non-negative.')
                  disp('----')
              elseif  (varargin{5} < 0) & strcmp(p.at,'squareroot')  % square-root version of UKF cannot work with negative kappa 
                  disp('----')
                  disp('This square-root version of the UKF cannot work with negative scaling parameter kappa.')
                  disp('The scaling parameter kappa has been set to zero.')
                  disp('----')
                  p.kappa = 0;
              end;
          else % scaling parameter is not integer;
              disp('----')
              disp('Scaling parameter kappa has to be integer.')
              disp('The scaling parameter kappa has been set to zero.')
              disp('----')
              p.kappa = 0;
          end;
      else % scaling parameter is not a number
          disp('----')
          disp('Scaling parameter kappa (the fifth input argument in ukf class) has to be a integer number.')
          disp('The scaling parameter kappa has been set to zero.')
          p.kappa = 0;
          disp('----')
      end;
  else % the fifth parameter is not set and the default value is used
      disp('----')
      disp('Scaling parameter kappa (the fifth input argument in ukf class) was not set.')
      if p.system.nx < 3
          p.kappa = 3 - p.system.nx;  % this choice of kappa is suitable for Gaussian probabillity distribution
                                      % for another distribution can be suitable different choice of kappa
          disp('The scaling parameter kappa has been set to value kappa = 3 - system.nx.')
      else
          p.kappa = 0;                      % prevent covarince matrices from loss of the possitive definitness
          disp('The scaling parameter kappa has been set to zero.')
      end;
      disp('----')
  end;
          

  % ESTIMATOR
  if nargin == 2
      ESTIMATOR = estimator(varargin{1},varargin{2});
  else
      ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
  end    
  
  % p = class(struct([]),'ukf',ESTIMATOR);
  p = class(p,'ukf',ESTIMATOR);
  
  % verify nlga class
  if ~isa(get(p,'system'),'nlga')
    warning('nft2:ukf:only_nlga','Only NLGA systems are allowed');
  end  
  
otherwise
  error('nft2:ukf:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
