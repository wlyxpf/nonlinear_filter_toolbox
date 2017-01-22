function s = sample(p)
% SAMPLE sampling from gspdf
% S = SAMPLE() generates sample from gspdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

  i = 1;
  s = p.weights(1);
  rr = rand;
  while(rr>s)
    i = i+1;
    s = s+p.weights(i);
  end

s = sample(gpdf(p.means{i},p.variances{i}));

% CHANGELOG