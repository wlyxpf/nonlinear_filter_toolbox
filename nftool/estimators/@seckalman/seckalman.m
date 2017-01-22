function p = seckalman(varargin)
% @SECKALMAN - extanded kalman filter of the 2. order
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
  if isa(varargin{1},'seckalman')
    p = varargin{1};
  else
    error('nft2:seckalman:ia_n_skal','Input argument is not an seckalman object');
  end    
 case {2,3}
  % specification of extended kalman filter of the 2. order  

  system = varargin{1};
  
  f = system.f;                 % get the transient vector mapping
  [secpad,f] = nfsecpad(f);     % prepare the second derivative if possible
  system = set(system, 'f', f); % store the vector mapping with determined
                                % second derivative back to the system 
                                % description

  h = system.h;                 % get the measurement vector mapping
  [secpad,h] = nfsecpad(h);     % prepare the second derivative if possible
  system = set(system, 'h', h); % store the vector mapping with determined
                                % second derivative back to the system 
                                % description

  % interites from EXTKALMAN
  if nargin == 2
      EXTKALMAN = extkalman(system,varargin{2});
  else
      EXTKALMAN = extkalman(system,varargin{2},varargin{3});
  end    
 
  p = class(struct([]),'seckalman',EXTKALMAN);
    
  % verify lga class
  if ~isa(get(p,'system'),'nlga')
    error('nft2:seckalman:only_nlga','Only NLGA systems are allowed');
  end  
  
otherwise
  error('nft2:seckalman:incomp_ia','Incompatible input arguments');
end

% CHANGELOG
