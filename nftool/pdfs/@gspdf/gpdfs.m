function gpdfs = gpdfs(p)
% GSPDF/GPDFS - 
%   

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen


gpdfs = cell(1,p.n_members);  % initialization of cell of Gaussian pdfs
for i = 1:p.n_members         % get i-th mixture term (Gaussian pdf)
  gpdfs{i} = gpdf(p.means{i},p.variances{i}); 
end
