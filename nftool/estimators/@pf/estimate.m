function [est,p] = estimate(p,z,u)
% PF/ESTIMATE - estimate  (filtering|predictive) step
% returns information structure
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%% velikost vstupni a vystupni promenne %%%%%%%%%%%%%%%%%%%%%%
[Iz,Jz] = size(z);

system = get(p,'system');
if  system.nu == 0              %for automous system, 3rd parameter is ignored
  uf = [];
  rizeni = 0;
elseif nargin == 3              %otherwise check input dimension
  if isnan(u)                   % nan input means zero input
    u = zeros(system.nu,1);
  end
  if p.estimator.time == 0
    u = [zeros(system.nu,1),u];
  end
  rizeni = 1;
  [Iu,Ju] = size(u);
  if Iu ~= system.nu
    error('nft2:pf:bad_dim_u','Wrong dimension of input U');
  end
else
  error('nft2:pf:en_inu','Wrong number of parameters');
end

est = {};
%%%%%%%%% algoritm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch sign(p.estimator.lag)

%%%%%%%%% filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 0
    for jz = 1 : Jz,
      if p.estimator.time == 0
        cur = filtering_init(p,get_cur(p.estimator.pipe),z(:,jz));
        p.estimator.pipe = set_cur(p.estimator.pipe,cur);
      else
        if rizeni
          uf = u(:,jz);
        end
        cur = filtering(p,get_cur(p.estimator.pipe),uf,z(:,jz));
        p.estimator.pipe = set_cur(p.estimator.pipe,cur);
      end
      est{end+1} = cur;
      cur = resampling(p,cur);
      p.estimator.time = p.estimator.time+1;
    end


%%%%%%%%% prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 1
    % for system with input check input size
    if rizeni == 1
      if ((p.estimator.time == 0)&(Ju < Jz+p.estimator.lag-1))|((p.estimator.time ~= 0)&(Ju < Jz+p.estimator.lag))
        error('nft2:pf:bad_quan_u','Wrong number of inputs U');
      end
    end
    for jz = 1 : Jz,
      if p.estimator.time == 0
        cur = get_cur(p.estimator.pipe);
        if ~isa(cur,'epdf')
          x0 = sampleset(cur,p.opt.ss);
          w0(1:p.opt.ss) = 1/p.opt.ss;
          cur = epdf(x0,w0);
          p.estimator.pipe = insert(p.estimator.pipe,cur);
        end
        for i = 0:p.estimator.lag-1,
          if rizeni == 1
            % prediction with input
            uf = u(:,jz+i);
          end
          % calculate remaining prediction steps
          cur = prediction(p,cur,uf);
        end
        est{end+1} = cur;
        p.estimator.time = p.estimator.time+1;
      end
      if rizeni
        uf = u(:,jz);
      end
      cur = get_cur(p.estimator.pipe);
      filt = filtering(p,cur,uf,z(:,jz));
      filt = resampling(p,filt);
      p.estimator.pipe = insert(p.estimator.pipe,filt);
      cur = filt;
      % calculate remaining prediction steps
      for i = 1:p.estimator.lag,
        if rizeni == 1
          % prediction with input
          uf = u(:,jz+i);
        end
        cur = prediction(p,cur,uf);
      end
      est{end+1} = cur;
      p.estimator.time = p.estimator.time+1;
    end

  case -1
    error('nft2:pf:smooth_not_imp','Smoothing is not implemented');

end %switch


% CHANGELOG
