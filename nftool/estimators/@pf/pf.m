function p = pf(varargin)
% PF - @PF - particle filter
%   input parameters
% #1 system
% #2 lag
% #3 px0
% #4 options; implicit struct('ss',100,'res','static','rescnt',5,'restyp','mul','sdtyp','aprior')
%      1. ss - sample size (integer)
%      2. res - resampling ('static'/'dynamic')
%      3. rescnt - alpha parameter for dynamic resampling
%                 or number of steps between resampling
%                 for static resampling
%      4. restyp - type of resampling ('mul')
%      5. sdtyp - type of sampling distribution ('aprior'/'optimal'/'auxil')

% References:
% A. Doucet, N. de Freitas and N. Gordon (2001):
% Sequential Monte Carlo Methods in Practice, Springer

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

% default options
p.opt.ss = 100;
p.opt.restyp = 'static';
p.opt.rescnt = 5;
p.opt.resmet = 'multinomial';
p.opt.sdtyp = 'prior';

switch nargin
  case  1
  % if single argument of class pf, return it
    if isa(varargin{1},'pf')
      p = varargin{1};
    else
      error('nft2:pf:ia_n_pfo','Input argument is not a pf object');
    end

  case 2
    ESTIMATOR = estimator(varargin{1},varargin{2});

  case 3
    if isstruct(varargin{3})
      ESTIMATOR = estimator(varargin{1},varargin{2});
      p.opt.ss = varargin{3}.ss;
      p.opt.restyp = lower(varargin{3}.restyp);
      p.opt.rescnt = varargin{3}.rescnt;
      p.opt.resmet = lower(varargin{3}.resmet);
      p.opt.sdtyp = lower(varargin{3}.sdtyp);
    else
      ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
    end

  case 4
    ESTIMATOR = estimator(varargin{1},varargin{2},varargin{3});
    p.opt.ss = varargin{4}.ss;
    p.opt.restyp = lower(varargin{4}.restyp);
    p.opt.rescnt = varargin{4}.rescnt;
    p.opt.resmet = lower(varargin{4}.resmet);
    p.opt.sdtyp = lower(varargin{4}.sdtyp);

otherwise
  error('nft2:pf:incomp_ia','Incompatible input arguments');
end

% optimal sample density needs linear measurement function
if strcmp(p.opt.sdtyp,'optimal')
  if ~islinear(varargin{1}.h,[varargin{1}.x,varargin{1}.v])
    error('nft2:pf:osd_lin_h','Measurement function must be linear for optimal sampling density');
  end
end

% create class
% only additive systems are allowed
if isa(varargin{1},'nlnga') | isa(varargin{1},'nlga') | isa(varargin{1},'lga') | isa(varargin{1},'lnga')
  disp('particle filter');
  p = class(p,'pf',ESTIMATOR);
else
  error('nft2:pf:only_addit','Only systems with additive noise are allowed');
end

% CHANGELOG
