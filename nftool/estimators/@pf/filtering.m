function [filt] = filtering(p,pred,u,z)
% @PF/FILTERING - proceeds filtering step
% returns information structure about
% filtering pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%%  setting variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system = get(p,'system');       % system
ss = p.opt.ss;
sdtyp = p.opt.sdtyp;
resmet = p.opt.resmet;

delta = get(system,'delta');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% particle filter with prior sampling density
if strcmp(sdtyp,'prior')
  % draw new samples from the transition pdf
  pred = prediction(p,pred,u);
  xf = samples(pred);
  wo = weights(pred);
  % evaluate new weights according to the measurement pdf
  for i = 1:ss
    zr = inv(delta)*(z - nfeval(system.h,[xf(:,i);zeros(system.nv,1)]));
    wf(i) = wo(i) * evaluate(system.pv,zr);
  end
end
xf = samples(pred);
wo = weights(pred);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% particle filter with optimal sampling density
% only for Gaussian systems with linear measurement equation
if strcmp(sdtyp,'optimal')
  Q = var(system.pw); % covariance matrix of state noise
  R = var(system.pv); % covariance matrix of measurement noise
  % matrix H
  H = nfderive(system.h,[ones(1, system.nx) zeros(1, system.nv)],system.x);
  S = inv(H'*inv(R)*H+inv(Q));
  ZR = H*Q*H'+R;
  for i = 1:ss
    xv = S*(inv(Q)*nfeval(system.f,[u;xf(:,i);zeros(system.nw,1)])+H'*inv(R)*z);
    ofd = gpdf(xv,S);
    tempz = nfeval(system.h,[xf(:,i);zeros(system.nv,1)]);
    zr = inv(delta)*(z - tempz);
    wf(i) = evaluate(gpdf(tempz,ZR),zr);
    xf(:,i) = sample(ofd);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% particle filter with point auxiliary sampling density
if strcmp(sdtyp,'auxiliary')
  for i = 1:ss
    % evaluate primary weights vp given by value of the measurement pdf for
    % state x given by mean of the transition pdf
    x = nfeval(system.f,[u;xf(:,i);mean(system.pw)]);
    zr = inv(delta)*(z - nfeval(system.h,[x;zeros(system.nv,1)]));
    vp(i) = evaluate(system.pv,zr); % primary weights
  end
  vp = normalize(p,vp); % normalize weights
  switch resmet % resample according to primary weights
    case 'multinomial'
      idx = rndmul(p,vp,ss);
    case 'residual'
      idx = residual(p,vp,ss);
    otherwise
      error('nft2:pf:bad_met','Unknown resampling method');
  end

  for i = 1:ss
    % draw new samples according to the transition pdf
    xf(:,i) = nfeval(system.f,[u;xf(:,idx(i));sample(system.pw)]);
    % evaluate new weights
    zr = inv(delta)*(z - nfeval(system.h,[xf(:,i);zeros(system.nv,1)]));
    wf(i) = wo(idx(i))*evaluate(system.pv,zr)/vp(idx(i));
  end
end
% normalizing weights
wf = normalize(p,wf);
%create filtering pdf object
filt = epdf(xf,wf);
