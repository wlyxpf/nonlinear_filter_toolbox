function p = kalman(varargin)
% @KALMAN - classical kalman filter
% input parameters
%  #1 system
%  #2 lag
%  #3 px0
%  

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
case 1
  % if single argument of class nlng, return it
  if isa(varargin{1},'kalman')
    p = varargin{1};
  else
    error('nft2:kalman:ia_n_kal','Input argument is not a kalman object');
  end    
 case {2,3}
  % specification of kalman filter   

  % interites from ESTIMATOR  
  if nargin == 2
      ESTIMATOR = estimator(varargin{1},varargin{2});
  else
      ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
  end    
  
  p = class(struct([]),'kalman',ESTIMATOR);
  
  % verify lga class
  if ~isa(get(p,'system'),'lga')
    error('nft2:kalman:only_lga','Only LGA systems are allowed');
  end  
  
otherwise
  error('nft2:kalman:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
