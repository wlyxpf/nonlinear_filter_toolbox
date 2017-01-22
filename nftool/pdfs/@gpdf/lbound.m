function l = lbound(p,m)
% LBOUND - lower bound for numerical integration and plotting
%   

% Nonlinear Filtering Toolbox version 2.0-rc4
% Copyright (c) 1995 - 2007 NFT developement Team,
%              Department of Cybernetics,
%              University of West Bohemia in Pilsen

for i=1:p.general_pdf.dim
 l(i) =  p.mean(i) - m*sqrt(p.var(i,i));
end
