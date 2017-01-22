function [idx] = residual(p,W,N);
% @PF/RESIDUAL - residual resampling
%
% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

ss = length(W); %sample size

ind = floor(N.*W);

idx1 = [];
ii = find(ind);
for j = 1:length(ii)
  idx1(end+1:end+ind(ii(j))) = ii(j);
end

Residue = N-sum(ind);
idx2 = [];
if Residue>0
  for i = 1:ss
    pomW(i) = W(i)-ind(i)/N;
  end
  pomW = normalize(p,pomW);
  idx2 = rndmul(p,pomW,Residue);
end

idx = [idx1,idx2];
if length(find(idx > ss))>0
 idx
 error('Critical error during residual resampling, index to high')
end
