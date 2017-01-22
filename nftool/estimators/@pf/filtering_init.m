function [filt] = filtering_init(p,pred,z)
% PF/FILTERING_INIT - proceeds filtering step
% returns information structure about
% filtering pdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%% setting variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system = get(p,'system');       % system
ss = p.opt.ss;

delta = get(system,'delta');

%%%%%%%%% init filtering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isa(pred,'epdf')
   xf = samples(pred);
else
  for i = 1:ss
    xf(:,i) = sample(pred);
  end
end

for i = 1:ss
  zr = inv(delta)*(z-nfeval(system.h,[xf(:,i);zeros(system.nv,1)]));
  wf(i) = evaluate(system.pv,zr);
end
wf = normalize(p,wf);

filt = epdf(xf,wf);

