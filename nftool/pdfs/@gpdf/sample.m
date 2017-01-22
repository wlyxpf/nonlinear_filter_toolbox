function s = sample(p)
% SAMPLE sampling from general pdf
% S = SAMPLE(P) generates sample from gpdf object P
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

s = (p.var^0.5)*randn(size(p.mean))+p.mean;

% CHANGELOG