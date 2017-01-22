function display(p)
% GSPDF/DISPLAY Command window display of a gspdf
%

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


fprintf('%s=\n',inputname(1));
for i = 1:p.n_members
  fprintf('%g*\n',p.weights(i));
  gpdf(p.means{i},p.variances{i})
end
 

% CHANGELOG
