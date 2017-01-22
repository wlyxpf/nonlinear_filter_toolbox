function s = sample(p)
% SAMPLE sampling from epdf
% S = SAMPLE(P,NS) generates ns samples from epdf object P
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

idx = rndmul(p,p.weights,1);
Sam = p.samples;
s = Sam(idx);

% CHANGELOG
