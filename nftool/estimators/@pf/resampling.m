function [resampl] = resampling(p,pred)
% @PF/RESAMPLING - proceeds resampling according to filter options

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%% setting variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ss = p.opt.ss;
rescnt = p.opt.rescnt;
restyp = p.opt.restyp;
resmet = p.opt.resmet;

xf = samples(pred);
wf = weights(pred);

%%%%%%%%% resampling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resampling = 0;

switch restyp
  case 'dynamic'
    ess = 1/(1+cov(wf)/mean(wf)^2);
    if ess<rescnt
      resampling = 1;
    end
  case 'static'
    if mod(p.estimator.time,rescnt) == 0
      resampling = 1;
    end
  otherwise
    error('nft2:pf:bad_restype','Unknown resampling type');
end

if resampling == 1
  switch resmet
    case 'multinomial'
      idx = rndmul(p,wf,ss);
    case 'residual'
      idx = residual(p,wf,ss);
    otherwise
      error('nft2:pf:bad_met','Unknown resampling method');
  end
  xf = xf(:,idx);
  wf = 1/ss*ones(1,ss);
end

resampl = epdf(xf,wf);
