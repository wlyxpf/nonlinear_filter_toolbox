function p = dd1(varargin)
% @DD2 - divided difference filter 2nd order
% input parameters
%  #1 system
%  #2 lag
%  #3 px0
%  #4 scaling parameter h (optional, default value is h = sqrt(3))
%       - half of an interpolation interval for Stirling's polynomial
%         interpolation
%       - any positive real number
%       - recomended setting is h = sqrt(3)
%       - for details see references in @dd2/dd2.m
%
%  

% References:
% M. Norgaard, N. K. Poulsen and O. Ravn (2000): 
% New developments in state estimation for nonlinear systems. 
% Automatica 36(11), 1627-1638.
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
  if isa(varargin{1},'dd2')
    p = varargin{1};
  else
    error('nft2:dd2:ia_n_dd2','Input argument is not a dd2 object');
 end    
 case {2,3,4}
  % specification of DD2   

  % check parameter h (half of the interval length for Stirling's polynomial interpolation)
  if nargin == 4
      if isnumeric(varargin{4}) %if parameter is a number
          if (abs(varargin{4}) == varargin{4}) & (varargin{4} ~= 0) %if parameter is non-zero positive integer
              p.h = varargin{4};
          else % scaling parameter is not non-zero positive number;
              disp('----')
              disp('Parameter h (half of an interpolation interval) has to be non-zero positive number.')
              disp('The parameter h has been set to h = sqrt(3).')
              disp('----')
              p.h = sqrt(3);
          end;
      else % scaling parameter is not a number
          disp('----')
          disp('Parameter h (half of an interpolation interval and the fourth input argument in dd1 class) has to be non-zero positive number.')
          disp('The parameter h has been set to h = sqrt(3).')
          disp('----')
          p.h = sqrt(3);
      end;
  else % the fourth parameter is not set and the default value is used
      disp('----')
      disp('Parameter h (half of an interpolation interval and the fourth input argument in dd1 class) was not set.')
      disp('The parameter h has been set to h = sqrt(3).')
      disp('----')
      p.h = sqrt(3); % this choice of h is suitable for Gaussian probabillity distribution
                     % for another distribution can be suitable different choice of h
  end;
  
  % ESTIMATOR
  if nargin == 2
      ESTIMATOR = estimator(varargin{1},varargin{2});
  else
      ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
  end    
 
  % p = class(struct([]),'dd1',ESTIMATOR);
  p = class(p,'dd2',ESTIMATOR);
  
  % verify nlga class
  if ~isa(get(p,'system'),'nlga')
    error('nft2:dd:only_nlga','Only NLGA systems are allowed');
  end  
  
otherwise
  error('nft2:dd:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
