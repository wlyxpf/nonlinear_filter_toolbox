function p = gpdf(varargin)
% GPDF gpdf class constructor
% P = GPDF() 
%     creates an object gpdf with mean 0 and variance 1
% P = GPDF(G) G must be an object of the gpdf class
%     creates an object equal to G
% P = GPDF(M,V) M must be a vector Nx1, V must be a NxN matrix
%     creates and gpdf object with mean M and variance V
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


switch nargin
 case 0
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% DEFAULT OBJECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  p.mean = 0;                           % default mean
  p.var = 1;                            % default variance
  p = class(p,'gpdf',general_pdf);      % creates an ancestor object gpdf
  p = set(p,'dim',1);                   % set dimension of random variable
 case 1
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% SIGNLE GPDF  OBJECT %%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if isa(varargin{1},'gpdf');
    p = varargin{1};
  else
    error('nft2:gpdf:mb_gpdf','Must be an object of the gpdf class');
  end    
 case 2
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%  NEW OBJECT WITH GIVEN PARAMETERS  %%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  p.mean = varargin{1};            % get the mean
  p.var = varargin{2};             % get the variance
    
  p = class(p,'gpdf',general_pdf); % creates an object gpdf
  
  p = set(p,'dim',size(p.mean,1)); % set dimension of random variable
                                   
%  verify(p);                      % check object

 otherwise
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% TOO MANY INPUT ARGS  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  warning('nft2:gpdf:too_m_a','Too many arguments');
end

% CHANGELOG
