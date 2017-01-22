function [nw] = normalize(p,w)
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

N = size(w,2);
s = sum(w);
if s == 0
  warning on
  warning('nft2:pf:we_zero','Normalizing zero weights');
  warning off
  nw = ones(1,N)/N;
else
  nw = w/s;
end
