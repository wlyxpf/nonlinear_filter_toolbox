function p = epdf(varargin)
% EPDF - epdf, empirical prdf
%   
% P = EDF() 
%     creates an object edf with  sample 0 and weight 1
% P = EPDF(E) E must be an object of the epdf class
%     creates an object equal to E
% P = EPDF(X,W) X must be a matrix NxM, W must be a Nx1 vector
%     creates an epdf object with samples X and weights W
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

switch nargin
 case 0
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % if no input arguments, create a default object
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  p.samples = 0;                           % default setting
  p.weights = {1};                           % default setting
  p = class(p,'epdf',general_pdf);      % creates an object epdf
  p = set(p,'dim',1);           % set dimension of random variable
 case 1
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % if single argument of class epdf, return it
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if isa(varargin{1},'epdf');
    p = varargin{1};
  else
    error('nft2:epdf:mb_epdf','Must be an object of the epdf class');
  end    
 case 2
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % create object using specified arguments
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  p.samples = varargin{1};                      % samples - vector
  p.weights = varargin{2};                      % weights - vector
  W = p.weights;
  
  S = p.samples;
  p = class(p,'epdf',general_pdf);      % creates an object epdf
  p = set(p,'dim',size(S,1));        % set dimension of random variable

  verify(p);
  
otherwise
  % error - too many input argumets
  error('nft2:epdf:too_m_a','Too many arguments');
end

% CHANGELOG
