function [next] = prediction(p,last,u)
% @PF/PREDICTION - proceeds prediction step
% returns information structure about
% predictive pdf
% 1st arg.: object
% 2nd arg.: necessary arguments (filtering)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

%%%%%%%%% setting of variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system = get(p,'system');       % system
ss = p.opt.ss;

wp = weights(last);
xl = samples(last);

%%%%%%%%% prediction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:ss
  xp(:,i) = nfeval(system.f,[u; xl(:,i); sample(system.pw)]);
end

next = epdf(xp,wp);
