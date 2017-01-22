function [idx] = rndmul(p,W,N);
% @PF/RNDMUL - random multivariable resampling
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

idx = []; %indexy presamplovanych vzorku

ss = length(W); %sample size

rr = rand(N,1); % samples from uniform pdf

bo(1) = 0;
for i = 1:ss
  bo(i+1) = bo(i) + W(i);
end

for i = 1:ss
  nr(i) = length(find((bo(i)<rr)&(rr<=(bo(i+1)))));
  idx(end+1:end+nr(i)) = i;
end

if length(find(idx > ss))>0
 idx 
 error('Critical error during multinomial resampling - index to high')
end
